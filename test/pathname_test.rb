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

  def test_touch_file
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      refute file.file?
      assert_equal file, file.touch_file
      assert file.file?
    end
  end

  def test_delete!
    Dir.mktmpdir do |tmp|
      path = Pathname.new(tmp) / 'path/to/dir'

      assert_equal path, path.delete! # doesn't exist, but nothing raised

      path.mkpath
      path.delete!
      refute path.exist?
      assert path.dirname.exist?

      path.mkpath
      path.dirname.delete!
      refute path.dirname.exist?
    end
  end

  def test_move
    Dir.mktmpdir do |tmp|
      src = Pathname.new(tmp) / 'src/path/x'
      src.mkpath
      dest = Pathname.new(tmp) / 'dest/path/y'

      refute dest.exist?
      assert_equal dest, src.move(dest)
      assert dest.exist?
      refute src.exist?
    end
  end

  def test_move_into
    Dir.mktmpdir do |tmp|
      src = Pathname.new(tmp) / 'src/path/x'
      src.mkpath
      dest = Pathname.new(tmp) / 'dest/path/x'

      refute dest.exist?
      assert_equal dest, src.move_into(dest.dirname)
      assert dest.exist?
      refute src.exist?
    end
  end

  def test_write_text
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      text = "line 1\nline 2\n"

      assert_equal file, file.write_text(text)
      assert_equal text, file.read()
    end
  end

end
