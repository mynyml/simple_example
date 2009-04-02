require 'test/unit'
require 'rubygems'
require 'context'
require 'matchy'
require 'unindent'
require 'mocha'
begin
  require 'ruby-debug'
  require 'quietbacktrace'
rescue LoadError, RuntimeError
end

class Test::Unit::TestCase
end
