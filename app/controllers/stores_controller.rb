class StoresController < ApplicationController
  def index
    @stores = Store.all
    @accounts = Account.all
  end

  def new
    @user = current_user
  end

  def update
    @user = current_user
    if @user.store.update_attributes(store_params)
      flash[:notice] = "Store Updated"
      redirect_to user_accounts_path(@user)
    else
      render 'edit'
    end
  end

  def create
    @user = current_user
    @user.create_store(store_params)
    @user.admin = true
    @user.save
    redirect_to user_accounts_path(current_user)
  end

  def show
    @store = Store.find(params[:id])
  end

  def edit
    @user = current_user
  end

  private
  def store_params
    params.require(:store).permit(:name, :description, :default_value)
  end
end
