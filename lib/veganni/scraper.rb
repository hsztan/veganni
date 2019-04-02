require "pry"

require "nokogiri"
require "open-uri"
require_relative "recipe"

class Scraper
  attr_accessor :path
  BASE_PATH = "https://www.veganricha.com/"

  def initialize(month = "2019/02")
    @path = self.make_path(month)
  end

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

  def scrape_detail_recipe(link)

  end

  def add_recipe_attributes

  end

  def make_path(month)
   BASE_PATH + month
  end
end
