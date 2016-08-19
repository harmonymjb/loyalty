class PointsTransactionsController < ApplicationController

  def create
    if params[:trans_type] == "credit"
      value = Account.find(params[:account_id]).store.default_value
      # If you're signed in, and you're requesting for yourself
      if user_signed_in? && current_user.id == params[:user_id].to_i
        ptrans = PointsTransaction.new(value: value, account_id: params[:account_id])
        ptrans.save
        flash[:notice] = "Points Requested"
        redirect_to user_accounts_path(current_user.id)
      # If you're a store, and creating for a user
      elsif user_signed_in? && current_user.admin
        # If there is an open requests, approve it rather than generating
        ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                           approved: false,
                                           trans_type: "credit")
        if ptrans
          params[:id] = ptrans.id
          update
        else
          ptrans = PointsTransaction.new(value: value,
                                         account_id: params[:account_id],
                                         approved: true)
          account = Account.find(params[:account_id])
          account.value += ptrans.value
          ptrans.save
          account.save
          flash[:notice] = 'A point was given'
          redirect_to user_accounts_path(current_user.id)
        end
      end

    elsif params[:trans_type] == "debit"
      reward = Reward.find(params[:reward_id])
      account = Account.find(params[:account_id])
      if user_signed_in? && current_user.id == params[:user_id].to_i && account.value >= reward.value
        ptrans = PointsTransaction.new(value: -1*reward.value,
                                       account_id: params[:account_id],
                                       trans_type: "debit")
        ptrans = ptrans.save
        flash[:notice] = "Reward Requested"
        redirect_to user_accounts_path(current_user.id)

      elsif user_signed_in? && current_user.admin
        ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                           approved: false,
                                           trans_type: "debit")
        if ptrans
          params[:id] = ptrans.id
          update
        end
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
          flash[:notice] = "A request was approved"
          redirect_to user_accounts_path(current_user.id)
        end
      end
    end
  end

end
