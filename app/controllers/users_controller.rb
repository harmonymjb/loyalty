class UsersController < ApplicationController
  def index
    @users = User.all.select { |user| !user.admin }
  end
  def show
    @user = User.find(params[:id])
  end
end
