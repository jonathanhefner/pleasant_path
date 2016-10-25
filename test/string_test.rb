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

end
