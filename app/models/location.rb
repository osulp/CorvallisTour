class Location < ActiveRecord::Base
  validates :name, :latitude, :longitude, :presence => true
  has_many :images
end
