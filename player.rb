require_relative 'players'
class Player < Players
  attr_accessor :name

  def initialize
    super
  end

  def add_name(name)
    self.name = name
  end

end
