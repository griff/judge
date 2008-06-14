$root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join($root, 'lib')
require 'test/unit'
require 'judge'

module MapReaderTest
  def setup_reader
    @reader = Judge::MapReader.new(File.join($root, 'test-data', 'dpmap'))
  end

  def test_power_names
    assert_equal @powers.map{|p| p[:name]}.to_set,
            @map.powers.map{|p| p.name}.to_set, 'Power names were loaded wrong'
  end
  
  def test_power_own_words
    assert_equal @powers.map{|p| p[:own_word]}.to_set,
          @map.powers.map{|p| p.own_word}.to_set, 
          'Power own words were loaded wrong'
  end
  
  def test_power_abbreviations
    assert_equal @powers.map{|p| p[:abbreviation]}.to_set,
          @map.powers.map{|p| p.abbreviation}.to_set, 
          'Power abbreviations were loaded wrong'
  end

  def test_power_homes
    @powers.each do |p|
      name = p[:name].downcase
      assert_equal p[:homes].to_set,
            @map.fetch_power(name).homes.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} homes were loaded wrong"
    end
  end

  def test_power_factories
    @powers.each do |p|
      name = p[:name].downcase
      assert_equal p[:factories].to_set,
            @map.fetch_power(name).factories.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} factories were loaded wrong"
    end
  end

  def test_power_partisans
    @powers.each do |p|
      name = p[:name].downcase
      assert_equal p[:partisans].to_set,
            @map.fetch_power(name).partisans.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} partisans were loaded wrong"
    end
  end
  
  def test_unowned
    assert_equal @unowned.to_set,
          @map.unowned.map{|h| h.full_abbreviation}.to_set, 
          'Unowned centers were loaded wrong'
  end
  
  def test_locations_names
    assert_equal @locations.map{|l| l[:name]}.to_set, 
          @map.locations.map{|p| p.name}.to_set,
          'Location names were loaded wrong'
    assert_equal @locations.map{|l| l[:name].upcase}.to_set.to_set,
          @map.locations.instance_variable_get(:@names).keys.to_set,
          'Location names hash was loaded wrong'
  end
  
  def test_locations_abbreviations
    assert_equal @locations.map{|l| l[:full_abbreviation]}.to_set,
          @map.locations.map{|p| p.full_abbreviation}.to_set,
          'Location abbreviations were loaded wrong'
  end
  
  def test_locations_aliases
    assert_equal @locations.map{|l| l[:aliases] }.flatten.to_set,
          @map.locations.instance_variable_get(:@aliases).keys.to_set,
          'Location aliases were loaded wrong'
  end
  
  def test_locations_ambiguous
    assert_equal @locations.map{|l| l[:ambiguous] }.flatten.to_set, 
          @map.locations.instance_variable_get(:@ambiguous).keys.to_set, 
          'Ambiguous location aliases were loaded wrong'
  end
  
  def test_location_aliases
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      assert_equal l[:aliases].to_set,
          @map.locations[abbr].instance_variable_get(:@aliases).to_set,
          "Aliases for #{abbr} were loaded wrong"
    end
  end
  
  def test_location_ambiguous
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      assert_equal l[:ambiguous].to_set,
          @map.locations[abbr].instance_variable_get(:@ambiguous).to_set,
          "Ambiguous for #{abbr} were loaded wrong"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et