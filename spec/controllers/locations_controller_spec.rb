require 'spec_helper'

describe LocationsController do
  describe ':index' do
    it "should return success" do
      get :index
      expect(response).to be_success
    end
  end
end
