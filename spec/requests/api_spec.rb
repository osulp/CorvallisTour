require 'spec_helper'

describe 'API calls' do
  let(:image) {create(:image)}
  let(:setup) {}
  context 'Locations#index' do
    before do
      image
      setup
      get '/locations/'
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
    context "as an admin" do
      let(:setup) do
        ApplicationController.any_instance.stub(:admin?).and_return(true)
      end
      it "should mark all as visited" do
        expect(@json[0]['visited']).to eq(true)
      end
    end
  end
  context 'Locations#images' do
    before do
      image
      get "/locations/#{image.location.id}/images"
    end
    it 'should return images' do
      json = JSON.parse(response.body)
      expect(json[0]['photo']['url']).to eq(image.photo.url)
    end
    it 'should be marked as visited' do
      get '/locations/'
      json = JSON.parse(response.body)
      expect(json[0]['visited']).to eq(true)
    end
    context 'when invalid location id given' do
      it 'should return empty array' do
        get '/locations/-1/images'
        expect(response.body).to eq('[]')
      end
    end
  end
end
