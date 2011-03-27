module Judge
  class Province < Location
    attr_reader :owner, :coasts
    
    def initialize( map, abbreviation )
      super map, abbreviation
      @coasts = [].to_set
    end
    
    def province
      self
    end

    def owner=(new_owner)
      @owner.remove_owned(self) if @owner
      new_owner.add_owned(self) if new_owner
      @owner = new_owner
    end

    def fetch_coast( coast )
      @coasts.find{|c| c.coast.upcase == coast.upcase }
    end
    
    def fetch_or_create_coast(coast)
      @coasts.find{|c| c.coast.upcase == coast.upcase } || @map.locations.fetch_or_create_place(abbreviation, coast)
    end

    alias :full_abbreviation :abbreviation

    def full_abbreviation=(new_abbrev)
      province, coast = Location.abbreviation_and_coast(new_abbrev)
      raise ArgumentError, 'Coast on non costal location' if coast
      old_full = self.full_abbreviation
      @abbreviation = province
      @map._replace(old_full, self.full_abbreviation)
    end
    
    def validate
      super
      raise "Mixed province abbreviation" unless @coasts.all?{|c| abbreviation == c.abbreviation}
      unless @coasts.all?{|c| terrain == c.terrain}
        puts "Main #{self.abbreviation} terrain #{self.terrain}"
        @coasts.each {|c| puts "  Coast #{c.coast} with terrain #{c.terrain}"}
        raise "Mixed terrains" unless @coasts.all?{|c| self.terrain == c.terrain}
      end
    end

    def _delete
      @coasts.each{|c| @map.delete(c.full_abbreviation)  }
      super
    end
  end
end
# vim: sts=4:sw=4:ts=4:et