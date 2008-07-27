module Judge
  class Province < Location
    attr_reader :owner, :coasts
    
    def initialize( container, abbreviation )
      super container, abbreviation
      @coasts = [].to_set
    end

    def owner=(new_owner)
      @owner.remove_owned(self) if @owner
      new_owner.add_owned(self) if new_owner
      @owner = new_owner
    end

    def delete
      @coasts.each_value{|c| @container.delete(c.full_abbreviation)  }
      super
    end

    def fetch_coast( coast )
      @coasts.find{|c| c.coast.upcase == coast.upcase }
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
    
    def validate
      super
      raise "Mixed province name" unless @coasts.all?{|c| abbreviation == c.abbreviation}
      raise "Mixed types name" unless @coasts.all?{|c| type == c.type}
    end
  end
end
# vim: sts=4:sw=4:ts=4:et