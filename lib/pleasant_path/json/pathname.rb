# frozen_string_literal: true

class Pathname

  # Reads the file indicated by the Pathname, and parses the contents as
  # JSON.  The returned result will be composed of only basic data
  # types, e.g. +nil+, +true+, +false+, +Numeric+, +String+, +Array+,
  # and +Hash+.
  #
  # For information about +options+, see
  # {https://docs.ruby-lang.org/en/master/JSON.html#method-i-parse
  # +JSON.parse+}.  By default, this method uses
  # {https://docs.ruby-lang.org/en/master/JSON.html#attribute-c-load_default_options
  # +JSON.load_default_options+} plus +create_additions: false+.
  #
  # @example
  #   File.write("file.json", '{"key": "value"}')
  #
  #   Pathname.new("file.json").read_json  # == { "key" => "value" }
  #
  # @param options [Hash{Symbol => Object}]
  # @return [nil, true, false, Numeric, String, Symbol, Array, Hash]
  def read_json(options = {})
    JSON.load(self, nil, { create_additions: false, **options })
  end

  # Reads the file indicated by the Pathname, and parses the contents as
  # JSON, deserializing arbitrary data types via type information
  # embedded in the JSON.  This is *UNSAFE* for JSON from an untrusted
  # source.  To consume untrusted JSON, use {read_json} instead.
  #
  # For information about +options+, see
  # {https://docs.ruby-lang.org/en/master/JSON.html#method-i-parse
  # +JSON.parse+}.  By default, this method uses
  # {https://docs.ruby-lang.org/en/master/JSON.html#attribute-c-load_default_options
  # +JSON.load_default_options+}.
  #
  # For information about serializing custom types to JSON, see the
  # {https://github.com/flori/json/blob/master/README.md#more-examples
  # JSON readme}.
  #
  # @example
  #   require "json/add/core" # provides Struct#to_json
  #   Point = Struct.new(:x, :y)
  #   point = Point.new(10, 20)
  #   File.write("file.json", point.to_json)
  #
  #   Pathname.new("file.json").load_json  # == Point.new(10, 20)
  #
  # @param options [Hash{Symbol => Object}]
  # @return [Object]
  def load_json(options = {})
    JSON.load(self, nil, options)
  end

end
