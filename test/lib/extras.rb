$root = File.join(File.dirname(__FILE__), '..', '..')
#$:.unshift File.join($root, 'lib')

require 'test/unit'

class NilClass
  def to_set
    [].to_set
  end
end

module Enumerable
  def changed(other)
    existing1, added = self.partition{|f| other.include?(f)}
    existing2, deleted = other.partition{|f| self.include?(f)}
    [added, existing1, deleted]
  end
end

module Test::Unit::Assertions
  def assert_set_equal(expected, actual, message=nil)
    added, existing, deleted = expected.to_set.changed(actual.to_set)
    full_message = build_message(message, <<EOT, deleted, added)
expected same set 
but had additional item(s) <?> 
and missing item(s) <?>.
EOT
    full_message_a = build_message(message, <<EOT, added)
expected same set 
but had missing item(s) <?>.
EOT
    full_message_d = build_message(message, <<EOT, deleted)
expected same list 
but had additional item(s) <?>.
EOT
    if added.size == 0
      assert_block(full_message_d) { deleted.size==0 }
    elsif deleted.size==0
      assert_block(full_message_a) { added.size==0 }
    else
      assert_block(full_message) { added.size==0 && deleted.size==0 }
    end
  end
end

