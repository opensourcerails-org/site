require 'rails_helper'

describe Projects::GithubAppScraper do
  before do
    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*\/git\/trees\/\w*$/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "git", "trees", "apps_level_1.json")), status: 200)

    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*\/git\/trees\/level_2$/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "git", "trees", "apps_level_2.json")), status: 200)

  end

  let(:project) { create(:project, last_commit: "asdfasdfasdfasdfasdfasdfasdfasdf") }
  subject { instance = described_class.new(project); instance.run; instance }

  it 'works' do
    expect(subject.app).to match_array(["assets", "controllers", "decorators", "helpers", "interactors", "jobs", "mailers", "models", "views"])
  end
end
