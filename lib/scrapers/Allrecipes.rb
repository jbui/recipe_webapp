class Allrecipes < Parser

  # url = "http://allrecipes.com/Recipe/Carrabbas-Chicken-Marsala/Detail.aspx?src=rotd"

  def scrape_name
    return @content.at_css('.itemreviewed').content
  end

  def scrape_image_url
    img = @content.at_css('.photo')
    if img
      return img['src']
    else
      nil
    end
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

