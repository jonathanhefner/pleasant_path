class String

  # Converts the string to a +Pathname+ object.
  #
  # @return [Pathname]
  def to_pathname
    Pathname.new(self)
  end

  # Alias of +String#to_pathname+.
  #
  # @return [Pathname]
  alias :path :to_pathname

  # Joins the string and the argument with a directory separator (a la
  # +File.join+) and returns the result as a +Pathname+ object.
  #
  # @example
  #   ("path/to" / "file").to_s #=> "path/to/file"
  #
  # @param child [String]
  # @return [Pathname]
  def /(child)
    self.path / child
  end

  # Treating the string as a path, joins the parent (+dirname+) of the
  # path with the argument, and returns the result as a +Pathname+
  # object.  The mnenomic for this operator is that the resultant path
  # goes up one directory level from the original, then goes down to the
  # directory specified by the argument.  See also +Pathname#^+.
  #
  # @example
  #   ("path/to/file1" ^ "file2").to_s #=> "path/to/file2"
  #
  # @param sibling [Pathname, String]
  # @return [Pathname]
  def ^(sibling)
    self.path ^ sibling
  end

  # Treats the string as a filename pattern, and expands the pattern
  # into matching paths as +Pathname+ objects.  See also +Dir.glob+ and
  # +Pathname.glob+.
  #
  # @return [Array<Pathname>]
  def glob
    Pathname.glob(self)
  end

  # Writes the string to the given file, and returns the string.  The
  # file is overwritten if it already exists.  Any necessary parent
  # directories are created if they do not exist.
  #
  # @param file [String, Pathname]
  # @return [String]
  def write_to_file(file)
    file.to_pathname.write_text(self)
    self
  end

end
