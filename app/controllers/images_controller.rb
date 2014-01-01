class ImagesController < ApplicationController
  respond_to :json

  def index
    location = Location.find(params[:location_id])
    images = Image.where(:location => location)
    session[:visited] ||= []
    session[:visited] <<= location.id
    respond_with images
  rescue ActiveRecord::RecordNotFound
    respond_with []
  end
end
