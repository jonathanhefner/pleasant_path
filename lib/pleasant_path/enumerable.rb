module Enumerable

  # Writes each object in the Enumerable as a string plus end-of-line
  # (EOL) characters to the specified +file+, overwriting the file if it
  # exists.  Creates the file if it does not exist, including any
  # necessary parent directories.  Returns the Enumerable.
  #
  # @see Pathname#write_lines
  #
  # @example
  #   [:one, :two].write_to_file("out.txt")  # == [:one, :two]
  #   File.read("out.txt")                   # == "one\ntwo\n"
  #
  # @param file [String, Pathname]
  # @param eol [String]
  # @return [self]
  def write_to_file(file, eol: $/)
    file.to_pathname.write_lines(self, eol: eol)
    self
  end

  # Appends each object in the Enumerable as a string plus end-of-line
  # (EOL) characters to the specified +file+.  Creates the file if it
  # does not exist, including any necessary parent directories.  Returns
  # the Enumerable.
  #
  # @see Pathname#append_lines
  #
  # @example
  #   [:one, :two].append_to_file("out.txt")     # == [:one, :two]
  #   File.read("out.txt")                       # == "one\ntwo\n"
  #   [:three, :four].append_to_file("out.txt")  # == [:three, :four]
  #   File.read("out.txt")                       # == "one\ntwo\nthree\nfour\n"
  #
  # @param file [String, Pathname]
  # @param eol [String]
  # @return [self]
  def append_to_file(file, eol: $/)
    file.to_pathname.append_lines(self, eol: eol)
    self
  end

end
