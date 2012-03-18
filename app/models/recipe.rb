class Recipe < ActiveRecord::Base
  # before_create :parse_url
  # attr_accessible :url

  # attr_protected :name, :url, :image_url, :ingredients, :directions, :capture

  has_and_belongs_to_many :users

  # Because of the fact that we use capture groups within the url
  # to figure out if the url has been added by another user,
  # we have to use each parser to determine generate these capture groups
  # and then decide if it's been added already.
  # 
  # This method takes an url. If url is in db or successfully parsed,
  # it returns a Recipe. Otherwise it returns nil.
  def self.parse_url_and_find_or_create(url)

    require 'Parser'
    require 'Epicurious'
    require 'Allrecipes'
    require 'Joythebaker'

    parsers = %w[Epicurious Allrecipes Joythebaker]
    recipe = nil

    # Iterates through all parsers in array and creates new objects out of
    # them. Then checks each url and if groups are capture by regex,
    # first queries db, and creates if not in db.
    parsers.each do |site|
      site = site.constantize 
      capture = url.match(Regexp.new(site.check_url))

      # If parser can parse this site
      if capture
        capture = capture[1..-1].join
        recipe = Recipe.find_by_captured_key(capture)

        # Not found in db
        if recipe.nil?
          content = site.new(url).content
          p content
          recipe = Recipe.create(:name => content[:name], 
                                 :url => url,
                                 :image_url => content[:image_url],
                                 :ingredients => content[:ingredients],
                                 :directions => content[:directions],
                                 :captured_key => capture)
        end

        return recipe
        break
      end

    end

    if recipe.nil?
      return nil
      #   raise "Not a valid url, no parser made for it yet or brokes yo."
    end

    # self.name = recipe.name
    # self.image_url = recipe.image_url
    # self.ingredients = recipe.ingredients.join("\t")
    # self.directions = recipe.directions.join("\t")

  end

end
