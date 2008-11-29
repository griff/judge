module Judge
  class Order
    attr_reader :unit
    def initialize(unit)
      @unit = unit
    end
  end
  class MovementOrder < Order
    attr_reader :destination
    
    def initialize(unit,destination)
      super(unit)
      @destination = destination
    end
  end
  class AttackOrder < MovementOrder
  end
  class RetreatOrder < MovementOrder
  end
  class DisbandOrder < Order
  end
  class BuildOrder < Order
  end
  class HoldOrder < Order
  end
  class ConveyOrder < Order
  end
  class SupportOrder < Order
    attr_reader :order
    def initialize(unit,order)
      super(unit)
      @order = order
    end
  end
end