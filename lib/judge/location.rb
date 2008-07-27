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
    end
    
    def supply_center=(new_value)
      @supply_center = new_value
    end
    
    def supply_center?
      @supply_center
    end
    
    def type=(new_value)
      new_value = TYPES[new_value.upcase] unless new_value.respond_to? :can_occupy?
      @type = new_value
    end
    
    def can_occupy?
      type.can_occupy?
    end
    
    def name=(new_value)
      @name = new_value
    end
    
    def hash
      full_abbreviation.hash
    end
    
    def eql?(other)
      other.kind_of?(Location) && self.full_abbreviation.eql?(other.full_abbreviation)
    end

    def ==(other)
      other.kind_of?(Location) && self.full_abbreviation == other.full_abbreviation
    end

    def clear_aliases
      @aliases.clear
      @ambiguous.clear
    end
    
    def delete
      clear_aliases
    end
    
    def validate
      raise "No name provided" unless @name
      raise "No type provided" unless @type
    end
    
    def abuts( abuts )
      abuts = abuts.split if abuts.kind_of? String
      abuts = abuts.to_a if abuts.respond_to? :to_a
      abuts.each do |abut|
        case abut
        when /^\-([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)$/
          adjacencies.delete($1)
        when /^[A-Z0-9]{3}(?:\/[A-Z0-9]+)?$/
          adjacencies.add($1)
        when /^[a-z0-9]{3}(?:\/[a-z0-9]+)?$/
          adjacencies.add($1)  # 
        else
          raise "Invalid adjacency #{abut}"
        end
      end
    end
  end  
end
# vim: sts=4:sw=4:ts=4:et