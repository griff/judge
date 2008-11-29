require 'singleton'

module Judge
  class Location
    class Water
      include Singleton
      def can_occupy?(unit)
        unit.is_a?(Judge::Fleet)
      end
    
      def can_convey?
        true
      end
      def can_support?() true end
    end
  
    class Shut
      include Singleton
      def can_occupy?(unit)
        false
      end
      def can_convey?
        false
      end
      def can_support?() true end
    end
  
    class Coast
      include Singleton
      def can_occupy?(unit)
        unit.is_a?(Judge::Fleet) || unit.is_a?(Judge::Army)
      end
      def can_convey?
        false
      end
      def can_support?() true end
    end
  
    class Land
      include Singleton
      def can_occupy?(unit)
        unit.is_a? Judge::Army
      end
      def can_convey?
        false
      end
      def can_support?() true end
    end

    TYPES = {
      'WATER' => Water.instance,
      'SHUT' => Shut.instance,
      'COAST' => Coast.instance,
      'LAND' => Land.instance
    }
  end
end