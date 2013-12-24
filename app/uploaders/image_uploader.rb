# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :scale_photo_size

  version :thumb do
    process :scale_thumbnail_size
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def get_resize_scale key, default_scale
    if !APP_CONFIG['resize_image'].nil? and APP_CONFIG['resize_image'][key].is_a? Array
      APP_CONFIG['resize_image'][key]
    else
      default_scale
    end
  end

  def scale_photo_size
    @photo_size ||= get_resize_scale 'photo', [480, 360]
    resize_to_fit *@photo_size
  end

  def scale_thumbnail_size
    @thumbnail_size ||= get_resize_scale 'thumbnail', [120, 90]
    resize_to_fill *@thumbnail_size
  end

end
