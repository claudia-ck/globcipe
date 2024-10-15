# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Cleaning DB..."
Favourite.destroy_all

Recipe.destroy_all

User.destroy_all

Ingredient.destroy_all


puts "Creating users..."

users = []

users << User.create!(email: 'user1@example.com', password: 'password123')
users << User.create!(email: 'user2@example.com', password: 'password123')
users << User.create!(email: 'user3@example.com', password: 'password123')
puts "Creating recipe..."

recipes = []

recipes << Recipe.create!(name: "Hoggle", instruction: "A Recipe with a spade", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Quill", instruction: "A Recipe with a big red hat", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Mirth", instruction: "A Recipe holding a fishing rod", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Perrin", instruction: "A Recipe sitting and reading a book", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Roscoe", instruction: "A Recipe holding a small lantern", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Zook", instruction: "A Recipe with a watering can", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Eldon", instruction: "A Recipe sitting on a big mushroom", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Nimble", instruction: "A Recipe pushing a wheelbarrow", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Ripplewink", instruction: "A Recipe holding a small shovel", category: "dessert", area: "Chinese")

recipes << Recipe.create!(name: "Yarnyarn", instruction: "A Recipe holding a bouquet of flowers", category: "dessert", area: "Chinese")



puts "Creating ingredients..."

ingredients = []

ingredients << Ingredient.create!(name: "InHoggle", description: "A Recipe holding a small shovel")

ingredients << Ingredient.create!(name: "InZook", description: "A Recipe pushing a wheelbarrow")

ingredients << Ingredient.create!(name: "InPerrin", description: "A Recipe holding a small lantern")

RecipeIngredient.create!(measure: "1 cup", recipe: recipes[0], ingredient: ingredients[0])
RecipeIngredient.create!(measure: "1 cup", recipe: recipes[0], ingredient: ingredients[1])
RecipeIngredient.create!(measure: "1 cup", recipe: recipes[0], ingredient: ingredients[2])
