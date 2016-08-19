class AccountsController < ApplicationController
  def index
    @user = current_user
    if !@user
      redirect_to stores_path
    elsif @user.admin
      @accounts = @user.store.accounts
    else
      @accounts = @user.accounts
    end
  end
  def create
    if user_signed_in? && current_user.id == params[:user_id].to_i
      begin
        @account = Account.new(value: 0, user_id: params[:user_id], store_id: params[:store_id])
        @account.save
        flash[:notice] = "Account successfully created"
        redirect_to user_accounts_url(current_user.id)
      rescue ActiveRecord::RecordNotUnique => e
        flash[:notice] = "Account already exists"
        redirect_to user_accounts_url(current_user.id)
      end
    end
  end
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to user_accounts_path(current_user.id)
  end
  def show
    @account = Account.find(params[:id])
    @ptranss = @account.points_transactions
  end
end
