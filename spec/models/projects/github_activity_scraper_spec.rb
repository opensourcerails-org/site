require 'rails_helper'

describe Projects::GithubActivityScraper do
  before do
    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*\/commits/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "commits", "index.json")), status: 200)
  end

  let(:project) { create(:project) }
  subject { instance = described_class.new(project); instance.run; instance }

  context '#last_activity_at' do
    it 'is set' do
      expect(subject.last_activity_at.to_s).to eq("2021-09-06T19:08:02+00:00")
    end
  end

  context '#last_commit' do
    it 'is set' do
      expect(subject.last_commit).to eq("c54ef41027276d709fd9d7ac0775e62d56c98c8b")
    end
  end
end
