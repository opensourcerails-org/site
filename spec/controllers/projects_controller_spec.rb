require 'rails_helper'

RSpec.describe ProjectsController do
  context '#index' do
    it 'returns 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
  context '#show' do
    context 'a valid slug' do
      let!(:project) { create(:project) }

      it 'returns 200' do
        get :show, params: { slug: project.slug }
        expect(response).to have_http_status(:ok)
      end

      it 'sets the title to the project name' do
        get :show, params: { slug: project.slug }
        expect(assigns(:meta_tags).meta_tags[:title]).to eq("GitLab")
      end
    end
  end
end
