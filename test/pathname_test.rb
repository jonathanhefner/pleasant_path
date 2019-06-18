require "test_helper"

class PathnameTest < Minitest::Test

  def test_null_constant
    assert_equal File::NULL, Pathname::NULL.to_s
  end

  def test_to_pathname
    path = Pathname.new("path/to/file")

    assert_same path, path.to_pathname
  end

  def test_op_caret
    dirname = Pathname.new("path/to")
    path = dirname / "file1"

    assert_equal (dirname / "file2"), (path ^ "file2")
  end

  def test_parentname
    dirname = Pathname.new("path/to")
    path = dirname / "file"

    assert_equal dirname.basename, path.parentname
  end

  def test_existence
    with_tmp_dir do |dir|
      assert_equal dir, dir.existence

      file = dir / "file"
      assert_nil file.existence

      FileUtils.touch(file)
      assert_equal file, file.existence
    end
  end

  def test_common_path
    [ ["aaa/bbb/xxx", "aaa/bbb/zzz"],
      ["aaa/bbb/xxx", "aaa/zzz"],
      ["aaa/bbb/xxx", "aaa"],
      ["aaa/bbb/xxx", "zzz"],
      ["aaa/bbb", "bbb/aaa"],
    ].each do |path1, path2|
      expected = Pathname.new(File.common_path([path1, path2]))

      assert_equal expected, Pathname.new(path1).common_path(path2)
    end
  end

  def test_dir_predicate_aliases_directory_predicate
    assert_equal :directory?, Pathname.new("/").method(:dir?).original_name
  end

  def test_dir_empty_predicate_aliases_empty_predicate
    assert_equal :empty?, Pathname.new("/").method(:dir_empty?).original_name
  end

  def test_dirs
    with_tmp_tree do |base, dirs, files|
      child_dirs = dirs.select{|dir| dir.dirname == base }

      assert_equal child_dirs.sort, base.dirs.sort
    end
  end

  def test_dirs_r
    with_tmp_tree do |base, dirs, files|
      assert_equal dirs.sort, base.dirs_r.sort
    end
  end

  def test_find_dirs_with_block
    with_tmp_tree do |base, dirs, files|
      found = []
      base.find_dirs do |dir|
        found << dir
      end

      assert_equal dirs.sort, found.sort
    end
  end

  def test_find_dirs_without_block
    with_tmp_tree do |base, dirs, files|
      enum = base.find_dirs

      assert_kind_of Enumerator, enum
      assert_equal dirs.sort, enum.to_a.sort
    end
  end

  def test_files
    with_tmp_tree do |base, dirs, files|
      child_files = files.select{|file| file.dirname == base }

      assert_equal child_files.sort, base.files.sort
    end
  end

  def test_files_r
    with_tmp_tree do |base, dirs, files|
      assert_equal files.sort, base.files_r.sort
    end
  end

  def test_find_files_with_block
    with_tmp_tree do |base, dirs, files|
      found = []
      base.find_files do |file|
        found << file
      end

      assert_equal files.sort, found.sort
    end
  end

  def test_find_files_without_block
    with_tmp_tree do |base, dirs, files|
      enum = base.find_files

      assert_kind_of Enumerator, enum
      assert_equal files.sort, enum.to_a.sort
    end
  end

  def test_chdir_with_block
    old_pwd = Pathname.pwd
    new_pwd = old_pwd.dirname
    retval = new_pwd.chdir{|path| ["expected", path] }

    assert_equal "expected", retval[0]
    assert_equal new_pwd, retval[1]
    assert_equal old_pwd, Pathname.pwd
  end

  def test_chdir_without_block
    old_pwd = Pathname.pwd
    new_pwd = old_pwd.dirname
    retval = new_pwd.chdir

    assert_equal new_pwd, retval
    assert_equal new_pwd, Pathname.pwd
  ensure
    Dir.chdir(old_pwd)
  end

  def test_chdir_with_nonexistent_dir
    old_pwd = Pathname.pwd
    new_pwd = old_pwd / "non/exist/ent"

    assert_raises(SystemCallError) do
      new_pwd.chdir
    end
    assert_equal old_pwd, Pathname.pwd
  end

  def test_make_dir
    with_tmp_dir(false) do |dir|
      assert_equal dir, dir.make_dir
      assert dir.directory?
    end
  end

  def test_make_dir_with_existent_file
    assert_raises(SystemCallError) do
      Pathname.new(__FILE__).make_dir
    end
  end

  def test_make_dirname
    with_tmp_dir(false) do |dir|
      file = dir / "file"

      assert_equal file, file.make_dirname
      assert dir.directory?
      refute file.exist?
    end
  end

  def test_make_dirname_with_existent_file
    assert_raises(SystemCallError) do
      (Pathname.new(__FILE__) / "dir").make_dirname
    end
  end

  def test_make_file
    with_tmp_file(false) do |file|
      assert_equal file, file.make_file
      assert file.file?

      file.write("expected")
      assert_equal "expected", file.make_file.read
    end
  end

  def test_make_file_with_existent_dir
    assert_raises(SystemCallError) do
      Pathname.new(__FILE__).dirname.make_file
    end
  end

  def test_touch_file
    with_tmp_file(false) do |file|
      assert_equal file, file.touch_file
      assert file.file?
    end
  end

  def test_delete_bang
    with_tmp_file do |file|
      dir = file.dirname

      assert_equal dir, dir.delete!
      refute dir.exist?
      assert_equal dir, dir.delete! # doesn't exist, but nothing raised
    end
  end

  def test_available_name
    with_tmp_dir do |dir|
      ["some_file.txt", "some_file", ".some_file"].each do |file|
        original = dir / file
        available = original.available_name

        assert_equal original, available

        2.times do
          FileUtils.touch(available)
          available = original.available_name

          refute available.exist?
          assert_equal original.dirname, available.dirname
          assert_equal original.extname, available.extname
          assert available.basename.to_s.start_with?(original.basename.sub_ext("").to_s)
        end
      end
    end
  end

  def test_available_name_with_format
    with_tmp_file do |file|
      expected = file.dirname / "1 #{file.extname} #{file.basename.sub_ext("")}"
      available = file.available_name("%{i} %{ext} %{name}")

      refute_empty file.extname # sanity check
      assert_equal expected, available
    end
  end

  def test_available_name_with_i
    with_tmp_file do |file|
      i = 123
      expected = file.sub_ext("_#{i}#{file.extname}")
      available = file.available_name(i: i)

      assert_equal expected, available
    end
  end

  def test_move
    with_tmp_file do |source|
      destination = source.dirname / "destination/dir/file"

      assert_equal destination, source.move(destination)
      assert destination.exist?
      refute source.exist?
    end
  end

  def test_move_as
    check_move_as_semantics("file_a", "dir/file_b") do |original, conflicting, block|
      original.move_as(conflicting, &block)
    end
  end

  def test_move_into
    check_move_as_semantics("file", "dir/file") do |original, conflicting, block|
      original.move_into(conflicting.dirname, &block)
    end
  end

  def test_copy
    with_tmp_file do |source|
      destination = source.dirname / "destination/dir/file"

      assert_equal destination, source.copy(destination)
      assert destination.exist?
      assert source.exist?
    end
  end

  def test_copy_into
    with_tmp_file do |source|
      destination = source.dirname / "destination/dir" / source.basename

      assert_equal destination, source.copy_into(destination.dirname)
      assert destination.exist?
      assert source.exist?
    end
  end

  def test_rename_basename
    check_move_as_semantics("file_a", "file_b") do |original, conflicting, block|
      original.rename_basename(conflicting.basename, &block)
    end
  end

  def test_rename_extname
    check_move_as_semantics("file.a", "file.b") do |original, conflicting, block|
      original.rename_extname(conflicting.extname, &block)
    end
  end

  def test_rename_extname_with_empty_extname
    with_tmp_file do |file|
      refute_empty file.extname # sanity check

      ["", ".a"].each do |extname| # to empty, from empty
        expected = file.sub_ext(extname)
        file = file.rename_extname(extname)
        assert_equal expected, file
        assert expected.file?
      end
    end
  end

  def test_rename_extname_without_dot
    with_tmp_file do |file|
      expected = file.sub_ext(".a")
      assert_equal expected, file.rename_extname("a")
      assert expected.file?
    end
  end

  def test_write_text
    text = "line 1\nline 2\n"

    with_tmp_file(false) do |file|
      assert_equal file, file.write_text(text)
      assert_equal text, file.read
    end
  end

  def test_append_text
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"

    with_tmp_file(false) do |file|
      assert_equal file, file.append_text(text1)
      assert_equal text1, file.read
      assert_equal file, file.append_text(text2)
      assert_equal (text1 + text2), file.read
    end
  end

  def test_write_lines
    lines = ["line 1", "line 2"]

    with_various_eol(lines) do |text, options|
      with_tmp_file(false) do |file|
        assert_equal file, file.write_lines(lines, **options)
        assert_equal text, file.read
      end
    end
  end

  def test_append_lines
    lines = ["line 1", "line 2"]

    with_various_eol(lines) do |text, options|
      with_tmp_file(false) do |file|
        assert_equal file, file.append_lines(lines, **options)
        assert_equal text, file.read
        assert_equal file, file.append_lines(lines, **options)
        assert_equal (text + text), file.read
      end
    end
  end

  def test_read_text_aliases_read
    assert_equal :read, Pathname.new("/").method(:read_text).original_name
  end

  def test_read_lines
    lines = ["line 1", "line 2"]

    with_tmp_file do |file|
      with_various_eol(lines) do |text, options|
        file.write(text)

        assert_equal lines, file.read_lines(**options)
      end
    end
  end

  def test_edit_text
    text = "  abcdef  "

    with_tmp_file do |file|
      file.write(text)

      assert_equal text.strip, file.edit_text(&:strip)
      assert_equal text.strip, file.read
    end
  end

  def test_edit_lines
    lines = ["AAA", "BBB", "BBB", "AAA", "CCC"]

    with_tmp_file do |file|
      with_various_eol(lines) do |text, options|
        file.write(text)

        assert_equal lines.uniq, file.edit_lines(**options, &:uniq)
        assert_equal lines.uniq, file.read.split(options[:eol] || $/)
      end
    end
  end

  def test_append_file
    text1 = "line 1\nline 2\n"
    text2 = "line 3\nline 4\n"

    with_tmp_file do |file1|
      file2 = file1.dirname / "file2"
      file1.write(text1)
      file2.write(text2)

      assert_equal file1, file1.append_file(file2)
      assert_equal (text1 + text2), file1.read
    end
  end


  private

  def with_tmp_tree
    Dir.mktmpdir do |tmp|
      base = Pathname.new(tmp)
      dirs = ["d1", "d2", "d2/d3"].map{|dir| base / dir }.
        each(&:mkpath)
      files = ([base] + dirs).flat_map{|dir| [dir / "f1", dir / "f2"] }.
        each{|file| FileUtils.touch(file) }

      yield base, dirs, files
    end
  end

  def check_move_as_semantics(original, conflicting)
    with_tmp_dir do |dir|
      original = dir / original
      original.dirname.mkpath
      original.write("A")

      # block is not called if paths are identical
      assert_equal original, (yield original, original, proc{ raise })
      assert_equal "A", original.read

      conflicting = dir / conflicting

      # block is not called if destination file does not exist
      assert_equal conflicting, (yield original, conflicting, proc{ raise })
      refute original.exist?
      assert_equal "A", conflicting.read

      original.write("B")

      # move is aborted if block returns nil
      assert_equal original, (yield original, conflicting, proc{ nil })
      assert_equal "B", original.read
      assert_equal "A", conflicting.read

      # block receives both paths
      yield original, conflicting, ->(src, dst) do
        assert_equal original, src
        assert_equal conflicting, dst
        nil
      end

      # block may return source path
      assert_equal original, (yield original, conflicting, ->(src, dst){ src })
      assert_equal "B", original.read
      assert_equal "A", conflicting.read

      # block may return destination path
      assert_equal conflicting, (yield original, conflicting, ->(src, dst){ dst })
      refute original.exist?
      assert_equal "B", conflicting.read

      original.write("C")
      other = dir / "deeper/nested/file"

      # block may return other path
      assert_equal other, (yield original, conflicting, proc{ other })
      refute original.exist?
      assert_equal "B", conflicting.read
      assert_equal "C", other.read

      original.write("D")
      conflicting.delete
      conflicting.mkdir

      # destination is deleted before move
      assert_equal conflicting, (yield original, conflicting, nil)
      refute original.exist?
      assert_equal "D", conflicting.read
    end
  end

end
