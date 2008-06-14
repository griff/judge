#!/usr/bin/env ruby
$root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join($root, 'lib')

require 'judge'

reader = Judge::MapReader.new(File.join($root, 'test-data', 'dpmap'))
reader.read(ARGV[0], true)
