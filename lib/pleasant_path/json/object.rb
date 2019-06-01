class Object

  # Dumps the Object as JSON, and writes the JSON to the specified file.
  # Returns the Object unmodified.
  #
  # For information about available options see
  # {http://ruby-doc.org/stdlib/libdoc/json/rdoc/JSON.html#method-i-generate
  # +JSON.generate+}.
  #
  # @example
  #   { "key" => "value" }.write_to_json("out.json")  # == { "key" => "value" }
  #   File.read("out.json")                           # == '{"key":"value"}'
  #
  # @param file [String, Pathname]
  # @param options [Hash]
  # @return [self]
  def write_to_json(file, options = {})
    options = JSON.dump_default_options.merge(options)
    file.to_pathname.write_text(self.to_json(options))
    self
  end

end
