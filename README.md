# pleasant_path

A [fluent API] for pleasant file IO, written as extensions to core Ruby
objects.  See API listing below, or browse the [full documentation].

[fluent API]: https://en.wikipedia.org/wiki/Fluent_interface
[full documentation]: http://www.rubydoc.info/gems/pleasant_path/


## Examples

```ruby
# Filter lines across multiple files
"logs/*.txt".glob.each do |log|
  log.read_lines.grep(/^ERROR /).append_to_file("errors.txt")
end

# Dedup lines in a file
"names.txt".path.edit_lines(&:uniq)
```


## Core API

The following methods are available:

- [Pathname](http://www.rubydoc.info/gems/pleasant_path/Pathname)
  - [::NULL](http://www.rubydoc.info/gems/pleasant_path/Pathname#NULL-constant)
  - [#^](http://www.rubydoc.info/gems/pleasant_path/Pathname:%5E)
  - [#append_file](http://www.rubydoc.info/gems/pleasant_path/Pathname:append_file)
  - [#append_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname:append_lines)
  - [#append_text](http://www.rubydoc.info/gems/pleasant_path/Pathname:append_text)
  - [#common_path](http://www.rubydoc.info/gems/pleasant_path/Pathname:common_path)
  - [#copy](http://www.rubydoc.info/gems/pleasant_path/Pathname:copy)
  - [#copy_into](http://www.rubydoc.info/gems/pleasant_path/Pathname:copy_into)
  - [#delete!](http://www.rubydoc.info/gems/pleasant_path/Pathname:delete%21)
  - [#dir?](http://www.rubydoc.info/gems/pleasant_path/Pathname:dir%3F)
  - [#dir_empty?](http://www.rubydoc.info/gems/pleasant_path/Pathname:dir_empty%3F)
  - [#dirs](http://www.rubydoc.info/gems/pleasant_path/Pathname:dirs)
  - [#dirs_r](http://www.rubydoc.info/gems/pleasant_path/Pathname:dirs_r)
  - [#edit_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname:edit_lines)
  - [#edit_text](http://www.rubydoc.info/gems/pleasant_path/Pathname:edit_text)
  - [#files](http://www.rubydoc.info/gems/pleasant_path/Pathname:files)
  - [#files_r](http://www.rubydoc.info/gems/pleasant_path/Pathname:files_r)
  - [#make_dir](http://www.rubydoc.info/gems/pleasant_path/Pathname:make_dir)
  - [#make_dirname](http://www.rubydoc.info/gems/pleasant_path/Pathname:make_dirname)
  - [#move](http://www.rubydoc.info/gems/pleasant_path/Pathname:move)
  - [#move_into](http://www.rubydoc.info/gems/pleasant_path/Pathname:move_into)
  - [#parentname](http://www.rubydoc.info/gems/pleasant_path/Pathname:parentname)
  - [#read_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname:read_lines)
  - [#rename_basename](http://www.rubydoc.info/gems/pleasant_path/Pathname:rename_basename)
  - [#rename_extname](http://www.rubydoc.info/gems/pleasant_path/Pathname:rename_extname)
  - [#to_pathname](http://www.rubydoc.info/gems/pleasant_path/Pathname:to_pathname)
  - [#touch_file](http://www.rubydoc.info/gems/pleasant_path/Pathname:touch_file)
  - [#write_lines](http://www.rubydoc.info/gems/pleasant_path/Pathname:write_lines)
  - [#write_text](http://www.rubydoc.info/gems/pleasant_path/Pathname:write_text)
- [String](http://www.rubydoc.info/gems/pleasant_path/String)
  - [#/](http://www.rubydoc.info/gems/pleasant_path/String:%2F)
  - [#^](http://www.rubydoc.info/gems/pleasant_path/String:%5E)
  - [#append_to_file](http://www.rubydoc.info/gems/pleasant_path/String:append_to_file)
  - [#glob](http://www.rubydoc.info/gems/pleasant_path/String:glob)
  - [#path](http://www.rubydoc.info/gems/pleasant_path/String:path)
  - [#to_pathname](http://www.rubydoc.info/gems/pleasant_path/String:to_pathname)
  - [#write_to_file](http://www.rubydoc.info/gems/pleasant_path/String:write_to_file)
- [Array](http://www.rubydoc.info/gems/pleasant_path/Array)
  - [#append_to_file](http://www.rubydoc.info/gems/pleasant_path/Array:append_to_file)
  - [#write_to_file](http://www.rubydoc.info/gems/pleasant_path/Array:write_to_file)
- [File](http://www.rubydoc.info/gems/pleasant_path/File)
  - [.common_path](http://www.rubydoc.info/gems/pleasant_path/File.common_path)
  - [.edit_lines](http://www.rubydoc.info/gems/pleasant_path/File.edit_lines)
  - [.edit_text](http://www.rubydoc.info/gems/pleasant_path/File.edit_text)
- [IO](http://www.rubydoc.info/gems/pleasant_path/IO)
  - [#read_lines](http://www.rubydoc.info/gems/pleasant_path/IO:read_lines)
  - [#write_lines](http://www.rubydoc.info/gems/pleasant_path/IO:write_lines)


## JSON-related and YAML-related API

*pleasant_path* also includes methods for interacting with JSON and YAML
files, using the [JSON module] and [YAML module] that are part of Ruby's
standard library.  Because Ruby does not load these modules by default,
*pleasant_path* does not load its JSON-related and YAML-related API by
default either.  To load these *pleasant_path* APIs **and** the relevant
standard library modules, use:

```ruby
require "pleasant_path/json"
require "pleasant_path/yaml"
```

[JSON module]: https://ruby-doc.org/stdlib/libdoc/json/rdoc/JSON.html
[YAML module]: https://ruby-doc.org/stdlib/libdoc/yaml/rdoc/YAML.html

The following methods are available:

- Object
  - [write_to_json](http://www.rubydoc.info/gems/pleasant_path/Object:write_to_json)
  - [write_to_yaml](http://www.rubydoc.info/gems/pleasant_path/Object:write_to_yaml)
- Pathname
  - [load_json](http://www.rubydoc.info/gems/pleasant_path/Pathname:load_json)
  - [load_yaml](http://www.rubydoc.info/gems/pleasant_path/Pathname:load_yaml)
  - [read_json](http://www.rubydoc.info/gems/pleasant_path/Pathname:read_json)
  - [read_yaml](http://www.rubydoc.info/gems/pleasant_path/Pathname:read_yaml)


## Installation

Install from [Ruby Gems](https://rubygems.org/gems/pleasant_path):

```bash
$ gem install pleasant_path
```

Then require in your Ruby script:

```ruby
require "pleasant_path"
```


## Contributing

Run `rake test` to run the tests.  You can also run `rake irb` for an
interactive prompt that pre-loads the project code.


## License

[MIT License](https://opensource.org/licenses/MIT)
