class IO

  # Writes each object as a string plus a succeeding new line character
  # (<code>$/</code>) to the IO.  Returns the objects unmodified.
  #
  # @example
  #   # NOTE File inherits from IO
  #   File.open("out.txt") do |file|
  #     file.write_lines([:one, :two])  # == [:one, :two]
  #   end                               # == [:one, :two]
  #
  #   File.read("out.txt")              # == "one\ntwo\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @return [Enumerable<#to_s>]
  def write_lines(lines)
    lines.each do |line|
      self.write(line)
      self.write($/)
    end
    self.write('') # write something even if no lines
    lines
  end

  # Reads from the IO all lines, and returns them as an array,
  # end-of-line characters excluded.  The <code>$/</code> global string
  # specifies what end-of-line characters to exclude.
  #
  # (Not to be confused with +IO#readlines+ which retains end-of-line
  # characters in every string it returns.)
  #
  # @example
  #   # NOTE File inherits from IO
  #   File.read("in.txt")            # == "one\ntwo\n"
  #
  #   File.open("in.txt") do |file|
  #     file.read_lines              # == ["one", "two"]
  #   end                            # == ["one", "two"]
  #
  # @return [Array<String>]
  def read_lines
    self.readlines.each(&:chomp!)
  end

end
