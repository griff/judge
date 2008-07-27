module Judge
  class MapReader
      attr_reader :maps_dir
      attr_accessor :current_power
      
      def initialize( maps_dir )
          @maps_dir = maps_dir
      end
    
      def read( file, output=false )
        @map = Map.new
        @output = output
        puts "Reading map #{file}" if @output
        map(file)
        puts "End read map #{file}" if @output
        @map.validate
        @map
      end
    
      def read_file(file)
        file += '.map' if File.extname( file ).empty?
        File.open( File.join( @maps_dir, file ) ) do |io|
            io.each_line {|line| parse_line(line) }
        end
      end
      
      def map(file)
        @map.visual = File.basename(file, File.extname(file))
        read_file(file)
      end
    
      def parse_line( line )
          case line.strip
              when /^USES?\s+(.*)$/
                  puts "Use file '#$1' #{line}" if @output
                  read_file($1)
                  puts "End use file '#$1'" if @output
              when /^MAP\s+(.*)$/
                  puts "Map '#$1' #{line}" if @output
                  map($1)
                  puts "End Map '#$1'" if @output

              # Place line
              when /^(?:([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)\s*->\s*)?([a-zA-Z0-9].*)=\s*([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)(.*)$/i
                  old_abbrev = $1
                  place_name = $2.strip
                  abbreviation = $3
                  aliases = $4.strip
                  puts "Abr '#{old_abbrev}', '#{place_name}', '#{abbreviation}', '#{aliases}': #{line}" if @output

                  if old_abbrev
                    province = @map.locations.fetch_place(old_abbrev)
                    raise "Invalid old appreviation '#{old_abbrev}'" unless province
                    province.full_abbreviation = abbreviation
                    province.aliases.clear
                  else
                    province = @map.locations.fetch_or_create_place(abbreviation)
                  end

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
                  province.name = place_name
                
              # Map terrain line
              when /^(COAST|LAND|WATER|PORT|SHUT|AMEND)\s+([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)(?:\s+ABUTS (.*))?$/i
                  terrainType = $1
                  abbreviation = $2
                  abuts = $3.strip
                  puts "Adj '#{terrainType}', '#{abbreviation}', '#{abuts}':#{line}" if @output
                  # TODO

                  province = @map.locations.fetch_or_create_place(abbreviation)
                  if terrainType != 'AMEND'
                    province.type = terrainType
                    province.adjacencies.clear
                  end
                  province.abuts(abuts)
                  
                
              # Drop terrain line
              when /^DROP((\s+[a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)*)$/i
                  abbreviations = $1.strip
                  puts "Drop: '#{abbreviations}' #{line}" if @output

                  abbreviations.split.each do |a|
                    @map.locations.delete(a)
                  end
                  
            
              # Political supply centers
              when /^(UNOWNED|NEUTRAL|CENTERS)((?:\s+-?[a-zA-Z0-9]{3})*)$/i
                  centers = $2.strip
                  puts "Neutral '#{centers}': #{line}" if @output
                  
                  part = centers.split.partition{ |c| c.match('$-').nil? }
                  part[0].each {|c| @map.add_unowned(c) }
                  part[1].each {|c| @map.delete_unowned(c) }
                
              # Unit placement
              when /^(F(?:leet)?|A(?:rmy)?)\s+([a-zA-Z0-9]{3}(?:\/[a-zA-Z0-9]+)?)$/
                  unitType = $1
                  location = $2
                  
                  puts "Unit '#{unitType}','#{location}': #{line}" if @output
                  puts "Added to power #{current_power.name} " if @output
                
              # Power line
              when /^([a-zA-Z+]+)(?:\s+\(([a-zA-Z+]+)(?::(\w))?\))?((\s+[+*-]?[a-zA-Z0-9]{3})*)$/
                  power_name = $1
                  own_word = $2
                  abbreviation = $3
                  centers = $4.strip
                  puts "Power '#{power_name}', '#{own_word}', '#{abbreviation}', '#{centers}': #{line}" if @output

                  power = @map.fetch_or_create_power(power_name)
                  power.own_word = own_word if own_word
                  power.abbreviation = abbreviation if abbreviation

                  centers = centers.split
                  centers.each do |center|
                    center = center.upcase
                    case center
                    when /^\+([A-Z0-9]{3})$/
                      #make factory
                      power.add_factory( center )
                    when /^\*([A-Z0-9]{3})$/
                      #make partisan
                      power.add_partisan( center )
                    when /^\-([A-Z0-9]{3})$/
                      #remove home center
                      c = @map.locations.fetch_province($1)
                      if c
                        power.factories.delete(c)
                        power.partisans.delete(c)
                        if power.homes.delete(c)
                          #make unowned
                          @map.add_unowned(c)
                        end
                      end
                    when /^([A-Z0-9]{3})$/
                      #make home center
                      c = @map.locations.fetch_or_create_province($1)
                      if @map.suplycenter?( c )
                        #center can not be suplycenter for more than one power
                        raise "#{$1} is allready a suply center"
                      end
                      power.homes.add(c)
                      power.owns.add(c)
                    else
                      throw ArgumentError, "Invalid center #{center}"
                    end
                  end
                  
                  @current_power = power
                
              # Comment line
              when /^#.*$/
                  puts line if @output
            
              # Empty line
              when /^$/
              else
                  puts "unknown: #{line}" if @output
          end
      end
  end
end