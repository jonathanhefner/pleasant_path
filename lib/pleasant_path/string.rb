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

end
