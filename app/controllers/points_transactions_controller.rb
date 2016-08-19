class PointsTransactionsController < ApplicationController

  def new
    @account = Account.find(params[:account_id])
  end

  def create
    if points_transaction_params
      value = points_transaction_params[:value].to_i
      params[:trans_type] = points_transaction_params[:trans_type]
    end
    if user_representing_self?(params) && user_on_account?(params)
      if params[:trans_type] == "credit"
        value ||= @account.store.default_value
        if current_user.admin
          ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                             approved: false,
                                             trans_type: "credit")
          if ptrans
            params[:id] = ptrans.id
            update
          else
            # Wrap this in a transaction
            ptrans = PointsTransaction.new(value: value,
                                           account_id: params[:account_id],
                                           approved: true)
            @account.value += ptrans.value
            ptrans.save
            @account.save
            flash[:notice] = "#{ptrans.value} point(s) were given"
            redirect_to user_accounts_path(current_user.id)
          end
        else
          ptrans = PointsTransaction.new(value: value, account_id: params[:account_id])
          if ptrans.save
            flash[:notice] = "#{value} Point(s) Requested"
          else
            flash[:alert] = "Points request failed"
          end
          redirect_to user_accounts_path(current_user.id)
        end
      elsif params[:trans_type] == "debit"
        p value
        value ||= Reward.find(params[:reward_id]).value
        if current_user.admin
          ptrans = PointsTransaction.find_by(account_id: params[:account_id],
                                             approved: false,
                                             trans_type: "debit")
          if ptrans
            params[:id] = ptrans.id
            update
          else
            account = Account.find(params[:account_id])
            value = -value
            ptrans = PointsTransaction.new(value: value, account_id: params[:account_id], trans_type: "debit", approved: true)
            account.value += value
            if ptrans.save && account.save
              flash[:notice] = "Reward redeemed for #{-value} point(s)"
            else
              flash[:alert] = "Redemption request failed"
            end
            redirect_to user_accounts_path(current_user.id)
          end
        elsif @account.value >= value
          value = -value
          ptrans = PointsTransaction.new(value: value,
                                         account_id: params[:account_id],
                                         trans_type: "debit")
          ptrans = ptrans.save
          flash[:notice] = "Reward Requested for #{-value} point(s)"
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
        flash[:notice] = "A request for #{ptrans.value} point(s) was approved"
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

  def points_transaction_params
    params.require(:points_transaction).permit(:value, :trans_type)
  end

end
