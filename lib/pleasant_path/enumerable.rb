module Enumerable

  # Writes the Enumerable as lines to the given file, and returns the
  # Enumerable.  End-of-line (EOL) characters are written after each
  # line.  The file is overwritten if it already exists.  Any necessary
  # parent directories are created if they do not exist.
  #
  # @example
  #   [:one, :two].write_to_file("out.txt")  # == [:one, :two]
  #   File.read("out.txt")                   # == "one\ntwo\n"
  #
  # @param file [String, Pathname]
  # @param eol [String]
  # @return [Enumerable]
  def write_to_file(file, eol: $/)
    file.to_pathname.write_lines(self, eol: eol)
    self
  end

  # Appends the Enumerable as lines to the given file, and returns the
  # Enumerable.  End-of-line (EOL) characters are written after each
  # line.  The file is created if it does not exist.  Any necessary
  # parent directories are created if they do not exist.
  #
  # @example
  #   [:one, :two].append_to_file("out.txt")     # == [:one, :two]
  #   File.read("out.txt")                       # == "one\ntwo\n"
  #   [:three, :four].append_to_file("out.txt")  # == [:three, :four]
  #   File.read("out.txt")                       # == "one\ntwo\nthree\nfour\n"
  #
  # @param file [String, Pathname]
  # @param eol [String]
  # @return [Enumerable]
  def append_to_file(file, eol: $/)
    file.to_pathname.append_lines(self, eol: eol)
    self
  end

end
