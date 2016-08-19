class RewardsController < ApplicationController

  def new
    redirect_to root_path unless user_is_store_admin?(params)
  end

  def create
    if user_is_store_admin?(params)
      if @store.rewards.create(reward_params)
        redirect_to user_accounts_path(current_user)
      else
        flash[:alert] = "Failed to save reward"
        redirect_to new_store_reward_path(@store)
      end
    else
      redirect_to root_path
    end
  end

  def update
    @reward = Reward.find(params[:id])
    if @reward.update_attributes(reward_params)
      flash[:notice] = "Reward Updated"
      redirect_to store_rewards_path(current_user.store)
    else
      flash[:alert] = "Failed to update reward"
      render 'edit'
    end
  end

  def index
    @store = Store.find(params[:store_id])
    @rewards = @store.rewards
    if params[:user_id]
      @user = User.find(params[:user_id])
      @account = Account.find_by(user_id: @user.id, store_id: @store.id)
    end
    if !current_user.admin
      @account = Account.find_by(user_id: current_user.id, store_id: @store.id)
    end
  end

  def edit
    if user_is_store_admin?(params)
      @reward = Reward.find(params[:id])
    end
  end

  def destroy
    if user_is_store_admin?(params)
      Reward.find(params[:id]).destroy
      redirect_to store_rewards_path(@store)
    else
      redirect_to root_path
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :value, :description)
  end

  def user_is_store_admin?(params)
    @store = current_user.store
    @store.id == params[:store_id].to_i
  end

end
