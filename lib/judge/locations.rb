module Judge
  class Locations
    include Enumerable
    
    def initialize
      @places = {}
    end
  
    def size
      @places.size
    end
    
    def fetch_location( location, use_ambiguous=true )
      location_u = location.upcase
      loc = @places.values.find{|p| p.name.upcase == location_u}
      loc = fetch_place(location_u) unless loc
      loc = @places.values.find{|p| p.aliases.any?{|a| a.upcase == location_u}} unless loc
      loc = @places.values.find{|p| p.ambiguous.any?{|a| a.upcase == location_u}} unless loc or !use_ambiguous
      loc
    end
    alias :[] :fetch_location
    
    def names
      @places.values.map{|p| p.name}
    end
    
    def aliases
      @places.values.map{|p| p.aliases.to_a}.flatten
    end
    
    def ambiguous
      @places.values.map{|p| p.ambiguous.to_a}.flatten
    end

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
    
    def validate
      @places.values.all?{|p| p.validate}
    end
  end
end