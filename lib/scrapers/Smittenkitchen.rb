class Smittenkitchen < Parser

  # url = "http://smittenkitchen.com/2011/11/homesick-texan-carnitas/"

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
    # return url =~ /smittenkitchen.com\/\d+\/\d+\/.+/
    nil
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