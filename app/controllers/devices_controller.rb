class DevicesController < ApplicationController

  def index
    Device.fetch_devices
    @devices = Device.all
  end

  def show
    @device = Device.find(params[:id])
  end

end
