module Judge
  class MovementEdge
    def weak
      @weak ||= false
    end
    attr_writer :weak

    def setup_with_weak_move
      self.setup_without_weak_move
      @weak = false
    end
    alias_method_chain :setup, :weak_move
    
    def strength_with_weak_move
      self.weak ? 0 : self.strength_without_weak_move
    end
    alias_method_chain :strength, :weak_move
    
    def can_support_with_weak_move?
      self.can_support_without_weak_move? && !self.weak
    end
    alias_method_chain :can_support?, :weak_move
  end
  Extensions << :weak_move
end