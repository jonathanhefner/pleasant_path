class Array

  # Writes the array as lines to the given file, and returns the array.
  # A new line character (<code>$/</code>) is written after each line.
  # The file is overwritten if it already exists.  Any necessary parent
  # directories are created if they do not exist.
  #
  # @example
  #   [:one, :two].write_to_file("out.txt")  # == [:one, :two]
  #   File.read("out.txt")                   # == "one\ntwo\n"
  #
  # @param file [String, Pathname]
  # @return [Array]
  def write_to_file(file)
    file.to_pathname.write_lines(self)
    self
  end

  # Appends the array as lines to the given file, and returns the array.
  # A new line character (<code>$/</code>) is written after each line.
  # The file is created if it does not exist.  Any necessary parent
  # directories are created if they do not exist.
  #
  # @example
  #   [:one, :two].append_to_file("out.txt")     # == [:one, :two]
  #   File.read("out.txt")                       # == "one\ntwo\n"
  #   [:three, :four].append_to_file("out.txt")  # == [:three, :four]
  #   File.read("out.txt")                       # == "one\ntwo\nthree\nfour\n"
  #
  # @param file [String, Pathname]
  # @return [Array]
  def append_to_file(file)
    file.to_pathname.append_lines(self)
    self
  end

end
