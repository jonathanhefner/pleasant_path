require "test_helper"

class IOTest < Minitest::Test

  def test_write_lines
    lines = ["line 1", "line 2"]

    with_tmp_file do |file|
      with_various_eol(lines) do |text, options|
        assert_equal lines, file.open("w"){|io| io.write_lines(lines, **options) }
        assert_equal text, file.read
      end
    end
  end

  def test_read_lines
    lines = ["line 1", "line 2"]

    with_tmp_file do |file|
      with_various_eol(lines) do |text, options|
        file.write(text)

        assert_equal lines, file.open("r"){|io| io.read_lines(**options) }
      end
    end
  end

end
