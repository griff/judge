require 'judge/dpjudge'

module Judge
  class DPJudgeMapReader
      attr_reader :maps_dir
      attr_accessor :current_power, :map

      Parser = [
          DPJudge::UsesLine,
          DPJudge::MapLine,
          DPJudge::PlaceLine,
          DPJudge::MapTerrainLine,
          DPJudge::DropTerrainLine,
          DPJudge::VictoryLine,
          DPJudge::PoliticalSupplyCentersLine,
          DPJudge::UnitPlacementLine,
          DPJudge::UnitsLine,
          DPJudge::OwnsLine,
          DPJudge::PowerLine,
          DPJudge::CommentLine,
          DPJudge::EmptyLine
        ]
      
      def initialize( maps_dir )
          @maps_dir = maps_dir
          @parser = Parser.map{|p| p.new(self)}
      end
      
      def read_string(name, text, output=false)
        @files = [].to_set
        @map = Map.new
        @output = output
        debug("Reading map #{name}")
        @map.visual = name
        read_file(text, name)
        debug("End read map #{name}")
        @map.finish
        @map.validate
        @map
      end
    
      def read( file, output=false )
        @files = [].to_set
        @map = Map.new
        @output = output
        debug("Reading map #{file}")
        map_read(file)
        debug("End read map #{file}")
        @map.finish
        @map.validate
        @map
      end
    
      def read_file(file, name=nil)
        unless name
          file += '.map' if File.extname( file ).empty?
          file = File.join(@maps_dir, file) if File.basename(file) == file
          name = File.basename(file, '.map')
          lines = File.open( file ) {|io| io.readlines }
        else
          lines = file.lines
        end
        raise DPJudgeLoadLoopDetectedError, "File already loaded #{name}" if @files.include?(name)
        @files.add(name)
        lines.each do |line|
          parse_line(line)
        end
      end
      
      def map_read(file)
        @map.visual = File.basename(file, File.extname(file))
        read_file(file)
      end
      
      def debug(msg)
        puts msg if @output
      end
    
      def parse_line( line )
        line = line.strip
        handler = @parser.find {|p| p.matches(line)}
        if handler
          handler.prereq(line)
          handler.matches(line)
          handler.action(line)
        else
          puts "unknown: #{line}" #if @output
        end
      end
  end
end