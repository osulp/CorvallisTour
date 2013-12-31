class WaypointsController < ApplicationController
  respond_to :json

  def index
    visited_waypoints = session[:visited] || []
    locations = Location.all
    waypoints = locations.map do |location|
      l = location.attributes
      l[:visited] = visited_waypoints.include? location[:id]
      l
    end

    respond_with waypoints
  end
end
