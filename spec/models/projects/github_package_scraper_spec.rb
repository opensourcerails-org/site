require 'rails_helper'

describe Projects::PackageScraper do
  before do
    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*\/git\/trees\/\w*$/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "git", "trees", "packages_level_1.json")), status: 200)

    stub_request(:get, /https:\/\/api.github.com\/repos\/\w*\/\w*\/git\/blobs\/\w*$/)
      .to_return(body: File.read(Rails.root.join("spec", "fixtures", "github_scraper", "repos", "git", "blobs", "package.json")), status: 200)

  end

  let(:project) { create(:project, last_commit: "asdfasdfasdfasdfasdfasdfasdfasdf") }
  subject { instance = described_class.new(project); instance.run; instance }

  it 'works' do
    expect(subject.packages).to match_array(%w[@babel/preset-react @rails/actioncable @rails/activestorage @rails/ujs @rails/webpacker babel-plugin-transform-react-remove-prop-types bootstrap bootstrap-select dayjs formik fuse.js is-svg jquery leaflet leaflet-ajax leaflet-spin leaflet.markercluster lodash mjml places.js popper.js prop-types react react-dom react-on-rails react-query stimulus turbolinks zxcvbn])
  end
end
