module Judge
  class Locations
    include Enumerable
    
    def initialize(map)
      @map = map
      @names = {}
      @places = {}
      @aliases = {}
      @ambiguous = {}
    end
  
    def size
      @places.size
    end
    
    def fetch_location( location, use_ambiguous=true )
      location_u = location.upcase
      loc = @names[location_u]
      loc = fetch_place(location_u) unless loc
      loc = @aliases[location_u] unless loc
      loc = @ambiguous[location_u] unless loc or !use_ambiguous
      loc
    end
    alias :[] :fetch_location

    def fetch_province( province )
      province, coast = Location.abbreviation_and_coast(province, coast)
      raise 'Coast specified' if coast
      @places[province.upcase]
    end
    
    def fetch_or_create_province(province)
      province, coast = Location.abbreviation_and_coast(province, coast)
      raise 'Coast specified' if coast
      
      province_u = province.upcase
      result = @places[province_u]
      unless result
        result = @places[province_u] = Province.new(self, province)
      end
      result
    end
    
    def fetch_place( province, coast=nil )
      province, coast = Location.abbreviation_and_coast(province, coast)
      if coast
        @places[province.upcase + '/' + coast.upcase]
      else
        @places[province.upcase]
      end
    end

    def fetch_or_create_place( province, coast=nil )
      province, coast = Location.abbreviation_and_coast(province, coast)
      province_u = province.upcase
      coast_u = coast.upcase if coast
      full_abbreviation = province_u  + (coast ? '/' + coast_u : '' )
      result = @places[full_abbreviation]
      unless result
        if coast
          owner = @places[province_u]
          owner = @places[province_u] = Province.new(self, province) unless owner
          result = @places[full_abbreviation] = ProvinceCoast.new(self, owner, province, coast)
        else
          result = @places[full_abbreviation] = Province.new(self, province)
        end
      end

      result
    end

    def add_alias(location, province)
      location = location.upcase
      @aliases[location] = province
    end
    
    def delete_alias(location)
      location = location.upcase
      @aliases.delete(location)
    end

    def add_ambiguous(location, province)
      location = location.upcase
      @ambiguous[location] = province
    end

    def delete_ambiguous(location)
      location = location.upcase
      @ambiguous.delete(location)
    end
    
    def add_name(name, province)
      name = name.upcase
      @names[name] = province
    end
    
    def delete_name(name)
      name = name.upcase
      @names.delete(name)
    end

    def each_place(&block)
      @places.each_value(&block)
    end
    alias :each :each_place

    def delete_place(key)
      province = @places.delete(key.upcase)
      if province
        province.delete
      
        @places.each_value do |p|
          p.delete_adjacency(province)
        end
        @map.deleted_province(province)
      end
      province
    end
    alias :delete :delete_place


=begin comment
    def fetch_alias(location)
      location = location.upcase
      @aliases[location]
    end


    def fetch_ambigous( location )
      @ambigous[location]
    end

    def fetch_province( province, coast=nil )
      province, coast = Location.abbreviation_and_coast(province, coast)
      if coast
        province = @locations[province.upcase]
        province.fetch_coast coast
      else
        @locations[province.upcase]
      end
    end

    def fetch_or_create_province( province, coast=nil )
      province, coast = Location.abbreviation_and_coast(province, coast)
      uProvince = province.upcase

      result = @locations[uProvince]
      result = @locations[uProvince] = Province.new(1, self, province) unless result
      result = result.fetch_or_create_coast( coast ) if coast

      result
    end

    def each_province(&block)
        @locations.each_value(block)
    end
    
    def validate_locations
      
    end
=end
  end
end