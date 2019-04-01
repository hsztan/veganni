
class Recipe
  attr_accessor :name, :description, :link

  @@all = []

  def initialize(name, description, link)
    @name = name
    @description = description
    @link = link
    @@all << self
  end

  def self.all
    @@all
  end

end
