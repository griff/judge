module Judge
  class Power
    attr_reader :name, :factories, :partisans, :homes
    attr_accessor :name

    def initialize( container, name)
      @container = container
      @name = name
      @own_word = nil
      @abbreviation = nil
      @factories = [].to_set
      @partisans = [].to_set
      @homes = [].to_set
    end

    def deleted_province(province)
      @factories.delete(province)
      @partisans.delete(province)
      @homes.delete(province)
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

    def <<( centers )
      centers = centers.split if centers.kind_of? String
      centers = centers.to_a if centers.respond_to? :to_a
      centers.each do |center|
        center = center.upcase
        case center
        when /^\+([A-Z0-9]{3})$/
          #make factory
          add_factory( center )
        when /^\*([A-Z0-9]{3})$/
          #make partisan
          add_partisan( center )
        when /^\-([A-Z0-9]{3})$/
          #remove home center
          c = @container.locations.fetch_province($1)
          if c
            @factories.delete(c)
            @partisans.delete(c)
            if @homes.delete(c)
              #make unowned
              @container.add_unowned(c)
            end
          end
        when /^([A-Z0-9]{3})$/
          #make home center
          c = @container.locations.fetch_or_create_province($1)
          if @container.suplycenter?( c )
            #center can not be suplycenter for more than one power
            raise "#{$1} is allready a suply center"
          end
          @homes << c
        else
          throw ArgumentError, "Invalid center #{center}"
        end
      end
    end
  end
end
# vim: sts=4:sw=4:ts=4:et