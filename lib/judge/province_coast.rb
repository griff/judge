module Judge
  class ProvinceCoast < Location
    attr_reader :province, :coast
    
    def initialize( container, province, abbreviation, coast )
      super(container, abbreviation)
      @province = province
      @coast = coast.upcase
      province.add_coast(self)
    end

    def delete
      @province.delete_coast(self)
      super
    end
    
    def full_abbreviation
      abbreviation + '/' + coast
    end

    def full_abbreviation=(new_abbrev)
      province, coast = Location.abbreviation_and_coast(new_abbrev)
      raise 'No coast for costal location' unless coast
      @abbreviation = province
      @province.delete_coast(self)
      @coast = coast
      @province.add_coast(self)
    end
    
    def to_s
      "Coast '#{coast}' for province '#{abbreviation}'"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et