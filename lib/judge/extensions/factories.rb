module Judge
  class Power
    def factories
      @factories ||= [].to_set
    end
    
    def setup_with_factories
      self.setup_without_factories
      @factories = [].to_set
    end
    alias_method_chain :setup, :factories
    
    def deleted_province_with_factories(province)
      factories.delete(province)
      self.deleted_province_without_factories(province)
    end
    alias_method_chain :deleted_province, :factories

    def remove_owned_with_factories( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      if center
        factories.delete(center)
        self.remove_owned_without_factories(center)
      end
    end
    alias_method_chain :remove_owned, :factories
    
    def add_factory( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.owned_supply_center?( center )
        #center can not be suplycenter for more than one power
        raise "#{$1} is allready a suply center"
      end
      factories.add(c)
    end
  end
  Extensions << :factories
end