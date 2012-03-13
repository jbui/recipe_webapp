class RecipesController < ApplicationController

  respond_to :html, :json

  def index

    if params[:view] == "recent"
      @recipes = Recipe.find(:all, :order => "created_at DESC", :limit => 10)
    elsif params[:view] == "popular"
      # fake it till you make it
      @recipes = Recipe.find(:all, :order => "RANDOM()", :limit => 10)
    end

    # respond_with(@recipes)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.find_by_url(params[:recipe][:url]) || Recipe.new(params[:recipe])
    # @recipe = Recipe.new(params[:recipe])

    # @recipe.users << current_user

    if @recipe.save
      # Make sure to add only after save, or dead links will appear if 
      # scraper doesnt work for that specific site
      current_user.recipes << @recipe
      # redirect_to(@recipe)
    else
      render :action => "new"
    end
    redirect_to root_url
  end

  def show
    @recipe = Recipe.find_by_id(params[:id])
    if @recipe.nil?
      render :action => "index"
    end
    # respond_with(@recipe)

  end

end
