module Judge
  class MovementEdge
    attr_reader :from, :to
    
    def initialize( from, to )
      @from = from
      @to = to
      self.setup
    end
    
    def setup
      @disallowed_units = []
    end
    
    def disallowed_units(*args)
      @disallowed_units = args.flatten
    end
    
    def passable?(unit)
      to.type.can_occupy?(unit) && @disallowed_units.all?{|u| !unit.is_a?(u)}
    end
    
    def strength
      1
    end
    
    def retreat_strength
      1
    end
    
    def can_support?
      true
    end
    
    def eql?(other)
      other.kind_of?(MovementEdge) && self.to.eql?(other.to) && self.from.eql?(other.from)
    end
  end
end
