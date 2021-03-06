module Judge
  class AlreadyPartisanError < JudgeError
  end

  class Map::SupplyCenterList
    def check_before_add_with_partisans(center)
      power = @map.powers.find{|p| p.partisans.include?(center)}
      raise AlreadyPartisanError, "#{center} is already a partisan center for #{power}" if power

      self.check_before_add_without_partisans(center)
    end
    alias_method_chain :check_before_add, :partisans
  end

  class Power
    class PartisansList < LocationList
      def add(center)
        center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
        if @container.supply_centers.include?( center )
          #center can not be a suplycenter and partisan
          raise AlreadySupplyCenterError, "#{center} is already a suply center"
        end
        _write_list.add(center)
      end
    end
    
    def partisans
      @partisans ||= PartisansList.new(@container)
    end
    
    def setup_with_partisans
      self.setup_without_partisans
      @partisans = PartisansList.new(@container)
    end
    alias_method_chain :setup, :partisans

    def delete_center_with_partisans( center, &block )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      self.delete_center_without_partisans(center, &block) unless center && partisans.delete(center)
    end
    alias_method_chain :delete_center, :partisans
    
    
    def _deleted_province_with_partisans(province)
      self._deleted_province_without_partisans(province)
      partisans._deleted_province(province)
    end
    alias_method_chain :_deleted_province, :partisans
    
    def _replace_with_partisans(old_loc,new_loc)
      _replace_without_partisans(old_loc,new_loc)
      partisans._replace(old_loc,new_loc)
    end
    alias_method_chain :_replace, :partisans
  end
  Extensions << :partisans
end