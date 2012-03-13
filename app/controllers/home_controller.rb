class HomeController < ApplicationController

  def index

    if current_user
      @recipe = Recipe.new
      @myrecipes = current_user.recipes
      render "home/index"
    else
      @user = User.new
      render "home/landing"
    end
  end
  
end
