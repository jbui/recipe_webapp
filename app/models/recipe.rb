class Recipe < ActiveRecord::Base
  before_create :parse_url
  attr_accessible :url
  attr_protected :name, :image_url, :ingredients, :directions

  has_and_belongs_to_many :users

  def parse_url()

    require 'Parser'
    require 'Epicurious'
    require 'Allrecipes'

    parsers = %w[Epicurious Allrecipes]
    recipe = nil
    parsers.each do |site|
      site = site.constantize
      if site.check_url self.url
        recipe = site.new(url)
        break
      end
    end

    if recipe.nil?
      # raise InvalidURLException
    end

    self.name = recipe.name
    self.image_url = recipe.image_url
    self.ingredients = recipe.ingredients.join("\t")
    self.directions = recipe.directions.join("\t")

  end

end
