module Politics
    def each_suplycenter(&block)
        @unowned.each(block)
        @powers.each do |power|
            power.homes.each(block)
        end
    end
    
    def add_unowned( center )
        center = fetch_location(center)
        @unowned << center unless suplycenter?
    end
    
    def find_power( name )
        name = name.upcase
        @powers.find { |power| name == power.name }
    end
    
    def find_or_create_power( name )
      uname = name.upcase
      ret = @powers.find { |power| uname == power.name }
      unless ret
        ret = Power.new(self)
    end
    
    def each_unowned(&block)
        @unowned.each(block)
    end
    
    def unowned?( abbreviation )
        abbreviation = fetch_location(abbreviation)
        @unowned.any?{|center|  abbreviation == center }
    end
    
    def suplycenter?( abbreviation )
        abbreviation = fetch_location(abbreviation)
        @unowned.any?{|center|  abbreviation == center } or
        @powers.any? do |power|
            power.homes.any? { |center| abbreviation == center } 
        end
    end
    
    def included(othermod)
        othermod.const_set(:Power, Politics::Power)
    end
    
end
