module Judge
  class Power
    attr_reader :name, :homes, :owns
    attr_accessor :name

    def initialize( container, name)
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

    def deleted_province(province)
      @homes.delete(province)
      @owns.delete(province)
    end

    def own_word
      @own_word or name
    end

    def own_word=(value)
      @own_word = value
    end

    def abbreviation
      @abbreviation or own_word[0...1]
    end

    def abbreviation=(abbrev)
      @abbreviation = abbrev
    end
    
    def add_home(center)
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.owned_supply_center?( center )
        #center can not be suplycenter for more than one power
        raise "#{center} is allready a suply center"
      end
      homes.add(center)
      owns.add(center)
    end

    def add_owned( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if !owns.include?(center) && @container.owned_supply_center?( cente )
        #center can not be suplycenter for more than one power
        raise "#{center} is allready a suply center"
      end
      owns.add(center)
    end

    def remove_owned( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      if center
        owns.delete(center)
        if homes.delete(center)
          #make unowned
          @container.add_unowned(center)
        end
      end
    end

    def validate
      true
    end
    
    def to_s
      "Help"
    end
  end
end
# vim: sts=4:sw=4:ts=4:et