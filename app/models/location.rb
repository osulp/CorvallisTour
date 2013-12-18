class Location < ActiveRecord::Base
  validates :name, :latitude, :longitude, :radius, :presence => true
  has_many :images
end
