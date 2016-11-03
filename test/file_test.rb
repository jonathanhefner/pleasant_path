require 'test_helper'

class PleasantPath::FileTest < Minitest::Test

  def test_edit_text
    Dir.mktmpdir do |tmp|
      file = Pathname.new(tmp) / 'file'
      text = "line 1\nline 2\n"

      file.write(text)
      assert_equal text.reverse, File.edit_text(file, &:reverse)
      assert_equal text.reverse, file.read
    end
  end

end
