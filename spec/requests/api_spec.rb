require 'spec_helper'

describe 'API calls' do
  let(:image) {create(:image)}
  context 'Waypoints#index' do
    before do
      image
      get '/waypoints/'
      expect(response).to be_success
      @json = JSON.parse(response.body)
    end
    it 'should contain locations' do
      expect(@json.length).to eq(1)
      expect(@json[0]['name']).to eq(image.location.name)
    end
    it 'should not be marked as visited' do
      expect(@json[0]['visited']).to eq(false)
    end
  end
  context 'Waypoints#images' do
    before do
      image
      get "/waypoints/#{image.location.id}/images"
    end
    it 'should return images' do
      json = JSON.parse(response.body)
      expect(json[0]['photo']['url']).to eq(image.photo.url)
    end
    it 'should be marked as visited' do
      get '/waypoints/'
      json = JSON.parse(response.body)
      expect(json[0]['visited']).to eq(true)
    end
  end
end