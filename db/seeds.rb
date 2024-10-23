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
IngredientShop.destroy_all
IngredientReview.destroy_all
Substitute.destroy_all
Shop.destroy_all
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
  recipe.youtube_url = response_parsed["meals"][0]["strYoutube"]

  youtube_url_id = response_parsed["meals"][0]["strYoutube"].partition('=').last
  recipe.embedded_youtube_url = "https://www.youtube.com/embed/#{youtube_url_id}"
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

# Chicken
ingredient = Ingredient.find_by(name: "Chicken")
if ingredient
  substitues << Substitute.create!(name: "Turkey", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tofu", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Seitan", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken"
end

# Salmon
ingredient = Ingredient.find_by(name: "Salmon")
if ingredient
  substitues << Substitute.create!(name: "Trout", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mackerel", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tofu (for a plant-based option)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Salmon"
end

# Beef
ingredient = Ingredient.find_by(name: "Beef")
if ingredient
  substitues << Substitute.create!(name: "Bison", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lamb", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tempeh", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef"
end

# Pork
ingredient = Ingredient.find_by(name: "Pork")
if ingredient
  substitues << Substitute.create!(name: "Chicken", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Jackfruit (for a plant-based option)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Pork"
end

# Avocado
ingredient = Ingredient.find_by(name: "Avocado")
if ingredient
  substitues << Substitute.create!(name: "Hummus", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mashed Banana", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Avocado"
end

# Apple Cider Vinegar
ingredient = Ingredient.find_by(name: "Apple Cider Vinegar")
if ingredient
  substitues << Substitute.create!(name: "White Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lemon Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Apple Cider Vinegar"
end

# Aubergine
ingredient = Ingredient.find_by(name: "Aubergine")
if ingredient
  substitues << Substitute.create!(name: "Portobello Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bell Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Aubergine"
end

# Bacon
ingredient = Ingredient.find_by(name: "Bacon")
if ingredient
  substitues << Substitute.create!(name: "Pancetta", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turkey Bacon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tempeh Bacon (for a plant-based option)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bacon"
end

# Baking Powder
ingredient = Ingredient.find_by(name: "Baking Powder")
if ingredient
  substitues << Substitute.create!(name: "Bicarbonate of Soda (with vinegar or lemon juice)", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yeast", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Self-raising Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Baking Powder"
end

# Balsamic Vinegar
ingredient = Ingredient.find_by(name: "Balsamic Vinegar")
if ingredient
  substitues << Substitute.create!(name: "Red Wine Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sherry Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Balsamic Vinegar"
end

# Basil
ingredient = Ingredient.find_by(name: "Basil")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Basil"
end

# Basil Leaves
ingredient = Ingredient.find_by(name: "Basil Leaves")
if ingredient
  substitues << Substitute.create!(name: "Fresh Mint", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tarragon", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Basil Leaves"
end

# Basmati Rice
ingredient = Ingredient.find_by(name: "Basmati Rice")
if ingredient
  substitues << Substitute.create!(name: "Jasmine Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Long-grain White Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brown Rice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Basmati Rice"
end

# Bay Leaf
ingredient = Ingredient.find_by(name: "Bay Leaf")
if ingredient
  substitues << Substitute.create!(name: "Rosemary", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bay Leaf"
end

# Bay Leaves
ingredient = Ingredient.find_by(name: "Bay Leaves")
if ingredient
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bay Leaves"
end

# Beef Brisket
ingredient = Ingredient.find_by(name: "Beef Brisket")
if ingredient
  substitues << Substitute.create!(name: "Chuck Roast", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Short Ribs", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef Brisket"
end

# Beef Fillet
ingredient = Ingredient.find_by(name: "Beef Fillet")
if ingredient
  substitues << Substitute.create!(name: "Ribeye Steak", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sirloin Steak", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pork Tenderloin", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef Fillet"
end

# Beef Gravy
ingredient = Ingredient.find_by(name: "Beef Gravy")
if ingredient
  substitues << Substitute.create!(name: "Mushroom Gravy", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Onion Gravy", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vegetable Broth with Cornstarch", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef Gravy"
end

# Beef Stock
ingredient = Ingredient.find_by(name: "Beef Stock")
if ingredient
  substitues << Substitute.create!(name: "Chicken Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mushroom Stock", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef Stock"
end

# Bicarbonate Of Soda
ingredient = Ingredient.find_by(name: "Bicarbonate Of Soda")
if ingredient
  substitues << Substitute.create!(name: "Baking Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Potassium Bicarbonate", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bicarbonate Of Soda"
end

# Black Pepper
ingredient = Ingredient.find_by(name: "Black Pepper")
if ingredient
  substitues << Substitute.create!(name: "White Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Black Pepper"
end

# Black Treacle
ingredient = Ingredient.find_by(name: "Black Treacle")
if ingredient
  substitues << Substitute.create!(name: "Molasses", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Honey", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Black Treacle"
end

# Borlotti Beans
ingredient = Ingredient.find_by(name: "Borlotti Beans")
if ingredient
  substitues << Substitute.create!(name: "Cannellini Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Kidney Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pinto Beans", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Borlotti Beans"
end

# Bramley Apples
ingredient = Ingredient.find_by(name: "Bramley Apples")
if ingredient
  substitues << Substitute.create!(name: "Granny Smith Apples", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fuji Apples", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pears", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bramley Apples"
end

# Brandy
ingredient = Ingredient.find_by(name: "Brandy")
if ingredient
  substitues << Substitute.create!(name: "Cognac", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bourbon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Juice (non-alcoholic option)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Brandy"
end

# Bread
ingredient = Ingredient.find_by(name: "Bread")
if ingredient
  substitues << Substitute.create!(name: "Pita Bread", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tortillas", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Cakes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bread"
end

# Breadcrumbs
ingredient = Ingredient.find_by(name: "Breadcrumbs")
if ingredient
  substitues << Substitute.create!(name: "Crushed Crackers", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Panko", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almond Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Breadcrumbs"
end

# Broccoli
ingredient = Ingredient.find_by(name: "Broccoli")
if ingredient
  substitues << Substitute.create!(name: "Cauliflower", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brussels Sprouts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Broccoli"
end

# Brown Lentils
ingredient = Ingredient.find_by(name: "Brown Lentils")
if ingredient
  substitues << Substitute.create!(name: "Green Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Red Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Black Lentils", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Brown Lentils"
end

# Brown Sugar
ingredient = Ingredient.find_by(name: "Brown Sugar")
if ingredient
  substitues << Substitute.create!(name: "White Sugar with Molasses", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Brown Sugar"
end

# Butter
ingredient = Ingredient.find_by(name: "Butter")
if ingredient
  substitues << Substitute.create!(name: "Margarine", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Olive Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Oil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Butter"
end

# Cannellini Beans
ingredient = Ingredient.find_by(name: "Cannellini Beans")
if ingredient
  substitues << Substitute.create!(name: "Navy Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Great Northern Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chickpeas", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cannellini Beans"
end

# Cardamom
ingredient = Ingredient.find_by(name: "Cardamom")
if ingredient
  substitues << Substitute.create!(name: "Nutmeg", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cinnamon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cardamom"
end

# Carrots
ingredient = Ingredient.find_by(name: "Carrots")
if ingredient
  substitues << Substitute.create!(name: "Parsnips", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sweet Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Squash", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Carrots"
end

# Cashew Nuts
ingredient = Ingredient.find_by(name: "Cashew Nuts")
if ingredient
  substitues << Substitute.create!(name: "Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Macadamia Nuts", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cashew Nuts"
end

# Cashews
ingredient = Ingredient.find_by(name: "Cashews")
if ingredient
  substitues << Substitute.create!(name: "Peanuts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cashews"
end

# Caster Sugar
ingredient = Ingredient.find_by(name: "Caster Sugar")
if ingredient
  substitues << Substitute.create!(name: "Granulated Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Powdered Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Caster Sugar"
end

# Cayenne Pepper
ingredient = Ingredient.find_by(name: "Cayenne Pepper")
if ingredient
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Red Pepper Flakes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cayenne Pepper"
end

# Celeriac
ingredient = Ingredient.find_by(name: "Celeriac")
if ingredient
  substitues << Substitute.create!(name: "Turnips", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carrots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Celeriac"
end

# Celery
ingredient = Ingredient.find_by(name: "Celery")
if ingredient
  substitues << Substitute.create!(name: "Fennel", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cucumber", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Celery"
end

# Celery Salt
ingredient = Ingredient.find_by(name: "Celery Salt")
if ingredient
  substitues << Substitute.create!(name: "Onion Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garlic Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sea Salt", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Celery Salt"
end

# Shallots
ingredient = Ingredient.find_by(name: "Shallots")
if ingredient
  substitues << Substitute.create!(name: "Onions", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Onions", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Shallots"
end

# Charlotte Potatoes
ingredient = Ingredient.find_by(name: "Charlotte Potatoes")
if ingredient
  substitues << Substitute.create!(name: "New Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yukon Gold Potatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Charlotte Potatoes"
end

# Cheddar Cheese
ingredient = Ingredient.find_by(name: "Cheddar Cheese")
if ingredient
  substitues << Substitute.create!(name: "Colby Jack", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Gouda", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mozzarella", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cheddar Cheese"
end

# Cheese
ingredient = Ingredient.find_by(name: "Cheese")
if ingredient
  substitues << Substitute.create!(name: "Feta", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Goat Cheese", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cheese"
end

# Cheese Curds
ingredient = Ingredient.find_by(name: "Cheese Curds")
if ingredient
  substitues << Substitute.create!(name: "Halloumi", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ricotta", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cheese Curds"
end

# Cherry Tomatoes
ingredient = Ingredient.find_by(name: "Cherry Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Grape Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Roma Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Baby Plum Tomatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cherry Tomatoes"
end

# Chestnut Mushroom
ingredient = Ingredient.find_by(name: "Chestnut Mushroom")
if ingredient
  substitues << Substitute.create!(name: "Shiitake Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cremini Mushrooms", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chestnut Mushroom"
end

# Chicken Breast
ingredient = Ingredient.find_by(name: "Chicken Breast")
if ingredient
  substitues << Substitute.create!(name: "Turkey Breast", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Breast"
end

# Chicken Legs
ingredient = Ingredient.find_by(name: "Chicken Legs")
if ingredient
  substitues << Substitute.create!(name: "Duck Legs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turkey Legs", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Legs"
end

# Chicken Stock
ingredient = Ingredient.find_by(name: "Chicken Stock")
if ingredient
  substitues << Substitute.create!(name: "Vegetable Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Beef Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mushroom Broth", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Stock"
end

# Chicken Thighs
ingredient = Ingredient.find_by(name: "Chicken Thighs")
if ingredient
  substitues << Substitute.create!(name: "Turkey Thighs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pork Shoulder", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Thighs"
end

# Chickpeas
ingredient = Ingredient.find_by(name: "Chickpeas")
if ingredient
  substitues << Substitute.create!(name: "Black Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lentils", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chickpeas"
end

# Chili Powder
ingredient = Ingredient.find_by(name: "Chili Powder")
if ingredient
  substitues << Substitute.create!(name: "Chipotle Powder", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chili Powder"
end

# Chilled Butter
ingredient = Ingredient.find_by(name: "Chilled Butter")
if ingredient
  substitues << Substitute.create!(name: "Margarine", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ghee", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chilled Butter"
end

# Chilli
ingredient = Ingredient.find_by(name: "Chilli")
if ingredient
  substitues << Substitute.create!(name: "Jalapeño", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chilli"
end

# Chinese Broccoli
ingredient = Ingredient.find_by(name: "Chinese Broccoli")
if ingredient
  substitues << Substitute.create!(name: "Bok Choy", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Spinach", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Kale", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chinese Broccoli"
end

# Chocolate Chips
ingredient = Ingredient.find_by(name: "Chocolate Chips")
if ingredient
  substitues << Substitute.create!(name: "Cocoa Nibs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chopped Dark Chocolate", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carob Chips", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chocolate Chips"
end

# Chopped Onion
ingredient = Ingredient.find_by(name: "Chopped Onion")
if ingredient
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chopped Onion"
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
