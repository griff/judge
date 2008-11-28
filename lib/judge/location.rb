module Judge
  class Location
    def Location.abbreviation_and_coast( abbreviation, coast = nil )
      if abbreviation =~ /^([a-zA-Z0-9]{3})(?:\/([a-zA-Z0-9]+))?/
        abbreviation = $1
        coast = $2
      end
      [abbreviation, coast]
    end

    attr_reader :abbreviation
    attr_reader :name
    attr_reader :type
    attr_reader :aliases
    attr_reader :ambiguous
    attr_reader :adjacencies

    def initialize( container, abbreviation, name=nil )
      @container = container
      @abbreviation = abbreviation.upcase
      @name = name
      @ambiguous = StringList.new
      @aliases = StringList.new
      @adjacencies = [].to_set
      @suply_center = false
      @restrictions = []
    end
    
    def supply_center=(new_value)
      @supply_center = new_value
    end
    
    def supply_center?
      @supply_center
    end
    
    def restrictions(*args)
      @restrictions = args.flatten
    end
    
    def type=(new_value)
      new_value = TYPES[new_value.to_s.upcase] unless new_value.respond_to? :can_occupy?
      raise ArgumentError, "Invalid type" unless new_value
      @type = new_value
    end
    
    def can_occupy?(unit)
      type.can_occupy?(unit) && @restrictions.all? {|r| unit.is_a? r}
    end
    
    def name=(new_value)
      raise ArgumentError, "Invalid name" unless new_value && !new_value.empty?
      @name = new_value
    end
    
    def hash
      full_abbreviation.hash
    end
    
    def eql?(other)
      other.kind_of?(Location) && self.full_abbreviation.eql?(other.full_abbreviation)
    end

    def ==(other)
      self.to_s == other.to_s
    end

    def clear_aliases
      @aliases.clear
      @ambiguous.clear
    end
    
    def delete
      clear_aliases
    end
    
    def delete_adjacency(place)
      @adjacencies.delete_if{|edge| edge.to == place}
    end
    
    def validate
      raise "No name provided for #{self.full_abbreviation}" unless @name
      raise "No type provided for #{self.full_abbreviation}" unless @type
    end
    
    def to_s
      self.full_abbreviation
    end
  end  
end
# vim: sts=4:sw=4:ts=4:et