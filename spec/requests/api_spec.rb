require 'spec_helper'

describe 'API calls' do
  let(:image) {create(:image)}
  context 'Home#get_waypoints' do
    before do
      image
      get '/home/get_waypoints'
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
  context 'Home#get_images' do
    before do
      image
      get "/home/get_images/#{image.location.id}"
    end
    it 'should return images' do
      json = JSON.parse(response.body)
      expect(json[0]['photo']['url']).to eq(image.photo.url)
    end
    it 'should be marked as visited' do
      get '/home/get_waypoints'
      json = JSON.parse(response.body)
      expect(json[0]['visited']).to eq(true)
    end
  end
end