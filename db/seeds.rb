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
  substitues << Substitute.create!(name: "Turkey", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Jackfruit (for a plant-based option)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Pork"
end

# Avocado
ingredient = Ingredient.find_by(name: "Avocado")
if ingredient
  substitues << Substitute.create!(name: "Hummus", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
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

# Asparagus
ingredient = Ingredient.find_by(name: "Asparagus")
if ingredient
  substitues << Substitute.create!(name: "Green Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Zucchini", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Broccoli", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Asparagus"
end

# Aubergine
ingredient = Ingredient.find_by(name: "Aubergine")
if ingredient
  substitues << Substitute.create!(name: "Zucchini", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Portobello Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bell Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Aubergine"
end

# Baby Plum Tomatoes
ingredient = Ingredient.find_by(name: "Baby Plum Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Cherry Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Grape Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sun-Dried Tomatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Baby Plum Tomatoes"
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
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rosemary", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bay Leaf"
end

# Bay Leaves
ingredient = Ingredient.find_by(name: "Bay Leaves")
if ingredient
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bay Leaves"
end

# Beef Brisket
ingredient = Ingredient.find_by(name: "Beef Brisket")
if ingredient
  substitues << Substitute.create!(name: "Chuck Roast", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Short Ribs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pork Shoulder", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Vegetable Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mushroom Stock", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Beef Stock"
end

# Bicarbonate Of Soda
ingredient = Ingredient.find_by(name: "Bicarbonate Of Soda")
if ingredient
  substitues << Substitute.create!(name: "Baking Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Potassium Bicarbonate", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yeast", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bicarbonate Of Soda"
end

# Biryani Masala
ingredient = Ingredient.find_by(name: "Biryani Masala")
if ingredient
  substitues << Substitute.create!(name: "Garam Masala", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Curry Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tandoori Masala", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Biryani Masala"
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

# Bowtie Pasta
ingredient = Ingredient.find_by(name: "Bowtie Pasta")
if ingredient
  substitues << Substitute.create!(name: "Penne", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fusilli", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rigatoni", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Bowtie Pasta"
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

# Brown Rice
ingredient = Ingredient.find_by(name: "Brown Rice")
if ingredient
  substitues << Substitute.create!(name: "Quinoa", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bulgur", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Wild Rice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Brown Rice"
end

# Brown Sugar
ingredient = Ingredient.find_by(name: "Brown Sugar")
if ingredient
  substitues << Substitute.create!(name: "White Sugar with Molasses", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
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

# Cajun
ingredient = Ingredient.find_by(name: "Cajun")
if ingredient
  substitues << Substitute.create!(name: "Creole Seasoning", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cajun"
end

# Canned Tomatoes
ingredient = Ingredient.find_by(name: "Canned Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Fresh Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tomato Paste with Water", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sun-Dried Tomatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Canned Tomatoes"
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
  substitues << Substitute.create!(name: "Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cashews"
end

# Caster Sugar
ingredient = Ingredient.find_by(name: "Caster Sugar")
if ingredient
  substitues << Substitute.create!(name: "Granulated Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Powdered Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Honey", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Caster Sugar"
end

# Cayenne Pepper
ingredient = Ingredient.find_by(name: "Cayenne Pepper")
if ingredient
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Red Pepper Flakes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cayenne Pepper"
end

# Celeriac
ingredient = Ingredient.find_by(name: "Celeriac")
if ingredient
  substitues << Substitute.create!(name: "Parsnips", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turnips", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carrots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Celeriac"
end

# Celery
ingredient = Ingredient.find_by(name: "Celery")
if ingredient
  substitues << Substitute.create!(name: "Fennel", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carrots", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Fingerling Potatoes", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Ricotta", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cheese"
end

# Cheese Curds
ingredient = Ingredient.find_by(name: "Cheese Curds")
if ingredient
  substitues << Substitute.create!(name: "Mozzarella", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Portobello Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shiitake Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cremini Mushrooms", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chestnut Mushroom"
end

# Chicken Breast
ingredient = Ingredient.find_by(name: "Chicken Breast")
if ingredient
  substitues << Substitute.create!(name: "Turkey Breast", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tofu", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tempeh", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Breast"
end

# Chicken Breasts
ingredient = Ingredient.find_by(name: "Chicken Breasts")
if ingredient
  substitues << Substitute.create!(name: "Turkey Breasts", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tofu", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tempeh", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Breasts"
end

# Chicken Legs
ingredient = Ingredient.find_by(name: "Chicken Legs")
if ingredient
  substitues << Substitute.create!(name: "Duck Legs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turkey Legs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Seitan", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Seitan", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chicken Thighs"
end

# Chickpeas
ingredient = Ingredient.find_by(name: "Chickpeas")
if ingredient
  substitues << Substitute.create!(name: "Cannellini Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Black Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lentils", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chickpeas"
end

# Chili Powder
ingredient = Ingredient.find_by(name: "Chili Powder")
if ingredient
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
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
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Jalapeño", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chilli"
end

# Chilli Powder
ingredient = Ingredient.find_by(name: "Chilli Powder")
if ingredient
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chipotle Powder", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chilli Powder"
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
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Onions", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chopped Onion"
end

# Chopped Parsley
ingredient = Ingredient.find_by(name: "Chopped Parsley")
if ingredient
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chopped Parsley"
end

# Chopped Tomatoes
ingredient = Ingredient.find_by(name: "Chopped Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Diced Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fresh Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tomato Paste with Water", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chopped Tomatoes"
end

# Chorizo
ingredient = Ingredient.find_by(name: "Chorizo")
if ingredient
  substitues << Substitute.create!(name: "Andouille Sausage", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Italian Sausage", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soy Chorizo", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Chorizo"
end

# Christmas Pudding
ingredient = Ingredient.find_by(name: "Christmas Pudding")
if ingredient
  substitues << Substitute.create!(name: "Fruitcake", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Panettone", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Stollen", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Christmas Pudding"
end

# Cilantro
ingredient = Ingredient.find_by(name: "Cilantro")
if ingredient
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mint", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cilantro"
end

# Cinnamon
ingredient = Ingredient.find_by(name: "Cinnamon")
if ingredient
  substitues << Substitute.create!(name: "Nutmeg", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cardamom", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cinnamon"
end

# Cinnamon Stick
ingredient = Ingredient.find_by(name: "Cinnamon Stick")
if ingredient
  substitues << Substitute.create!(name: "Ground Cinnamon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Nutmeg", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cinnamon Stick"
end

# Cloves
ingredient = Ingredient.find_by(name: "Cloves")
if ingredient
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cinnamon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Nutmeg", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cloves"
end

# Coco Sugar
ingredient = Ingredient.find_by(name: "Coco Sugar")
if ingredient
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brown Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Granulated Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coco Sugar"
end

# Cocoa
ingredient = Ingredient.find_by(name: "Cocoa")
if ingredient
  substitues << Substitute.create!(name: "Cacao", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carob Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Dark Chocolate", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cocoa"
end

# Coconut Cream
ingredient = Ingredient.find_by(name: "Coconut Cream")
if ingredient
  substitues << Substitute.create!(name: "Heavy Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Cream", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coconut Cream"
end

# Coconut Milk
ingredient = Ingredient.find_by(name: "Coconut Milk")
if ingredient
  substitues << Substitute.create!(name: "Almond Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soy Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Milk", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coconut Milk"
end

# Colby Jack Cheese
ingredient = Ingredient.find_by(name: "Colby Jack Cheese")
if ingredient
  substitues << Substitute.create!(name: "Cheddar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Monterey Jack", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mozzarella", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Colby Jack Cheese"
end

# Cold Water
ingredient = Ingredient.find_by(name: "Cold Water")
if ingredient
  substitues << Substitute.create!(name: "Ice Water", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chilled Soda Water", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Water", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cold Water"
end

# Coriander
ingredient = Ingredient.find_by(name: "Coriander")
if ingredient
  substitues << Substitute.create!(name: "Cumin", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coriander"
end

# Coriander Leaves
ingredient = Ingredient.find_by(name: "Coriander Leaves")
if ingredient
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mint", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coriander Leaves"
end

# Coriander Seeds
ingredient = Ingredient.find_by(name: "Coriander Seeds")
if ingredient
  substitues << Substitute.create!(name: "Cumin Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fennel Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Caraway Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coriander Seeds"
end

# Corn Tortillas
ingredient = Ingredient.find_by(name: "Corn Tortillas")
if ingredient
  substitues << Substitute.create!(name: "Flour Tortillas", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lettuce Wraps", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pita Bread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Corn Tortillas"
end

# Cornstarch
ingredient = Ingredient.find_by(name: "Cornstarch")
if ingredient
  substitues << Substitute.create!(name: "Arrowroot Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tapioca Starch", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Potato Starch", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cornstarch"
end

# Cream
ingredient = Ingredient.find_by(name: "Cream")
if ingredient
  substitues << Substitute.create!(name: "Coconut Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yogurt", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cream"
end

# Creme Fraiche
ingredient = Ingredient.find_by(name: "Creme Fraiche")
if ingredient
  substitues << Substitute.create!(name: "Sour Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mascarpone", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Creme Fraiche"
end

# Cubed Feta Cheese
ingredient = Ingredient.find_by(name: "Cubed Feta Cheese")
if ingredient
  substitues << Substitute.create!(name: "Goat Cheese", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ricotta", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paneer", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cubed Feta Cheese"
end

# Cucumber
ingredient = Ingredient.find_by(name: "Cucumber")
if ingredient
  substitues << Substitute.create!(name: "Zucchini", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Celery", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bell Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cucumber"
end

# Cumin
ingredient = Ingredient.find_by(name: "Cumin")
if ingredient
  substitues << Substitute.create!(name: "Coriander", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garam Masala", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cumin"
end

# Cumin Seeds
ingredient = Ingredient.find_by(name: "Cumin Seeds")
if ingredient
  substitues << Substitute.create!(name: "Fennel Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Caraway Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coriander Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Cumin Seeds"
end

# Curry Powder
ingredient = Ingredient.find_by(name: "Curry Powder")
if ingredient
  substitues << Substitute.create!(name: "Garam Masala", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cumin", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turmeric", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Curry Powder"
end

# Dark Brown Sugar
ingredient = Ingredient.find_by(name: "Dark Brown Sugar")
if ingredient
  substitues << Substitute.create!(name: "Light Brown Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Molasses", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dark Brown Sugar"
end

# Dark Soft Brown Sugar
ingredient = Ingredient.find_by(name: "Dark Soft Brown Sugar")
if ingredient
  substitues << Substitute.create!(name: "Light Brown Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Molasses", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dark Soft Brown Sugar"
end

# Dark Soy Sauce
ingredient = Ingredient.find_by(name: "Dark Soy Sauce")
if ingredient
  substitues << Substitute.create!(name: "Tamari", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Liquid Aminos", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Worcestershire Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dark Soy Sauce"
end

# Demerara Sugar
ingredient = Ingredient.find_by(name: "Demerara Sugar")
if ingredient
  substitues << Substitute.create!(name: "Brown Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turbinado Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Demerara Sugar"
end

# Diced Tomatoes
ingredient = Ingredient.find_by(name: "Diced Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Crushed Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fresh Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tomato Puree", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Diced Tomatoes"
end

# Digestive Biscuits
ingredient = Ingredient.find_by(name: "Digestive Biscuits")
if ingredient
  substitues << Substitute.create!(name: "Graham Crackers", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shortbread Cookies", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oat Biscuits", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Digestive Biscuits"
end

# Dill
ingredient = Ingredient.find_by(name: "Dill")
if ingredient
  substitues << Substitute.create!(name: "Fennel Fronds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tarragon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dill"
end

# Doner Meat
ingredient = Ingredient.find_by(name: "Doner Meat")
if ingredient
  substitues << Substitute.create!(name: "Gyro Meat", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lamb", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chicken", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Doner Meat"
end

# Double Cream
ingredient = Ingredient.find_by(name: "Double Cream")
if ingredient
  substitues << Substitute.create!(name: "Heavy Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Whipped Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Cream", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Double Cream"
end

# Dried Oregano
ingredient = Ingredient.find_by(name: "Dried Oregano")
if ingredient
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Marjoram", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dried Oregano"
end

# Dry White Wine
ingredient = Ingredient.find_by(name: "Dry White Wine")
if ingredient
  substitues << Substitute.create!(name: "White Grape Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chicken Broth", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Dry White Wine"
end

# Egg Plants
ingredient = Ingredient.find_by(name: "Egg Plants")
if ingredient
  substitues << Substitute.create!(name: "Zucchini", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Portobello Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bell Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Egg Plants"
end

# Egg Rolls
ingredient = Ingredient.find_by(name: "Egg Rolls")
if ingredient
  substitues << Substitute.create!(name: "Spring Rolls", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Wonton Wraps", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Paper Rolls", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Egg Rolls"
end

# Egg White
ingredient = Ingredient.find_by(name: "Egg White")
if ingredient
  substitues << Substitute.create!(name: "Aquafaba (Chickpea Water)", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Meringue Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Flaxseed", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Egg White"
end

# Egg Yolks
ingredient = Ingredient.find_by(name: "Egg Yolks")
if ingredient
  substitues << Substitute.create!(name: "Mashed Avocado", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chia Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Silken Tofu", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Egg Yolks"
end

# Eggs
ingredient = Ingredient.find_by(name: "Eggs")
if ingredient
  substitues << Substitute.create!(name: "Flax Eggs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chia Eggs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Applesauce (in baking)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Eggs"
end

# Enchilada Sauce
ingredient = Ingredient.find_by(name: "Enchilada Sauce")
if ingredient
  substitues << Substitute.create!(name: "Salsa", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tomato Sauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Taco Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Enchilada Sauce"
end

# English Mustard
ingredient = Ingredient.find_by(name: "English Mustard")
if ingredient
  substitues << Substitute.create!(name: "Dijon Mustard", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yellow Mustard", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Horseradish", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: English Mustard"
end

# Extra Virgin Olive Oil
ingredient = Ingredient.find_by(name: "Extra Virgin Olive Oil")
if ingredient
  substitues << Substitute.create!(name: "Avocado Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Canola Oil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Extra Virgin Olive Oil"
end

# Fajita Seasoning
ingredient = Ingredient.find_by(name: "Fajita Seasoning")
if ingredient
  substitues << Substitute.create!(name: "Taco Seasoning", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fajita Seasoning"
end

# Farfalle
ingredient = Ingredient.find_by(name: "Farfalle")
if ingredient
  substitues << Substitute.create!(name: "Penne", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fusilli", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rigatoni", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Farfalle"
end

# Fennel Bulb
ingredient = Ingredient.find_by(name: "Fennel Bulb")
if ingredient
  substitues << Substitute.create!(name: "Celery", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bok Choy", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fennel Bulb"
end

# Fennel Seeds
ingredient = Ingredient.find_by(name: "Fennel Seeds")
if ingredient
  substitues << Substitute.create!(name: "Caraway Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cumin Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Anise Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fennel Seeds"
end

# Fenugreek
ingredient = Ingredient.find_by(name: "Fenugreek")
if ingredient
  substitues << Substitute.create!(name: "Mustard Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Celery Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fennel Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fenugreek"
end

# Feta
ingredient = Ingredient.find_by(name: "Feta")
if ingredient
  substitues << Substitute.create!(name: "Goat Cheese", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ricotta", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Halloumi", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Feta"
end

# Fish Sauce
ingredient = Ingredient.find_by(name: "Fish Sauce")
if ingredient
  substitues << Substitute.create!(name: "Soy Sauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tamari", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Worcestershire Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fish Sauce"
end

# Flaked Almonds
ingredient = Ingredient.find_by(name: "Flaked Almonds")
if ingredient
  substitues << Substitute.create!(name: "Sliced Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pine Nuts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Flaked Almonds"
end

# Flax Eggs
ingredient = Ingredient.find_by(name: "Flax Eggs")
if ingredient
  substitues << Substitute.create!(name: "Chia Eggs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Applesauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mashed Bananas", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Flax Eggs"
end

# Flour
ingredient = Ingredient.find_by(name: "Flour")
if ingredient
  substitues << Substitute.create!(name: "Almond Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Whole Wheat Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Flour"
end

# Flour Tortilla
ingredient = Ingredient.find_by(name: "Flour Tortilla")
if ingredient
  substitues << Substitute.create!(name: "Corn Tortilla", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lettuce Wraps", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pita Bread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Flour Tortilla"
end

# Floury Potatoes
ingredient = Ingredient.find_by(name: "Floury Potatoes")
if ingredient
  substitues << Substitute.create!(name: "Yukon Gold Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Russet Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sweet Potatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Floury Potatoes"
end

# Free-range Egg, Beaten
ingredient = Ingredient.find_by(name: "Free-range Egg, Beaten")
if ingredient
  substitues << Substitute.create!(name: "Flax Egg", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chia Egg", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mashed Banana", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Free-range Egg, Beaten"
end

# Free-range Eggs, Beaten
ingredient = Ingredient.find_by(name: "Free-range Eggs, Beaten")
if ingredient
  substitues << Substitute.create!(name: "Flax Eggs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chia Eggs", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Applesauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Free-range Eggs, Beaten"
end

# French Lentils
ingredient = Ingredient.find_by(name: "French Lentils")
if ingredient
  substitues << Substitute.create!(name: "Green Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brown Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Black Lentils", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: French Lentils"
end

# Fresh Basil
ingredient = Ingredient.find_by(name: "Fresh Basil")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fresh Basil"
end

# Fresh Thyme
ingredient = Ingredient.find_by(name: "Fresh Thyme")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rosemary", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Marjoram", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fresh Thyme"
end

# Freshly Chopped Parsley
ingredient = Ingredient.find_by(name: "Freshly Chopped Parsley")
if ingredient
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chervil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Freshly Chopped Parsley"
end

# Fries
ingredient = Ingredient.find_by(name: "Fries")
if ingredient
  substitues << Substitute.create!(name: "Baked Potato Wedges", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sweet Potato Fries", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Polenta Fries", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Fries"
end

# Full Fat Yogurt
ingredient = Ingredient.find_by(name: "Full Fat Yogurt")
if ingredient
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Yogurt", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Full Fat Yogurt"
end

# Garam Masala
ingredient = Ingredient.find_by(name: "Garam Masala")
if ingredient
  substitues << Substitute.create!(name: "Curry Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cumin", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Garam Masala"
end

# Garlic
ingredient = Ingredient.find_by(name: "Garlic")
if ingredient
  substitues << Substitute.create!(name: "Garlic Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chives", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Garlic"
end

# Garlic Clove
ingredient = Ingredient.find_by(name: "Garlic Clove")
if ingredient
  substitues << Substitute.create!(name: "Garlic Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garlic Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Garlic Clove"
end

# Garlic Powder
ingredient = Ingredient.find_by(name: "Garlic Powder")
if ingredient
  substitues << Substitute.create!(name: "Onion Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fresh Garlic", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Garlic Powder"
end

# Garlic Sauce
ingredient = Ingredient.find_by(name: "Garlic Sauce")
if ingredient
  substitues << Substitute.create!(name: "Tahini Sauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Aioli", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yogurt Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Garlic Sauce"
end

# Ghee
ingredient = Ingredient.find_by(name: "Ghee")
if ingredient
  substitues << Substitute.create!(name: "Butter", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Olive Oil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ghee"
end

# Ginger
ingredient = Ingredient.find_by(name: "Ginger")
if ingredient
  substitues << Substitute.create!(name: "Ground Ginger", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ginger Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Galangal", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ginger"
end

# Ginger Cordial
ingredient = Ingredient.find_by(name: "Ginger Cordial")
if ingredient
  substitues << Substitute.create!(name: "Ginger Ale", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ginger Tea", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lemon Juice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ginger Cordial"
end

# Ginger Garlic Paste
ingredient = Ingredient.find_by(name: "Ginger Garlic Paste")
if ingredient
  substitues << Substitute.create!(name: "Minced Garlic", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ginger Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garlic Powder", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ginger Garlic Paste"
end

# Ginger Paste
ingredient = Ingredient.find_by(name: "Ginger Paste")
if ingredient
  substitues << Substitute.create!(name: "Fresh Ginger", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ground Ginger", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Galangal", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ginger Paste"
end

# Golden Syrup
ingredient = Ingredient.find_by(name: "Golden Syrup")
if ingredient
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Honey", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Agave Syrup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Golden Syrup"
end

# Gouda Cheese
ingredient = Ingredient.find_by(name: "Gouda Cheese")
if ingredient
  substitues << Substitute.create!(name: "Cheddar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Edam", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Monterey Jack", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Gouda Cheese"
end

# Granulated Sugar
ingredient = Ingredient.find_by(name: "Granulated Sugar")
if ingredient
  substitues << Substitute.create!(name: "Caster Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brown Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Powdered Sugar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Granulated Sugar"
end

# Grape Tomatoes
ingredient = Ingredient.find_by(name: "Grape Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Cherry Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Plum Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sun-Dried Tomatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Grape Tomatoes"
end

# Greek Yogurt
ingredient = Ingredient.find_by(name: "Greek Yogurt")
if ingredient
  substitues << Substitute.create!(name: "Plain Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sour Cream", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Greek Yogurt"
end

# Green Beans
ingredient = Ingredient.find_by(name: "Green Beans")
if ingredient
  substitues << Substitute.create!(name: "Asparagus", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Snap Peas", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Broccoli", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Green Beans"
end

# Green Chilli
ingredient = Ingredient.find_by(name: "Green Chilli")
if ingredient
  substitues << Substitute.create!(name: "Jalapeños", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Poblano Peppers", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Serrano Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Green Chilli"
end

# Green Olives
ingredient = Ingredient.find_by(name: "Green Olives")
if ingredient
  substitues << Substitute.create!(name: "Black Olives", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Capers", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pickled Peppers", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Green Olives"
end

# Green Red Lentils
ingredient = Ingredient.find_by(name: "Green Red Lentils")
if ingredient
  substitues << Substitute.create!(name: "Brown Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yellow Lentils", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Split Peas", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Green Red Lentils"
end

# Green Salsa
ingredient = Ingredient.find_by(name: "Green Salsa")
if ingredient
  substitues << Substitute.create!(name: "Tomatillo Sauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pico de Gallo", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Guacamole", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Green Salsa"
end

# Ground Almonds
ingredient = Ingredient.find_by(name: "Ground Almonds")
if ingredient
  substitues << Substitute.create!(name: "Almond Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Hazelnut Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ground Almonds"
end

# Ground Cumin
ingredient = Ingredient.find_by(name: "Ground Cumin")
if ingredient
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coriander", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garam Masala", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ground Cumin"
end

# Ground Ginger
ingredient = Ingredient.find_by(name: "Ground Ginger")
if ingredient
  substitues << Substitute.create!(name: "Fresh Ginger", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ginger Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Galangal", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ground Ginger"
end

# Gruyère
ingredient = Ingredient.find_by(name: "Gruyère")
if ingredient
  substitues << Substitute.create!(name: "Swiss Cheese", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Emmental", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Jarlsberg", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Gruyère"
end

# Hard Taco Shells
ingredient = Ingredient.find_by(name: "Hard Taco Shells")
if ingredient
  substitues << Substitute.create!(name: "Soft Tortillas", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lettuce Wraps", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pita Bread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Hard Taco Shells"
end

# Harissa Spice
ingredient = Ingredient.find_by(name: "Harissa Spice")
if ingredient
  substitues << Substitute.create!(name: "Chili Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sriracha", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Harissa Spice"
end

# Heavy Cream
ingredient = Ingredient.find_by(name: "Heavy Cream")
if ingredient
  substitues << Substitute.create!(name: "Coconut Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Cream", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Heavy Cream"
end

# Honey
ingredient = Ingredient.find_by(name: "Honey")
if ingredient
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Agave Syrup", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Golden Syrup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Honey"
end

# Horseradish
ingredient = Ingredient.find_by(name: "Horseradish")
if ingredient
  substitues << Substitute.create!(name: "Wasabi", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mustard", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ginger", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Horseradish"
end

# Hot Beef Stock
ingredient = Ingredient.find_by(name: "Hot Beef Stock")
if ingredient
  substitues << Substitute.create!(name: "Chicken Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vegetable Broth", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mushroom Broth", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Hot Beef Stock"
end

# Hotsauce
ingredient = Ingredient.find_by(name: "Hotsauce")
if ingredient
  substitues << Substitute.create!(name: "Sriracha", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Harissa", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Hotsauce"
end

# Ice Cream
ingredient = Ingredient.find_by(name: "Ice Cream")
if ingredient
  substitues << Substitute.create!(name: "Sorbet", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Frozen Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Gelato", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ice Cream"
end

# Italian Fennel Sausages
ingredient = Ingredient.find_by(name: "Italian Fennel Sausages")
if ingredient
  substitues << Substitute.create!(name: "Chorizo", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Andouille Sausage", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tofu Sausage", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Italian Fennel Sausages"
end

# Italian Seasoning
ingredient = Ingredient.find_by(name: "Italian Seasoning")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Italian Seasoning"
end

# Jalapeno
ingredient = Ingredient.find_by(name: "Jalapeno")
if ingredient
  substitues << Substitute.create!(name: "Serrano Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Poblano Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Chili", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Jalapeno"
end

# Jasmine Rice
ingredient = Ingredient.find_by(name: "Jasmine Rice")
if ingredient
  substitues << Substitute.create!(name: "Basmati Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Long-Grain White Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brown Rice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Jasmine Rice"
end

# Jerusalem Artichokes
ingredient = Ingredient.find_by(name: "Jerusalem Artichokes")
if ingredient
  substitues << Substitute.create!(name: "Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turnips", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Parsnips", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Jerusalem Artichokes"
end

# Kale
ingredient = Ingredient.find_by(name: "Kale")
if ingredient
  substitues << Substitute.create!(name: "Spinach", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Swiss Chard", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Collard Greens", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Kale"
end

# Khus Khus
ingredient = Ingredient.find_by(name: "Khus Khus")
if ingredient
  substitues << Substitute.create!(name: "Poppy Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sesame Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chia Seeds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Khus Khus"
end

# King Prawns
ingredient = Ingredient.find_by(name: "King Prawns")
if ingredient
  substitues << Substitute.create!(name: "Shrimp", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Scallops", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lobster", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: King Prawns"
end

# Kosher Salt
ingredient = Ingredient.find_by(name: "Kosher Salt")
if ingredient
  substitues << Substitute.create!(name: "Sea Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Table Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Himalayan Pink Salt", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Kosher Salt"
end

# Lamb
ingredient = Ingredient.find_by(name: "Lamb")
if ingredient
  substitues << Substitute.create!(name: "Beef", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pork", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turkey", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lamb"
end

# Lamb Loin Chops
ingredient = Ingredient.find_by(name: "Lamb Loin Chops")
if ingredient
  substitues << Substitute.create!(name: "Pork Chops", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Beef Steaks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chicken Thighs", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lamb Loin Chops"
end

# Lamb Mince
ingredient = Ingredient.find_by(name: "Lamb Mince")
if ingredient
  substitues << Substitute.create!(name: "Beef Mince", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pork Mince", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Turkey Mince", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lamb Mince"
end

# Lasagne Sheets
ingredient = Ingredient.find_by(name: "Lasagne Sheets")
if ingredient
  substitues << Substitute.create!(name: "Zucchini Slices", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Eggplant Slices", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Noodles", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lasagne Sheets"
end

# Lean Minced Beef
ingredient = Ingredient.find_by(name: "Lean Minced Beef")
if ingredient
  substitues << Substitute.create!(name: "Turkey Mince", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chicken Mince", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Plant-Based Mince", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lean Minced Beef"
end

# Leek
ingredient = Ingredient.find_by(name: "Leek")
if ingredient
  substitues << Substitute.create!(name: "Onions", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Scallions", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Leek"
end

# Lemon
ingredient = Ingredient.find_by(name: "Lemon")
if ingredient
  substitues << Substitute.create!(name: "Lime", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tamarind", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lemon"
end

# Lemon Juice
ingredient = Ingredient.find_by(name: "Lemon Juice")
if ingredient
  substitues << Substitute.create!(name: "Lime Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Orange Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lemon Juice"
end

# Lemon Zest
ingredient = Ingredient.find_by(name: "Lemon Zest")
if ingredient
  substitues << Substitute.create!(name: "Orange Zest", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lime Zest", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Grapefruit Zest", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lemon Zest"
end

# Lemons
ingredient = Ingredient.find_by(name: "Lemons")
if ingredient
  substitues << Substitute.create!(name: "Limes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oranges", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lemons"
end

# Lettuce
ingredient = Ingredient.find_by(name: "Lettuce")
if ingredient
  substitues << Substitute.create!(name: "Spinach", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Arugula", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Kale", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lettuce"
end

# Lime
ingredient = Ingredient.find_by(name: "Lime")
if ingredient
  substitues << Substitute.create!(name: "Lemon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tamarind", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Lime"
end

# Little Gem Lettuce
ingredient = Ingredient.find_by(name: "Little Gem Lettuce")
if ingredient
  substitues << Substitute.create!(name: "Romaine Lettuce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Iceberg Lettuce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Arugula", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Little Gem Lettuce"
end

# Macaroni
ingredient = Ingredient.find_by(name: "Macaroni")
if ingredient
  substitues << Substitute.create!(name: "Penne", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rigatoni", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Fusilli", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Macaroni"
end

# Mackerel
ingredient = Ingredient.find_by(name: "Mackerel")
if ingredient
  substitues << Substitute.create!(name: "Sardines", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Trout", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Herring", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Mackerel"
end

# Madras Paste
ingredient = Ingredient.find_by(name: "Madras Paste")
if ingredient
  substitues << Substitute.create!(name: "Curry Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tandoori Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garam Masala", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Madras Paste"
end

# Coconut Milk
ingredient = Ingredient.find_by(name: "Coconut Milk")
if ingredient
  substitues << Substitute.create!(name: "Almond Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soy Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cashew Milk", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Coconut Milk"
end

# Marjoram
ingredient = Ingredient.find_by(name: "Marjoram")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Marjoram"
end

# Massaman Curry Paste
ingredient = Ingredient.find_by(name: "Massaman Curry Paste")
if ingredient
  substitues << Substitute.create!(name: "Red Curry Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Yellow Curry Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Curry Paste", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Massaman Curry Paste"
end

# Medjool Dates
ingredient = Ingredient.find_by(name: "Medjool Dates")
if ingredient
  substitues << Substitute.create!(name: "Raisins", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Dried Apricots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Dried Figs", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Medjool Dates"
end

# Meringue Nests
ingredient = Ingredient.find_by(name: "Meringue Nests")
if ingredient
  substitues << Substitute.create!(name: "Pavlova", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Whipped Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Macarons", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Meringue Nests"
end

# Milk
ingredient = Ingredient.find_by(name: "Milk")
if ingredient
  substitues << Substitute.create!(name: "Almond Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soy Milk", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oat Milk", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Milk"
end

# Minced Garlic
ingredient = Ingredient.find_by(name: "Minced Garlic")
if ingredient
  substitues << Substitute.create!(name: "Garlic Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Garlic Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Minced Garlic"
end

# Miniature Marshmallows
ingredient = Ingredient.find_by(name: "Miniature Marshmallows")
if ingredient
  substitues << Substitute.create!(name: "Marshmallow Fluff", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Whipped Cream", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Meringue", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Miniature Marshmallows"
end

# Mint
ingredient = Ingredient.find_by(name: "Mint")
if ingredient
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Parsley", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Mint"
end

# Mozzarella
ingredient = Ingredient.find_by(name: "Mozzarella")
if ingredient
  substitues << Substitute.create!(name: "Provolone", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cheddar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Monterey Jack", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Mozzarella"
end

# Mushrooms
ingredient = Ingredient.find_by(name: "Mushrooms")
if ingredient
  substitues << Substitute.create!(name: "Portobello Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cremini Mushrooms", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shiitake Mushrooms", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Mushrooms"
end

# Mustard
ingredient = Ingredient.find_by(name: "Mustard")
if ingredient
  substitues << Substitute.create!(name: "Horseradish", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Wasabi", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Dijon Mustard", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Mustard"
end

# Nutmeg
ingredient = Ingredient.find_by(name: "Nutmeg")
if ingredient
  substitues << Substitute.create!(name: "Cinnamon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Allspice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mace", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Nutmeg"
end

# Olive Oil
ingredient = Ingredient.find_by(name: "Olive Oil")
if ingredient
  substitues << Substitute.create!(name: "Avocado Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Canola Oil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Olive Oil"
end

# Onion
ingredient = Ingredient.find_by(name: "Onion")
if ingredient
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Onions", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Onion"
end

# Oregano
ingredient = Ingredient.find_by(name: "Oregano")
if ingredient
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Marjoram", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Oregano"
end

# Paprika
ingredient = Ingredient.find_by(name: "Paprika")
if ingredient
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Smoked Paprika", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Paprika"
end

# Parmesan
ingredient = Ingredient.find_by(name: "Parmesan")
if ingredient
  substitues << Substitute.create!(name: "Pecorino Romano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Asiago", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Grana Padano", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Parmesan"
end

# Parsley
ingredient = Ingredient.find_by(name: "Parsley")
if ingredient
  substitues << Substitute.create!(name: "Cilantro", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chervil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Parsley"
end

# Peas
ingredient = Ingredient.find_by(name: "Peas")
if ingredient
  substitues << Substitute.create!(name: "Green Beans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Edamame", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lentils", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Peas"
end

# Pecans
ingredient = Ingredient.find_by(name: "Pecans")
if ingredient
  substitues << Substitute.create!(name: "Walnuts", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Hazelnuts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Pecans"
end

# Pine Nuts
ingredient = Ingredient.find_by(name: "Pine Nuts")
if ingredient
  substitues << Substitute.create!(name: "Sunflower Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pumpkin Seeds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almonds", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Pine Nuts"
end

# Pita Bread
ingredient = Ingredient.find_by(name: "Pita Bread")
if ingredient
  substitues << Substitute.create!(name: "Naan", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Tortilla", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Flatbread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Pita Bread"
end

# Plain Flour
ingredient = Ingredient.find_by(name: "Plain Flour")
if ingredient
  substitues << Substitute.create!(name: "Whole Wheat Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almond Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Plain Flour"
end

# Prawns
ingredient = Ingredient.find_by(name: "Prawns")
if ingredient
  substitues << Substitute.create!(name: "Shrimp", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Scallops", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lobster", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Prawns"
end

# Quinoa
ingredient = Ingredient.find_by(name: "Quinoa")
if ingredient
  substitues << Substitute.create!(name: "Couscous", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Millet", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bulgur Wheat", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Quinoa"
end

# Red Onion
ingredient = Ingredient.find_by(name: "Red Onion")
if ingredient
  substitues << Substitute.create!(name: "Yellow Onion", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "White Onion", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Red Onion"
end

# Red Pepper
ingredient = Ingredient.find_by(name: "Red Pepper")
if ingredient
  substitues << Substitute.create!(name: "Yellow Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Green Pepper", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Poblano Pepper", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Red Pepper"
end

# Red Wine
ingredient = Ingredient.find_by(name: "Red Wine")
if ingredient
  substitues << Substitute.create!(name: "Grape Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Beef Stock", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Balsamic Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Red Wine"
end

# Ricotta
ingredient = Ingredient.find_by(name: "Ricotta")
if ingredient
  substitues << Substitute.create!(name: "Cottage Cheese", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mascarpone", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cream Cheese", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Ricotta"
end

# Rice
ingredient = Ingredient.find_by(name: "Rice")
if ingredient
  substitues << Substitute.create!(name: "Quinoa", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Couscous", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Bulgur Wheat", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rice"
end

# Rice Noodles
ingredient = Ingredient.find_by(name: "Rice Noodles")
if ingredient
  substitues << Substitute.create!(name: "Egg Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Soba Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Zucchini Noodles", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rice Noodles"
end

# Rice Vinegar
ingredient = Ingredient.find_by(name: "Rice Vinegar")
if ingredient
  substitues << Substitute.create!(name: "White Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lemon Juice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rice Vinegar"
end

# Risotto Rice
ingredient = Ingredient.find_by(name: "Risotto Rice")
if ingredient
  substitues << Substitute.create!(name: "Arborio Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Carnaroli Rice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Barley", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Risotto Rice"
end

# Rocket (Arugula)
ingredient = Ingredient.find_by(name: "Rocket")
if ingredient
  substitues << Substitute.create!(name: "Spinach", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Watercress", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Kale", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rocket"
end

# Rolled Oats
ingredient = Ingredient.find_by(name: "Rolled Oats")
if ingredient
  substitues << Substitute.create!(name: "Steel-Cut Oats", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Quinoa Flakes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Flakes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rolled Oats"
end

# Roma Tomatoes
ingredient = Ingredient.find_by(name: "Roma Tomatoes")
if ingredient
  substitues << Substitute.create!(name: "Plum Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Grape Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sun-Dried Tomatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Roma Tomatoes"
end

# Rosemary
ingredient = Ingredient.find_by(name: "Rosemary")
if ingredient
  substitues << Substitute.create!(name: "Thyme", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sage", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rosemary"
end

# Rum
ingredient = Ingredient.find_by(name: "Rum")
if ingredient
  substitues << Substitute.create!(name: "Bourbon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Brandy", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Juice (non-alcoholic)", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rum"
end

# Russet Potatoes
ingredient = Ingredient.find_by(name: "Russet Potatoes")
if ingredient
  substitues << Substitute.create!(name: "Yukon Gold Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sweet Potatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Red Potatoes", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Russet Potatoes"
end

# Rye Bread
ingredient = Ingredient.find_by(name: "Rye Bread")
if ingredient
  substitues << Substitute.create!(name: "Whole Wheat Bread", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pumpernickel Bread", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sourdough Bread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Rye Bread"
end

# Saffron
ingredient = Ingredient.find_by(name: "Saffron")
if ingredient
  substitues << Substitute.create!(name: "Turmeric", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Annatto", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Saffron"
end

# Scallions (Green Onions)
ingredient = Ingredient.find_by(name: "Scallions")
if ingredient
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Shallots", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chives", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Scallions"
end

# Scallops
ingredient = Ingredient.find_by(name: "Scallops")
if ingredient
  substitues << Substitute.create!(name: "Shrimp", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lobster", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Crab", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Scallops"
end

# Sea Salt
ingredient = Ingredient.find_by(name: "Sea Salt")
if ingredient
  substitues << Substitute.create!(name: "Kosher Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Table Salt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Himalayan Salt", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sea Salt"
end

# Sesame Oil
ingredient = Ingredient.find_by(name: "Sesame Oil")
if ingredient
  substitues << Substitute.create!(name: "Olive Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Peanut Oil", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sunflower Oil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sesame Oil"
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

# Shrimp
ingredient = Ingredient.find_by(name: "Shrimp")
if ingredient
  substitues << Substitute.create!(name: "Scallops", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lobster", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Crab", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Shrimp"
end

# Sliced Almonds
ingredient = Ingredient.find_by(name: "Sliced Almonds")
if ingredient
  substitues << Substitute.create!(name: "Flaked Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Slivered Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chopped Walnuts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sliced Almonds"
end

# Smoked Paprika
ingredient = Ingredient.find_by(name: "Smoked Paprika")
if ingredient
  substitues << Substitute.create!(name: "Paprika", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chili Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cayenne Pepper", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Smoked Paprika"
end

# Soba Noodles
ingredient = Ingredient.find_by(name: "Soba Noodles")
if ingredient
  substitues << Substitute.create!(name: "Rice Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Zucchini Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Udon Noodles", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Soba Noodles"
end

# Sour Cream
ingredient = Ingredient.find_by(name: "Sour Cream")
if ingredient
  substitues << Substitute.create!(name: "Greek Yogurt", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Creme Fraiche", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cottage Cheese", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sour Cream"
end

# Soy Sauce
ingredient = Ingredient.find_by(name: "Soy Sauce")
if ingredient
  substitues << Substitute.create!(name: "Tamari", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Aminos", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Worcestershire Sauce", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Soy Sauce"
end

# Spinach
ingredient = Ingredient.find_by(name: "Spinach")
if ingredient
  substitues << Substitute.create!(name: "Kale", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Swiss Chard", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Arugula", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Spinach"
end

# Spring Onions
ingredient = Ingredient.find_by(name: "Spring Onions")
if ingredient
  substitues << Substitute.create!(name: "Scallions", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Leeks", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chives", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Spring Onions"
end

# Squash
ingredient = Ingredient.find_by(name: "Squash")
if ingredient
  substitues << Substitute.create!(name: "Zucchini", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pumpkin", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Butternut Squash", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Squash"
end

# Sugar
ingredient = Ingredient.find_by(name: "Sugar")
if ingredient
  substitues << Substitute.create!(name: "Coconut Sugar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Honey", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sugar"
end

# Sweet Potatoes
ingredient = Ingredient.find_by(name: "Sweet Potatoes")
if ingredient
  substitues << Substitute.create!(name: "Yams", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Butternut Squash", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Pumpkin", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Sweet Potatoes"
end

# Swiss Chard
ingredient = Ingredient.find_by(name: "Swiss Chard")
if ingredient
  substitues << Substitute.create!(name: "Spinach", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Kale", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Collard Greens", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Swiss Chard"
end

# Thyme
ingredient = Ingredient.find_by(name: "Thyme")
if ingredient
  substitues << Substitute.create!(name: "Oregano", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Marjoram", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Basil", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Thyme"
end

# Tofu
ingredient = Ingredient.find_by(name: "Tofu")
if ingredient
  substitues << Substitute.create!(name: "Tempeh", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Seitan", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chickpeas", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Tofu"
end

# Tomato Paste
ingredient = Ingredient.find_by(name: "Tomato Paste")
if ingredient
  substitues << Substitute.create!(name: "Tomato Sauce", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Crushed Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ketchup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Tomato Paste"
end

# Tomato Sauce
ingredient = Ingredient.find_by(name: "Tomato Sauce")
if ingredient
  substitues << Substitute.create!(name: "Tomato Paste", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Crushed Tomatoes", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Ketchup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Tomato Sauce"
end

# Tuna
ingredient = Ingredient.find_by(name: "Tuna")
if ingredient
  substitues << Substitute.create!(name: "Salmon", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Mackerel", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sardines", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Tuna"
end

# Udon Noodles
ingredient = Ingredient.find_by(name: "Udon Noodles")
if ingredient
  substitues << Substitute.create!(name: "Soba Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rice Noodles", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Zucchini Noodles", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Udon Noodles"
end

# Vanilla Extract
ingredient = Ingredient.find_by(name: "Vanilla Extract")
if ingredient
  substitues << Substitute.create!(name: "Vanilla Bean", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almond Extract", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Maple Syrup", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Vanilla Extract"
end

# Vinegar
ingredient = Ingredient.find_by(name: "Vinegar")
if ingredient
  substitues << Substitute.create!(name: "Lemon Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lime Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Vinegar"
end

# Walnuts
ingredient = Ingredient.find_by(name: "Walnuts")
if ingredient
  substitues << Substitute.create!(name: "Pecans", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almonds", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Hazelnuts", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Walnuts"
end

# White Bread
ingredient = Ingredient.find_by(name: "White Bread")
if ingredient
  substitues << Substitute.create!(name: "Whole Wheat Bread", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sourdough Bread", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Rye Bread", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: White Bread"
end

# White Wine
ingredient = Ingredient.find_by(name: "White Wine")
if ingredient
  substitues << Substitute.create!(name: "White Grape Juice", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Chicken Broth", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: White Wine"
end

# White Wine Vinegar
ingredient = Ingredient.find_by(name: "White Wine Vinegar")
if ingredient
  substitues << Substitute.create!(name: "Apple Cider Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Red Wine Vinegar", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Lemon Juice", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: White Wine Vinegar"
end

# Whole Wheat Flour
ingredient = Ingredient.find_by(name: "Whole Wheat Flour")
if ingredient
  substitues << Substitute.create!(name: "White Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Almond Flour", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Coconut Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Whole Wheat Flour"
end

# Yeast
ingredient = Ingredient.find_by(name: "Yeast")
if ingredient
  substitues << Substitute.create!(name: "Baking Powder", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Sourdough Starter", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Self-Rising Flour", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Yeast"
end

# Zucchini
ingredient = Ingredient.find_by(name: "Zucchini")
if ingredient
  substitues << Substitute.create!(name: "Eggplant", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Squash", ingredient_id: ingredient.id)
  substitues << Substitute.create!(name: "Cucumber", ingredient_id: ingredient.id)
else
  puts "Ingredient not found: Zucchini"
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
