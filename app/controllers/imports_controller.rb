class ImportsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_import, only: [:show, :destroy]

  def index
    @imports = Import.where(user: current_user).paginate(page: params[:page])
  end

  def new
    @imports = Import.new
  end

  def show
  end

  def create
    @imports = Import.new(import_params)
    @imports.user = current_user
    if @imports.save
      flash[:success] = "Prüfbericht angelegt!"
      redirect_to imports_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @imports.update_attributes(import_params)
      flash[:success] = "Änderungen gespeichert."
      redirect_to imports_path
    else
      render 'edit'
    end
  end

  def destroy
    @imports.destroy
    flash[:success] = "Import wurde gelöscht."
    redirect_to imports_url
  end

  private

  def import_params
    params.require(:import).permit(:import_file)
  end

    # Before filters

    def correct_import
      @imports = Import.find_by_id(params[:id])
      redirect_to root_url unless @imports != nil && current_user?(@imports.user)
    end
end
