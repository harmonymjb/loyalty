class AccountsController < ApplicationController

  def index
    if !current_user
      redirect_to stores_path
    elsif current_user.admin
      @accounts = current_user.store.accounts
    else
      @accounts = current_user.accounts
    end
  end

  def create
    if user_representing_self?(params) && !current_user.admin
      begin
        @account = Account.new(value: 0, user_id: params[:user_id], store_id: params[:store_id])
        @account.save
        flash[:notice] = "Account successfully created"
        redirect_to user_accounts_url(current_user)
      rescue ActiveRecord::RecordNotUnique => e
        flash[:alert] = "Account already exists"
        redirect_to user_accounts_url(current_user)
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    if user_representing_self?(params) && user_on_account?(params)
      @account.destroy
      redirect_to user_accounts_path(current_user.id)
    else
      redirect_to root_path
    end
  end

  def show
    if user_representing_self?(params) && user_on_account?(params)
      @ptranss = @account.points_transactions
    else
      redirect_to root_path
    end
  end

  private

  def user_representing_self?(params)
    user_signed_in? && current_user.id == params[:user_id].to_i
  end

  def user_on_account?(params)
    @account = Account.find(params[:id])
    if current_user.admin
      current_user.store.id == @account.store_id
    else
      current_user.id == @account.user_id
    end
  end
end
