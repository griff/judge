# $Id: Rakefile 227 2008-09-04 20:25:27Z phw $
# Copyright (c) 2008, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.
 
# Rakefile for Judge

require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

PKG_EXTRA_RDOC_FILES = ['doc/README.rdoc', 'LICENSE', 'TODO', 'CHANGES']

task :default do
  puts "Please see 'rake --tasks' for an overview of the available tasks."
end

desc "Do predistribution stuff"
task :predist => [:changelog, :rdoc]

desc "Make an archive as .tar.gz"
task :dist => [:test, :predist] do
  sh "git archive --format=tar --prefix=#{release}/ HEAD^{tree} >#{release}.tar"
  sh "pax -waf #{release}.tar -s ':^:#{release}/:' RDOX SPEC ChangeLog doc"
  sh "gzip -f -9 #{release}.tar"
end

# Helper to retrieve the "revision number" of the git tree.
def git_tree_version
  if File.directory?(".git")
    @tree_version ||= `git describe`.strip.sub('-', '.')
    if $? != 0
      $: << "lib"
      require 'judge/version'
      @tree_version = Judge::VERSION
    else
      @tree_version << ".0"  unless @tree_version.count('.') == 2
    end
  else
    $: << "lib"
    require 'judge/version'
    @tree_version = Judge::VERSION
  end
  @tree_version
end

def gem_version
  git_tree_version.gsub(/-.*/, '')
end

def release
  "judge-#{git_tree_version}"
end

def manifest
  `git ls-files`.split("\n")
end

desc "Generate a ChangeLog"
task :changelog do
  File.open("ChangeLog", "w") { |out|
    `git log -z`.split("\0").map { |chunk|
      author = chunk[/Author: (.*)/, 1].strip
      date = chunk[/Date: (.*)/, 1].strip
      desc, detail = $'.strip.split("\n", 2)
      detail ||= ""
      detail = detail.gsub(/.*darcs-hash:.*/, '')
      detail.rstrip!
      out.puts "#{date}  #{author}"
      out.puts "  * #{desc.strip}"
      out.puts detail  unless detail.empty?
      out.puts
    }
  }
end

spec = Gem::Specification.new do |s|
  s.name            = "judge"
  s.version         = gem_version
  s.platform        = Gem::Platform::RUBY
  s.summary         = "a modular Ruby webserver interface"

  s.description = <<-EOF
Rack provides minimal, modular and adaptable interface for developing
web applications in Ruby.  By wrapping HTTP requests and responses in
the simplest way possible, it unifies and distills the API for web
servers, web frameworks, and software in between (the so-called
middleware) into a single method call.

Also see http://judge.rubyforge.org.
  EOF

  s.files           = manifest
  s.bindir          = 'bin'
  s.executables     << 'read'
  s.require_path    = 'lib'
  s.has_rdoc        = true
  s.extra_rdoc_files = ['README', 'KNOWN-ISSUES']
  s.test_files      = Dir['test/{test,spec}_*.rb']

  s.author          = 'Brian Olsen'
  s.email           = 'brian@maven-group.org'
  s.homepage        = 'http://judge.rubyforge.org'
  s.rubyforge_project = 'judge'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = false
end

desc "Run just the unit tests"
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList['test/test*.rb', 'test/datc/test*.rb']
  test.libs = ['lib', 'test/lib']
  test.warning = true
end

# Documentation tasks: ---------------------------------------------------

Rake::RDocTask.new do |rdoc|
  rdoc.title    = "Judge %s" % gem_version
  rdoc.main     = 'doc/README.rdoc'
  rdoc.rdoc_dir = 'doc/api'
  rdoc.rdoc_files.include('lib/**/*.rb', PKG_EXTRA_RDOC_FILES)
  rdoc.options << '--inline-source' << '--line-numbers' \
               << '--charset=UTF-8' #<< '--diagram'
end
