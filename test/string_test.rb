require 'test_helper'

class StringTest < Minitest::Test

  def test_to_pathname
    s = 'path/to/file'
    p = s.to_pathname

    assert_instance_of Pathname, p
    assert_equal s, p.to_s
  end

  def test_path
    s = 'path/to/file'

    assert_equal s.to_pathname, s.path
  end

  def test_op_slash
    result = 'path/to' / 'subdir/file'

    assert_instance_of Pathname, result
    assert_equal 'path/to/subdir/file', result.to_s
  end

  def test_op_caret
    result = 'path/to/file1' ^ 'file2'

    assert_instance_of Pathname, result
    assert_equal 'path/to/file2', result.to_s
  end

end
