class LocationsController < ApplicationController
  respond_to :json

  def index
    visited_locations = session[:visited] || []
    locations = Location.all
    locations = locations.map do |location|
      l = location.attributes
      l[:visited] = visited_locations.include? location[:id]
      l
    end

    respond_with locations
  end
end
