class Object

  # Writes the Object serialized as JSON to the specified +file+,
  # overwriting the file if it exists.  Creates the file if it does not
  # exist, including any necessary parent directories.  Returns the
  # Object, unmodified.
  #
  # For information about +options+ see
  # {https://docs.ruby-lang.org/en/master/JSON.html#method-i-generate
  # +JSON.generate+}.  By default, this method uses the default options
  # for {https://docs.ruby-lang.org/en/master/JSON.html#method-i-dump
  # +JSON.dump+}.
  #
  # @example
  #   { "key" => "value" }.write_to_json("file.json")  # == { "key" => "value" }
  #   File.read("file.json")                           # == '{"key":"value"}'
  #
  # @param file [String, Pathname]
  # @param options [Hash{Symbol => Object}]
  # @return [self]
  def write_to_json(file, options = {})
    file.to_pathname.write_text(JSON.dump(self, nil, nil, options))
    self
  end

end
