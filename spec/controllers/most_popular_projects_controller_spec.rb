require 'rails_helper'

describe MostPopularProjectsController do
  render_views

  let!(:project) { create(:project, last_activity_at: Time.current, stars: 1000) }

  it 'displays stars count' do
    get :index
    expect(response.body).to match(/1,000 stars/)
  end
end
