module Judge
  class MovementEdge
    def allowed_powers
      @allowed_powers ||= []
    end
    attr_writer :allowed_powers

    def setup_with_allowed_powers
      self.setup_without_allowed_powers
      @allowed_powers = []
    end
    alias_method_chain :setup, :allowed_powers

    def passable_with_allowed_powers?(unit)
      passable_without_allowed_powers?(unit) &&
      self.allowed_powers.include?(unit.owner)
    end
    alias_method_chain :passable?, :allowed_powers
  end
  Extensions << :allowed_powers
end