module Judge
  class Location
    class StringList
      include Enumerable
    
      def initialize(arr=[])
        @items = arr
      end
      
      def size
        @items.size
      end
    
      def add(item)
        item = item.gsub(/\+/, ' ')
        @items.push(item)
        self
      end
    
      def delete(item)
        item = item.gsub(/\+/, ' ')
        @items.delete(item)
      end
  
      def clear
        @items.clear
        self
      end
  
      def each(&block)
        @items.each(&block)
      end
      
      def flatten
        @items.flatten
      end
      
      def method_missing(m, *args)
        puts m
        puts args
        super
      end
    end
  end
end