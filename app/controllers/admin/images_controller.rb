class Admin::ImagesController < AdminController
  respond_to :html
  before_filter :get_location

  def index
    @images = @location.images
    respond_with @images
  end

  def new
    @image = @location.images.new
    respond_with @image
  end

  def edit
    @image = @location.images.find(params[:id])
    respond_with @image
  end

  def create
    @image = @location.images.new(image_params)
    flash[:success] = 'Image added' if @image.save
    respond_with @image, :location => admin_location_images_path(@location)
  end

  def update
    @image = @location.images.find(params[:id])
    flash[:success] = 'Image updated' if @image.update(image_params)
    respond_with @image, :location => admin_location_images_path(@location)
  end

  def destroy
    @image = @location.images.find(params[:id])
    flash[:success] = 'Image deleted' if @image.destroy
    respond_with @image, :location => admin_location_images_path(@location)
  end

  private

  def image_params
    params.require(:image).permit(:title, :description, :photo)
  end

  def get_location
    @location = Location.find(params[:location_id])
  end
end
