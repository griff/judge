require 'extras'
require 'judge'

module MapReaderTest
  def setup_reader
    @reader = Judge::MapReader.new(File.join($root, 'test-data', 'dpmap'))
  end

  def test_power_names
    assert_list_equal @powers.map{|p| p[:name]},
            @map.powers.map{|p| p.name}, 'Power names were loaded wrong'
  end
  
  def test_power_own_words
    assert_list_equal @powers.map{|p| p[:own_word]}.to_set,
          @map.powers.map{|p| p.own_word}.to_set, 
          'Power own words were loaded wrong'
  end
  
  def test_power_abbreviations
    assert_list_equal @powers.map{|p| p[:abbreviation]}.to_set,
          @map.powers.map{|p| p.abbreviation}.to_set, 
          'Power abbreviations were loaded wrong'
  end

  def test_power_homes
    @powers.each do |p|
      name = p[:name].downcase
      assert_list_equal p[:homes].to_set,
            @map.fetch_power(name).homes.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} homes were loaded wrong"
    end
  end

  def test_power_factories
    return unless Judge::Extensions.include? :factories
    @powers.each do |p|
      name = p[:name].downcase
      assert_list_equal p[:factories].to_set,
            @map.fetch_power(name).factories.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} factories were loaded wrong"
    end
  end

  def test_power_partisans
    return unless Judge::Extensions.include? :partisans
    @powers.each do |p|
      name = p[:name].downcase
      assert_list_equal p[:partisans].to_set,
            @map.fetch_power(name).partisans.map{|h| h.full_abbreviation}.to_set, 
            "Power #{name} partisans were loaded wrong"
    end
  end
  
  def test_unowned
    assert_list_equal @unowned.to_set,
          @map.unowned.map{|h| h.full_abbreviation}.to_set, 
          'Unowned centers were loaded wrong'
  end
  
  def test_locations_names
    assert_list_equal @locations.map{|l| l[:name]}.to_set, 
          @map.locations.map{|p| p.name}.to_set,
          'Location names were loaded wrong'
  end
  
  def test_locations_abbreviations
    assert_list_equal @locations.map{|l| l[:full_abbreviation]}.to_set,
          @map.locations.map{|p| p.full_abbreviation}.to_set,
          'Location abbreviations were loaded wrong'
  end
  
  def test_locations_aliases
    assert_list_equal @locations.map{|l| l[:aliases] }.flatten.to_set,
          @map.locations.aliases.to_set,
          'Location aliases were loaded wrong'
  end
  
  def test_locations_ambiguous
    assert_list_equal @locations.map{|l| l[:ambiguous] }.flatten.to_set, 
          @map.locations.ambiguous.to_set, 
          'Ambiguous location aliases were loaded wrong'
  end
  
  def test_location_aliases
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      
      location = @map.locations[abbr]
      assert_not_nil location, "Location #{abbr} does not exists"
      
      assert_list_equal l[:aliases].to_set,
          location.aliases.to_set,
          "Aliases for #{abbr} were loaded wrong"
    end
  end
  
  def test_location_ambiguous
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      assert_list_equal l[:ambiguous].to_set,
          @map.locations[abbr].ambiguous.to_set,
          "Ambiguous for #{abbr} were loaded wrong"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et