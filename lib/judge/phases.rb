module Judge
  class MovementPhase
    def allowed_orders
      [Judge::AttackOrder, Judge::HoldOrder, Judge::SupportOrder, Judge::ConveyOrder].to_set
    end
  end
  class RetreatPhase
    def allowed_orders
      [Judge::RetreatOrder,Judge::DisbandOrder].to_set
    end
  end
  class AdjustmentPhase
    def allowed_orders
      [Judge::BuildOrder,Judge::DisbandOrder].to_set
    end
  end
end