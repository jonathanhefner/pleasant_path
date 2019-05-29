require "test_helper"
require "pleasant_path/json"
require "json/add/core"

class PathnameJsonTest < Minitest::Test

  def test_read_json
    with_tmp_file do |file|
      file.write(JSON.dump(SERIALIZABLE_DATA))
      result = file.read_json

      refute_equal SERIALIZABLE_DATA, result
      assert_equal SERIALIZABLE_BASIC_DATA, (result & SERIALIZABLE_BASIC_DATA)
    end
  end

  def test_read_json_with_options
    with_tmp_file do |file|
      file.write('{ "foo": 42 }')

      assert_instance_of OpenStruct, file.read_json(object_class: OpenStruct)
    end
  end

  def test_load_json
    with_tmp_file do |file|
      file.write(JSON.dump(SERIALIZABLE_DATA))

      assert_equal SERIALIZABLE_DATA, file.load_json
    end
  end

  def test_load_json_with_options
    with_tmp_file do |file|
      file.write('{ "foo": 42 }')

      assert_instance_of OpenStruct, file.load_json(object_class: OpenStruct)
    end
  end

end
