# frozen_string_literal: true

class File

  # Computes the longest path that every path in a list has in common.
  #
  # @example
  #   File.common_path(["a/b/x", "a/b/y", "a/b/z"])  # == "a/b/"
  #   File.common_path(["a/b/x", "a/b/y", "a/z"])    # == "a/"
  #   File.common_path(["a/b/x", "a/b/y", "a"])      # == "a"
  #
  # @param paths [Enumerable<String>]
  # @return [String]
  def self.common_path(paths)
    return paths.first if paths.length <= 1
    short, long = paths.minmax
    i = 0
    last = -1
    while i < short.length && short[i] == long[i]
      last = i if short[i] == "/"
      i += 1
    end
    short[0, i == short.length ? i : (last + 1)]
  end

  # Reads from the specified file its contents as a string, and yields
  # the string to the given block for editing.  Writes the return value
  # of the block back to the file, overwriting previous contents.
  # Returns the file's new contents.
  #
  # @example update JSON data file
  #   File.read("data.json")  # == '{"nested":{"key":"value"}}'
  #
  #   File.edit_text("data.json") do |text|
  #     data = JSON.parse(text)
  #     data["nested"]["key"] = "new value"
  #     data.to_json
  #   end                     # == '{"nested":{"key":"new value"}}'
  #
  #   File.read("data.json")  # == '{"nested":{"key":"new value"}}'
  #
  # @param filename [String, Pathname]
  # @yield [text] edits current file contents
  # @yieldparam text [String] current contents
  # @yieldreturn [String] new contents
  # @return [String]
  def self.edit_text(filename)
    self.open(filename, "r+") do |f|
      text = yield f.read
      f.seek(0, IO::SEEK_SET)
      f.write(text)
      f.truncate(f.pos)
      text
    end
  end

  # Reads from the specified file its contents as an array of lines, and
  # yields the array to the given block for editing.  Writes the return
  # value of the block back to the file, overwriting previous contents.
  # End-of-line (EOL) characters are stripped when reading, and appended
  # after each line when writing.  Returns the return value of the
  # block.
  #
  # @example dedup lines of file
  #   File.read("entries.txt")  # == "AAA\nBBB\nBBB\nCCC\nAAA\n"
  #
  #   File.edit_lines("entries.txt", &:uniq)
  #     # == ["AAA", "BBB", "CCC"]
  #
  #   File.read("entries.txt")  # == "AAA\nBBB\nCCC\n"
  #
  # @param filename [String, Pathname]
  # @param eol [String]
  # @yield [lines] edits current file contents
  # @yieldparam lines [Array<String>] current contents
  # @yieldreturn [Array<String>] new contents
  # @return [Array<String>]
  def self.edit_lines(filename, eol: $/)
    self.open(filename, "r+") do |f|
      lines = yield f.read_lines(eol: eol)
      f.seek(0, IO::SEEK_SET)
      f.write_lines(lines, eol: eol)
      f.truncate(f.pos)
      lines
    end
  end

end
