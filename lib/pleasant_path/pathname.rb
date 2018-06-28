class Pathname

  # {https://ruby-doc.org/core/File/Constants.html#NULL +File::NULL+} as
  # a Pathname.  On POSIX systems, this should be equivalent to
  # +Pathname.new("/dev/null")+.
  NULL = Pathname.new(File::NULL)

  # Returns the Pathname unmodified.  Exists for parity with
  # {String#to_pathname}.
  #
  # @return [Pathname]
  def to_pathname
    self
  end

  # Joins the parent (+dirname+) of the Pathname with the argument.  The
  # mnemonic for this operator is that the resultant path goes up one
  # directory level from the original, then goes down to the directory
  # specified by the argument.
  #
  # @example
  #   Pathname.new("path/to/file1") ^ "file2"  # == Pathname.new("path/to/file2")
  #
  # @param sibling [Pathname, String]
  # @return [Pathname]
  def ^(sibling)
    self.dirname / sibling
  end

  # Returns the +basename+ of the Pathname's parent directory.
  #
  # @example
  #   Pathname.new("path/to/file").parentname  # == Pathname.new("to")
  #
  # @return [Pathname]
  def parentname
    self.dirname.basename
  end

  # Computes the longest path that the Pathname and +other+ have in
  # common.  See also {File.common_path}.
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

  # True if the directory indicated by the Pathname contains no other
  # directories or files.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #
  #   Pathname.new("parent").dir_empty?       # == false
  #   Pathname.new("parent/dir1").dir_empty?  # == true
  #
  # @return [Boolean]
  def dir_empty?
    self.children(false).empty?
  end

  # Returns the immediate (non-recursive) child directories of the
  # directory indicated by the Pathname.  Returned Pathnames are
  # prefixed by the original Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
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
  def dirs
    self.children.tap{|c| c.select!(&:dir?) }
  end

  # Returns the recursively descended child directories of the
  # directory indicated by the Pathname.  Returned Pathnames are
  # prefixed by the original Pathname.
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
    self.find.select(&:dir?).tap(&:shift)
  end

  # Returns the immediate (non-recursive) child files of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.touch("parent/file1")
  #   FileUtils.touch("parent/file2")
  #   FileUtils.mkdir("parent/dir1")
  #
  #   Pathname.new("parent").files
  #     # == [
  #     #      Pathname.new("parent/file1"),
  #     #      Pathname.new("parent/file2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def files
    self.children.tap{|c| c.select!(&:file?) }
  end

  # Returns the recursively descended child files of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.touch("parent/dir1/file1")
  #   FileUtils.touch("parent/file1")
  #
  #   Pathname.new("parent").files_r
  #     # == [
  #     #      Pathname.new("parent/dir1/file1"),
  #     #      Pathname.new("parent/file1")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def files_r
    self.find.select(&:file?)
  end

  # Alias of +Pathname#mkpath+, but this method returns the Pathname.
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
  # @return [Pathname]
  def make_dir
    self.mkpath
    self
  end

  # Creates the parent (+dirname+) directories of the Pathname if they
  # do not exist, and returns the Pathname.
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
  # @return [Pathname]
  def make_dirname
    self.dirname.make_dir
    self
  end

  # Updates the modification time (mtime) and access time (atime) of the
  # file indicated by the Pathname, and returns the Pathname.  Creates
  # the file and any necessary parent directories if they do not exist.
  # See also +FileUtils.touch+.
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
  # @return [Pathname]
  def touch_file
    self.make_dirname
    FileUtils.touch(self)
    self
  end

  # Recursively deletes the directory or file indicated by the Pathname,
  # and returns the Pathname.  Similar to +Pathname#rmtree+, but does
  # not raise an exception if the file does not exist.
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
  # @return [Pathname]
  def delete!
    self.rmtree if self.exist?
    self
  end

  # Moves the file or directory indicated by the Pathname to the given
  # destination, and returns that destination as a Pathname.  Creates
  # any necessary parent directories if they do not exist.  See also
  # +FileUtils.mv+.
  #
  # @example
  #   File.exist?("path/to/file")      # == true
  #   Dir.exist?("some")               # == false
  #   Dir.exist?("some/other")         # == false
  #   File.exist?("some/other/thing")  # == false
  #
  #   Pathname.new("path/to/file").move("some/other/thing")
  #     # == Pathname.new("some/other/thing")
  #
  #   File.exist?("path/to/file")      # == false
  #   Dir.exist?("some")               # == true
  #   Dir.exist?("some/other")         # == true
  #   File.exist?("some/other/thing")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def move(destination)
    destination = destination.to_pathname
    destination.make_dirname
    FileUtils.mv(self, destination)
    destination
  end

  # Moves the file or directory indicated by the Pathname into the given
  # directory, and returns the resultant path as a Pathname.  Creates
  # any necessary parent directories if they do not exist.
  #
  # @example
  #   File.exist?("path/to/file")     # == true
  #   Dir.exist?("other")             # == false
  #   Dir.exist?("other/path")        # == false
  #   File.exist?("other/path/file")  # == false
  #
  #   Pathname.new("path/to/file").move_into("other/path")
  #     # == Pathname.new("other/path/file")
  #
  #   File.exist?("path/to/file")     # == false
  #   Dir.exist?("other")             # == true
  #   Dir.exist?("other/path")        # == true
  #   File.exist?("other/path/file")  # == true
  #
  # @param directory [Pathname, String]
  # @return [Pathname]
  def move_into(directory)
    self.move(directory / self.basename)
  end

  # Copies the file or directory indicated by the Pathname to the given
  # destination, and returns that destination as a Pathname.  Creates
  # any necessary parent directories if they do not exist.  See also
  # +FileUtils.cp_r+.
  #
  # @example
  #   File.exist?("path/to/file")      # == true
  #   Dir.exist?("some")               # == false
  #   Dir.exist?("some/other")         # == false
  #   File.exist?("some/other/thing")  # == false
  #
  #   Pathname.new("path/to/file").copy("some/other/thing")
  #     # == Pathname.new("some/other/thing")
  #
  #   File.exist?("path/to/file")      # == true
  #   Dir.exist?("some")               # == true
  #   Dir.exist?("some/other")         # == true
  #   File.exist?("some/other/thing")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def copy(destination)
    destination = destination.to_pathname
    destination.make_dirname
    FileUtils.cp_r(self, destination)
    destination
  end

  # Copies the file or directory indicated by the Pathname into the
  # given directory, and returns the resultant path as a Pathname.
  # Creates any necessary parent directories if they do not exist.
  #
  # @example
  #   File.exist?("path/to/file")     # == true
  #   Dir.exist?("other")             # == false
  #   Dir.exist?("other/path")        # == false
  #   File.exist?("other/path/file")  # == false
  #
  #   Pathname.new("path/to/file").copy_into("other/path")
  #     # == Pathname.new("other/path/file")
  #
  #   File.exist?("path/to/file")     # == true
  #   Dir.exist?("other")             # == true
  #   Dir.exist?("other/path")        # == true
  #   File.exist?("other/path/file")  # == true
  #
  # @param directory [Pathname, String]
  # @return [Pathname]
  def copy_into(directory)
    self.copy(directory / self.basename)
  end

  # Renames the file or directory indicated by the Pathname, but
  # preserves its location as indicated by +dirname+.  Returns the
  # resultant path as a Pathname.
  #
  # @example
  #   File.exist?("path/to/file")   # == true
  #
  #   Pathname.new("path/to/file").rename_basename("other")
  #     # == Pathname.new("path/to/other")
  #
  #   File.exist?("path/to/file")   # == false
  #   File.exist?("path/to/other")  # == true
  #
  # @param new_basename [String]
  # @return [Pathname]
  def rename_basename(new_basename)
    new_path = self.dirname / new_basename
    self.rename(new_path)
    new_path
  end

  # Renames the file extension of the file indicated by the Pathname.
  # If the file has no extension, the new extension is appended.
  #
  # @example replace extension
  #   File.exist?("path/to/file.abc")   # == true
  #
  #   Pathname.new("path/to/file.abc").rename_extname(".xyz")
  #     # == Pathname.new("path/to/file.xyz")
  #
  #   File.exist?("path/to/file.abc")   # == false
  #   File.exist?("path/to/file.xyz")   # == true
  #
  # @example remove extension
  #   File.exist?("path/to/file.abc")   # == true
  #
  #   Pathname.new("path/to/file.abc").rename_extname("")
  #     # == Pathname.new("path/to/file")
  #
  #   File.exist?("path/to/file.abc")   # == false
  #   File.exist?("path/to/file")       # == true
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

  # Writes given text to the file indicated by the Pathname, and returns
  # the Pathname.  The file is overwritten if it already exists.  Any
  # necessary parent directories are created if they do not exist.
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
  # @return [Pathname]
  def write_text(text)
    self.make_dirname.open('w'){|f| f.write(text) }
    self
  end

  # Appends given text to the file indicated by the Pathname, and
  # returns the Pathname.  The file is created if it does not exist.
  # Any necessary parent directories are created if they do not exist.
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
  # @return [Pathname]
  def append_text(text)
    self.make_dirname.open('a'){|f| f.write(text) }
    self
  end

  # Writes each object as a string plus a succeeding new line character
  # (<code>$/</code>) to the file indicated by the Pathname.  Returns
  # the Pathname.  The file is overwritten if it already exists.  Any
  # necessary parent directories are created if they do not exist.
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
  # @return [Pathname]
  def write_lines(lines)
    self.make_dirname.open('w'){|f| f.write_lines(lines) }
    self
  end

  # Appends each object as a string plus a succeeding new line character
  # (<code>$/</code>) to the file indicated by the Pathname.  Returns
  # the Pathname.  The file is created if it does not exist.  Any
  # necessary parent directories are created if they do not exist.
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
  # @return [Pathname]
  def append_lines(lines)
    self.make_dirname.open('a'){|f| f.write_lines(lines) }
    self
  end

  # Alias of +Pathname#read+.
  #
  # @return [String]
  alias :read_text :read

  # Reads from the file indicated by the Pathname all lines, and returns
  # them as an array, end-of-line characters excluded.  The
  # <code>$/</code> global string specifies what end-of-line characters
  # to look for.  See also {IO#read_lines}.
  #
  # (Not to be confused with +Pathname#readlines+ which retains
  # end-of-line characters in every string it returns.)
  #
  # @example
  #   File.read("path/to/file")                # == "one\ntwo\n"
  #
  #   Pathname.new("path/to/file").read_lines  # == ["one", "two"]
  #
  # @return [Array<String>]
  def read_lines
    self.open('r'){|f| f.read_lines }
  end

  # Reads the contents of the file indicated by the Pathname into memory
  # as a string, and yields the string to the given block for editing.
  # Writes the return value of the block back to the file, overwriting
  # previous contents.  Returns the file's new contents.  See also
  # {File.edit_text}.
  #
  # @example update JSON data file
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
  # @yield [text] edits current file contents
  # @yieldparam text [String] current contents
  # @yieldreturn [String] new contents
  # @return [String]
  def edit_text(&block)
    File.edit_text(self, &block)
  end

  # Reads the contents of the file indicated by the Pathname into memory
  # as an array of lines, and yields the array to the given block for
  # editing.  Writes the return value of the block back to the file,
  # overwriting previous contents.  The <code>$/</code> global string
  # specifies what end-of-line characters to use for both reading and
  # writing.  Returns the array of lines that comprises the file's new
  # contents.  See also {File.edit_lines}.
  #
  # @example dedup lines of file
  #   File.read("entries.txt")  # == "AAA\nBBB\nBBB\nCCC\nAAA\n"
  #
  #   Pathname.new("entries.txt").edit_lines(&:uniq)
  #     # == ["AAA", "BBB", "CCC"]
  #
  #   File.read("entries.txt")  # == "AAA\nBBB\nCCC\n"
  #
  # @yield [lines] edits current file contents
  # @yieldparam lines [Array<String>] current contents
  # @yieldreturn [Array<String>] new contents
  # @return [Array<String>]
  def edit_lines(&block)
    File.edit_lines(self, &block)
  end

  # Appends the contents of another file to the destination indicated by
  # Pathname.  Returns the destination Pathname.
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
  # @return [Pathname]
  def append_file(source)
    self.open('a'){|destination| IO::copy_stream(source, destination) }
    self
  end

end
