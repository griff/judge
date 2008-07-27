module Judge
  class MovementEdge
    attr_reader :from, :to
    
    def initialize( from, to )
      @from = from
      @to = to
      @disallowed_units = [Fleet]
      @allowed_powers = [:Austria]
      @must_own = []
      @weak = false
      @good_hope = false
    end
    
    def passable?(unit)
      to.type.can_occupy?(unit) && @disallowed_units.all?{|u| !unit.is_a? u} &&
      @allowed_powers.include?(unit.owner) && @must_own.all?{|a| a == unit.owner}
    end
    
    def strength
      @weak ? 0 : 1
    end
    
    def retreat_strenght
      @good_hope ? 0 : 1
    end
    
    def can_support?
      !@weak && !@good_hope
    end
  end
end
