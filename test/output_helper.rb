module OutputHelper

  def assert_output(expected, &block)
    keep_stdout do |stdout|
      block.call
      if expected.is_a?(Regexp)
        assert_match expected, stdout.string
      else
        stdout.string.should be(expected.to_s)
      end
    end
  end

  def keep_stdout(&block)
    begin
      orig_stream, $stdout = $stdout, StringIO.new
      block.call($stdout)
    ensure
      s, $stdout = $stdout.string, orig_stream
      s
    end
  end

end
