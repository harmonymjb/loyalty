class StoresController < ApplicationController
  def index
    @stores = Store.all
    @accounts = Account.all
  end

  def new
    @user = User.find(current_user.id)
  end

  def create
    @user = User.find(params[:user_id])
    @store = @user.create_store(store_params)
    @user.admin = true
    @user.save
    redirect_to store_path(@store)
  end

  def show
    @store = Store.find(params[:id])    
  end

  private
  def store_params
    params.require(:store).permit(:name, :description)
  end
end
