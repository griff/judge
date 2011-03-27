require 'extras'
require 'judge'
require 'judge/dpjudge_map_reader'

class TestDPJudgeMapErrors < Test::Unit::TestCase
  def self.const_missing(const)
    ::Judge::const_get(const)
  end
  
  def setup
    @reader = Judge::DPJudgeMapReader.new(File.join($root, 'test-data', 'dpfailmap'))
  end
  
  def self.error_map(name, error, text)
    self.class_eval <<_END_, __FILE__, __LINE__+1
      def test_#{name}
        @reader.read_string("#{name}", #{text.inspect})
      rescue #{error}
      else
        fail("test #{name} should fail with error #{error}")
      end
_END_
  end
  
  def self.error_map_file(name, error)
    self.class_eval <<_END_, __FILE__, __LINE__+1
      def test_#{name}
        @reader.read("#{name}")
      rescue #{error}
      else
        fail("test #{name} should fail with error #{error}")
      end
_END_
  end
      

  module_eval(IO.read(File.join($root, 'test-data', 'dpjudge_error_maps.rb')))

end