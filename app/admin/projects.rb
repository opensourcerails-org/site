# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params(:name, :slug, :rails_major_version, :github, :github_about, :website, :contributors, :dependents, :stars,
                :watchers, :forks, :app, :content, :description, :primary_image, :short_blurb, :color, :hidden_at, :gems_path,
                stack_list: [], category_list: [], adjective_list: [])

  filter :name
  filter :hidden_at

  Project.tag_types.each do |type|
    scope "No #{type}", "without_tagged_#{type}".to_sym
  end

  member_action :scan do
    resource.scan!
    redirect_to [:admin, resource], notice: 'Scanned.'
  end

  member_action :scrape_app do
    resource.scrape_app!
    redirect_to [:admin, resource], notice: 'Scraped app.'
  end

  action_item :scrape_app do
    link_to 'Scrape app', scrape_app_admin_project_path(resource)
  end

  member_action :scrape_last_activity do
    resource.scrape_last_activity!
    redirect_to [:admin, resource], notice: 'Scraped last activity.'
  end

  action_item :scrape_last_activity do
    link_to 'Scrape last activity', scrape_last_activity_admin_project_path(resource)
  end

  action_item :scrape_meta do
    link_to 'Scrape meta', scrape_meta_admin_project_path(resource)
  end

  member_action :scrape_meta do
    resource.scrape_meta!
    redirect_to [:admin, resource], notice: 'Scraped meta.'
  end

  action_item :check_pulse do
    link_to 'Check pulse', check_pulse_admin_project_path(resource)
  end

  member_action :check_pulse do
    resource.check_pulse!
    redirect_to [:admin, resource], notice: 'Checked pulse.'
  end

  action_item :analyze_stacks do
    link_to 'Analyze stack', analyze_stacks_admin_project_path(resource)
  end

  member_action :analyze_stacks do
    resource.analyze_stacks!
    redirect_to [:admin, resource], notice: 'Analyzed stack.'
  end

  action_item :scrape_gemfile do
    link_to 'scrape gemfile', scrape_gemfile_admin_project_path(resource)
  end

  member_action :scrape_gemfile do
    resource.scrape_gemfile!
    redirect_to [:admin, resource], notice: 'scraped gemfile.'
  end

  action_item :scrape_packages do
    link_to 'scrape packages', scrape_packages_admin_project_path(resource)
  end

  member_action :scrape_packages do
    resource.scrape_packages!
    redirect_to [:admin, resource], notice: 'scraped packages.'
  end

  member_action :colorpicker do
    render template: 'admin/projects/colorpicker'
  end

  action_item :colorpicker do
    link_to 'Colorpicker', colorpicker_admin_project_path(resource)
  end

  controller do
    def update
      resource_params.first.delete(:color) if resource_params.first[:color] == '#000000'
      if resource_params.first[:gems_path].nil? || resource_params.first[:gems_path].try(:empty?) || resource_params.first[:gems_path].try(:blank?)
        resource.gems_path = []
      else
        resource.gems_path = resource_params.first[:gems_path]
      end
      super
    end

    def find_resource
      if params[:id]
        resource_class.friendly.find(params[:id])
      else
        resource_class
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :github
    column :primary_image do |resource|
      resource.primary_image.present?
    end
  end

  show do
    attributes_table do
      resource.class.columns_hash.each_key do |key|
        row key
      end
      row :content do
        div resource.content
      end
      resource.tag_types.each do |type|
        row type
      end
      row :primary_image do
        if resource.primary_image.present?
          div style: 'object-scale: fit-content' do
            image_tag resource.primary_image, style: 'max-width: 400px;'
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Project' do
      f.input :name
      f.input :slug
      f.input :description
      f.input :short_blurb
      f.input :github
      f.input :github_about
      f.input :website
      f.input :color, as: :color_picker
      f.input :hidden_at, as: :date_time_picker
    end
    f.inputs 'Rails' do
      f.input :rails_major_version
    end
    f.inputs 'Config' do
      f.input :gems_path, as: :string, hint: 'no starting slash, something like dir/Gemfile.lock'
    end
    f.inputs 'Community' do
      f.input :watchers
      f.input :forks
      f.input :contributors
      f.input :dependents
      f.input :stars
    end
    f.inputs 'Taggings' do
      f.input :category_list, as: :select, multiple: true, collection: TagCache.categories.pluck(:name).uniq,
                              input_html: { 'data-tags' => true }
      f.input :adjective_list, as: :select, multiple: true, collection: TagCache.adjectives.pluck(:name).uniq,
                               input_html: { 'data-tags' => true }
    end
    f.inputs 'Content' do
      f.li do
        f.label :content, class: 'trix-editor-label'
        f.rich_text_area :content
      end
      f.input :primary_image, as: :file
    end
    f.actions
  end
end
