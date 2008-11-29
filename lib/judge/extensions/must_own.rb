module Judge
  class MovementEdge
    def must_own
      @must_own ||= []
    end
    attr_writer :must_own

    def setup_with_must_own
      self.setup_without_must_own
      @must_own = []
    end
    alias_method_chain :setup, :must_own

    def passable_with_must_own?(unit)
      passable_without_must_own?(unit) &&
      self.must_own.all? do |l|
        unit.owner.owns.include?(l)
      end
    end
    alias_method_chain :passable?, :must_own
  end
  Extensions << :must_own
end