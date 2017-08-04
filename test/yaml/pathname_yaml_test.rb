require 'test_helper'
require 'pleasant_path/yaml'

class PathnameYamlTest < Minitest::Test

  def test_read_json
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      file.write(YAML.dump(SERIALIZABLE_DATA))

      assert_raises(Psych::DisallowedClass){ file.read_yaml }
    end

    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      file.write(YAML.dump(SERIALIZABLE_BASIC_DATA))

      assert_equal SERIALIZABLE_BASIC_DATA, file.read_yaml
    end
  end

  def test_load_json
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      file.write(YAML.dump(SERIALIZABLE_DATA))

      assert_equal SERIALIZABLE_DATA, file.load_yaml
    end
  end

end
