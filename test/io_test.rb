require 'test_helper'

class IOTest < Minitest::Test

  def test_write_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      assert_equal lines, file.open('w'){|f| f.write_lines(lines) }
      assert_equal text, file.read()
    end
  end

  def test_read_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      file.write(text)
      assert_equal lines, file.open('r'){|f| f.read_lines }
    end
  end

end
