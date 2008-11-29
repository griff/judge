module Judge
  class Unit
    attr_reader :owner,:location
    
    def initialize( owner, location )
      @owner = owner
      @location = location
      @dislodged = false
    end
    
    def dislodged?
      @dislodged
    end
    
    def dislodge
      @dislodged = true
    end
    
    def moved(location)
      self.class.new(self.owner,location)
    end
    
    def name
      self.class.name.gsub(/.*::(\w+)$/) {$1.downcase}
    end
    
    def hash
      self.class.hash + self.owner.hash + self.location.hash
    end
    
    def eql?(other)
      other.kind_of?(self.class) && self.owner.eql?(other.owner) && self.location.eql?(other.location)
    end
    
    def to_s
      self.owner.own_word + " " + self.name + " in " + self.location.name
    end
    
    def pretty_print(q)
      q.text(self.to_s)
    end
  end
  
  class Army < Unit
  end
  
  class Fleet < Unit
  end
end