require 'pathname'
root  =  Pathname(__FILE__).dirname.parent.expand_path
require root.join('test/test_helper.rb')
require root.join('test/output_helper.rb')
require root.join('lib/simple_example.rb')

class String
  # name isn't so intuitive; maybe to_exact_regexp ?
  def to_regexp
    Regexp.new(Regexp.escape(self))
  end
end

class SimpleExampleTest < Test::Unit::TestCase
  include SimpleExample
  include OutputHelper

  context "SimpleExample" do
    def reset_config!
      SimpleExample::Format.instance_variable_set(:@source_prefix, nil)
      SimpleExample::Format.instance_variable_set(:@result_prefix, nil)
      SimpleExample::Format.instance_variable_set(:@separator, nil)
      SimpleExample::Format.instance_variable_set(:@compact, nil)
    end

    before do
      reset_config!

      # shortcuts
      @sp = SimpleExample::Format.source_prefix
      @rp = SimpleExample::Format.result_prefix
    end

    test "can be called from original scope" do
      Kernel.stubs(:puts)
      lambda { SimpleExample.example {} }.should_not raise_error(NoMethodError)
    end
    context "evaluation" do
      test "returns result" do
        Kernel.stubs(:puts)
        example { 1+1 }.should be(2)
      end
    end
    context "output" do
      test "prints statement's source" do
        assert_output('(1 + 1)'.to_regexp) { example { 1+1 } }
      end
      test "prints statement's result" do
        assert_output(/2/) { example { 1+1 } }
      end
      test "prints every step's source + result" do
        out = <<-STR.unindent
          #{@sp}(1 + 1)
          #{@rp}2
          #{@sp}(3 + 3)
          #{@rp}6
        STR
        assert_output(out) do
          example { 1+1; 3+3 }
        end
      end
      test "doesn't strip closing brakets" do
        Kernel.stubs(:puts)

        lambda {
          example do
            arr = %w( a b c )
            arr.each {|x| x.upcase! }
          end
        }.should_not raise_error(SyntaxError)
      end
    end
    context "formating" do
      test "prepends source lines with marker" do
        SimpleExample::Format.source_prefix = '>   '
        assert_output('>   (1 + 1)'.to_regexp) { example { 1+1 } }
      end
      test "prepends result lines with marker" do
        SimpleExample::Format.result_prefix = '#=> '
        assert_output('#=> 2'.to_regexp) { example { 1+1 } }
      end
      test "default source marker" do
        SimpleExample::Format.source_prefix.should be('')
      end
      test "default result marker" do
        SimpleExample::Format.result_prefix.should be('#=> ')
      end
      test "custom source marker" do
        SimpleExample::Format.source_prefix = '|   '
        assert_output('|   (1 + 1)'.to_regexp) { example { 1+1 } }
      end
      test "custom result marker" do
        SimpleExample::Format.result_prefix = '|=> '
        assert_output('|=> 2'.to_regexp) { example { 1+1 } }
      end
      test "seperator marker" do
        SimpleExample::Format.separator = '-'*10

        out = <<-STR.unindent
          #{@sp}(1 + 1)
          #{@rp}2
          #{@sp}(2 + 2)
          #{@rp}4
          ----------
          #{@sp}(3 + 3)
          #{@rp}6
          ----------
        STR
        assert_output(out) do
          example { 1+1; 2+2 }
          example { 3+3 }
        end
      end
      test "compact output" do
        SimpleExample::Format.compact = true

        out = <<-STR.unindent
          #{@sp}(1 + 1) #{@rp}2
          #{@sp}(3 + 3) #{@rp}6
        STR
        assert_output(out) do
          example { 1+1; 3+3 }
        end
      end
    end
  end
end
