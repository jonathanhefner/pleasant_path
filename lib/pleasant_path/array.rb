class Array

  # Writes the array as lines to the given file, and returns the array.
  # A new line character (<code>$/</code>) is written after each line.
  # The file is overwritten if it already exists.  Any necessary parent
  # directories are created if they do not exist.
  #
  # @param file [String, Pathname]
  # @return [Array]
  def write_to_file(file)
    file.to_pathname.write_lines(self)
    self
  end

end
