require 'pathname'
require 'rubygems'
require 'ruby2ruby'
require 'parse_tree'
require 'parse_tree_extensions'

module SimpleExample
  extend self

  class Format
    class << self
      attr_accessor :source_prefix
      attr_accessor :result_prefix
      attr_accessor :separator
      attr_accessor :compact

      def source_prefix
        @source_prefix || ''
      end

      def result_prefix
        @result_prefix || '#=> '
      end

      def separator
        @separator || ''
      end

      def compact?
        !!@compact
      end
    end
  end

  def example(&block)
    result = block.call

    statement = block.to_ruby
    statement.gsub!(/\Aproc \{/,'')
    statement.gsub!(/\}\Z/,'')

    lines = statement.strip.split(/\n/)
    lines.each do |line|
      src_str = Format.source_prefix + line.strip
      res_str = Format.result_prefix + eval(line.strip, block.binding, Pathname(__FILE__).basename, __LINE__).inspect
      sep_str = Format.compact? ? " " : "\n"

      Kernel.puts "#{src_str}#{sep_str}#{res_str}"
    end
    Kernel.puts Format.separator unless Format.separator.empty?

    result
  end
end
