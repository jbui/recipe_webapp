  class Joythebaker < Parser

  def content_mod
    # Get the image which is before the printable div
    @image_url = @content.at_css('img')['src']
    @content.at_css('.printable')
  end

  def scrape_name
    # Content_mod returned a div for recipe
    @content = @content.children


    # Go through everything and strip the empty new lines
    new_content = []
    @content.each do |line|
      new_content << line if not line.content.strip == ""
    end
    @content = new_content

    # Get the title name and remove it from the list
    name = @content.first.content
    @content = @content[1..-1]

    return name
  end 

  def scrape_image_url
    @image_url
  end 

  # Reverses through content and gets last number as last ingredient.
  # This doesn't work for all cases as some ingredients dont have num leader
  def scrape_ingredients
    begin
      removed = @content.first.content
      @content = @content[1..-1]
    end while removed != "Print this Recipe!"

   
    # http://joythebaker.com/2012/03/biscuit-cinnamon-rolls/ 
    # Corner case
    # This stupid recipe has a div surrounding the actual recipe
    if @content.first.name == "div"
      @content = @content.first.children 
      # New line stripper
      new_content = []
      @content.each do |line|
        new_content << line if not line.content.strip == ""
      end
      @content = new_content
    end

    # Reverse looking for num
    index = nil
    @content.reverse.each_with_index do |line, i|
      if line.content[0] =~ /\d/
        index = @content.length - i - 1
        break
      end
    end

    @content = @content.map {|x| x.content.strip}
    @ingredients = @content[0..index]
    @directions = @content[index + 1..-1]

    return @ingredients
  end 

  def scrape_directions
    @directions
  end 
  
  def self.check_url
    # http://joythebaker.com/2012/03/baked-lemon-risotto/
    # http://joythebaker.com/2012/03/biscuit-cinnamon-rolls/
    # http://joythebaker.com/2012/03/edamame-and-toasted-coconut-in-avocado/
    /(joythebaker.com)\/(\d{4})\/(\d{2})\/(.+)\/?(?:.+\/)?/
  end  
end