module Judge
  class ProvinceCoast < Location
    attr_reader :province, :coast
    
    def initialize( container, province, abbreviation, coast )
      super(container, abbreviation)
      @province = province
      @coast = coast.upcase
      province.coasts.add(self)
    end
    
    def owner
      @province.owner
    end

    def delete
      @province.coasts.delete(self)
      super
    end
    
    def full_abbreviation
      abbreviation + '/' + coast
    end

    def full_abbreviation=(new_abbrev)
      province, coast = Location.abbreviation_and_coast(new_abbrev)
      raise 'No coast for costal location' unless coast
      old_full = self.full_abbreviation
      @abbreviation = province
      if coast != @coast
        @province.coasts.delete(self)
        @coast = coast
        @province.coasts.add(self)
      end
      @container.replace(old_full, self.full_abbreviation)
    end
  end
end
# vim: sts=4:sw=4:ts=4:et