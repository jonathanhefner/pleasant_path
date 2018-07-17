require "test_helper"
require "pleasant_path/yaml"

class ObjectYamlTest < Minitest::Test

  def test_write_to_yaml
    SERIALIZABLE_DATA.each do |data|
      with_deep_path do |file|
        assert_equal data, data.write_to_yaml(file)
        assert_equal data, file.open("r"){|f| YAML.load(f) }
      end
    end
  end

end
