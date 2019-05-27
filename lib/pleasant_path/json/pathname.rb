# frozen_string_literal: true

class Pathname

  # Reads the contents of the file indicated by the Pathname, and parses
  # it as JSON.  The returned result will be a basic Ruby data
  # structure, namely, one of: +nil+, +true+, +false+, a +Numeric+, a
  # +String+, an +Array+, or a +Hash+.
  #
  # For information about available options, see
  # {http://ruby-doc.org/stdlib/libdoc/json/rdoc/JSON.html#method-i-parse
  # +JSON.parse+}.
  #
  # @example
  #   File.write("in.json", '{"key": "value"}')
  #
  #   Pathname.new("in.json").read_json  # == { "key" => "value" }
  #
  # @param options [Hash]
  # @return [nil, true, false, Numeric, String, Symbol, Array, Hash]
  def read_json(options = {})
    options = {
      quirks_mode: true,
      allow_nan: true,
      max_nesting: false,
      create_additions: false,
    }.merge(options)

    JSON.parse(self.read_text, options)
  end

  # Reads the contents of the file indicated by the Pathname, and parses
  # it as JSON.  The parser will use type information embedded in the
  # JSON to deserialize custom types.  This is *UNSAFE* for JSON from
  # an untrusted source.  To consume untrusted JSON, use
  # {Pathname#read_json} instead.
  #
  # For information about available options, see
  # {http://ruby-doc.org/stdlib/libdoc/json/rdoc/JSON.html#method-i-parse
  # +JSON.parse+}.
  #
  # For information about serializing custom types to JSON, see the
  # {https://github.com/flori/json/blob/master/README.md#more-examples
  # JSON readme}.
  #
  # @example
  #   require "json/add/core" # provides Struct#to_json
  #   Point = Struct.new(:x, :y)
  #   point = Point.new(10, 20)
  #   File.write("in.json", point.to_json)
  #
  #   Pathname.new("in.json").load_json  # == Point.new(10, 20)
  #
  # @param options [Hash]
  # @return deserialized object
  def load_json(options = {})
    self.open("r"){|f| JSON.load(f, nil, options) }
  end

end
