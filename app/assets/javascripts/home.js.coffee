# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
  $(".recipe_click").click ->

    $("span.active").toggleClass("hide")
    $("span.active").toggleClass("active")
    $("li.active").toggleClass("active")

    recipe = $(this).attr("class").split(" ")[1].replace("_title", "")
    $("." + recipe).toggleClass("active")
    $("." + recipe).toggleClass("hide")
    $(this).toggleClass("active")
    console.log $(this)




