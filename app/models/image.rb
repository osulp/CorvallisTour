class Image < ActiveRecord::Base
  belongs_to :location
  mount_uploader :photo, ImageUploader
  validates_presence_of :photo
end
