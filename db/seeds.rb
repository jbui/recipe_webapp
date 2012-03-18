# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

kevin = User.create!(:username => "kevin", :password => "a")
james = User.create!(:username => "james", :password => "a")

url = "http://allrecipes.com/recipe/cranberry-hootycreeks/"
recipe = Recipe.parse_url_and_find_or_create(url)
kevin.recipes << recipe
james.recipes << recipe


url = "http://allrecipes.com/recipe/best-big-fat-chewy-chocolate-chip-cookie/detail.aspx"
recipe = Recipe.parse_url_and_find_or_create(url)
kevin.recipes << recipe

url = "http://allrecipes.com/recipe/white-chocolate-and-cranberry-cookies/"
recipe = Recipe.parse_url_and_find_or_create(url)
james.recipes << recipe
