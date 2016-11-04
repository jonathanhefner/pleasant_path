# pleasant_path

A [fluent API] for pleasant file IO, written as extensions to core Ruby
objects.  See method listing below or browse the [full documentation].

[fluent API]: https://en.wikipedia.org/wiki/Fluent_interface
[full documentation]: http://www.rubydoc.info/gems/pleasant_path/


## Examples

```ruby
# Dedup lines in a file
"line_items.txt".path.edit_lines(&:uniq)

# Filter lines across multiple files
"logs/*.txt".glob.each do |log|
  log.read_lines.grep(/Error/).append_to_file('errors.txt')
end
```


## API Methods

- Pathname
  - [^](http://www.rubydoc.info/gems/pleasant_path/Pathname%3A%5E)
  - [append_file](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aappend_file)
  - [append_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aappend_lines)
  - [append_text](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aappend_text)
  - [delete!](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Adelete%21)
  - [dir_empty?](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Adir_empty%3F)
  - [dirs](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Adirs)
  - [dirs_r](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Adirs_r)
  - [edit_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aedit_lines)
  - [edit_text](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aedit_text)
  - [files](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Afiles)
  - [files_r](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Afiles_r)
  - [make_dir](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Amake_dir)
  - [make_dirname](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Amake_dirname)
  - [move](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Amove)
  - [move_into](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Amove_into)
  - [parentname](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aparentname)
  - [read_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Aread_lines)
  - [to_pathname](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Ato_pathname)
  - [touch_file](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Atouch_file)
  - [write_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Awrite_lines)
  - [write_text](http://www.rubydoc.info/gems/pleasant_path/Pathname%3Awrite_text)
- String
  - [/](http://www.rubydoc.info/gems/pleasant_path/String%3A%2F)
  - [^](http://www.rubydoc.info/gems/pleasant_path/String%3A%5E)
  - [append_to_file](http://www.rubydoc.info/gems/pleasant_path/String%3Aappend_to_file)
  - [glob](http://www.rubydoc.info/gems/pleasant_path/String%3Aglob)
  - [to_pathname](http://www.rubydoc.info/gems/pleasant_path/String%3Ato_pathname)
  - [write_to_file](http://www.rubydoc.info/gems/pleasant_path/String%3Awrite_to_file)
- Array
  - [append_to_file](http://www.rubydoc.info/gems/pleasant_path/Array%3Aappend_to_file)
  - [write_to_file](http://www.rubydoc.info/gems/pleasant_path/Array%3Awrite_to_file)
- File
  - [edit_lines](http://www.rubydoc.info/gems/pleasant_path/File.edit_lines)
  - [edit_text](http://www.rubydoc.info/gems/pleasant_path/File.edit_text)
- IO
  - [read_lines](http://www.rubydoc.info/gems/pleasant_path/IO%3Aread_lines)
  - [write_lines](http://www.rubydoc.info/gems/pleasant_path/IO%3Awrite_lines)


## Installation

    $ gem install pleasant_path


## Development

Run `rake test` to run the tests.  You can also run `rake irb` for an
interactive prompt that pre-loads the project code.


## License

[MIT License](http://opensource.org/licenses/MIT)
