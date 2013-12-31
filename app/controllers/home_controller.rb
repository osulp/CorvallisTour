class HomeController < ApplicationController
  layout false
  def index
  end

  respond_to :json
  def get_waypoints
    visited_waypoints = session[:visited] || []
    locations = Location.all
    waypoints = locations.map do |location|
      l = location.attributes
      l[:visited] = visited_waypoints.include? location[:id]
      l
    end
    respond_to do |format|
      format.json { render :json => waypoints }
    end
  end

  def get_images
    location = Location.find(params[:id])
    images = Image.where(:location => location)
    session[:visited] ||= []
    session[:visited] <<= location.id
    respond_with images
  rescue ActiveRecord::RecordNotFound
    respond_with []
  end
end
