require 'test_helper'

class PathnameTest < Minitest::Test

  def test_to_pathname
    p = Pathname.new('path/to/file')
    assert_same p, p.to_pathname
  end

  def test_op_caret
    p1 = Pathname.new('path/to/file1')
    p2 = Pathname.new('path/to/file2')

    assert_equal p2, (p1 ^ 'file2')
  end

end
