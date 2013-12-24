require 'spec_helper'

describe Image do
  subject {build(:image)}
  describe "validations" do
    it {should belong_to(:location)}
    it 'should validate presence of :photo' do
      expect(Image.new).to have(1).error_on(:photo)
    end
  end
end
