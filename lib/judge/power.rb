module Judge
  class Power
    attr_reader :name, :homes, :owns
    attr_accessor :name
    attr_reader :factories, :partisans

    def initialize( container, name)
      @container = container
      @name = name
      @own_word = nil
      @abbreviation = nil
      @homes = [].to_set
      @units = [].to_set
      @owns = [].to_set
      @factories = [].to_set
      @partisans = [].to_set
    end

    def deleted_province(province)
      @factories.delete(province)
      @partisans.delete(province)
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

    def add_factory( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.suplycenter?( center )
        #center can not be both suplycenter and factory
        raise "#{center} is allready a suply center"
      end
      @factories << center
    end

    def add_partisan( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.suplycenter?( center )
        #center can not be both suplycenter and partisan
        raise "#{center} is allready a suply center"
      end
      @partisans << center
    end

    def add_owned( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Province
      if @container.suplycenter?( center )
        #center can not be both suplycenter and partisan
        raise "#{center} is allready a suply center"
      end
      @partisans << center
    end

    def remove_owned( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Province
      if @container.suplycenter?( center )
        #center can not be both suplycenter and partisan
        raise "#{center} is allready a suply center"
      end
      @partisans << center
    end
    
    def validate
      true
    end
  end
end
# vim: sts=4:sw=4:ts=4:et