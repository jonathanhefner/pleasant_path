# frozen_string_literal: true

class IO

  # Writes each object as a string plus end-of-line (EOL) characters to
  # the IO.  Returns the objects unmodified.
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
  # @param eol [String]
  # @return [Enumerable<#to_s>]
  def write_lines(lines, eol: $/)
    lines.each do |line|
      self.write(line)
      self.write(eol)
    end
    self.write("") # write something even if no lines
    lines
  end

  # Reads from the IO all lines, and returns them as an array, with all
  # end-of-line (EOL) characters stripped.
  #
  # (Not to be confused with +IO#readlines+ which retains end-of-line
  # (EOL) characters in every string it returns.)
  #
  # @example
  #   # NOTE File inherits from IO
  #   File.read("in.txt")            # == "one\ntwo\n"
  #
  #   File.open("in.txt") do |file|
  #     file.read_lines              # == ["one", "two"]
  #   end                            # == ["one", "two"]
  #
  # @param eol [String]
  # @return [Array<String>]
  def read_lines(eol: $/)
    self.readlines(eol, chomp: true)
  end

end
