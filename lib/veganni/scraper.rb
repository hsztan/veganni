
class Scraper
  attr_accessor :path, :recipe

  BASE_PATH = "https://www.veganricha.com/"

  def scrape_main
    file = open(@path)
    doc = Nokogiri::HTML(file).css("article")
  end

  def create_recipes
    self.scrape_main.each do |node|
      name = node.css(".entry-title").text
      description = node.css(".entry-content p").text.split("\u00a0").first
      link = node.css("a.entry-title-link").attr("href").value
      recipe = Recipe.new(name, description, link)
    end
    !Recipe.all.empty?
  end

  def add_ingredients
    doc = self.scrape_ingredients
      doc.css(".wprm-recipe-ingredient").each do |i|
        ingredient = {}
        ingredient[:amount] = i.css(".wprm-recipe-ingredient-amount").text
        ingredient[:unit] = i.css(".wprm-recipe-ingredient-unit").text
        ingredient[:name] = i.css(".wprm-recipe-ingredient-name").text
        ingredient[:notes] = i.css(".wprm-recipe-ingredient-notes").text
        self.recipe.ingredients << ingredient
      end
  end

  def add_prep
    doc = self.scrape_prep
    doc.each do |step|
      self.recipe.prep_steps << step.css("div p").text
    end
    self.recipe.prep_steps.select {|step| step != ""}
  end

  def make_path(month)
   BASE_PATH + month
  end

  def self.create_by_month(month = "2019/02")
    scrape = self.new
    scrape.path = scrape.make_path(month)
    scrape
  end

  def self.scrape_by_recipe(recipe)
    scrape = self.new
    scrape.recipe = recipe
    scrape
  end

  def scrape_ingredients
    file = open(self.recipe.link)
    Nokogiri::HTML(file).css(".wprm-recipe-container")
  end

  def scrape_prep
    file = open(self.recipe.link)
    Nokogiri::HTML(file).css(".wprm-recipe-instruction")
  end


end
