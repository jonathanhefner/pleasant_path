require "test_helper"
require "pleasant_path/json"
require "json/add/core"

class ObjectJsonTest < Minitest::Test

  def test_write_to_json
    SERIALIZABLE_DATA.each do |data|
      with_tmp_file(false) do |file|
        assert_equal data, data.write_to_json(file)
        assert_equal data, JSON.load(file)
      end
    end
  end

  def test_write_to_json_with_options
    with_tmp_file do |file|
      Float::NAN.write_to_json(file, allow_nan: true) # no error
      assert_raises(JSON::GeneratorError) do
        Float::NAN.write_to_json(file, allow_nan: false)
      end
    end
  end

end
