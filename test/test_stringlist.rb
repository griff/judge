require 'extras'
require 'judge/location/stringlist'
require 'set'

SL = Judge::Location::StringList

class TestStringList < Test::Unit::TestCase
  def test_flatten
    assert_list_equal ['A', 'B', 'CA', 'CB'], [['A'].to_set, ['B'].to_set, ['CA', 'CB'].to_set]
    assert_list_equal ['A', 'B', 'CA', 'CB'], [SL.new(['A']), SL.new(['B']), SL.new(['CA', 'CB'])].flatten
  end
end