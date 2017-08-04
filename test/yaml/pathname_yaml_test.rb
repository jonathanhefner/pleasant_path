require 'test_helper'
require 'pleasant_path/yaml'

class PathnameYamlTest < Minitest::Test

  def test_read_json
    with_temp_file(YAML.dump(SERIALIZABLE_DATA)) do |file|
      assert_raises(Psych::DisallowedClass){ file.read_yaml }
    end

    with_temp_file(YAML.dump(SERIALIZABLE_BASIC_DATA)) do |file|
      assert_equal SERIALIZABLE_BASIC_DATA, file.read_yaml
    end
  end

  def test_load_json
    with_temp_file(YAML.dump(SERIALIZABLE_DATA)) do |file|
      assert_equal SERIALIZABLE_DATA, file.load_yaml
    end
  end

end
