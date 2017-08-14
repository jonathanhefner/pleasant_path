require 'test_helper'

class PathnameTest < Minitest::Test

  def test_null_constant
    assert_equal File::NULL, Pathname::NULL.to_s
  end

  def test_to_pathname
    p = Pathname.new("path/to/file")
    assert_same p, p.to_pathname
  end

  def test_op_caret
    p1 = Pathname.new("path/to/file1")
    p2 = Pathname.new("path/to/file2")

    assert_equal p2, (p1 ^ "file2")
  end

  def test_parentname
    p = Pathname.new("path/to/file")
    assert_equal p.dirname.basename, p.parentname
  end

  def test_common_path
    [
      ["dir1/file1", "dir1/subdir1/file2"],
      ["dir1/subdir1/file2", "dir1/subdir1/file3"],
      ["dir1/subdir1/file3", "dir2/file4"],
    ].each do |paths|
      result = paths.map{|p| Pathname.new(p) }.reduce(&:common_path)

      assert_instance_of Pathname, result

      assert paths.all?{|p| p.start_with?(result.to_s) }

      refute paths.all?{|p| p[result.to_s.length] == "/" }

      depth = result.to_s.split("/").length
      alternatives = paths.map{|p| p.split("/").take(depth + 1).join("/") } - [result.to_s]

      refute alternatives.any?{|a| paths.all?{|p| p.start_with?(a) } }
    end
  end

  def test_dir?
    file = Pathname.new(__FILE__)

    refute file.dir?
    assert file.dirname.dir?
  end

  def test_dir_empty?
    with_deep_path(:dir) do |path|
      assert path.dir_empty?
      refute path.dirname.dir_empty?
    end
  end

  def test_dirs
    with_deep_path do |path|
      dirs = make_dirs(path, "d1", "d2")
      make_files(path, "f1", "d2/d3/f2")

      assert_equal dirs.sort, path.dirs.sort
    end
  end

  def test_dirs_r
    with_deep_path do |path|
      dirs = make_dirs(path, "d1", "d2", "d2/d3")
      make_files(path, "f1", "d2/d3/f2")

      assert_equal dirs.sort, path.dirs_r.sort
    end
  end

  def test_files
    with_deep_path do |path|
      files = make_files(path, "f1", "f2")
      make_files(path, "d1/f3")

      assert_equal files.sort, path.files.sort
    end
  end

  def test_files_r
    with_deep_path do |path|
      files = make_files(path, "f1", "f2", "d1/d2/f3")

      assert_equal files.sort, path.files_r.sort
    end
  end

  def test_make_dir
    with_deep_path do |dir|
      refute dir.directory?
      assert_equal dir, dir.make_dir
      assert dir.directory?
    end
  end

  def test_make_dirname
    with_deep_path do |file|
      refute file.dirname.directory?
      assert_equal file, file.make_dirname
      assert file.dirname.directory?
      refute file.exist?
    end
  end

  def test_touch_file
    with_deep_path do |file|
      refute file.file?
      assert_equal file, file.touch_file
      assert file.file?
    end
  end

  def test_delete!
    with_deep_path do |path|
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
    with_deep_path(:file) do |source|
      destination = source.dirname / "destination/dir/file"

      refute destination.exist?
      assert_equal destination, source.move(destination)
      assert destination.exist?
      refute source.exist?
    end
  end

  def test_move_into
    with_deep_path(:file) do |source|
      destination = source.dirname / "destination/dir" / source.basename

      refute destination.exist?
      assert_equal destination, source.move_into(destination.dirname)
      assert destination.exist?
      refute source.exist?
    end
  end

  def test_copy
    with_deep_path(:file) do |source|
      destination = source.dirname / "destination/dir/file"

      refute destination.exist?
      assert_equal destination, source.copy(destination)
      assert destination.exist?
      assert source.exist?
    end
  end

  def test_copy_into
    with_deep_path(:file) do |source|
      destination = source.dirname / "destination/dir" / source.basename

      refute destination.exist?
      assert_equal destination, source.copy_into(destination.dirname)
      assert destination.exist?
      assert source.exist?
    end
  end

  def test_rename_basename
    with_deep_path(:file) do |old_path|
      new_path = old_path.dirname / "renamed"

      refute new_path.exist?
      assert_equal new_path, old_path.rename_basename(new_path.basename)
      assert new_path.exist?
      refute old_path.exist?
    end
  end

  def test_rename_extname
    [
      [".a", ".b"],
      ["", ".b"],
      [".a", ""],
    ].each do |old_extname, new_extname|
      with_deep_path(:dir) do |path|
        old_file = (path / "file#{old_extname}").tap{|f| FileUtils.touch(f) }
        new_file = (path / "file#{new_extname}")

        refute new_file.exist?
        assert_equal new_file, old_file.rename_extname(new_extname)
        assert new_file.exist?
        refute old_file.exist?
      end
    end
  end

  def test_rename_extname_missing_dot
    [
      [".a", "b"],
      ["", "b"],
    ].each do |old_extname, new_extname|
      with_deep_path(:dir) do |path|
        old_file = (path / "file#{old_extname}").tap{|f| FileUtils.touch(f) }
        new_file = (path / "file.#{new_extname}")

        refute new_file.exist?
        assert_equal new_file, old_file.rename_extname(new_extname)
        assert new_file.exist?
        refute old_file.exist?
      end
    end
  end

  def test_write_text
    text = "line 1\nline 2\n"

    with_deep_path do |file|
      assert_equal file, file.write_text(text)
      assert_equal text, file.read
    end
  end

  def test_append_text
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"

    with_deep_path do |file|
      assert_equal file, file.append_text(text1)
      assert_equal text1, file.read
      assert_equal file, file.append_text(text2)
      assert_equal (text1 + text2), file.read
    end
  end

  def test_write_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_deep_path do |file|
      assert_equal file, file.write_lines(lines)
      assert_equal text, file.read
    end
  end

  def test_append_lines
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"
    lines1 = text1.split("\n")
    lines2 = text2.split("\n")

    with_deep_path do |file|
      assert_equal file, file.append_lines(lines1)
      assert_equal text1, file.read
      assert_equal file, file.append_lines(lines2)
      assert_equal (text1 + text2), file.read
    end
  end

  def test_read_text
    file = Pathname.new(__FILE__)
    assert_equal file.read, file.read_text
  end

  def test_read_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_temp_file(text) do |file|
      assert_equal lines, file.read_lines
    end
  end

  def test_edit_text
    text = "line 1\nline 2\n"

    with_temp_file(text) do |file|
      assert_equal text.reverse, file.edit_text(&:reverse)
      assert_equal text.reverse, file.read
    end
  end

  def test_edit_lines
    text = "line 1\nline 2\n"
    lines = text.split("\n")

    with_temp_file(text) do |file|
      assert_equal lines.reverse, file.edit_lines(&:reverse)
      assert_equal lines.reverse, file.read.split("\n")
    end
  end

  def test_append_file
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"

    with_temp_file(text1) do |file|
      appendix = (file.dirname / "appendix").tap{|f| f.write(text2) }

      assert_equal file, file.append_file(appendix)
      assert_equal (text1 + text2), file.read
    end
  end


  private

  def make_dirs(path, *dirs)
    dirs.map{|d| path / d }.each(&:mkpath)
  end

  def make_files(path, *files)
    files.map{|f| path / f }.each do |f|
      f.dirname.mkpath
      FileUtils.touch(f)
    end
  end

end
