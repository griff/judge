module Judge
  class Game
    class PowerList
      include Enumerable
      
      def initialize(map)
        @list = [].to_set
        map.powers.each{|p| @list.add(p.dup) }
      end
      
      def each(&block)
        @list.each(&block)
      end
      
      def [](name)
        name = name.upcase
        @list.find{|p| p.name.upcase == name}
      end
    end
    
    class UnitList
      include Enumerable
      
      def initialize(game)
        @game = game
      end
      
      def each(&block)
        @game.powers.each {|p| p.units.each(&block) }
      end
      
      def clear
        @game.powers.each {|p| p.units.clear}
        self
      end
    end
    
    attr_reader :map, :powers
    
    def initialize(map)
      @map = map
      @units = UnitList.new(self)
      @powers = PowerList.new(map)
    end
    
    def units(power = nil)
      if power
        powers[power].units
      else
        @units
      end
    end
    
    def orders(power = nil)
      
    end
  end
end