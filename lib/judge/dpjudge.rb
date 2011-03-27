module Judge
  class DPJudgeNoCurrentPower < JudgeError
  end
  
  class DPJudgeProvinceRedefinitionError < JudgeError
  end

  class DPJudgeLoadLoopDetectedError < JudgeError
  end
  
  module DPJudge
    class ParserLine
      def initialize(reader)
        @reader = reader
      end
      
      def prereq(line)
      end
      
      def matches(line)
        if line =~ self.class::Expr
          @m1 = $1
          @m2 = $2
          @m3 = $3
          @m4 = $4
          @m5 = $5
          @m6 = $6
          @m7 = $7
          @m8 = $8
          @m9 = $9
          true
        else
          false
        end
      end
      def action(line)
      end
    end
    class CurrentPowerParserLine < ParserLine
      def prereq(line)
        raise DPJudgeNoCurrentPower, "No power is currently active" unless @reader.current_power
      end
    end
    
    class UsesLine < ParserLine
      Expr = /^USES?\s+(.*)$/i
      def action(line)
        @reader.debug("Use file '#@m1' #{line}")
        @reader.read_file(@m1)
        @reader.debug("End use file@m1'")
      end
    end
    
    class MapLine < ParserLine
      Expr = /^MAP\s+(.*)$/i
      def action(line)
        @reader.debug("Map '#@m1' #{line}")
        @reader.map_read(@m1)
        @reader.debug("End Map '#@m1'")
      end
    end
    
    class PlaceLine < ParserLine
      Expr = /^(?:([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)\s*->\s*)?([a-zA-Z0-9].*)=\s*([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)(.*)$/
      def action(line)
        old_abbrev = @m1
        place_name = @m2.strip
        abbreviation = @m3
        aliases = @m4.strip
        @reader.debug("Abr '#{old_abbrev}', '#{place_name}', '#{abbreviation}', '#{aliases}': #{line}")

        if old_abbrev
          province = @reader.map.locations.fetch_place(old_abbrev)
          raise InvalidLocationError, "Invalid old abbreviation '#{old_abbrev}'" unless province
          province.full_abbreviation = abbreviation
          province.aliases.clear
        else
          province = @reader.map.locations.fetch_or_create_place(abbreviation)
          raise DPJudgeProvinceRedefinitionError, "Province already configured" if province.name || province.ambiguous.size > 0 || province.aliases.size > 0
        end
        province.name = place_name

        aliases = aliases.split
        aliases.each do |center|
          center = center.upcase
          case center
          when /^(.*)\?$/
            province.ambiguous.add($1)
          when /^(.*)$/
            province.aliases.add($1)
          else
            raise 'Invalid alias'
          end
        end
      end
    end
    
    class MapTerrainLine < ParserLine
      Expr = /^(COAST|LAND|WATER|PORT|SHUT|AMEND)\s+([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)(?:\s+ABUTS (.*))?$/i
      def action(line)
        terrainType = @m1.upcase
        abbreviation = @m2
        abuts = @m3
        @reader.debug("Adj '#{terrainType}', '#{abbreviation}', '#{abuts}':#{line}")

        Judge.load_extension('ports') if terrainType == 'PORT'

        province = @reader.map.locations.fetch_location(abbreviation, false)
        raise InvalidLocationError, "Undefined province #{abbreviation}" unless province
        if terrainType != 'AMEND'
          province.terrain = terrainType
          province.adjacencies.clear if abuts
        end
        
        if abbreviation==abbreviation.downcase
          province.restrictions Judge::Fleet
        else
          province.restrictions
        end
        
        if abuts
          abuts = abuts.strip.split 
          abuts.each do |abut|
            if abut =~ /^(\-)?([A-Z]+\:)?([*~])?([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)(?:\(([a-zA-Z0-9\/,]+)\))?([*~])?$/
              to_name = $4
              to = @reader.map.locations.fetch_or_create_place(to_name)
              edge = Judge::MovementEdge.new(province,to)
              if $1=='-'
                raise "Invalid adjacency #{abut}" if terrainType != 'AMEND'
                province.adjacencies.delete(edge)
              else
                places = $5
                powers = $2
                special = $3 or $6
                
                if to_name == to_name.downcase
                  edge.disallowed_units Judge::Fleet
                elsif to_name == to_name.capitalize
                  edge.disallowed_units Judge::Army
                end
                
                if special=='*'
                  Judge.load_extension('good_hope')
                  edge.good_hope = true
                elsif special =='~'
                  Judge.load_extension('weak_move')
                  edge.weak = true
                end

                if places
                  Judge.load_extension('must_own')
                  places = places.split(',') 
                  if places.length > 0
                    places.map! do |l|
                      raise "Invalid constraint #{l}" unless l =~ /^[a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?$/
                      @reader.map.locations.fetch_or_create_place(l)
                    end
                    edge.must_own = places
                  end
                end
              
                if powers
                  Judge.load_extension('allowed_powers')
                  list = []
                  powers.each_char {|c| list << @reader.map.fetch_or_create_power(nil,nil,c)}
                  edge.allowed_powers = list
                end
                province.adjacencies.add(edge)
              end
            else
              raise "Invalid adjacency #{abut}"
            end
          end
        end
      end
    end
    
    class DropTerrainLine < ParserLine
      Expr = /^DROP((\s+[a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)*)$/i
      def action(line)
        abbreviations = @m1.strip
        @reader.debug("Drop: '#{abbreviations}' #{line}")

        abbreviations.split.each do |a|
          @reader.map.locations.delete(a)
        end
      end
    end

    class VictoryLine < ParserLine
      Expr = /^VICTORY\s+(\d+)$/i
      def action(line)
        count = @m1.to_i
        @reader.debug("Victory #{count}: #{line}")
        
        @reader.map.victory = count
      end
    end
    
    class PoliticalSupplyCentersLine < ParserLine
      Expr = /^(UNOWNED|NEUTRAL|CENTERS)((?:\s+-?[a-zA-Z0-9]{3})*)$/i
      def action(line)
        centers = @m2.strip
        @reader.debug("Neutral '#{centers}': #{line}")
        
        part = centers.split.partition{ |c| c.match('^-').nil? }
        part[0].each {|c| @reader.map.unowned.add(c) }
        part[1].each {|c| @reader.map.unowned.delete(c[1..-1]) }
        @reader.current_power = nil
      end
    end
    
    class UnitPlacementLine < CurrentPowerParserLine
      Expr = /^(F(?:leet)?|A(?:rmy)?)\s+(.+)$/i
      def action(line)
        unitType = @m1
        location = @m2
        
        center = @reader.map.locations[location]
        center = @reader.map.locations.fetch_or_create_place(location) unless center
        
        unit = case unitType[0..1].downcase
        when 'a'
          Judge::Army.new(@reader.current_power, center)
        when 'f'
          Judge::Fleet.new(@reader.current_power, center)
        end
        @reader.map.powers.each{|p| p.units.clear_location(center)}
        @reader.current_power.units.build(unit)
        
        @reader.debug("Unit '#{unitType}','#{location}': #{line}")
        @reader.debug("Added to power #{@reader.current_power.name}")
      end
    end
    
    class UnitsLine < CurrentPowerParserLine
      Expr = /^UNITS$/i
      def action(line)
        @reader.current_power.units.clear
      end
    end
    
    class OwnsLine < CurrentPowerParserLine
      Expr = /^OWNS((\s+[a-zA-Z0-9]{3})*)$/i
      def action(line)
        centers = @m1.strip
        @reader.debug("Owns '#{centers}': #{line}")
        
        centers = centers.split
        
        #clear list of owned supply centers
        @reader.current_power.owns.clear if centers.size == 0
        
        centers.each do |center|
          center = center.upcase
          #make supply center owned by power
          @reader.current_power.owns.add(center)
        end
      end
    end
    
    class PowerLine < ParserLine
      Expr = /^([a-zA-Z+\-.]+)(?:\s+\(([a-zA-Z+\-]+)(?::(.))?\))?((\s+[+*-]?[a-zA-Z0-9]{3})*)$/
      def action(line)
        power_name = @m1
        own_word = @m2
        abbreviation = @m3
        centers = @m4.strip
        @reader.debug("Power '#{power_name}', '#{own_word}', '#{abbreviation}', '#{centers}': #{line}")

        own_word = power_name unless own_word
        abbreviation = own_word[0...1] unless abbreviation
        
        power_name = power_name.downcase.gsub(/(^|\+)(.)/) { $2.upcase }
        own_word = own_word.downcase.gsub(/(^|\+)(.)/) { ($1=='+' ? ' ' : '') + $2.upcase }
        
        power = @reader.map.fetch_or_create_power(power_name, own_word, abbreviation)

        centers = centers.split
        centers.each do |center|
          center = center.upcase
          case center
          when /^\+([A-Z0-9]{3})$/
            #make factory
            Judge.load_extension('factories')
            power.factories.add($1)
          when /^\*([A-Z0-9]{3})$/
            #make partisan
            Judge.load_extension('partisans')
            power.partisans.add($1)
          when /^\-([A-Z0-9]{3})$/
            #remove home center
            power.delete_center($1)
          when /^([A-Z0-9]{3})$/
            #make home center
            power.homes.add($1)
          else
            throw ArgumentError, "Invalid center #{center}"
          end
        end
        
        @reader.current_power = power        
      end
    end
    
    class CommentLine < ParserLine
      Expr = /^#.*$/
      def action(line)
        @reader.debug(line)
      end
    end
    
    class EmptyLine < ParserLine
      Expr = /^$/
    end
  end
end