class Location < ActiveRecord::Base
  validates :name, :latitude, :longitude, :radius, :presence => true
  has_many :images
  acts_as_list
end
