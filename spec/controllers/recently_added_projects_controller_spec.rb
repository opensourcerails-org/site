require 'rails_helper'

describe RecentlyAddedProjectsController do
  render_views

  context '#index' do
    let!(:project) { create(:project, last_activity_at: Time.current) }
    it 'uses time_ago_in_words' do
      get :index
      expect(response.body).to match(/added less than a minute ago/)
    end
  end
end
