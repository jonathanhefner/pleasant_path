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

  # Alias of +Pathname#directory?+.
  #
  # @return [Boolean]
  alias :dir? :directory?

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

  # Moves the file indicated by Pathname to the given destination, and
  # returns that destination as a Pathname.  Creates any necessary
  # parent directories if they do not exist.
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def move(destination)
    destination = destination.to_pathname
    destination.make_dirname
    self.rename(destination)
    destination
  end

  # Moves the file indicated by Pathname into the given directory, and
  # returns the resultant path to the file as a Pathname.  Creates any
  # necessary parent directories if they do not exist.
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

end
