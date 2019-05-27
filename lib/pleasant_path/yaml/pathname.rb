# frozen_string_literal: true

class Pathname

  # Reads the contents of the file indicated by the Pathname, and parses
  # it as YAML.  The returned result will be a basic Ruby data
  # structure, namely, one of: +nil+, +true+, +false+, a +Numeric+, a
  # +String+, an +Array+, or a +Hash+.
  #
  # @example
  #   File.write("in.yaml", "key: value")
  #
  #   Pathname.new("in.yaml").read_yaml  # == { "key" => "value" }
  #
  # @return [nil, true, false, Numeric, String, Array, Hash]
  def read_yaml
    self.open("r") do |f|
      # HACK fix Ruby 2.6 warning, but still support Ruby < 2.6
      if Gem::Version.new(Psych::VERSION) >= Gem::Version.new("3.1.0.pre1")
        YAML.safe_load(f, filename: self)
      else
        YAML.safe_load(f, [], [], false, self)
      end
    end
  end

  # Reads the contents of the file indicated by the Pathname, and parses
  # it as YAML.  The parser will use type information embedded in the
  # YAML to deserialize custom types.  This is *UNSAFE* for YAML from
  # an untrusted source.  To consume untrusted YAML, use
  # {Pathname#read_yaml} instead.
  #
  # @example
  #   Point = Struct.new(:x, :y)
  #   point = Point.new(10, 20)
  #   File.write("in.yaml", point.to_yaml)
  #
  #   Pathname.new("in.yaml").load_yaml  # == Point.new(10, 20)
  #
  # @return deserialized object
  def load_yaml
    YAML.load_file(self)
  end

end
