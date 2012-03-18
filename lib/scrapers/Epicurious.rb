class Epicurious < Parser


  def scrape_name
    return @content.at_css('h1.fn').content
  end 

  def scrape_image_url
    # large image
    @image_location = @url.sub '/views/', '/photo/'
    @image_content = Nokogiri::HTML(open(@image_location))
    image = @image_content.at_css('#recipe_full_photo img')
    if not image.nil?
      image = 'http://www.epicurious.com' + image['src']
    end
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

  def self.check_url
    # http://www.epicurious.com/articlesguides/bestof/toprecipes/bestburgerrecipes/recipes/food/views/Grilled-Turkey-Burgers-with-Cheddar-and-Smoky-Aioli-354289
    # http://www.epicurious.com/recipes/food/views/-em-Gourmet-Live-em-s-First-Birthday-Cake-367789
    "(epicurious.com)\/(?:.*\/)?recipes\/food\/views\/(.+)\/?"
  end

end 