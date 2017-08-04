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

  def with_temp_file(contents = nil)
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / "file"
      file.write(contents) if contents
      yield file
    end
  end

  def with_deep_path(path_type = nil)
    Dir.mktmpdir do |tmp|
      path = Pathname.new(tmp) / "deeply/nested/thing"

      if path_type == :dir
        path.mkpath
      elsif path_type == :file
        path.dirname.mkpath
        FileUtils.touch(path)
      elsif path_type
        raise "Unrecognized path_type: #{path_type}"
      end

      yield path
    end
  end

end
