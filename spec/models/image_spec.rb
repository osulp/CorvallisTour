require 'spec_helper'

describe Image do
  subject {build(:image)}
  describe "validations" do
    it {should belong_to(:location)}
    it {should validate_presence_of(:path)}
  end
end
