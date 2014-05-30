# -*- coding: utf-8 -*-
class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_report,         only: [:show, :edit, :update, :destroy]

  def index
    @reports = Report.where(user: current_user).paginate(page: params[:page])
  end

  def new
    @report = Report.new
  end

  def show
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user
    if @report.save
      flash[:success] = "Prüfbericht angelegt!"
      redirect_to reports_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @report.update_attributes(report_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to reports_path
    else
      render 'edit'
    end
  end

  def destroy
    @report.destroy
    flash[:success] = "Prüfbericht wurde gelöscht."
    redirect_to reports_url
  end

  private

  def report_params
    params.require(:report).permit(:summary)
  end

    # Before filters

    def correct_report
      @report = Report.find(params[:id])
      redirect_to root_url unless current_user?(@report.user)
    end

end
