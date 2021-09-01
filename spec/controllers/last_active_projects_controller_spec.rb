require 'rails_helper'

describe LastActiveProjectsController do
  render_views

  context '#index' do
    context 'a project with last_activity_at is present' do
      let!(:project) { create(:project, last_activity_at: Time.current) }
      it 'uses time_ago_in_words' do
        get :index
        expect(response.body).to match(/Last updated less than a minute ago/)
      end
    end
  end
end
