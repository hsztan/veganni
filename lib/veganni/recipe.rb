
class Veganni::Recipe
  attr_accessor :name, :description, :link, :ingredients, :prep_steps, :prep_notes

  @@all = []

  def initialize(name, link)
    @name = name
    @link = link
    @ingredients = []
    @prep_steps = []
    @prep_notes = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset_all
    self.all.clear
  end

end
