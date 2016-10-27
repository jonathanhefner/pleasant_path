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

end
