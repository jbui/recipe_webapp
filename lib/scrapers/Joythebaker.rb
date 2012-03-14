# A template
class Joythebaker < Parser
  def scrape_name
  end 

  def scrape_image_url
  end 

  def scrape_ingredients
  end 

  def scrape_directions
  end 
  
  def self.check_url(url)
    return url =~ /joythebaker.com\/\d{4}\/\d{2}\/.+/
  end  
end