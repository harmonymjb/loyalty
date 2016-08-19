class RewardsController < ApplicationController

  def new
    @store = current_user.store
  end

  def create
    @store = current_user.store
    @store.rewards.create(reward_params)
    redirect_to store_path(current_user.store.id)
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
    @user = current_user
    if !@current_user.admin
      @account = Account.find_by(user_id: current_user.id, store_id: @store.id)
    end
  end

  def edit
    if user_signed_in? && current_user.admin
      @reward = Reward.find(params[:id])
    end
  end

  private
  def reward_params
    params.require(:reward).permit(:name, :value, :description)
  end
end
