# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId
  include AttrJson::Record

  attr_json_config default_container_attribute: :data
  friendly_id :name, use: :slugged
  attr_json :gems_path, :string

  has_rich_text :content
  has_one_attached :primary_image

  acts_as_taggable_on :categories
  acts_as_taggable_on :license
  acts_as_taggable_on :adjectives
  acts_as_taggable_on :gems
  acts_as_taggable_on :packages
  acts_as_taggable_on :app_directories
  acts_as_taggable_on :backend_stack
  acts_as_taggable_on :frontend_stack

  validates :slug, uniqueness: true
  validate :license_count

  scope :without_tagged, lambda { |context|
                           where.not(id: ActsAsTaggableOn::Tagging.distinct(:taggable_id).select(:taggable_id).where(context: context))
                         }

  tag_types.each do |type|
    scope "without_tagged_#{type}".to_sym, -> { without_tagged(type) }
  end

  scope :slim, lambda {
                 select(:id, :slug, :name, :description, :short_blurb, :color, :updated_at).includes(:adjectives).with_attached_primary_image
               }
  scope :hidden, -> { where.not(hidden_at: nil) }
  scope :visible, -> { where(hidden_at: nil) }

  after_create_commit :scan_project_first!

  def user
    @user ||= github.split('/')[0]
  end

  def repo
    @repo ||= github.split('/')[1]
  end

  # used for background colors on a projects list
  def extracted_colors
    Miro::DominantColors.new(Rails.application.routes.url_helpers.cdn_proxy_url(primary_image.blob)).to_hex
  end

  def extract_color!
    return :no_primary_image unless primary_image.present?

    miro = extracted_colors
    update!(color: miro.first)
  end

  def scrape_last_activity
    Projects::GithubActivityScraper.new(self)
  end

  def scrape_last_activity!
    result = scrape_last_activity
    result.run
    update!(last_activity_at: result.last_activity_at, last_commit: result.last_commit) if result
  end

  def scrape_meta
    Projects::GithubMetaScraper.new(self)
  end

  def scrape_meta!(first = false)
    result = scrape_meta
    result.run
    if result
      assign_attributes(
        branch: result.branch,
        stars: result.stars,
        forks: result.forks,
        github_about: result.about,
        license_list: result.license,
        meta_last_updated_at: Time.current,
        watchers: result.watchers,
        github: result.repo
      )
      self.name = result.name if (result.name.present? && name.nil?) || first
      self.website = result.website if (result.website.present? && website.nil?) || first
      save!
    end
  end

  def scrape_app
    raise ArgumentError, 'requires branch. Please run #scrape_meta! first.' if branch.nil?

    Projects::GithubAppScraper.new(self)
  end

  def scrape_app!
    result = scrape_app
    result.run
    update!(app_directory_list: result.app) if result
  end

  def scrape_gemfile
    raise ArgumentError, 'requires branch. Please run #scrape_meta! first.' if branch.nil?

    Projects::GemfileScraper.new(self)
  end

  def scrape_gemfile!
    result = scrape_gemfile
    result.run
    update!(gem_list: result.gems) if result
  end

  def scrape_packages
    raise ArgumentError, 'requires branch. Please run #scrape_meta! first.' if branch.nil?

    Projects::PackageScraper.new(self)
  end

  def scrape_packages!
    result = scrape_packages
    result.run
    update!(package_list: result.packages) if result
  end

  def analyze_stacks
    raise ArgumentError, 'requires gems. Please run #scrape_gemfile! first.' if gems.empty?

    Projects::StackAnalyzer.new(self)
  end

  def analyze_stacks!
    result = analyze_stacks
    result.run
    return :nope unless result

    assign_attributes(frontend_stack_list: result.frontend) if result.frontend
    assign_attributes(backend_stack_list: result.backend) if result.backend
    save!
  end

  # this isn't used yet
  def check_pulse
    raise ArgumentError, 'requires gems. Please run #scrape_gemfile! first.' if gems.empty?

    Projects::PulseCalculator.new(self)
  end

  # this isn't used yet
  def check_pulse!
    result = check_pulse
    result.run
    update!(pulse: result.pulse) if result
  end

  def scan!(first = false)
    scrape_meta!(first)
    scrape_last_activity!
    scrape_app!
    scrape_gemfile!
    scrape_packages!
    analyze_stacks!
    check_pulse!
  end

  def sync!
    scrape_last_activity!
  end

  def weekly_sync!
    scrape_app!
    scrape_gemfile!
    scrape_packages!
    analyze_stacks!
    check_pulse!
  end

  private

  def license_count
    if license_ids.size > 1
      errors.add(:license, 'should only have one.')
      throw(:abort)
    end
  end

  def scan_project_first!
    Projects::ScanProjectWorker.perform_async(slug, true)
  end

  def scan_project!
    Projects::ScanProjectWorker.perform_async(slug)
  end
end
