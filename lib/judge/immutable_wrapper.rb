module Judge
  class ImmutableWrapper
    include Enumerable
    
    def initialize(arr)
      @arr = arr
    end
    def each(&block)
      @arr.each(&block)
    end
  end
end