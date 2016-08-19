class StoresController < ApplicationController
  def index
    @stores = Store.all
    @accounts = Account.all
  end

  def new
    if current_user.admin
      flash[:notice] = "You are already administrating a store"
      redirect_to user_accounts_path(current_user)
    end
  end

  def update
    redirect_to root_path unless user_is_store_admin?(params)
    if current_user.store.update_attributes(store_params)
      flash[:notice] = "Store Updated"
      redirect_to user_accounts_path(current_user)
    else
      render 'edit'
    end
  end

  def create
    redirect_to root_path if current_user.admin
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
    redirect_to root_path unless user_is_store_admin?(params)
  end

  private
  def store_params
    params.require(:store).permit(:name, :description, :default_value)
  end

  def user_is_store_admin?(params)
    @store = current_user.store
    @store.id == params[:id].to_i
  end
end
