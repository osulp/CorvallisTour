require 'spec_helper'

describe Location do
  subject {build(:location)}
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:latitude)}
    it {should validate_presence_of(:longitude)}
  end
end
