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

end
