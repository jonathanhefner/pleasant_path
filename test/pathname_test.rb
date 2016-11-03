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

  def test_dir_empty?
    Dir.mktmpdir do |tmp|
      tmp = Pathname.new(tmp)
      assert tmp.dir_empty?
      (tmp / 'child').mkpath
      refute tmp.dir_empty?
    end
  end

  def test_dirs
    Dir.mktmpdir do |tmp|
      tmp = Pathname.new(tmp)
      d1 = (tmp / 'dir1/dir1').tap(&:mkpath)
      d2 = (tmp / 'dir2/dir2').tap(&:mkpath)
      FileUtils.touch(tmp / 'file')

      assert_same_elements [d1.dirname, d2.dirname], tmp.dirs
    end
  end

  def test_dirs_r
    Dir.mktmpdir do |tmp|
      tmp = Pathname.new(tmp)
      d1 = (tmp / 'dir1/dir1').tap(&:mkpath)
      d2 = (tmp / 'dir2/dir2').tap(&:mkpath)
      FileUtils.touch(tmp / 'file')

      assert_same_elements [d1, d1.dirname, d2, d2.dirname], tmp.dirs_r
    end
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

  def test_append_text
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      text1 = "line 1\nline 2\n"
      text2 = "line 3\nline 4\n"

      assert_equal file, file.append_text(text1)
      assert_equal text1, file.read()
      assert_equal file, file.append_text(text2)
      assert_equal (text1 + text2), file.read()
    end
  end

  def test_write_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      assert_equal file, file.write_lines(lines)
      assert_equal text, file.read()
    end
  end

  def test_append_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'path/to/file'
      text1 = "line 1\nline 2\n"
      text2 = "line 3\nline 4\n"
      lines1 = text1.split("\n")
      lines2 = text2.split("\n")

      assert_equal file, file.append_lines(lines1)
      assert_equal text1, file.read()
      assert_equal file, file.append_lines(lines2)
      assert_equal (text1 + text2), file.read()
    end
  end

  def test_read_text
    file = Pathname.new(__FILE__)
    assert_equal file.read, file.read_text
  end

  def test_read_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      file.write(text)
      assert_equal lines, file.read_lines
    end
  end

  def test_edit_text
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"

      file.write(text)
      assert_equal text.reverse, file.edit_text(&:reverse)
      assert_equal text.reverse, file.read
    end
  end

  def test_edit_lines
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"
      lines = text.split("\n")

      file.write(text)
      assert_equal lines.reverse, file.edit_lines(&:reverse)
      assert_equal lines.reverse, file.read.split("\n")
    end
  end

  def test_append_file
    Dir.mktmpdir do |tmp|
      tmp = Pathname.new(tmp)
      text1 = "line 1\nline 2\n"
      file1 = (tmp / 'file1').tap{|f| f.write(text1) }
      text2 = "line 3\nline 4\n"
      file2 = (tmp / 'file2').tap{|f| f.write(text2) }

      assert_equal file1, file1.append_file(file2)
      assert_equal (text1 + text2), file1.read()
    end
  end

end
