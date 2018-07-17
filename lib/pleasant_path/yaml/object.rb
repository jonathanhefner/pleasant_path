class Object

  # Dumps the Object as YAML, and writes the YAML to the specified file.
  # Returns the Object unmodified.
  #
  # For information about available options see
  # {https://ruby-doc.org/stdlib/libdoc/psych/rdoc/Psych.html#method-c-dump
  # +YAML.dump+}.
  #
  # @example
  #   { "key" => "value" }.write_to_yaml("out.yaml")  # == { "key" => "value" }
  #   File.read("out.yaml")                           # == "---\nkey: value\n"
  #
  # @param file [String, Pathname]
  # @param options [Hash]
  # @return [self]
  def write_to_yaml(file, options = {})
    file.to_pathname.make_dirname.open("w") do |f|
      YAML.dump(self, f, options)
    end
    self
  end

end
