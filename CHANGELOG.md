## 2.0.0

* [BREAKING] Drop support for Ruby < 2.6
* [BREAKING] Remove `Pathname#dir_empty?`
  * Use `Pathname#empty?` instead
* [BREAKING] Remove `Pathname#touch_file`
  * Use `Pathname#make_file` instead
* [BREAKING] Remove `String#^`
* [BREAKING] Remove `String#glob`
* [BREAKING] Cease creating parent directories in `Pathname#move`
* [BREAKING] Cease creating parent directories in `Pathname#copy`
* [BREAKING] Cease prepending dot in `Pathname#rename_extname`
* [BREAKING] Change `Pathname#edit_text` to return the Pathname
* [BREAKING] Change `Pathname#edit_lines` to return the Pathname


## 1.3.0

* Add `Pathname#find_dirs`
* Add `Pathname#find_files`
* Add `Pathname#make_file`
* Add `Pathname#available_name`
* Add `Pathname#move_as`
* Add `Pathname#copy_as`
* Add `eol` parameter to line-oriented methods (e.g.
  `Pathname#read_lines`, `Pathname#write_lines`, etc)
* Move Array methods to Enumerable
* Use `JSON.dump_default_options` and `JSON.load_default_options` in
  JSON-related API


## 1.2.0

* Add `Pathname#existence`
* Add `Pathname#chdir`
* Fix `Object#write_to_yaml` to create parent directories as necessary


## 1.1.0

* Add `Pathname#copy`
* Add `Pathname#copy_into`
* Add `Pathname#rename_basename`
* Add `Pathname#rename_extname`
* Add `File.common_path`
* Add `Pathname#common_path`
* Add `Pathname::NULL`
* Add JSON-related API
* Add YAML-related API
* Fix `File.edit_text` and `File.edit_lines` to properly truncate


## 1.0.0

* Initial release
