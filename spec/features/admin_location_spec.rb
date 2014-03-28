require 'spec_helper'
include AuthHelper

describe 'location admin' do
  let(:location) {create(:location)}
  before(:each) do
    capybara_login
  end
  context 'when there are locations defined' do
    before(:each) do
      location
      visit admin_locations_path
    end
    it 'should show them' do
      expect(page).to have_content(location.name)
    end
    it 'should let you edit' do
      click_link 'Edit'
      expect(page).to have_content('Edit')
      fill_in 'location_name', :with => 'A random place'
      fill_in 'location_latitude', :with => '42.01'
      fill_in 'location_longitude', :with => '-42.01'
      fill_in 'location_radius', :with => '150.01'
      click_button 'Save'
      expect(page).to have_content('Location updated')
      last = Location.last
      expect(last.name).to eq 'A random place'
      expect(last.latitude).to be_within(1e-5).of 42.01
      expect(last.longitude).to be_within(1e-5).of -42.01
      expect(last.radius).to be_within(1e-5).of 150.01
    end
    it 'should let you delete', :js => true do
      expect(page).to have_content(location.name)
      find("a[href='/admin/locations/#{location.id}'][data-method='delete']").click
      expect(page).not_to have_content(location.name)
      expect(page).to have_content("Location deleted")
    end
    it 'should let you move up and down' do
      test_location = create(:location)
      visit admin_locations_path
      expect(Location.find(test_location.id)).to be_last
      page.find(".location-#{test_location.id} .up").click
      expect(Location.find(test_location.id)).not_to be_last
      page.find(".location-#{test_location.id} .down").click
      expect(Location.find(test_location.id)).to be_last
      page.find(".location-#{test_location.id} .top").click
      expect(Location.find(test_location.id)).to be_first
      page.find(".location-#{test_location.id} .bottom").click
      expect(Location.find(test_location.id)).to be_last
    end
  end
  it 'should let you create' do
    visit admin_locations_path
    click_link 'New location'
    fill_in 'location_name', :with => 'Another random place'
    fill_in 'location_latitude', :with => '24.01'
    fill_in 'location_longitude', :with => '-24.01'
    fill_in 'location_radius', :with => '120.01'
    click_button 'Save'
    expect(page).to have_content('Location added')
    last = Location.last
    expect(last.name).to eq 'Another random place'
    expect(last.latitude).to be_within(1e-5).of 24.01
    expect(last.longitude).to be_within(1e-5).of -24.01
    expect(last.radius).to be_within(1e-5).of 120.01
  end
end