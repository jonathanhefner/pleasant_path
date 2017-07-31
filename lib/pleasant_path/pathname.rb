class Pathname

  # Returns the Pathname unmodified.  Exists for parity with
  # +String#to_pathname+.
  #
  # @return [Pathname]
  def to_pathname
    self
  end

  # Joins the parent (+dirname+) of the Pathname with the argument.  The
  # mnenomic for this operator is that the resultant path goes up one
  # directory level from the original, then goes down to the directory
  # specified by the argument.
  #
  # @example
  #   (Pathname.new("path/to/file1") ^ "file2").to_s #=> "path/to/file2"
  #
  # @param sibling [Pathname, String]
  # @return [Pathname]
  def ^(sibling)
    self.dirname / sibling
  end

  # Returns the +basename+ of the Pathname's parent directory.
  #
  # @example
  #   Pathname.new("path/to/file").parentname.to_s #=> "to"
  #
  # @return [Pathname]
  def parentname
    self.dirname.basename
  end

  # Alias of +Pathname#directory?+.
  #
  # @return [Boolean]
  alias :dir? :directory?

  # True if the directory indicated by the Pathname contains no other
  # directories or files.
  #
  # @return [Boolean]
  def dir_empty?
    self.children(false).empty?
  end

  # Returns the immediate (non-recursive) child directories of the
  # directory indicated by the Pathname.  Returned Pathnames are
  # prefixed by the original Pathname.
  #
  # @return [Array<Pathname>]
  def dirs
    self.children.tap{|c| c.select!(&:dir?) }
  end

  # Returns the recursively descended child directories of the
  # directory indicated by the Pathname.  Returned Pathnames are
  # prefixed by the original Pathname.
  #
  # @return [Array<Pathname>]
  def dirs_r
    self.find.select(&:dir?).tap(&:shift)
  end

  # Returns the immediate (non-recursive) child files of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname.
  #
  # @return [Array<Pathname>]
  def files
    self.children.tap{|c| c.select!(&:file?) }
  end

  # Returns the recursively descended child files of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname.
  #
  # @return [Array<Pathname>]
  def files_r
    self.find.select(&:file?)
  end

  # Alias of +Pathname#mkpath+, but this method returns the Pathname.
  #
  # @return [Pathname]
  def make_dir
    self.mkpath
    self
  end

  # Creates the parent (+dirname+) directories of the Pathname if they
  # do not exist, and returns the Pathname.
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
  # @param directory [Pathname, String]
  # @return [Pathname]
  def move_into(directory)
    self.move(directory / self.basename)
  end

  # Writes given text to the file indicated by the Pathname, and returns
  # the Pathname.  The file is overwritten if it already exists.  Any
  # necessary parent directories are created if they do not exist.
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
  # @param text [String]
  # @return [Pathname]
  def append_text(text)
    self.make_dirname.open('a'){|f| f.write(text) }
    self
  end

  # Writes given lines of text to the file indicated by the Pathname,
  # and returns the Pathname.  A new line character (<code>$/</code>) is
  # written after each line.  The file is overwritten if it already
  # exists.  Any necessary parent directories are created if they do not
  # exist.
  #
  # @param lines [Array<String>]
  # @return [Pathname]
  def write_lines(lines)
    self.make_dirname.open('w'){|f| f.write_lines(lines) }
    self
  end

  # Appends given lines of text to the file indicated by the Pathname,
  # and returns the Pathname.  A new line character (<code>$/</code>) is
  # written after each line.  The file is created if it does not exist.
  # Any necessary parent directories are created if they do not exist.
  #
  # @param lines [Array<String>]
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
  # to look for.  See also +IO#read_lines+.
  #
  # (Not to be confused with +Pathname#readlines+ which retains
  # end-of-line characters in every string it returns.)
  #
  # @return [Array<String>]
  def read_lines
    self.open('r'){|f| f.read_lines }
  end

  # Reads the contents of the file indicated by the Pathname into memory
  # as a string, and yields the string to the given block for editing.
  # Writes the return value of the block back to the file, overwriting
  # previous contents.  Returns the file's new contents.  See also
  # +File.edit_text+.
  #
  # @example Update YAML data file
  #   path.edit_text do |text|
  #     data = YAML.load(text)
  #     data['deeply']['nested']['key'] = 'new value'
  #     data.to_yaml
  #   end
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
  # contents.  See also +File.edit_lines+.
  #
  # @example Dedup lines of file
  #   path.edit_lines(&:uniq)
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
  # @param source [String, Pathname]
  # @return [Pathname]
  def append_file(source)
    self.open('a'){|destination| IO::copy_stream(source, destination) }
    self
  end

end
