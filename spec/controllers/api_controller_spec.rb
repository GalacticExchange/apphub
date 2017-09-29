require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  render_views

  describe 'GET index' do
    it 'gets index' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body).to match('{}')
    end
  end


  describe 'GET search' do
    it 'request without "fields" param should return 400' do
      get :search
      expect(response).to have_http_status(400)
    end

    it 'request with blank "fields" param should return 400' do
      get :search, params: {fields: []}
      expect(response).to have_http_status(400)
    end

    it 'request with "fields" param should succeed' do
      get :search, params: {fields: ['id', 'status']}
      expect(response).to have_http_status(200)
    end
  end


  describe 'GET container' do
    it 'request withoud "id" param should return 400' do
      get :get_container
      expect(response).to have_http_status(400)
    end

    it 'request with "id" we don\'t have should return 404' do
      get :get_container, params: {id: 2000}
      expect(response).to have_http_status(404)
    end

    it 'request with wrong "id" should return 404' do
      get :get_container, params: {id: 'asd'}
      expect(response).to have_http_status(404)
    end
  end


  describe 'GET random container' do
    it 'should return container with status 1' do
      100.times do
        get :random_container, params: {fields: ['status']}
        expect(response).to have_http_status(200)
        expect(response.body).to match('{"status":1}')
      end
    end
  end
end
