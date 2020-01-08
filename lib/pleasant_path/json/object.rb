class Object

  # Writes the Object serialized as JSON to the specified +file+,
  # overwriting the file if it exists.  Creates the file if it does not
  # exist, including any necessary parent directories.  Returns the
  # Object, unmodified.
  #
  # For information about +options+ see
  # {https://docs.ruby-lang.org/en/master/JSON.html#method-i-generate
  # +JSON.generate+}.  By default, this method uses
  # {https://docs.ruby-lang.org/en/master/JSON.html#attribute-c-dump_default_options
  # +JSON.dump_default_options+}.
  #
  # @example
  #   { "key" => "value" }.write_to_json("out.json")  # == { "key" => "value" }
  #   File.read("out.json")                           # == '{"key":"value"}'
  #
  # @param file [String, Pathname]
  # @param options [Hash<Symbol, Object>]
  # @return [self]
  def write_to_json(file, options = {})
    options = JSON.dump_default_options.merge(options)
    file.to_pathname.write_text(self.to_json(options))
    self
  end

end
