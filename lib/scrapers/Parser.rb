class Parser

  # attr_accessor :name, :url, :image_url, :ingredients, :directions
  attr_accessor :content

  # scrape_ingredients returns an array
  # scrape_directions returns an array
  def initialize(url)
    @url = url
    @content = Nokogiri::HTML(open(url))
    @content = content_mod

    # @name = scrape_name
    # @image_url = scrape_image_url
    # @ingredients = scrape_ingredients.map{|x| x.gsub("\t", " ")}
    # @directions = scrape_directions.map{|x| x.gsub("\t", " ")}  

    @content = {:url => url, 
                :name => scrape_name,
                :image_url => scrape_image_url,
                :ingredients => scrape_ingredients.map{|x| x.gsub("\t", " ")}.join("\t"),
                :directions => scrape_directions.map{|x| x.gsub("\t", " ")}.join("\t")
               }
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
  
  def self.check_url
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
  
#   def self.check_url
#   end  
# end