class RecipesController < ApplicationController

  def index
    @recipes = Recipe.find(:all, :order => "created_at DESC", :limit => 10)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(params[:recipe])

    if @recipe.save
      redirect_to(@recipe)
    else
      render :action => "new"
    end
  end

  def show
    @recipe = Recipe.find_by_id(params[:id])
    if @recipe.nil?
      render :action => "index"
    end
  end

end
