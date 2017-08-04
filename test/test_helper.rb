$/ = "\n"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pleasant_path'

require 'minitest/autorun'

class Minitest::Test

  SERIALIZABLE_BASIC_DATA = [
    true,
    false,
    9001,
    "bare string",
    [1, 2, 3],
    { "key1" => "value1", "key2" => "value2" },
    { "nested" => { "key" => "value" } },
  ].freeze

  Point = Struct.new(:x, :y)

  SERIALIZABLE_DATA = [
    *SERIALIZABLE_BASIC_DATA,
    :bare_symbol,
    Point.new(10, 20),
    { "top_left" => Point.new(1, 2), "bottom_right" => Point.new(3, 4) },
  ].freeze

  def assert_same_elements(expected, actual)
    assert_equal(expected.sort, actual.sort)
  end

end
