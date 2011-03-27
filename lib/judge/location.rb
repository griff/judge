module Judge
  class Location
    def Location.abbreviation_and_coast( abbreviation, coast = nil )
      if abbreviation =~ /^([a-zA-Z0-9]{3})(?:\/([a-zA-Z0-9]+))?/
        abbreviation = $1
        coast = $2
      else
        raise "Invalid location name #{abbreviation}"
      end
      [abbreviation, coast]
    end

    attr_reader :abbreviation, :name, :terrain
    attr_reader :aliases, :ambiguous, :adjacencies, :map
    

    def initialize( map, abbreviation, name=nil )
      @map = map
      @abbreviation = abbreviation.upcase
      @name = name
      @ambiguous = StringList.new
      @aliases = StringList.new
      @adjacencies = [].to_set
      @restrictions = []
      @terrain = nil
    end
    
    def supply_center?
      @container.supply_centers.include?(self)
    end
    
    def restrictions(*args)
      @restrictions = args.flatten
    end
    
    def terrain=(new_value)
      new_value = TERRAINS[new_value.to_s.upcase] unless new_value.respond_to? :can_occupy?
      raise ArgumentError, "Invalid terrain" unless new_value
      @terrain = new_value
    end
    
    def can_occupy?(unit)
      terrain.can_occupy?(unit) && @restrictions.all? {|r| !unit.is_a?(r)}
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
    
    def delete_adjacency(place)
      @adjacencies.delete_if{|edge| edge.to == place}
    end
    
    def validate
      raise InvalidLocationError, "No name provided for #{self.full_abbreviation}" unless @name
      raise InvalidLocationError, "No terrain provided for #{self.full_abbreviation}" unless @terrain
    end
    
    def to_s
      self.full_abbreviation
    end

    def pretty_print(q)
      q.text(self.name)
    end

    def _delete
      clear_aliases
    end
    
    def _replace(old_loc,new_loc)
      @adjacencies.each do |edge|
        edge.to = new_loc if edge.to == old_loc
      end
    end
  end  
end
# vim: sts=4:sw=4:ts=4:et