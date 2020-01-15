# frozen_string_literal: true

class Object

  # Writes the Object serialized as YAML to the specified +file+,
  # overwriting the file if it exists.  Creates the file if it does not
  # exist, including any necessary parent directories.  Returns the
  # Object, unmodified.
  #
  # For information about +options+ see
  # {https://docs.ruby-lang.org/en/master/Psych.html#method-c-dump
  # +YAML.dump+}.
  #
  # @example
  #   { "key" => "value" }.write_to_yaml("file.yaml")  # == { "key" => "value" }
  #   File.read("file.yaml")                           # == "---\nkey: value\n"
  #
  # @param file [String, Pathname]
  # @param options [Hash{Symbol => Object}]
  # @return [self]
  def write_to_yaml(file, options = {})
    file.to_pathname.make_dirname.open("w") do |f|
      YAML.dump(self, f, options)
    end
    self
  end

end
