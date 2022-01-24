# frozen_string_literal: true

class Pathname

  # Reads the file indicated by the Pathname, and parses the contents as
  # YAML.  The returned result will be composed of only basic data
  # types, e.g. +nil+, +true+, +false+, +Numeric+, +String+, +Array+,
  # and +Hash+.
  #
  # @example
  #   File.write("file.yaml", "key: value")
  #
  #   Pathname.new("file.yaml").read_yaml  # == { "key" => "value" }
  #
  # @return [nil, true, false, Numeric, String, Array, Hash]
  def read_yaml
    self.open("r"){|f| YAML.safe_load(f, filename: self) }
  end

  # Reads the file indicated by the Pathname, and parses the contents as
  # YAML, deserializing arbitrary data types via type information
  # embedded in the YAML.  This is *UNSAFE* for YAML from an untrusted
  # source.  To consume untrusted YAML, use {read_yaml} instead.
  #
  # @example
  #   Point = Struct.new(:x, :y)
  #   point = Point.new(10, 20)
  #   File.write("file.yaml", point.to_yaml)
  #
  #   Pathname.new("file.yaml").load_yaml  # == Point.new(10, 20)
  #
  # @return [Object]
  def load_yaml
    YAML.respond_to?(:unsafe_load_file) ? YAML.unsafe_load_file(self) : YAML.load_file(self)
  end

end
