require 'spec_helper'

describe Admin::LocationsController do
  it_behaves_like 'admin_panel'
  context ':new' do
    it 'should return sane default values to initialize Google Maps API' do
      http_login
      get :new
      location = assigns(:location)
      expect(location.latitude).not_to be_nil
      expect(location.longitude).not_to be_nil
      expect(location.radius).not_to be_nil
    end
  end
end
