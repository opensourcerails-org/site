require 'rails_helper'

describe TagCache do
  let!(:counter) { 0 }
  before do
    record_events
  end

  after do
    TagCache.flush_cache
  end

  shared_examples_for "memoized" do
    it 'fires a query if not cached' do
      expect { subject }.to change(events, :size).by(1)
    end

    it 'memoizes the method' do
      subject
      expect { subject }.to_not change(events, :size)
    end

    it 'loads into an array' do
      expect(subject).to be_an(Array)
    end

  end

  context 'gems' do
    let!(:gem) { create(:gem) }
    subject { TagCache.gems }

    it_behaves_like 'memoized'

    it 'has the right count' do
      expect(subject.first.taggings.where(context: "gems").count).to eq(1)
    end
  end

  # this is flaky
  context 'packages' do
    let!(:package) { create(:package) }
    subject { TagCache.packages }

    it_behaves_like 'memoized'

    it 'has the right count' do
      expect(subject.first.taggings.where(context: "packages").count).to eq(1)
    end
  end

  context 'adjectives' do
    let!(:adjective) { create(:adjective) }
    subject { TagCache.adjectives }

    it_behaves_like 'memoized'

    it 'has the right count' do
      expect(subject.first.taggings.where(context: "adjectives").count).to eq(1)
    end
  end

  context 'frontend_stacks' do
    let!(:frontend_stack) { create(:frontend_stack) }
    subject { TagCache.frontend_stacks }

    it_behaves_like 'memoized'

    it 'has the right count' do
      expect(subject.first.taggings.where(context: "frontend_stack").count).to eq(1)
    end
  end

  context 'backend_stacks' do
    let!(:backend_stack) { create(:backend_stack) }
    subject { TagCache.backend_stacks }

    it_behaves_like 'memoized'

    it 'has the right count' do
      expect(subject.first.taggings.where(context: "backend_stack").count).to eq(1)
    end
  end

  private

  attr_reader :events

  def record_events
    @events = []
    ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      @events << ActiveSupport::Notifications::Event.new(*args)
    end
  end
end
