class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,         only: [:show, :create, :edit, :update, :destroy]

  def index
    @reports = Report.where(user: current_user).paginate(page: params[:page])
  end

  def new
    @report = Report.new
  end

  def show
    @report = Report.find(params[:id])
  end

  def create
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
  end

  def destroy
  end

    # Before filters

    def correct_user
      @user = Report.find(params[:id]).user
      redirect_to root_url unless current_user?(@user)
    end

end
