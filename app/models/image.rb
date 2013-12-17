class Image < ActiveRecord::Base
  validates :path, :presence => true
  belongs_to :location
end
