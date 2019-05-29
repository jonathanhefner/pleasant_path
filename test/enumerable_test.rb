require "test_helper"

class EnumerableTest < Minitest::Test

  def test_write_to_file
    lines = ["line 1", "line 2"]

    with_various_eol(lines) do |text, options|
      with_tmp_file(false) do |file|
        assert_equal lines, lines.write_to_file(file, **options)
        assert_equal text, file.read
      end
    end
  end

  def test_append_to_file
    lines = ["line 1", "line 2"]

    with_various_eol(lines) do |text, options|
      with_tmp_file(false) do |file|
        assert_equal lines, lines.append_to_file(file, **options)
        assert_equal text, file.read
        assert_equal lines, lines.append_to_file(file, **options)
        assert_equal (text + text), file.read
      end
    end
  end

end
