require 'test_helper'

class ArrayTest < Minitest::Test

  def test_write_to_file
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      assert_equal lines, lines.write_to_file(file)
      assert_equal text, file.read()
    end
  end

end
