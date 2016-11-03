class File

  # Reads from the specified file its contents as a string, and yields
  # the string to the given block for editing.  Writes the return value
  # of the block back to the file, overwriting previous contents.
  # Returns the file's new contents.
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
    end
  end

end
