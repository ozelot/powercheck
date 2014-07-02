class DevicesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_device,         only: [:show,:edit, :update, :destroy]

  def index
    @devices = Device.where(user: current_user).paginate(page: params[:page])
  end

  def new
    @device = Device.new
  end

  def show
  end

  def create
    @device = Device.new(device_params)
    @device.user = current_user
    if @device.save
      flash[:success] = "Gerät angelegt!"
      redirect_to devices_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @device.update_attributes(device_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to devices_path
    else
      render 'edit'
    end
  end

  def destroy
    @device.destroy
    flash[:success] = "Gerät wurde gelöscht."
    redirect_to devices_path
  end

  private

  def device_params
    params.require(:device).permit()
  end

  # Before filters

  def correct_device
    @device = Device.find(params[:id])
    redirect_to root_url unless current_user?(@device.user)
  end

end
