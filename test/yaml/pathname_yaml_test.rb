require "test_helper"
require "pleasant_path/yaml"

class PathnameYamlTest < Minitest::Test

  def test_read_yaml
    with_tmp_file do |file|
      file.write(YAML.dump(SERIALIZABLE_DATA))

      assert_raises(Psych::DisallowedClass){ file.read_yaml }

      file.write(YAML.dump(SERIALIZABLE_BASIC_DATA))

      assert_equal SERIALIZABLE_BASIC_DATA, file.read_yaml
    end
  end

  def test_load_yaml
    with_tmp_file do |file|
      file.write(YAML.dump(SERIALIZABLE_DATA))

      assert_equal SERIALIZABLE_DATA, file.load_yaml
    end
  end

end
