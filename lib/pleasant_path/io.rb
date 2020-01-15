# frozen_string_literal: true

class IO

  # Writes each object in +lines+ as a string plus +eol+ (end-of-line)
  # characters to the IO.  Returns +lines+, unmodified.
  #
  # @example
  #   File.open("out.txt") do |io|
  #     io.write_lines([:one, :two])  # == [:one, :two]
  #   end                             # == [:one, :two]
  #
  #   File.read("out.txt")            # == "one\ntwo\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @param eol [String]
  # @return [lines]
  def write_lines(lines, eol: $/)
    lines.each do |line|
      self.write(line)
      self.write(eol)
    end
    self.write("") # write something even if no lines
    lines
  end

  # Reads all lines from the IO, and returns them with +eol+
  # (end-of-line) characters stripped.
  #
  # @note Not to be confused with +IO#readlines+, which retains
  #   end-of-line characters.
  #
  # @example
  #   File.read("in.txt")          # == "one\ntwo\n"
  #
  #   File.open("in.txt") do |io|
  #     io.read_lines              # == ["one", "two"]
  #   end                          # == ["one", "two"]
  #
  # @param eol [String]
  # @return [Array<String>]
  def read_lines(eol: $/)
    self.readlines(eol, chomp: true)
  end

end
