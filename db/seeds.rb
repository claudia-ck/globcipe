# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require "rest-client"

puts "Cleaning database..."
RecipeIngredient.destroy_all
Recipe.destroy_all
IngredientReview.destroy_all
Substitute.destroy_all
Ingredient.destroy_all

puts "Creating recipes..."

# Obtain all of the different food categories
response = RestClient.get "https://www.themealdb.com/api/json/v1/1/categories.php"
response_parsed = JSON.parse(response)
arr_category_objs = response_parsed["categories"]

arr_categories = []
arr_category_objs.each do |category_obj|
  arr_categories << category_obj["strCategory"]
end

# For each category, obtain all of the meal ids associated with a given category
# Do this for each category
arr_meal_ids = []
arr_categories.each do |category|
  response = RestClient.get "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category}"
  response_parsed = JSON.parse(response)
  arr_meal_objs = response_parsed["meals"]
  arr_meal_objs.each do |meal_obj|
    arr_meal_ids << meal_obj["idMeal"]
  end
end

# Now, using each meal id, create a Recipe Object appropriately populated with the correct data based on the schema
# using the data returned from the specific meal id
puts
arr_meal_ids.each do |meal_id|
  response = RestClient.get "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}"
  response_parsed = JSON.parse(response)

  recipe = Recipe.new
  recipe.name = response_parsed["meals"][0]["strMeal"]
  recipe.category = response_parsed["meals"][0]["strCategory"]
  recipe.area = response_parsed["meals"][0]["strArea"]
  recipe.instruction = response_parsed["meals"][0]["strInstructions"]
  recipe.image_url = response_parsed["meals"][0]["strMealThumb"]
  recipe.save

  counter = 1
  while counter < 21
    ingredient_name = response_parsed["meals"][0]["strIngredient#{counter}"].to_s
    ingredient_measure = response_parsed["meals"][0]["strMeasure#{counter}"].to_s
    recipe_ingredient = RecipeIngredient.new

    if (ingredient_name != "" && ingredient_name != "null")
      if (Ingredient.find_by(name: ingredient_name) == nil)
        ingredient = Ingredient.new
        ingredient.name = ingredient_name
        ingredient.save
      end
      recipe_ingredient.ingredient = Ingredient.find_by(name: ingredient_name)
      recipe_ingredient.measure = ingredient_measure
    end
    recipe_ingredient.recipe = recipe
    recipe_ingredient.save
    counter += 1
  end
end

puts "Creating substitutes..."
substitues = []
## recipe 1 Chinese mafo tofu
#  Sichuan pepper - dependence on Ingredient table  ,
ingredient = Ingredient.find_by(name: "Sichuan pepper") # Find the ingredient by name
if ingredient
  substitues << Substitute.create!(name: "Black Pepper and Coriander Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tasmanian Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sansho Pepper", ingredient_id: ingredient.id)
else
  puts "Ingredient not found 1"
end

#  Fermented Black Beans - dependence on Ingredient table  ,
ingredient = Ingredient.find_by(name: "Fermented Black Beans") # Find the ingredient by name
if ingredient
  substitues << Substitute.create!(name: "Miso Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soy Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found 2"
end

#  Fermented Black Beans - dependence on Ingredient table  ,
ingredient = Ingredient.find_by(name: "Doubanjiang") # Find the ingredient by name
if ingredient
  substitues << Substitute.create!(name: "Miso Paste mix Chili Flakes or Chili Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Korean Gochujang", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thai Chili Paste", ingredient_id: ingredient.id)
else
  puts "Ingredient not found 3"
end

## recipe 2 french Flamiche
ingredient = Ingredient.find_by(name: "Creme Fraiche") # Find the ingredient by name
if ingredient
  substitues << Substitute.create!(name: "Sour Cream:", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cream Cheese", ingredient_id: ingredient.id)
else
  puts "Ingredient not found 4"
end

puts "Finished!"

# counter = 0
# while counter < 300
#   response = RestClient.get "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{arr_meal_ids[counter]}"
#   response_parsed = JSON.parse(response)

#   recipe = Recipe.new
#   recipe.name = response_parsed["meals"][0]["strMeal"]
#   recipe.category = response_parsed["meals"][0]["strCategory"]
#   recipe.area = response_parsed["meals"][0]["strArea"]
#   recipe.instruction = response_parsed["meals"][0]["strInstructions"]
#   recipe.save
#   counter += 1
# end
# puts "Finished!"
