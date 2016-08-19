class PointsTransactionsController < ApplicationController

  def create
    if user_representing_self?(params) && user_on_account?(params)
      if params[:trans_type] == "credit"
        if current_user.admin
          ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                             approved: false,
                                             trans_type: "credit")
          if ptrans
            params[:id] = ptrans.id
            update
          else
            # Wrap this in a transaction
            ptrans = PointsTransaction.new(value: current_user.store.default_value,
                                           account_id: params[:account_id],
                                           approved: true)
            @account.value += ptrans.value
            ptrans.save
            @account.save
            flash[:notice] = 'A point was given'
            redirect_to user_accounts_path(current_user.id)
          end
        else
          value = @account.store.default_value
          ptrans = PointsTransaction.new(value: value, account_id: params[:account_id])
          ptrans.save
          flash[:notice] = "Points Requested"
          redirect_to user_accounts_path(current_user.id)
        end
      elsif params[:trans_type] == "debit"
        reward = Reward.find(params[:reward_id])
        if current_user.admin
          ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                             approved: false,
                                             trans_type: "debit")
          if ptrans
            params[:id] = ptrans.id
            update
          end
        elsif @account.value >= reward.value
          ptrans = PointsTransaction.new(value: -1*reward.value,
                                         account_id: params[:account_id],
                                         trans_type: "debit")
          ptrans = ptrans.save
          flash[:notice] = "Reward Requested"
          redirect_to user_accounts_path(current_user.id)
        end
      end
    end
  end

  def update
    # The patch here is for approving a transaction
    if user_representing_self?(params) && user_on_account?(params) && current_user.admin
      ptrans = PointsTransaction.find(params[:id])
      if !ptrans.approved
        # Wrap this in a transaction
        ptrans.approved = true
        @account.value += ptrans.value
        ptrans.save
        @account.save
        flash[:notice] = "A request was approved"
        redirect_to user_accounts_path(current_user.id)
      end
    end
  end

  private

  def user_representing_self?(params)
    user_signed_in? && current_user.id == params[:user_id].to_i
  end

  def user_on_account?(params)
    @account = Account.find(params[:account_id])
    if current_user.admin
      current_user.store.id == @account.store_id
    else
      current_user.id == @account.user_id
    end
  end
end
