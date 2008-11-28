module Judge
  class Power
    def partisans
      @partisans ||= [].to_set
    end
    
    def setup_with_partisans
      self.setup_without_partisans
      @partisans = [].to_set
    end
    alias_method_chain :setup, :partisans
    
    def deleted_province_with_partisans(province)
      partisans.delete(province)
      self.deleted_province_without_partisans(province)
    end
    alias_method_chain :deleted_province, :partisans

    def delete_center_with_partisans( center )
      center = @container.locations.fetch_province(center) unless center.kind_of? Location
      if center && partisans.delete(center)
        #make unowned
        @container.add_unowned(center)
        true
      else
        self.delete_center_without_partisans(center)
      end
    end
    alias_method_chain :delete_center, :partisans
    
    def add_partisan( center )
      center = @container.locations.fetch_or_create_province(center) unless center.kind_of? Location
      if @container.supply_center?( center )
        #center can not be suplycenter for more than one power
        raise "#{$1} is allready a suply center"
      end
      self.partisans.add(center)
    end
  end
  Extensions << :partisans
end