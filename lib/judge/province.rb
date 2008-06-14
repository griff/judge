module Judge
  class Province < Location
    def initialize( container, abbreviation )
      super container, abbreviation
      @coasts = Hash.new
    end

    def delete
      @coasts.each_value{|c| @container.delete(c.full_abbreviation)  }
      super
    end

    def fetch_coast( coast )
      @coasts[coast.upcase]
    end

    def add_coast( coast )
      @coasts[coast.coast.upcase] = coast
    end

    def delete_coast( coast )
      @coasts.delete[coast.coast.upcase]
    end

    alias :full_abbreviation :abbreviation

    def full_abbreviation=(new_abbrev)
      province, coast = Location.abbreviation_and_coast(new_abbrev)
      raise 'Coast on non costal location' if coast
      @abbreviation = province
    end
    
    def to_s
      "Province '#{abbreviation}'"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et