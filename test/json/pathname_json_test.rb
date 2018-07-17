require "test_helper"
require "pleasant_path/json"
require "json/add/core"

class PathnameJsonTest < Minitest::Test

  def test_read_json
    with_temp_file(JSON.dump(SERIALIZABLE_DATA)) do |file|
      result = file.read_json
      refute_equal SERIALIZABLE_DATA, result
      assert_equal SERIALIZABLE_BASIC_DATA, (result & SERIALIZABLE_BASIC_DATA)
    end
  end

  def test_read_json_with_options
    with_temp_file('{ "foo": 42 }') do |file|
      assert_instance_of OpenStruct, file.read_json(object_class: OpenStruct)
    end
  end

  def test_load_json
    with_temp_file(JSON.dump(SERIALIZABLE_DATA)) do |file|
      assert_equal SERIALIZABLE_DATA, file.load_json
    end
  end

  def test_read_load_with_options
    with_temp_file('{ "foo": 42 }') do |file|
      assert_instance_of OpenStruct, file.load_json(object_class: OpenStruct)
    end
  end

end
