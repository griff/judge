module Judge
  class MovementEdge
    def good_hope
      @good_hope ||= false
    end
    attr_writer :good_hope

    def setup_with_good_hope
      self.setup_without_good_hope
      @good_hope = false
    end
    alias_method_chain :setup, :good_hope
    
    def retreat_strength_with_good_hope
      self.good_hope ? 0 : self.retreat_strength_without_good_hope
    end
    alias_method_chain :retreat_strength, :good_hope
    
    def can_support_with_good_hope?
      self.can_support_without_good_hope? && !self.good_hope
    end
    alias_method_chain :can_support?, :good_hope
  end
  Extensions << :good_hope
end