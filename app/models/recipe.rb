class Recipe < ActiveRecord::Base
  before_create :parse_url
  attr_accessible :url
  attr_protected :name, :image_url, :ingredients, :directions

  # Extend all site Parsers from this!
  class Parser

    attr_accessor :name, :url, :image_url, :ingredients, :directions

    def initialize(url)
      @url = url
      @content = Nokogiri::HTML(open(url))
      @content = content_mod

      @name = scrape_name
      @image_url = scrape_image_url
      @ingredients = scrape_ingredients.map{|x| x.gsub("\t", " ")}
      @directions = scrape_directions.map{|x| x.gsub("\t", " ")}  
    end

    def scrape_name
      raise NotImplementedException 
    end 

    def scrape_image_url
      raise NotImplementedException 
    end 

    def scrape_ingredients
      raise NotImplementedException 
    end 

    def scrape_directions
      raise NotImplementedException 
    end 
    
    def self.check_url(url)
      raise NotImplementedException 
    end

    # Used if nokogiri result is complex
    # and needs preprocessing before parsing
    def content_mod
      return @content
    end

  end

  # # A template
  # class Classname < Parser
  #   def scrape_name
  #   end 

  #   def scrape_image_url
  #   end 

  #   def scrape_ingredients
  #   end 

  #   def scrape_directions
  #   end 
    
  #   def self.check_url(url)
  #     return url =~ //
  #   end  
  # end

  # --------------------------- HERE START CUSTOM PARSERS ---------------------
  class Epicurious < Parser

    def scrape_name
      return @content.at_css('h1.fn').content
    end 

    def scrape_image_url
      # large image
      @image_location = @url.sub '/views/', '/photo/'
      @image_content = Nokogiri::HTML(open(@image_location))
      image = @image_content.at_css('#recipe_full_photo img')
      image = 'http://www.epicurious.com' + image['src']
      return image
      # small image
      # return @content.at_css('.photo')['src']
    end 

    def scrape_ingredients
      ingredients = @content.css('li.ingredient')
      ingredients = ingredients.map {|x| x.content.strip}
      return ingredients
    end 

    def scrape_directions
      directions = @content.css('p.instruction')
      directions = directions.map {|x| x.content.strip}
      return directions
    end 

    def self.check_url(url)
      return url =~ /epicurious.com\/recipes\/food\/views\/.+/
    end

  end 

  class Allrecipes < Parser

    def scrape_name
      return @content.at_css('.itemreviewed').content
    end

    def scrape_image_url
      return @content.at_css('.photo')['src']
    end 

    def scrape_ingredients
      ingredients = @content.css('.ingredients ul li')
      ingredients = ingredients.map {|x| x.content.strip}
      return ingredients
    end

    def scrape_directions
      directions = @content.css('.directions ol li')
      directions = directions.map {|x| x.content.strip}
      return directions

    end 

    def self.check_url(url)
      return url =~ /allrecipes.com\/[rR]ecipe\/.+/
    end

  end

  class Smittenkitchen < Parser
    def scrape_name
      return @name
    end 

    def scrape_image_url
      return @content.css('.entry img').first['src']
    end 

    def scrape_ingredients
      return @ingredients
    end 

    def scrape_directions
      return @directions
    end 
    def self.check_url(url)
      return url =~ /smittenkitchen.com\/\d+\/\d+\/.+/
    end

    def content_mod
      # Reverse traversal of <p> tags, skipping the first 3
      # Break at first <b> which should be the name
      # Go back down, first <p> is the ingredients, and subsequent are directions
      # recipe = []
      # @content.css('.entry p')[0..-4].reverse_each do |tag|
      #   recipe << tag
      #   if tag.to_s.include? '<b>'
      #     break
      #   end
      # end
      # recipe = recipe.reverse
      # @name = recipe[0].content
      
      # recipe[1..-1].each do |r|
      #   puts "=================="
      #   puts r
      #   puts "=================="
      # end
      # @ingredients = recipe[1].to_s
      # @ingredients = @ingredients.sub('<p>', '')
      # @ingredients = @ingredients.sub('</p>', '')
      # @ingredients = @ingredients.split("<br>\n")

      # @directions = recipe[2..-1].map {|x| x.content.strip}
      
      p_tags = @content.css('.entry p')

      names = []
      ingredients = []
      directions = []

      p_tags.each_with_index do |tag, i| 
        tag_s = tag.to_s
        tag_s_split = tag_s.split("<br>")
        tag_s_split = tag_s_split.map{|x| x.gsub(/<.*>/,'').strip}
        tag_digits = tag_s_split.map{|x| x[0]}

        is_dig = 0.0
        not_dig = 0.0
        tag_digits.each do |digit|
          if digit.to_i.to_s == digit
            is_dig += 1
          else
            not_dig += 1
          end
        end
        digit_percent = is_dig/(is_dig+not_dig)


        if tag_s_split.size > 1 and not tag_s.include?("year ago:") and digit_percent > 0.8

          ingredients += tag_s_split

          i.downto(0).each do |j|
            if p_tags[j].to_s.include? '<b>'
              names << p_tags[j]
              break
            end
          end

          direction = []
          i.upto(p_tags.size).each do |j|
            if p_tags[j].to_s.include? '<b>'
              break
            elsif p_tags[j].to_s.include? 'See more:'
              break
            else
              direction << p_tags[j].content.strip
            end
          end
          directions = directions + direction
        end
      end

      @name = names.join(" and ")
      @ingredients = ingredients
      @directions = directions

      # No changes to content
      return @content
    end
  end
  # --------------------------- HERE END CUSTOM PARSERS ----------------------

  def parse_url()
    # url = "http://allrecipes.com/Recipe/Carrabbas-Chicken-Marsala/Detail.aspx?src=rotd"
    # url = "http://www.epicurious.com/recipes/food/views/-em-Gourmet-Live-em-s-First-Birthday-Cake-367789"
    # url = "http://smittenkitchen.com/2011/11/homesick-texan-carnitas/"
    p self
    parsers = %w[Epicurious Allrecipes Smittenkitchen]
    recipe = nil
    parsers.each do |site|
      if Recipe.const_get(site).check_url self.url
        recipe = Recipe.const_get(site).new(url)
        break
      end
      # "Array".constantize.new # in rails only
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
