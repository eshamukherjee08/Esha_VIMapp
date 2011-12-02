class GoogleMapController < ApplicationController
  def index
    @lat = params[:lat] || "28.6450384"
    @lon = params[:lon] || "77.1692714"
    @zoom = params[:zoom] || "10"
  end
  
  # def change_map_location
  #     @loc = params[:location]
  #   end

end
