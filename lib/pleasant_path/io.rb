class IO

  # Writes each string plus a succeeding new line character
  # (<code>$/</code>) to the IO.  Returns the lines unmodified.
  #
  # @param lines [Array<String>]
  # @return [Array<String>]
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
  # specifies what end-of-line characters to look for.
  #
  # (Not to be confused with +IO#readlines+ which retains end-of-line
  # characters in every string it returns.)
  #
  # @return [Array<String>]
  def read_lines
    self.readlines.each(&:chomp!)
  end

end
