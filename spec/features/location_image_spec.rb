require 'spec_helper'
include AuthHelper

describe 'location image admin' do
  let(:location) {create(:location)}
  before(:each) do
    capybara_login
  end
  context 'when there are images defined' do
    let(:image) {create(:image)}
    before(:each) do
      image
      visit location_images_path image.location
    end
    it 'should show them' do
      expect(page).to have_content(image.title)
    end
    it 'should let you edit' do
      click_link 'Edit'
      expect(page).to have_content('Edit')
      fill_in 'image_title', :with => 'Another stadium'
      fill_in 'image_description', :with => 'The title is not correct'
      click_button 'Save'
      expect(page).to have_content('Image updated')
      last = image.location.images.last
      expect(last.title).to eq 'Another stadium'
      expect(last.description).to eq 'The title is not correct'
    end
    it 'should let you delete', :js => true do
      expect(page).to have_content(image.title)
      find("a[href='/locations/#{image.location.id}/images/#{image.id}'][data-method='delete']").click
      expect(page).not_to have_content(image.title)
      expect(page).to have_content("Image deleted")
    end
  end
  it 'should let you create' do
    visit location_images_path location
    click_link 'New image'
    fill_in 'image_title', :with => 'Rings'
    fill_in 'image_description', :with => 'Many rings in the picture'
    attach_file "image_photo", 'spec/fixtures/sample_image.png'
    click_button 'Save'
    expect(page).to have_content('Image added')
    last = location.images.last
    expect(last.title).to eq 'Rings'
    expect(last.description).to eq 'Many rings in the picture'
    expect(last.photo).not_to be_nil
  end
end