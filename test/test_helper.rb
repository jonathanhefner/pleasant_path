$/ = "\n"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pleasant_path'

require 'minitest/autorun'

class Minitest::Test

  def assert_same_elements(expected, actual)
    assert_equal(expected.sort, actual.sort)
  end

end
