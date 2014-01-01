class Admin::LocationsController < AdminController
  respond_to :html

  def index
    @locations = Location.includes(:images)
    respond_with @locations
  end

  def new
    @location = Location.new(APP_CONFIG['default_location'])
    respond_with @location
  end

  def edit
    @location = Location.find(params[:id])
    respond_with @location
  end

  def create
    @location = Location.new(location_params)
    flash[:success] = 'Location added' if @location.save
    respond_with @location, :location => admin_locations_path
  end

  def update
    @location = Location.find(params[:id])
    flash[:success] = 'Location updated' if @location.update(location_params)
    respond_with @location, :location => admin_locations_path
  end

  def destroy
    @location = Location.find(params[:id])
    flash[:success] = 'Location deleted' if @location.destroy
    respond_with @location, :location => admin_locations_path
  end

  private

  def location_params
    params.require(:location).permit(:name, :latitude, :longitude, :radius)
  end
end
