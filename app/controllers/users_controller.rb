# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_action :signed_in_user,                only: [:show, :edit, :update]
  before_action :correct_user,                  only: [:show, :edit, :update]
  before_action :admin_user,                    only: [:index, :destroy]
  before_action :not_signed_in_user,            only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Willkommen bei Power.Check!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def not_signed_in_user
      redirect_to root_url if signed_in?
    end
end
