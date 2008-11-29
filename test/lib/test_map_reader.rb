require 'extras'
require 'judge'
require 'judge/dpjudge_map_reader'

module MapReaderTest
  def army(location)
    Judge::Army.new(nil, location)
  end
  
  def fleet(location)
    Judge::Fleet.new(nil, location)
  end

  def setup_reader
    @reader = Judge::DPJudgeMapReader.new(File.join($root, 'test-data', 'dpmap'))
  end

  def test_power_names
    assert_set_equal @powers.map{|p| p[:name]},
            @map.powers.map{|p| p.name}, 'Power names were loaded wrong'
  end
  
  def test_power_own_words
    assert_set_equal @powers.map{|p| p[:own_word]},
          @map.powers.map{|p| p.own_word}, 
          'Power own words were loaded wrong'
  end
  
  def test_power_abbreviations
    assert_set_equal @powers.map{|p| p[:abbreviation]},
          @map.powers.map{|p| p.abbreviation}, 
          'Power abbreviations were loaded wrong'
  end

  def test_power_homes
    @powers.each do |p|
      name = p[:name]
      assert_set_equal p[:homes],
            @map.fetch_power(name).homes.map{|h| h.full_abbreviation}, 
            "Power #{name} homes were loaded wrong"
    end
  end

  def test_power_owns
    @powers.each do |p|
      name = p[:name]
      assert_set_equal p[:owns],
            @map.fetch_power(name).owns.map{|h| h.full_abbreviation}
            "Power #{name} owns were loaded wrong"
    end
  end
  
  def test_power_factories
    return unless Judge::Extensions.include? :factories
    @powers.each do |p|
      name = p[:name]
      assert_set_equal p[:factories],
            @map.fetch_power(name).factories.map{|h| h.full_abbreviation}, 
            "Power #{name} factories were loaded wrong"
    end
  end

  def test_power_partisans
    return unless Judge::Extensions.include? :partisans
    @powers.each do |p|
      name = p[:name]
      assert_set_equal p[:partisans],
            @map.fetch_power(name).partisans.map{|h| h.full_abbreviation}, 
            "Power #{name} partisans were loaded wrong"
    end
  end
  
  def test_units
    @powers.each do |p|
      name = p[:name]
      power = @map.fetch_power(name)
      assert_set_equal p[:units].map{|u| u.class.new(power, @map.locations[u.location])},
          power.units,
          "Power #{name} units were loaded wrong"
    end
  end
  
  def test_unowned
    assert_set_equal @unowned,
          @map.unowned.map{|h| h.full_abbreviation}, 
          'Unowned centers were loaded wrong'
  end
  
  def test_locations_names
    assert_set_equal @locations.map{|l| l[:name]}, 
          @map.locations.map{|p| p.name},
          'Location names were loaded wrong'
  end
  
  def test_locations_abbreviations
    assert_set_equal @locations.map{|l| l[:full_abbreviation].upcase},
          @map.locations.map{|p| p.full_abbreviation},
          'Location abbreviations were loaded wrong'
  end
  
  def test_locations_aliases
    assert_set_equal @locations.map{|l| l.fetch(:aliases, []).map{|f| f.upcase} }.flatten,
          @map.locations.aliases,
          'Location aliases were loaded wrong'
  end
  
  def test_locations_ambiguous
    assert_set_equal @locations.map{|l| l.fetch(:ambiguous, []).map{|f| f.upcase} }.flatten, 
          @map.locations.ambiguous, 
          'Ambiguous location aliases were loaded wrong'
  end
  
  def test_location_aliases
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      
      location = @map.locations[abbr]
      assert_not_nil location, "Location #{abbr} does not exists"
      
      assert_set_equal l.fetch(:aliases,[]).map{|l| l.upcase},
          location.aliases,
          "Aliases for #{abbr} were loaded wrong"
    end
  end
  
  def test_location_ambiguous
    @locations.each do |l|
      abbr = l[:full_abbreviation]
      assert_set_equal l.fetch(:ambiguous,[]).map{|l| l.upcase},
          @map.locations[abbr].ambiguous,
          "Ambiguous for #{abbr} were loaded wrong"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et