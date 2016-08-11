class PointsTransactionsController < ApplicationController
  def create
    # If you're signed in, and you're requesting for yourself
    if user_signed_in? && current_user.id == params[:user_id].to_i
      @ptrans = PointsTransaction.new(value: 1, account_id: params[:account_id])
      @ptrans.save
      flash[:notice] = "Points Requested"
      redirect_to user_accounts_path(current_user.id)
    # If you're a store, and creating for a user
    elsif user_signed_in? && current_user.admin
      # If there is an open requests, approve it rather than generating
      ptrans = PointsTransaction.find_by(account_id: params[:account_id], approved: false)
      if ptrans
        params[:id] = ptrans.id
        update
      else
        @ptrans = PointsTransaction.new(value: 1, account_id: params[:account_id], approved: true)
        @account = Account.find(params[:account_id])
        @account.value += @ptrans.value
        @ptrans.save
        @account.save
        redirect_to user_accounts_path(current_user.id)
      end
    end
  end
  def update
    # The patch here is for approving a transaction
    if user_signed_in? && current_user.admin
      if current_user.store.id == Account.find(params[:account_id]).store_id
        ptrans = PointsTransaction.find(params[:id])
        if !ptrans.approved
          ptrans.approved = true
          account = Account.find(params[:account_id])
          account.value += ptrans.value
          ptrans.save
          account.save
          redirect_to user_accounts_path(current_user.id)
        end
      end
    end
  end
end
