# pleasant_path

A [fluent API] for pleasant file IO, written as extensions to core Ruby
objects.  See API listing below, or browse the [full documentation].

[fluent API]: https://en.wikipedia.org/wiki/Fluent_interface
[full documentation]: https://www.rubydoc.info/gems/pleasant_path/


## Examples

```ruby
# Pluck lines from a file
"log.txt".path.read_lines.grep(/^ERROR /).append_to_file("errors.txt")

# Dedup lines in a file
"names.txt".path.edit_lines(&:uniq)
```


## Core API

The following methods are available:

- [Pathname](https://www.rubydoc.info/gems/pleasant_path/Pathname)
  - [::NULL](https://www.rubydoc.info/gems/pleasant_path/Pathname#NULL-constant)
  - [#^](https://www.rubydoc.info/gems/pleasant_path/Pathname:%5E)
  - [#append_file](https://www.rubydoc.info/gems/pleasant_path/Pathname:append_file)
  - [#append_lines](https://www.rubydoc.info/gems/pleasant_path/Pathname:append_lines)
  - [#append_text](https://www.rubydoc.info/gems/pleasant_path/Pathname:append_text)
  - [#available_name](https://www.rubydoc.info/gems/pleasant_path/Pathname:available_name)
  - [#chdir](https://www.rubydoc.info/gems/pleasant_path/Pathname:chdir)
  - [#common_path](https://www.rubydoc.info/gems/pleasant_path/Pathname:common_path)
  - [#copy](https://www.rubydoc.info/gems/pleasant_path/Pathname:copy)
  - [#copy_as](https://www.rubydoc.info/gems/pleasant_path/Pathname:copy_as)
  - [#copy_into](https://www.rubydoc.info/gems/pleasant_path/Pathname:copy_into)
  - [#delete!](https://www.rubydoc.info/gems/pleasant_path/Pathname:delete%21)
  - [#dir?](https://www.rubydoc.info/gems/pleasant_path/Pathname:dir%3F)
  - [#dirs](https://www.rubydoc.info/gems/pleasant_path/Pathname:dirs)
  - [#dirs_r](https://www.rubydoc.info/gems/pleasant_path/Pathname:dirs_r)
  - [#edit_lines](https://www.rubydoc.info/gems/pleasant_path/Pathname:edit_lines)
  - [#edit_text](https://www.rubydoc.info/gems/pleasant_path/Pathname:edit_text)
  - [#existence](https://www.rubydoc.info/gems/pleasant_path/Pathname:existence)
  - [#files](https://www.rubydoc.info/gems/pleasant_path/Pathname:files)
  - [#files_r](https://www.rubydoc.info/gems/pleasant_path/Pathname:files_r)
  - [#find_dirs](https://www.rubydoc.info/gems/pleasant_path/Pathname:find_dirs)
  - [#find_files](https://www.rubydoc.info/gems/pleasant_path/Pathname:find_files)
  - [#make_dir](https://www.rubydoc.info/gems/pleasant_path/Pathname:make_dir)
  - [#make_dirname](https://www.rubydoc.info/gems/pleasant_path/Pathname:make_dirname)
  - [#make_file](https://www.rubydoc.info/gems/pleasant_path/Pathname:make_file)
  - [#move](https://www.rubydoc.info/gems/pleasant_path/Pathname:move)
  - [#move_as](https://www.rubydoc.info/gems/pleasant_path/Pathname:move_as)
  - [#move_into](https://www.rubydoc.info/gems/pleasant_path/Pathname:move_into)
  - [#parentname](https://www.rubydoc.info/gems/pleasant_path/Pathname:parentname)
  - [#read_lines](https://www.rubydoc.info/gems/pleasant_path/Pathname:read_lines)
  - [#rename_basename](https://www.rubydoc.info/gems/pleasant_path/Pathname:rename_basename)
  - [#rename_extname](https://www.rubydoc.info/gems/pleasant_path/Pathname:rename_extname)
  - [#to_pathname](https://www.rubydoc.info/gems/pleasant_path/Pathname:to_pathname)
  - [#write_lines](https://www.rubydoc.info/gems/pleasant_path/Pathname:write_lines)
  - [#write_text](https://www.rubydoc.info/gems/pleasant_path/Pathname:write_text)
- [String](https://www.rubydoc.info/gems/pleasant_path/String)
  - [#/](https://www.rubydoc.info/gems/pleasant_path/String:%2F)
  - [#append_to_file](https://www.rubydoc.info/gems/pleasant_path/String:append_to_file)
  - [#path](https://www.rubydoc.info/gems/pleasant_path/String:path)
  - [#to_pathname](https://www.rubydoc.info/gems/pleasant_path/String:to_pathname)
  - [#write_to_file](https://www.rubydoc.info/gems/pleasant_path/String:write_to_file)
- [Enumerable](https://www.rubydoc.info/gems/pleasant_path/Enumerable)
  - [#append_to_file](https://www.rubydoc.info/gems/pleasant_path/Enumerable:append_to_file)
  - [#write_to_file](https://www.rubydoc.info/gems/pleasant_path/Enumerable:write_to_file)
- [File](https://www.rubydoc.info/gems/pleasant_path/File)
  - [.common_path](https://www.rubydoc.info/gems/pleasant_path/File.common_path)
  - [.edit_lines](https://www.rubydoc.info/gems/pleasant_path/File.edit_lines)
  - [.edit_text](https://www.rubydoc.info/gems/pleasant_path/File.edit_text)
- [IO](https://www.rubydoc.info/gems/pleasant_path/IO)
  - [#read_lines](https://www.rubydoc.info/gems/pleasant_path/IO:read_lines)
  - [#write_lines](https://www.rubydoc.info/gems/pleasant_path/IO:write_lines)


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

[JSON module]: https://docs.ruby-lang.org/en/master/JSON.html
[YAML module]: https://docs.ruby-lang.org/en/master/YAML.html

The following methods are available:

- Object
  - [write_to_json](https://www.rubydoc.info/gems/pleasant_path/Object:write_to_json)
  - [write_to_yaml](https://www.rubydoc.info/gems/pleasant_path/Object:write_to_yaml)
- Pathname
  - [load_json](https://www.rubydoc.info/gems/pleasant_path/Pathname:load_json)
  - [load_yaml](https://www.rubydoc.info/gems/pleasant_path/Pathname:load_yaml)
  - [read_json](https://www.rubydoc.info/gems/pleasant_path/Pathname:read_json)
  - [read_yaml](https://www.rubydoc.info/gems/pleasant_path/Pathname:read_yaml)


## Installation

Install the [gem](https://rubygems.org/gems/pleasant_path):

```bash
$ gem install pleasant_path
```

Then require in your Ruby code:

```ruby
require "pleasant_path"
```


## Contributing

Run `rake test` to run the tests.


## License

[MIT License](LICENSE.txt)
