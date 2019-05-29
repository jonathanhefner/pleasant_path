require "test_helper"

class PleasantPath::FileTest < Minitest::Test

  def test_edit_text
    text = "  abcdef  "

    with_tmp_file do |file|
      file.write(text)

      assert_equal text.strip, File.edit_text(file, &:strip)
      assert_equal text.strip, file.read
    end
  end

  def test_edit_lines
    text = "AAA\nBBB\nBBB\nAAA\nCCC\n"
    lines = text.split("\n")

    with_tmp_file do |file|
      file.write(text)

      assert_equal lines.uniq, File.edit_lines(file, &:uniq)
      assert_equal lines.uniq, file.read.split("\n")
    end
  end

  def test_common_path
    [ ["aaa/bbb/xxx", "aaa/bbb/yyy", "aaa/bbb/zzz"],
      ["aaa/bbb/xxx", "aaa/bbb/yyy", "aaa/zzz"],
      ["aaa/bbb/xxx", "aaa/bbb/yyy", "aaa"],
      ["aaa/bbb/xxx", "aaa/bbb/yyy", "zzz"],
      ["aaa/bbb", "bbb/aaa"],
    ].each do |paths|
      result = File.common_path(paths)

      assert paths.all?{|path| path.start_with?(result) }

      refute paths.all?{|path| path[result.length] == "/" }

      depth = result.split("/").length
      alternatives = paths.map{|path| path.split("/").take(depth + 1).join("/") } - [result]
      refute alternatives.any?{|alt| paths.all?{|path| path.start_with?(alt) } }
    end
  end

end
