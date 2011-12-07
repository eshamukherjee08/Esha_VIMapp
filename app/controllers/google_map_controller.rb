class GoogleMapController < ApplicationController
  def index
    @lat = params[:lat] || "28.6450384"
    @lon = params[:lon] || "77.1692714"
    @zoom = params[:zoom] || "10"
  end
end
