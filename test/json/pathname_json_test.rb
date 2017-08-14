require 'test_helper'
require 'pleasant_path/json'
require 'json/add/core'

class PathnameJsonTest < Minitest::Test

  def test_read_json
    with_temp_file(JSON.dump(SERIALIZABLE_DATA)) do |file|
      result = file.read_json
      refute_equal SERIALIZABLE_DATA, result
      assert_equal SERIALIZABLE_BASIC_DATA, (result & SERIALIZABLE_BASIC_DATA)
    end
  end

  def test_read_json_with_options
    with_temp_file("42") do |file|
      assert_equal 42, file.read_json(quirks_mode: true)
      assert_raises(JSON::ParserError) do
        file.read_json(quirks_mode: false)
      end
    end
  end

  def test_load_json
    with_temp_file(JSON.dump(SERIALIZABLE_DATA)) do |file|
      assert_equal SERIALIZABLE_DATA, file.load_json
    end
  end

  def test_read_load_with_options
    with_temp_file("42") do |file|
      assert_equal 42, file.load_json(quirks_mode: true)
      assert_raises(JSON::ParserError) do
        file.load_json(quirks_mode: false)
      end
    end
  end

end