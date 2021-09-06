require 'rails_helper'

describe Projects::GithubMetaScraper do
  before do
    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*$/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "show.json")), status: 200)
  end

  it 'works' do
    project = create(:project)
    instance = described_class.new(project)
    instance.run
    expect(instance.watchers).to eq(31)
  end
end
