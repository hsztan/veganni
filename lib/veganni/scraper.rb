require "pry"

require "nokogiri"
require "open-uri"
require_relative "recipe"

class Scraper
  attr_accessor :path

  def initialize(month = "2019/02")
    @path = self.make_path(month)
    @recepies = []
  end

  def scrape_main
    file = open(@path)
    doc = Nokogiri::HTML(file).css("article")
    doc.each do |node|
      name = node.css(".entry-title").text
      description = node.css(".entry-content p").text
      link = node.css("a.entry-title-link[href]").to_s.match(/http.+html/).to_s
      #how can I get the value of href in the "a" attribute??????

      recipe = Recipe.new(name, description, link)
    end
    Recipe.all
  end

  def scrape_detail_recipe(link)

  end

  def make_path(month)
   "https://www.veganricha.com/" + month
  end
end

scrape = Scraper.new
scrape.scrape_main
binding.pry
