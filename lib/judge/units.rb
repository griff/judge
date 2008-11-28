module Judge
  class Unit
    attr_reader :owner
    attr_reader :current_location
    attr_reader :next_location
    
    def initialize( owner, location )
      @owner = owner
      @current_location = location
      @next_location = nil
    end
  end
  
  class Army
  end
  
  class Fleet
  end
end