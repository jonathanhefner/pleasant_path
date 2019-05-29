require "test_helper"

class IOTest < Minitest::Test

  def test_write_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_tmp_file do |file|
      assert_equal lines, file.open("w"){|io| io.write_lines(lines) }
      assert_equal text, file.read
    end
  end

  def test_read_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_tmp_file do |file|
      file.write(text)

      assert_equal lines, file.open("r"){|io| io.read_lines }
    end
  end

end
