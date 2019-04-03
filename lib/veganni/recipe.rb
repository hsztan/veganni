
class Recipe
  attr_accessor :name, :description, :link, :ingredients, :prep_steps

  @@all = []

  def initialize(name, description, link)
    @name = name
    @description = description
    @link = link
    @ingredients = []
    @prep_steps = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset_all
    self.all.clear
  end

end
