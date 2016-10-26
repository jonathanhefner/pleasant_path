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

  def test_dir?
    file = Pathname.new(__FILE__)

    refute file.dir?
    assert file.dirname.dir?
  end

  def test_make_dir
    Dir.mktmpdir do |tmp|
      dir = Pathname.new(tmp) / 'path/to/dir'
      refute dir.directory?
      assert_equal dir, dir.make_dir
      assert dir.directory?
    end
  end

  def test_make_dirname
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      assert_equal file, file.make_dirname
      assert file.dirname.directory?
      refute file.exist?
    end
  end

end
