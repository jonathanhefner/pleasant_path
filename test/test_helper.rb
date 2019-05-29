$/ = "\n"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pleasant_path"

require "minitest/autorun"

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

  def with_tmp_dir(make = true)
    Dir.mktmpdir do |tmp|
      dir = Pathname.new(tmp) / "deeply/nested/dir"
      dir.mkpath if make
      yield dir
    end
  end

  def with_tmp_file(make = true)
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / "deeply/nested/file.ext"
      if make
        file.dirname.mkpath
        FileUtils.touch(file)
      end
      yield file
    end
  end

end
