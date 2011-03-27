require 'test/unit'
require 'judge'

$root = File.join(File.dirname(__FILE__), '..', '..')

class DatcTestCase < Test::Unit::TestCase
  def setup
    @map = Judge::MapReader.read(File.join($root, 'maps', 'standard.rb'))
    @game = Judge::Game.new(@map)
    @game.units.clear
  end
end