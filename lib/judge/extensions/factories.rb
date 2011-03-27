module Judge
  class AlreadyFactoryError < JudgeError
  end

  class Map::SupplyCenterList
    def check_before_add_with_factories(center)
      power = @map.powers.find{|p| p.factories.include?(center)}
      raise AlreadyFactoryError, "#{center} is already a factory center for #{power}" if power

      self.check_before_add_without_factories(center)
    end
    alias_method_chain :check_before_add, :factories
  end
  
  class Power
    class FactoriesList < LocationList
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        if @container.supply_centers.include?( center )
          #center can not be a suply center and a factory
          raise AlreadySupplyCenterError, "#{center} is already a suply center"
        end
        _write_list.add(center)
      end
    end
    def factories
      @factories ||= FactoriesList.new(@container)
    end
    
    def setup_with_factories
      self.setup_without_factories
      @factories = FactoriesList.new(@container)
    end
    alias_method_chain :setup, :factories

    def delete_center_with_factories( center, &block )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      self.delete_center_without_factories(center, &block) unless center && factories.delete(center)
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