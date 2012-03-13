class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    # @user = User.new
    # if @user.save
    #   # logic
    # else
    #   # logic
    # end
    user = User.create!(params[:user])
    cookies.permanent[:auth_token] = user.auth_token
    redirect_to root_url
  end

end
