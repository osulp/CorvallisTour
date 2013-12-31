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

  def images
    location = Location.find(params[:id])
    images = Image.where(:location => location)
    session[:visited] ||= []
    session[:visited] <<= location.id
    respond_with images
  rescue ActiveRecord::RecordNotFound
    respond_with []
  end
end
