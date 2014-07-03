class ImportsController < ApplicationController
  before_action :admin_user
  before_action :correct_import, only: [:show, :edit, :destroy]

  def index
    @imports = Import.where(user: current_user).paginate(page: params[:page])
  end

  def new
    @import = Import.new
  end

  def show
  end

  def create
    @import = Import.new(import_params)
    @import.user = current_user
    if @import.save
      flash[:success] = "Prüfbericht angelegt!"
      redirect_to imports_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @import.update_attributes(import_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to imports_path
    else
      render 'edit'
    end
  end

  def destroy
    @import.destroy
    flash[:success] = "Import wurde gelöscht."
    redirect_to imports_url
  end

  private

  def import_params
    params.require(:import).permit(:import_file)
  end

    # Before filters

    def correct_import
      @import = Import.find_by_id(params[:id])
      redirect_to root_url unless @import != nil && current_user?(@import.user)
    end
end
