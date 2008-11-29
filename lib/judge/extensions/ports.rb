module Judge
  class Location
    class Port
      include Singleton
      def can_occupy?(unit)
        unit.is_a?(Judge::Fleet) || unit.is_a?(Judge::Army)
      end
      def can_convey?
        true
      end
      def can_support?() true end
    end
    
    TYPES['PORT'] = Port.instance
  end
  Extensions << :ports
end