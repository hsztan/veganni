require "nokigiri"
require "open-uri"

class Veganni::Scraper
  attr_accessor :recepies, :path

  def initialize(month = "2019/02")
    @path = self.make_path(month)
    @recepies = []
  end

  def scrape_main
    file = open(@path)
    doc = Nokogiri::HTML(file).css("article")
    doc.each do |name|
      recepie = {}
      recepie[:name] = name.css(".entry-title").text
      recepie[:description] = name.css(".entry-content p").text
      recepie[:link] = name.css("a.entry-title-link[href]").to_s.match(/http.+html/).to_s
      self.recepies << recepie
    end
    !self.recepies.empty?
  end

  def scrape_detail

  end

  def make_path(month)
   "https://www.veganricha.com/" + month
  end


end
