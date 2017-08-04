require 'test_helper'

class StringTest < Minitest::Test

  def test_to_pathname
    s = "path/to/file"
    p = s.to_pathname

    assert_instance_of Pathname, p
    assert_equal s, p.to_s
  end

  def test_path
    s = "path/to/file"

    assert_equal s.to_pathname, s.path
  end

  def test_op_slash
    result = "path/to" / "subdir/file"

    assert_instance_of Pathname, result
    assert_equal "path/to/subdir/file", result.to_s
  end

  def test_op_caret
    result = "path/to/file1" ^ "file2"

    assert_instance_of Pathname, result
    assert_equal "path/to/file2", result.to_s
  end

  def test_glob
    project_dir = File.dirname(File.dirname(__FILE__))
    gemspec = project_dir + "/pleasant_path.gemspec"
    pattern = project_dir + "/*.gemspec"

    assert_equal [Pathname.new(gemspec)], pattern.glob
  end

  def test_write_to_file
    s = "the string to write"

    with_deep_path do |file|
      assert_equal s, s.write_to_file(file)
      assert_equal s, file.read
    end
  end

  def test_append_to_file
    s1 = "the string to write"
    s2 = "the string to append"

    with_deep_path do |file|
      assert_equal s1, s1.append_to_file(file)
      assert_equal s1, file.read
      assert_equal s2, s2.append_to_file(file)
      assert_equal (s1 + s2), file.read
    end
  end

end
