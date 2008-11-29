module Judge
  class Province < Location
    attr_reader :owner, :coasts
    
    def initialize( container, abbreviation )
      super container, abbreviation
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

    alias :full_abbreviation :abbreviation

    def full_abbreviation=(new_abbrev)
      province, coast = Location.abbreviation_and_coast(new_abbrev)
      raise 'Coast on non costal location' if coast
      old_full = self.full_abbreviation
      @abbreviation = province
      @container._replace(old_full, self.full_abbreviation)
    end
    
    def validate
      super
      raise "Mixed province abbreviation" unless @coasts.all?{|c| abbreviation == c.abbreviation}
      unless @coasts.all?{|c| type == c.type}
        puts "Main #{self.abbreviation} type #{self.type}"
        @coasts.each {|c| puts "  Coast #{c.coast} with type #{c.type}"}
        raise "Mixed types" unless @coasts.all?{|c| self.type == c.type}
      end
    end

    def _delete
      @coasts.each{|c| @container.delete(c.full_abbreviation)  }
      super
    end
  end
end
# vim: sts=4:sw=4:ts=4:et