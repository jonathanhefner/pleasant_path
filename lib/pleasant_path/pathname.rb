# frozen_string_literal: true

class Pathname

  # {https://docs.ruby-lang.org/en/trunk/File/File/Constants.html#NULL +File::NULL+}
  # as a Pathname.  On POSIX systems, this should be equivalent to
  # +Pathname.new("/dev/null")+.
  NULL = Pathname.new(File::NULL)

  # Returns the Pathname unmodified.  Exists for parity with
  # {String#to_pathname}.
  #
  # @return [self]
  def to_pathname
    self
  end

  # Joins the Pathname +dirname+ with the given +sibling+.
  #
  # The mnemonic for this operator is that the result is formed by going
  # up one directory level from the original path, then going back down
  # to +sibling+.
  #
  # @example
  #   Pathname.new("path/to/file1") ^ "file2"  # == Pathname.new("path/to/file2")
  #
  # @param sibling [Pathname, String]
  # @return [Pathname]
  def ^(sibling)
    self.dirname / sibling
  end

  # Returns the +basename+ of the parent directory (+dirname+).
  #
  # @example
  #   Pathname.new("path/to/file").parentname  # == Pathname.new("to")
  #
  # @return [Pathname]
  def parentname
    self.dirname.basename
  end

  # Returns the Pathname if +exist?+ returns true, otherwise returns
  # nil.
  #
  # @example
  #   FileUtils.mkdir("dir1")
  #   FileUtils.touch("dir1/file1")
  #
  #   Pathname.new("dir1/file1").existence  # == Pathname.new("dir1/file1")
  #
  #   Pathname.new("dir1/file2").existence  # == nil
  #
  # @return [self, nil]
  def existence
    self if self.exist?
  end

  # Returns the longest path that the Pathname and +other+ have in
  # common.
  #
  # @see File.common_path
  #
  # @example
  #   f1 = Pathname.new("dir1/file1")
  #   f2 = Pathname.new("dir1/subdir1/file2")
  #   f3 = Pathname.new("dir1/subdir1/file3")
  #   f4 = Pathname.new("dir2/file4")
  #
  #   f1.common_path(f2)  # == Pathname.new("dir1/")
  #   f2.common_path(f3)  # == Pathname.new("dir1/subdir1/")
  #   f3.common_path(f4)  # == Pathname.new("")
  #
  #   [f1, f2, f3].reduce(&:common_path)  # == Pathname.new("dir1/")
  #
  # @param other [Pathname]
  # @return [Pathname]
  def common_path(other)
    File.common_path([self.to_s, other.to_s]).to_pathname
  end

  # Alias of +Pathname#directory?+.
  #
  # @return [Boolean]
  alias :dir? :directory?

  # @deprecated Use +Pathname#empty?+.
  #
  # Alias of +Pathname#empty?+.
  #
  # @return [Boolean]
  alias :dir_empty? :empty?

  # Returns the immediate child directories of the directory indicated
  # by the Pathname.  Returned Pathnames are prefixed by the original
  # Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.mkdir("parent/dir1/dir1")
  #   FileUtils.mkdir("parent/dir2")
  #   FileUtils.touch("parent/file1")
  #
  #   Pathname.new("parent").dirs
  #     # == [
  #     #      Pathname.new("parent/dir1"),
  #     #      Pathname.new("parent/dir2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def dirs
    self.children.tap{|c| c.select!(&:dir?) }
  end

  # Returns all (recursive) descendent directories of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname, and are in depth-first order.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.mkdir("parent/dir1/dir1")
  #   FileUtils.mkdir("parent/dir2")
  #   FileUtils.touch("parent/dir2/file1")
  #
  #   Pathname.new("parent").dirs_r
  #     # == [
  #     #      Pathname.new("parent/dir1"),
  #     #      Pathname.new("parent/dir1/dir1"),
  #     #      Pathname.new("parent/dir2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def dirs_r
    self.find_dirs.to_a
  end

  # Iterates over all (recursive) descendent directories of the
  # directory indicated by the Pathname.  Iterated Pathnames are
  # prefixed by the original Pathname, and are in depth-first order.
  #
  # If no block is given, this method returns an Enumerator.  Otherwise,
  # the block is called with each descendent Pathname, and this method
  # returns the original Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/Pathname.html#method-i-find Pathname#find
  #
  # @overload find_dirs()
  #   @return [Enumerator<Pathname>]
  #
  # @overload find_dirs(&block)
  #   @yieldparam descendent [Pathname]
  #   @return [Pathname]
  def find_dirs
    return to_enum(__method__) unless block_given?

    self.find do |path|
      if path.file?
        Find.prune
      elsif path != self
        yield path
      end
    end

    self
  end

  # Returns the immediate child files of the directory indicated by the
  # Pathname.  Returned Pathnames are prefixed by the original Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.touch("parent/file1")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.touch("parent/dir1/file1")
  #   FileUtils.touch("parent/file2")
  #
  #   Pathname.new("parent").files
  #     # == [
  #     #      Pathname.new("parent/file1"),
  #     #      Pathname.new("parent/file2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def files
    self.children.tap{|c| c.select!(&:file?) }
  end

  # Returns all (recursive) descendent files of the directory indicated
  # by the Pathname.  Returned Pathnames are prefixed by the original
  # Pathname, and are in depth-first order.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.touch("parent/file1")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.touch("parent/dir1/file1")
  #   FileUtils.touch("parent/file2")
  #
  #   Pathname.new("parent").files_r
  #     # == [
  #     #      Pathname.new("parent/dir1/file1"),
  #     #      Pathname.new("parent/file1")
  #     #      Pathname.new("parent/file2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def files_r
    self.find_files.to_a
  end

  # Iterates over all (recursive) descendent files of the directory
  # indicated by the Pathname.  Iterated Pathnames are prefixed by the
  # original Pathname, and are in depth-first order.
  #
  # If no block is given, this method returns an Enumerator.  Otherwise,
  # the block is called with each descendent Pathname, and this method
  # returns the original Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/Pathname.html#method-i-find Pathname#find
  #
  # @overload find_files()
  #   @return [Enumerator<Pathname>]
  #
  # @overload find_files(&block)
  #   @yieldparam descendent [Pathname]
  #   @return [Pathname]
  def find_files
    return to_enum(__method__) unless block_given?

    self.find do |path|
      yield path if path.file?
    end

    self
  end

  # Changes the current working directory to the Pathname.  If no block
  # is given, this method returns the Pathname.  Otherwise, the block is
  # called with the Pathname, the original working directory is restored
  # after the block exits, this method returns the return value of the
  # block.
  #
  # @see https://docs.ruby-lang.org/en/trunk/Dir.html#method-c-chdir Dir.chdir
  #
  # @example
  #   FileUtils.mkdir("dir1")
  #   FileUtils.mkdir("dir2")
  #
  #   Pathname.new("dir1").chdir  # == Pathname.new("dir1")
  #   Pathname.pwd                # == Pathname.new("dir1")
  #
  #   Pathname.new("dir2").chdir{|path| "in #{path}" }  # == "in dir2"
  #   Pathname.pwd                                      # == Pathname.new("dir1")
  #
  # @overload chdir()
  #   @return [Pathname]
  #
  # @overload chdir(&block)
  #   @yieldparam working_dir [Pathname]
  #   @yieldreturn [Object] retval
  #   @return [retval]
  #
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def chdir
    if block_given?
      Dir.chdir(self) do |dir|
        yield dir.to_pathname
      end
    else
      Dir.chdir(self)
      self
    end
  end

  # Creates the directory indicated by the Pathname, including any
  # necessary parent directories.  Returns the Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/Pathname.html#method-i-mkpath Pathname#mkpath
  #
  # @example
  #   Dir.exist?("path")                # == false
  #   Dir.exist?("path/to")             # == false
  #
  #   Pathname.new("path/to").make_dir  # == Pathname.new("path/to")
  #
  #   Dir.exist?("path")                # == true
  #   Dir.exist?("path/to")             # == true
  #
  # @return [self]
  # @raise [SystemCallError]
  #   if the Pathname points to an existing file (non-directory)
  def make_dir
    self.mkpath
    self
  end

  # Creates the directory indicated by the Pathname +dirname+, including
  # any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")                         # == false
  #   Dir.exist?("path/to")                      # == false
  #
  #   Pathname.new("path/to/file").make_dirname  # == Pathname.new("path/to/file")
  #
  #   Dir.exist?("path")                         # == true
  #   Dir.exist?("path/to")                      # == true
  #   Dir.exist?("path/to/file")                 # == false
  #
  # @return [self]
  # @raise [SystemCallError]
  #   if any element of the +dirname+ points to an existing file
  #   (non-directory)
  def make_dirname
    self.dirname.make_dir
    self
  end

  # Creates the file indicated by the Pathname, including any necessary
  # parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")                      # == false
  #   Dir.exist?("path/to")                   # == false
  #
  #   Pathname.new("path/to/file").make_file  # == Pathname.new("path/to/file")
  #
  #   Dir.exist?("path")                      # == true
  #   Dir.exist?("path/to")                   # == true
  #   File.exist?("path/to/file")             # == true
  #
  # @return [Pathname]
  # @raise [SystemCallError]
  #   if the Pathname points to an existent directory
  def make_file
    self.make_dirname.open("a"){}
    self
  end

  # @deprecated Use {Pathname#make_file}.
  #
  # Creates the file indicated by the Pathname, including any necessary
  # parent directories.  If the file already exists, its modification
  # time (mtime) and access time (atime) are updated.  Returns the
  # Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/FileUtils.html#method-c-touch FileUtils.touch
  #
  # @example
  #   Dir.exist?("path")                       # == false
  #   Dir.exist?("path/to")                    # == false
  #
  #   Pathname.new("path/to/file").touch_file  # == Pathname.new("path/to/file")
  #
  #   Dir.exist?("path")                       # == true
  #   Dir.exist?("path/to")                    # == true
  #   File.exist?("path/to/file")              # == true
  #
  # @return [self]
  def touch_file
    self.make_dirname
    FileUtils.touch(self)
    self
  end

  # Recursively deletes the directory or file indicated by the Pathname.
  # Similar to +Pathname#rmtree+, but does not raise an exception if the
  # file does not exist.  Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")   # == true
  #
  #   Pathname.new("path").delete!  # == Pathname.new("path")
  #
  #   Dir.exist?("path")            # == false
  #   Dir.exist?("path/to")         # == false
  #   File.exist?("path/to/file")   # == false
  #
  # @return [self]
  def delete!
    self.rmtree if self.exist?
    self
  end

  # Moves the file or directory indicated by the Pathname to
  # +destination+, creating any necessary parent directories beforehand.
  # Returns +destination+ as a Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/FileUtils.html#method-c-mv FileUtils.mv
  #
  # @example
  #   File.exist?("path/to/file")         # == true
  #   Dir.exist?("other")                 # == false
  #   Dir.exist?("other/dir")             # == false
  #   File.exist?("other/dir/same_file")  # == false
  #
  #   Pathname.new("path/to/file").move("other/dir/same_file")
  #     # == Pathname.new("other/dir/same_file")
  #
  #   File.exist?("path/to/file")         # == false
  #   Dir.exist?("other")                 # == true
  #   Dir.exist?("other/dir")             # == true
  #   File.exist?("other/dir/same_file")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def move(destination)
    destination = destination.to_pathname
    destination.make_dirname
    FileUtils.mv(self, destination)
    destination
  end

  # Moves the file or directory indicated by the Pathname into
  # +directory+, creating any necessary parent directories beforehand.
  # Returns the resultant path as a Pathname.
  #
  # @example
  #   File.exist?("path/to/file")    # == true
  #   Dir.exist?("other")            # == false
  #   Dir.exist?("other/dir")        # == false
  #   File.exist?("other/dir/file")  # == false
  #
  #   Pathname.new("path/to/file").move_into("other/dir")
  #     # == Pathname.new("other/dir/file")
  #
  #   File.exist?("path/to/file")    # == false
  #   Dir.exist?("other")            # == true
  #   Dir.exist?("other/dir")        # == true
  #   File.exist?("other/dir/file")  # == true
  #
  # @param directory [Pathname, String]
  # @return [Pathname]
  def move_into(directory)
    self.move(directory / self.basename)
  end

  # Copies the file or directory indicated by the Pathname to
  # +destination+, creating any necessary parent directories beforehand.
  # Returns +destination+ as a Pathname.
  #
  # @see https://docs.ruby-lang.org/en/trunk/FileUtils.html#method-c-cp_r FileUtils.cp_r
  #
  # @example
  #   File.exist?("path/to/file")         # == true
  #   Dir.exist?("other")                 # == false
  #   Dir.exist?("other/dir")             # == false
  #   File.exist?("other/dir/same_file")  # == false
  #
  #   Pathname.new("path/to/file").copy("other/dir/same_file")
  #     # == Pathname.new("other/dir/same_file")
  #
  #   File.exist?("path/to/file")         # == true
  #   Dir.exist?("other")                 # == true
  #   Dir.exist?("other/dir")             # == true
  #   File.exist?("other/dir/same_file")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def copy(destination)
    destination = destination.to_pathname
    destination.make_dirname
    FileUtils.cp_r(self, destination)
    destination
  end

  # Copies the file or directory indicated by the Pathname into
  # +directory+, creating any necessary parent directories beforehand.
  # Returns the resultant path as a Pathname.
  #
  # @example
  #   File.exist?("path/to/file")    # == true
  #   Dir.exist?("other")            # == false
  #   Dir.exist?("other/dir")        # == false
  #   File.exist?("other/dir/file")  # == false
  #
  #   Pathname.new("path/to/file").copy_into("other/dir")
  #     # == Pathname.new("other/dir/file")
  #
  #   File.exist?("path/to/file")    # == true
  #   Dir.exist?("other")            # == true
  #   Dir.exist?("other/dir")        # == true
  #   File.exist?("other/dir/file")  # == true
  #
  # @param directory [Pathname, String]
  # @return [Pathname]
  def copy_into(directory)
    self.copy(directory / self.basename)
  end

  # Renames the file or directory indicated by the Pathname relative to
  # its +dirname+.  Returns the resultant path as a Pathname.
  #
  # @example
  #   File.exist?("path/to/file")   # == true
  #
  #   Pathname.new("path/to/file").rename_basename("same_file")
  #     # == Pathname.new("path/to/same_file")
  #
  #   File.exist?("path/to/file")       # == false
  #   File.exist?("path/to/same_file")  # == true
  #
  # @param new_basename [String]
  # @return [Pathname]
  def rename_basename(new_basename)
    new_path = self.dirname / new_basename
    self.rename(new_path)
    new_path
  end

  # Changes the file extension (+extname+) of the file indicated by the
  # Pathname.  If the file has no extension, the new extension is
  # appended.  Returns the resultant path as a Pathname.
  #
  # @example Replace extension
  #   File.exist?("path/to/file.abc")  # == true
  #
  #   Pathname.new("path/to/file.abc").rename_extname(".xyz")
  #     # == Pathname.new("path/to/file.xyz")
  #
  #   File.exist?("path/to/file.abc")  # == false
  #   File.exist?("path/to/file.xyz")  # == true
  #
  # @example Add extension
  #   File.exist?("path/to/file")      # == true
  #
  #   Pathname.new("path/to/file").rename_extname(".abc")
  #     # == Pathname.new("path/to/file.abc")
  #
  #   File.exist?("path/to/file")      # == false
  #   File.exist?("path/to/file.abc")  # == true
  #
  # @example Remove extension
  #   File.exist?("path/to/file.abc")  # == true
  #
  #   Pathname.new("path/to/file.abc").rename_extname("")
  #     # == Pathname.new("path/to/file")
  #
  #   File.exist?("path/to/file.abc")  # == false
  #   File.exist?("path/to/file")      # == true
  #
  # @param new_extname [String]
  # @return [Pathname]
  def rename_extname(new_extname)
    unless new_extname.start_with?(".") || new_extname.empty?
      new_extname = ".#{new_extname}"
    end
    new_path = self.sub_ext(new_extname)
    self.rename(new_path)
    new_path
  end

  # Writes +text+ to the file indicated by the Pathname, overwriting the
  # file if it exists.  Creates the file if it does not exist, including
  # any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")           # == false
  #   Dir.exist?("path/to")        # == false
  #   File.exist?("path/to/file")  # == false
  #
  #   Pathname.new("path/to/file").write_text("hello world")
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "hello world"
  #
  # @param text [String]
  # @return [self]
  def write_text(text)
    self.make_dirname.open("w"){|f| f.write(text) }
    self
  end

  # Appends +text+ to the file indicated by the Pathname.  Creates the
  # file if it does not exist, including any necessary parent
  # directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")           # == false
  #   Dir.exist?("path/to")        # == false
  #   File.exist?("path/to/file")  # == false
  #
  #   Pathname.new("path/to/file").append_text("hello").append_text(" world")
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "hello world"
  #
  # @param text [String]
  # @return [self]
  def append_text(text)
    self.make_dirname.open("a"){|f| f.write(text) }
    self
  end

  # Writes each object in +lines+ as a string plus end-of-line (EOL)
  # characters to the file indicated by the Pathname, overwriting the
  # file if it exists.  Creates the file if it does not exist, including
  # any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")  # false
  #
  #   Pathname.new("path/to/file").write_lines([:one, :two])
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "one\ntwo\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @param eol [String]
  # @return [self]
  def write_lines(lines, eol: $/)
    self.make_dirname.open("w"){|f| f.write_lines(lines, eol: eol) }
    self
  end

  # Appends each object in +lines+ as a string plus end-of-line (EOL)
  # characters to the file indicated by the Pathname.  Creates the file
  # if it does not exist, including any necessary parent directories.
  # Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")  # false
  #
  #   Pathname.new("path/to/file").append_lines([:one, :two]).append_lines([:three, :four])
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "one\ntwo\nthree\nfour\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @param eol [String]
  # @return [self]
  def append_lines(lines, eol: $/)
    self.make_dirname.open("a"){|f| f.write_lines(lines, eol: eol) }
    self
  end

  # Alias of +Pathname#read+.
  #
  # @return [String]
  alias :read_text :read

  # Reads all lines from the file indicated by the Pathname, and returns
  # them with all end-of-line (EOL) characters stripped.
  #
  # @see IO#read_lines
  #
  # @note Not to be confused with +Pathname#readlines+, which retains
  #   end-of-line (EOL) characters.
  #
  # @example
  #   File.read("path/to/file")                # == "one\ntwo\n"
  #
  #   Pathname.new("path/to/file").read_lines  # == ["one", "two"]
  #
  # @param eol [String]
  # @return [Array<String>]
  def read_lines(eol: $/)
    self.open("r"){|f| f.read_lines(eol: eol) }
  end

  # Reads the entire contents of the file indicated by the Pathname as a
  # string, and yields that string to the given block for editing.
  # Writes the return value of the block back to the file, overwriting
  # previous contents.  Returns the return value of the block.
  #
  # @see File.edit_text
  #
  # @example Update JSON data file
  #   File.read("data.json")  # == '{"nested":{"key":"value"}}'
  #
  #   Pathname.new("data.json").edit_text do |text|
  #     data = JSON.parse(text)
  #     data["nested"]["key"] = "new value"
  #     data.to_json
  #   end                     # == '{"nested":{"key":"new value"}}'
  #
  #   File.read("data.json")  # == '{"nested":{"key":"new value"}}'
  #
  # @yield [text]
  # @yieldparam text [String]
  # @yieldreturn [String]
  # @return [String]
  def edit_text(&block)
    File.edit_text(self, &block)
  end

  # Reads the entire contents of the file indicated by the Pathname as
  # an array of lines, and yields that array to the given block for
  # editing.  Writes the return value of the block back to the file,
  # overwriting previous contents.  End-of-line (EOL) characters are
  # stripped when reading, and appended after each line when writing.
  # Returns the return value of the block.
  #
  # @see File.edit_lines
  #
  # @example Dedup lines of file
  #   File.read("entries.txt")  # == "AAA\nBBB\nBBB\nCCC\nAAA\n"
  #
  #   Pathname.new("entries.txt").edit_lines(&:uniq)
  #     # == ["AAA", "BBB", "CCC"]
  #
  #   File.read("entries.txt")  # == "AAA\nBBB\nCCC\n"
  #
  # @param eol [String]
  # @yield [lines]
  # @yieldparam lines [Array<String>]
  # @yieldreturn [Array<String>]
  # @return [Array<String>]
  def edit_lines(eol: $/, &block)
    File.edit_lines(self, eol: eol, &block)
  end

  # Appends the contents of file indicated by +source+ to the file
  # indicated by the Pathname.  Returns the Pathname.
  #
  # @example
  #   File.read("yearly.log")  # == "one\ntwo\n"
  #   File.read("daily.log")   # == "three\nfour\n"
  #
  #   Pathname.new("yearly.log").append_file("daily.log")
  #     # == Pathname.new("yearly.log")
  #
  #   File.read("yearly.log")  # == "one\ntwo\nthree\nfour\n"
  #
  # @param source [String, Pathname]
  # @return [self]
  def append_file(source)
    self.open("a"){|destination| IO::copy_stream(source, destination) }
    self
  end

end
