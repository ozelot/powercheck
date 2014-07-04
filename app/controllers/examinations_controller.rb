class ExaminationsController < ApplicationController

  before_action :signed_in_user
  before_action :correct_examination,         only: [:show,:edit, :update, :destroy]

  def index
    @examinations = Examination.joins(:device, :user).where(user: current_user).paginate(page: params[:page])
  end

  def new
    @examination = Examination.new
  end

  def show
  end

  def create
    @examination = Examination.new(examination_params)
    if @examination.save
      flash[:success] = "Prüfung angelegt!"
      redirect_to examinations_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @examination.update_attributes(examination_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to examinations_path
    else
      render 'edit'
    end
  end

  def destroy
    @examination.destroy
    flash[:success] = "Prüfung wurde gelöscht."
    redirect_to examinations_path
  end

  private

  def examination_params
    params.require(:examination).permit(:device, :result, :date)
  end

  # Before filters

  def correct_examination
    @examination = Examination.find(params[:id])
    @device = Device.where(id: @examination.device_id)
    @user = User.where(id: @device.user_id)
    redirect_to root_url unless current_user?(@user)
  end


end
