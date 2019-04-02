class Veganni::CLI

  SEPARATOR = "---------------------------------------------"

  def initialize
  end

  def call
    user_interface
  end

  def user_interface
    puts "Welcome to Veganni. An excelente source of wonderful vegan recipes."
    puts "Information from: veganricha.com!"
    puts SEPARATOR
    select_month
    show_recipe_summary(select_recipe)

  end

  def show_recipe_summary(recipe_number)
    index = recipe_number - 1
    recipe = Recipe.all[index]
    puts SEPARATOR
    puts "Name:"
    puts recipe.name
    puts "Description:"
    puts recipe.description
    puts SEPARATOR
  end

  def select_month
    puts "Please select a month between 2008/12 and 2019/02"
    bad_month = true
    while bad_month
      month = gets.chomp
      if month.match?(/\d{4}\/\d{2}/)
        list_month_recipes(month)
        bad_month = false
      else
        puts "Please enter a valid month"
      end
    end
  end

  def select_recipe
    selection = nil
    puts "Please enter the number of the recipe you wish to get more details:"
    bad_number = true
    while bad_number
      selection = gets.chomp.to_i
      if selection > 0 && selection < Recipe.all.size  #maybe can abstract it more?
        bad_number = false
      else
        puts "Please enter a valid selection:"
      end
    end
    selection
  end

  def list_month_recipes(month)
    scrape_month = Scraper.new(month).create_recipes
    Recipe.all.each.with_index(1) do |recipe, index|
      puts "#{index}. #{recipe.name}"
    end
  end

end
