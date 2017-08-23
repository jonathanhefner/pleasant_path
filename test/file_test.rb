require 'test_helper'

class PleasantPath::FileTest < Minitest::Test

  def test_edit_text
    text = "line 1\nline 2\n"

    with_temp_file(text) do |file|
      assert_equal text.reverse, File.edit_text(file, &:reverse)
      assert_equal text.reverse, file.read
    end
  end

  def test_edit_text_with_truncation
    text = "  abcdef  "

    with_temp_file(text) do |file|
      assert_equal text.strip, File.edit_text(file, &:strip)
      assert_equal text.strip, file.read
    end
  end

  def test_edit_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_temp_file(text) do |file|
      assert_equal lines.reverse, File.edit_lines(file, &:reverse)
      assert_equal lines.reverse, file.read.split("\n")
    end
  end

  def test_edit_lines_with_truncation
    text = "AAA\nBBB\nBBB\nCCC\nAAA\n"
    lines = text.split("\n")

    with_temp_file(text) do |file|
      assert_equal lines.uniq, File.edit_lines(file, &:uniq)
      assert_equal lines.uniq, file.read.split("\n")
    end
  end

end
