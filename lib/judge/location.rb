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

    def initialize( container, abbreviation, name=nil )
      @container = container
      @abbreviation = abbreviation.upcase
      @name = name
      @ambiguous = [].to_set
      @aliases = [].to_set
      @adjacencies = [].to_set
    end
    
    def type=(new_value)
      @type = new_value
    end
    
    def name=(new_value)
      @container.delete_name(@name) if @name
      @name = new_value
      @container.add_name(new_value, self)
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

    def add_alias( short )
      short = short.gsub(/\+/, ' ')
      @aliases.add(short)
      @container.add_alias(short, self)
    end

    def add_ambiguous( ambi )
      short = short.gsub(/\+/, ' ')
      @ambiguous << ambi
      @container.add_ambiguous(short, self)
    end
    
    def add_adjacency(other)
      @adjacencies.add(other)
    end
    
    def delete_adjacency(other)
      @adjacencies.delete(other)
    end

    def clear_aliases
      @aliases.each{|e| @container.remove_alias(e)}
      @ambiguous.each{|e| @container.remove_ambiguous(e)}
      @aliases.clear
      @ambiguous.clear
    end
    
    def delete
      clear_aliases
    end

    def <<( aliases )
      aliases = aliases.split if aliases.kind_of? String
      aliases = aliases.to_a if aliases.respond_to? :to_a
      aliases.each do |center|
        center = center.upcase
        case center
        when /^(.*)\?$/
          add_ambiguous($1)
        when /^(.*)$/
          add_alias($1)
        else
          raise 'Invalid alias'
        end
      end
    end
    
    def abuts( abuts )
      abuts = abuts.split if abuts.kind_of? String
      abuts = abuts.to_a if abuts.respond_to? :to_a
=begin commend
  
      abuts.each do |abut|
        case center
        when /^(.*)\?$/
          add_ambiguous($1)
        when /^(.*)$/
          add_alias($1)
        else
          raise 'Invalid alias'
        end
      end
=end
    end
  end  
end
# vim: sts=4:sw=4:ts=4:et