require "test_helper"
require "pleasant_path/yaml"

class ObjectYamlTest < Minitest::Test

  def test_write_to_yaml
    SERIALIZABLE_DATA.each do |data|
      with_tmp_file(false) do |file|
        assert_equal data, data.write_to_yaml(file)
        assert_equal data, YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(file.read) : YAML.load(file.read)
      end
    end
  end

end
