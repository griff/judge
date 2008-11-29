module Judge
  class Power
    class FactoriesList < LocationList
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        if @container.supply_center?( center )
          #center can not be a suply center and a factory
          raise "#{$1} is allready a supply center"
        end
        @list.add(c)
      end
    end
    def factories
      @factories ||= FactoriesList.new(@contaier)
    end
    
    def setup_with_factories
      self.setup_without_factories
      @factories = FactoriesList.new(@contaier)
    end
    alias_method_chain :setup, :factories

    def delete_center_with_factories( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      self.delete_center_without_factories(center) unless center && factories.delete(center)
    end
    alias_method_chain :delete_center, :factories
    
    def _deleted_province_with_factories(province)
      self._deleted_province_without_factories(province)
      factories._deleted_province(province)
    end
    alias_method_chain :_deleted_province, :factories
    
    def _replace_with_factories(old_loc,new_loc)
      _replace_without_factories(old_loc,new_loc)
      factories._replace(old_loc,new_loc)
    end
    alias_method_chain :_replace, :factories
  end
  Extensions << :factories
end