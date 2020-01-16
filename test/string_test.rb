require "test_helper"

class StringTest < Minitest::Test

  def test_to_pathname
    str = "path/to/file"

    assert_equal Pathname.new(str), str.to_pathname
  end

  def test_path_aliases_to_pathname
    assert_equal :to_pathname, "".method(:path).original_name
  end

  def test_op_slash
    str1 = "path/to"
    str2 = "subdir/file"

    assert_equal (Pathname.new(str1) / str2), (str1 / str2)
  end

  def test_glob
    pattern = "#{__dir__}/../*.gemspec"
    expected = Pathname.glob(pattern)

    refute_empty expected # sanity check
    assert_equal expected, pattern.glob
  end

  def test_write_to_file
    str = "the string to write"

    with_tmp_file(false) do |file|
      assert_equal str, str.write_to_file(file)
      assert_equal str, file.read
    end
  end

  def test_append_to_file
    str1 = "the string to write"
    str2 = "the string to append"

    with_tmp_file(false) do |file|
      assert_equal str1, str1.append_to_file(file)
      assert_equal str1, file.read
      assert_equal str2, str2.append_to_file(file)
      assert_equal (str1 + str2), file.read
    end
  end

end
