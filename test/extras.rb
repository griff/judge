$root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join($root, 'lib')

require 'test/unit'

module Enumerable
  def changed(other)
    existing1, added = self.partition{|f| other.include?(f)}
    existing2, deleted = other.partition{|f| self.include?(f)}
    [added, existing1, deleted]
  end
end

module Test::Unit::Assertions
  def assert_list_equal(expected, actual, message=nil)
    added, existing, deleted = expected.changed(actual)
    full_message = build_message(message, <<EOT, added, deleted)
expected same list 
but had additional item(s) <?> 
and missing item(s) <?>.
EOT
    assert_block(full_message) { added.size == 0 && deleted.size==0 }
  end
end

