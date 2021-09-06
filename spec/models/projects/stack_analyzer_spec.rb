require 'rspec'

describe Projects::StackAnalyzer do
  let(:project) { create(:project, gem_list: "pg, caffeinate", package_list: "react, caffeinate-js") }

  it 'has the correct stacks' do
    instance = described_class.new(project)
    instance.run
    expect(instance.backend).to match_array(["pg"])
    expect(instance.frontend).to match_array(["react"])
  end
end
