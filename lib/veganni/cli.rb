class Veganni::CLI

  attr_accessor :exit, :recipe, :month

  SEPARATOR = "---------------------------------------------------"

  def initialize
    @exit = false
  end

  def call
    self.user_interface
  end

  def user_interface
    puts SEPARATOR
    self.greeting
    puts SEPARATOR
    self.list_month_recipes
    puts SEPARATOR
    self.select_recipe unless exit
    self.show_recipe_summary unless exit

    while !self.exit
      puts SEPARATOR
      self.menu
      case input = gets.chomp.downcase
      when "main"
        puts SEPARATOR
        self.list_month_recipes
        puts SEPARATOR
        self.select_recipe
        self.show_recipe_summary
      when "prep"
        puts SEPARATOR
        self.show_ingredients_and_prep
      when "exit"
        self.exit = true
      end
    end
    puts SEPARATOR
    puts "Thank you for using Veganni, have a great day!"
    puts SEPARATOR
  end

  def greeting
    puts "Welcome to Veganni. An excelente source of wonderful vegan recipes."
    puts "Information from: veganricha.com!"
  end

  def menu
    puts "Type prep to get cooking!"
    puts "Type main to go back to the beginning."
    puts "Type exit to quit the program."
  end

  def get_ingredients_and_prep
    scrapy = Scraper.scrape_by_recipe(self.recipe)
    scrapy.add_ingredients
    scrapy.add_prep
  end

  def show_ingredients_and_prep
    self.get_ingredients_and_prep
    self.show_ingredients
    self.show_prep
  end

  def show_ingredients
    puts "Showing ingredients"
  end

  def show_prep
    puts "Showing preparation"
  end

  def show_recipe_summary
    if !self.recipe.nil?
      puts "Name:"
      puts self.recipe.name
      puts "Description:"
      puts self.recipe.description
    end
  end

  def list_month_recipes
    self.month = nil
    puts "Please select a month between 2008/12 and 2019/02 or type exit"
    bad_month = true
    while bad_month && !self.exit
      input = gets.chomp
      if input.match?(/\d{4}\/\d{2}/)
        self.month = input
        puts "Recipes for this month are:"
        puts SEPARATOR
        self.get_month_recipes
        bad_month = false
      elsif input == "exit"
       self.exit = true
      else
        puts "Please enter a valid month"
      end
    end
  end

  def select_recipe  #sets recipe to an instance
    selection = nil
    puts "Please enter the number of the recipe you wish to get more details: (or type exit)"
    bad_number = true
    while bad_number && !self.exit
      selection = gets.chomp
      if selection.to_i > 0 && selection.to_i <= Recipe.all.size  #maybe can abstract it more?
        bad_number = false
        self.recipe = Recipe.all[selection.to_i - 1]
      elsif selection == "exit"
        self.exit = true
      else
        puts "Please enter a valid selection:"
      end
    end
  end

  def get_month_recipes
    Recipe.reset_all
    Scraper.create_by_month(self.month).create_recipes
    Recipe.all.each.with_index(1) do |recipe, index|
      puts "#{index}. #{recipe.name}"
    end
  end

end
