module Judge
  class Power
    attr_reader :homes, :owns, :abbreviation
    attr_accessor :name, :own_word

    def initialize( container, name=nil)
      @container = container
      @name = name
      self.setup
    end
    
    def setup
      @own_word = nil
      @abbreviation = nil
      @homes = [].to_set
      @units = [].to_set
      @owns = [].to_set
    end
    
    def abbreviation=(new_value)
      @abbreviation = new_value.upcase
    end

    def deleted_province(province)
      @homes.delete(province)
      @owns.delete(province) if @owns
    end
    
    def add_home(center)
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.supply_center?( center )
        @container.delete_supply_center(center)
        #center can not be suplycenter for more than one power
#        raise "#{center} is allready a suply center"
      end
      homes.add(center)
      owns.add(center)
    end

    def add_owned( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if !owns.include?(center) && @container.supply_center?( center )
        @container.delete_supply_center(center)
        #center can not be suplycenter for more than one power
        #raise "#{center} is allready a suply center"
      end
      owns.add(center)
    end
    
    def delete_owned(center)
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      center && owns.delete(center)
    end

    def delete_center( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      if center && homes.delete(center)
        @owns.delete(center)
        #make unowned
        @container.add_unowned(center)
        true
      else
        false
      end
    end

    def validate
      raise "No abbreviation provided" unless abbreviation
      raise "No name provided" unless name
      raise "No own word provided" unless own_word
    end
  end
end
# vim: sts=4:sw=4:ts=4:et