class File

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
    self.open(filename, 'r+') do |f|
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
  # The <code>$/</code> global string specifies what end-of-line
  # characters to use for both reading and writing.  Returns the array
  # of lines that comprises the file's new contents.
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
  # @yield [lines] edits current file contents
  # @yieldparam lines [Array<String>] current contents
  # @yieldreturn [Array<String>] new contents
  # @return [Array<String>]
  def self.edit_lines(filename)
    self.open(filename, 'r+') do |f|
      lines = yield f.read_lines
      f.seek(0, IO::SEEK_SET)
      f.write_lines(lines)
      f.truncate(f.pos)
      lines
    end
  end

end
