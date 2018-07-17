require 'test_helper'

class ArrayTest < Minitest::Test

  def test_write_to_file
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_deep_path do |file|
      assert_equal lines, lines.write_to_file(file)
      assert_equal text, file.read
    end
  end

  def test_append_to_file
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"
    lines1 = text1.split("\n")
    lines2 = text2.split("\n")

    with_deep_path do |file|
      assert_equal lines1, lines1.append_to_file(file)
      assert_equal text1, file.read
      assert_equal lines2, lines2.append_to_file(file)
      assert_equal (text1 + text2), file.read
    end
  end

end
