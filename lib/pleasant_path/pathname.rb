# frozen_string_literal: true

class Pathname

  # {https://docs.ruby-lang.org/en/master/File/File/Constants.html#NULL
  # +File::NULL+} as a Pathname.  On POSIX systems, this should be
  # equivalent to +Pathname.new("/dev/null")+.
  NULL = Pathname.new(File::NULL)

  # Returns the Pathname unmodified.  Exists for parity with
  # {String#to_pathname}.
  #
  # @return [self]
  def to_pathname
    self
  end

  # Joins the Pathname's +dirname+ with the given +sibling+.
  #
  # The mnemonic for this operator is that the result is formed by going
  # up one directory level from the original path, then going back down
  # to +sibling+.
  #
  # @example
  #   Pathname.new("path/to/file1") ^ "file2"  # == Pathname.new("path/to/file2")
  #
  # @param sibling [Pathname, String]
  # @return [Pathname]
  def ^(sibling)
    self.dirname / sibling
  end

  # Returns the +basename+ of the Pathname's +dirname+.
  #
  # @example
  #   Pathname.new("grand/parent/base").parentname  # == Pathname.new("parent")
  #
  # @return [Pathname]
  def parentname
    self.dirname.basename
  end

  # Returns the Pathname if +exist?+ is true, otherwise returns nil.
  #
  # @example
  #   FileUtils.mkdir("dir1")
  #   FileUtils.touch("dir1/file1")
  #
  #   Pathname.new("dir1/file1").existence  # == Pathname.new("dir1/file1")
  #
  #   Pathname.new("dir1/file2").existence  # == nil
  #
  # @return [self, nil]
  def existence
    self if self.exist?
  end

  # Returns the longest path that the Pathname and +other+ have in
  # common.
  #
  # @see File.common_path
  #
  # @example
  #   f1 = Pathname.new("dir1/file1")
  #   f2 = Pathname.new("dir1/subdir1/file2")
  #   f3 = Pathname.new("dir1/subdir1/file3")
  #   f4 = Pathname.new("dir2/file4")
  #
  #   f1.common_path(f2)  # == Pathname.new("dir1/")
  #   f2.common_path(f3)  # == Pathname.new("dir1/subdir1/")
  #   f3.common_path(f4)  # == Pathname.new("")
  #
  #   [f1, f2, f3].reduce(&:common_path)  # == Pathname.new("dir1/")
  #
  # @param other [Pathname]
  # @return [Pathname]
  def common_path(other)
    File.common_path([self.to_s, other.to_s]).to_pathname
  end

  # Alias of +Pathname#directory?+.
  #
  # @return [Boolean]
  alias :dir? :directory?

  # Returns the direct child directories of the directory indicated by
  # the Pathname.  Returned Pathnames are prefixed by the original
  # Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.mkdir("parent/dir1/dir1")
  #   FileUtils.mkdir("parent/dir2")
  #   FileUtils.touch("parent/file1")
  #
  #   Pathname.new("parent").dirs
  #     # == [
  #     #      Pathname.new("parent/dir1"),
  #     #      Pathname.new("parent/dir2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def dirs
    self.children.tap{|c| c.select!(&:dir?) }
  end

  # Returns all (recursive) descendent directories of the directory
  # indicated by the Pathname.  Returned Pathnames are prefixed by the
  # original Pathname, and are in depth-first order.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.mkdir("parent/dir1/dir1")
  #   FileUtils.mkdir("parent/dir2")
  #   FileUtils.touch("parent/dir2/file1")
  #
  #   Pathname.new("parent").dirs_r
  #     # == [
  #     #      Pathname.new("parent/dir1"),
  #     #      Pathname.new("parent/dir1/dir1"),
  #     #      Pathname.new("parent/dir2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def dirs_r
    self.find_dirs.to_a
  end

  # Iterates over all (recursive) descendent directories of the
  # directory indicated by the Pathname.  Iterated Pathnames are
  # prefixed by the original Pathname, and are in depth-first order.
  #
  # If a block is given, each descendent Pathname is yielded, and this
  # method returns the original Pathname.  Otherwise, an Enumerator is
  # returned.
  #
  # @see https://docs.ruby-lang.org/en/master/Pathname.html#method-i-find Pathname#find
  #
  # @overload find_dirs(&block)
  #   @yieldparam descendent [Pathname]
  #   @return [self]
  #
  # @overload find_dirs()
  #   @return [Enumerator<Pathname>]
  def find_dirs
    return to_enum(__method__) unless block_given?

    self.find do |path|
      if path.file?
        Find.prune
      elsif path != self
        yield path
      end
    end

    self
  end

  # Returns the direct child files of the directory indicated by the
  # Pathname.  Returned Pathnames are prefixed by the original Pathname.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.touch("parent/file1")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.touch("parent/dir1/file1")
  #   FileUtils.touch("parent/file2")
  #
  #   Pathname.new("parent").files
  #     # == [
  #     #      Pathname.new("parent/file1"),
  #     #      Pathname.new("parent/file2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def files
    self.children.tap{|c| c.select!(&:file?) }
  end

  # Returns all (recursive) descendent files of the directory indicated
  # by the Pathname.  Returned Pathnames are prefixed by the original
  # Pathname, and are in depth-first order.
  #
  # @example
  #   FileUtils.mkdir("parent")
  #   FileUtils.touch("parent/file1")
  #   FileUtils.mkdir("parent/dir1")
  #   FileUtils.touch("parent/dir1/file1")
  #   FileUtils.touch("parent/file2")
  #
  #   Pathname.new("parent").files_r
  #     # == [
  #     #      Pathname.new("parent/dir1/file1"),
  #     #      Pathname.new("parent/file1")
  #     #      Pathname.new("parent/file2")
  #     #    ]
  #
  # @return [Array<Pathname>]
  def files_r
    self.find_files.to_a
  end

  # Iterates over all (recursive) descendent files of the directory
  # indicated by the Pathname.  Iterated Pathnames are prefixed by the
  # original Pathname, and are in depth-first order.
  #
  # If a block is given, each descendent Pathname is yielded, and this
  # method returns the original Pathname.  Otherwise, an Enumerator is
  # returned.
  #
  # @see https://docs.ruby-lang.org/en/master/Pathname.html#method-i-find Pathname#find
  #
  # @overload find_files(&block)
  #   @yieldparam descendent [Pathname]
  #   @return [self]
  #
  # @overload find_files()
  #   @return [Enumerator<Pathname>]
  def find_files
    return to_enum(__method__) unless block_given?

    self.find do |path|
      yield path if path.file?
    end

    self
  end

  # Changes the current working directory to the Pathname.  If no block
  # is given, this method returns the Pathname.  Otherwise, the block is
  # called with the Pathname, the original working directory is restored
  # after the block exits, and this method returns the return value of
  # the block.
  #
  # @see https://docs.ruby-lang.org/en/master/Dir.html#method-c-chdir Dir.chdir
  #
  # @example
  #   FileUtils.mkdir("dir1")
  #   FileUtils.mkdir("dir2")
  #
  #   Pathname.new("dir1").chdir  # == Pathname.new("dir1")
  #   Pathname.pwd                # == Pathname.new("dir1")
  #
  #   Pathname.new("dir2").chdir{|path| "in #{path}" }  # == "in dir2"
  #   Pathname.pwd                                      # == Pathname.new("dir1")
  #
  # @overload chdir()
  #   @return [self]
  #
  # @overload chdir(&block)
  #   @yieldparam working_dir [Pathname]
  #   @yieldreturn [Object]
  #   @return [Object]
  #
  # @raise [SystemCallError]
  #   if the Pathname does not point to an existing directory
  def chdir
    if block_given?
      Dir.chdir(self) do |dir|
        yield dir.to_pathname
      end
    else
      Dir.chdir(self)
      self
    end
  end

  # Creates the directory indicated by the Pathname, including any
  # necessary parent directories.  Returns the Pathname.
  #
  # @see https://docs.ruby-lang.org/en/master/Pathname.html#method-i-mkpath Pathname#mkpath
  #
  # @example
  #   Dir.exist?("path")                # == false
  #   Dir.exist?("path/to")             # == false
  #
  #   Pathname.new("path/to").make_dir  # == Pathname.new("path/to")
  #
  #   Dir.exist?("path")                # == true
  #   Dir.exist?("path/to")             # == true
  #
  # @return [self]
  # @raise [SystemCallError]
  #   if the Pathname points to an existing file (non-directory)
  def make_dir
    self.mkpath
    self
  end

  # Creates the directory indicated by the Pathname's +dirname+,
  # including any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")                         # == false
  #   Dir.exist?("path/to")                      # == false
  #
  #   Pathname.new("path/to/file").make_dirname  # == Pathname.new("path/to/file")
  #
  #   Dir.exist?("path")                         # == true
  #   Dir.exist?("path/to")                      # == true
  #   Dir.exist?("path/to/file")                 # == false
  #
  # @return [self]
  # @raise [SystemCallError]
  #   if any element of the +dirname+ points to an existing file
  #   (non-directory)
  def make_dirname
    self.dirname.make_dir
    self
  end

  # Creates the file indicated by the Pathname, including any necessary
  # parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")                      # == false
  #   Dir.exist?("path/to")                   # == false
  #
  #   Pathname.new("path/to/file").make_file  # == Pathname.new("path/to/file")
  #
  #   Dir.exist?("path")                      # == true
  #   Dir.exist?("path/to")                   # == true
  #   File.exist?("path/to/file")             # == true
  #
  # @return [self]
  # @raise [SystemCallError]
  #   if the Pathname points to an existing directory, or if any element
  #   of the +dirname+ points to an existing file (non-directory)
  def make_file
    self.make_dirname.open("a"){}
    self
  end

  # Recursively deletes the directory or file indicated by the Pathname.
  # Similar to +Pathname#rmtree+, but does not raise an exception if the
  # file does not exist.  Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")   # == true
  #
  #   Pathname.new("path").delete!  # == Pathname.new("path")
  #
  #   Dir.exist?("path")            # == false
  #   Dir.exist?("path/to")         # == false
  #   File.exist?("path/to/file")   # == false
  #
  # @return [self]
  def delete!
    self.rmtree if self.exist?
    self
  end

  # Finds an available name based on the Pathname.  If the Pathname does
  # not point to an existing file or directory, returns the Pathname.
  # Otherwise, iteratively generates and tests names until one is found
  # that does not point to an existing file or directory.
  #
  # Names are generated using a Hash-style format string with three
  # populated values:
  #
  # * +%{name}+: original Pathname basename *without* extname
  # * +%{ext}+: original Pathname extname, including leading dot
  # * +%{i}+: iteration counter; can be initialized via +:i+ kwarg
  #
  # @example Incremental
  #   Pathname.new("dir/file.txt").available_name  # == Pathname.new("dir/file.txt")
  #
  #   FileUtils.mkdir("dir")
  #   FileUtils.touch("dir/file.txt")
  #
  #   Pathname.new("dir/file.txt").available_name  # == Pathname.new("dir/file_1.txt")
  #
  #   FileUtils.touch("dir/file_1.txt")
  #   FileUtils.touch("dir/file_2.txt")
  #
  #   Pathname.new("dir/file.txt").available_name  # == Pathname.new("dir/file_3.txt")
  #
  # @example Specifying format
  #   FileUtils.touch("file.txt")
  #
  #   Pathname.new("file.txt").available_name("%{name} (%{i})%{ext}")
  #     # == Pathname.new("file (1).txt")
  #
  # @example Specifying initial counter
  #   FileUtils.touch("file.txt")
  #
  #   Pathname.new("file.txt").available_name(i: 0)
  #     # == Pathname.new("file_0.txt")
  #
  # @param format [String]
  # @param i [Integer]
  # @return [Pathname]
  def available_name(format = "%{name}_%{i}%{ext}", i: 1)
    return self unless self.exist?

    dirname = File.dirname(self)
    format = "%{dirname}/" + format unless dirname == "."

    values = {
      dirname: dirname,
      name: File.basename(self, ".*"),
      ext: self.extname,
      i: i,
    }

    while (path = format % values) && File.exist?(path)
      values[:i] += 1
    end

    path.to_pathname
  end

  # Moves the file or directory indicated by the Pathname to
  # +destination+, in the same manner as +FileUtils.mv+.  Returns
  # +destination+ as a Pathname.
  #
  # @see https://docs.ruby-lang.org/en/master/FileUtils.html#method-c-mv FileUtils.mv
  #
  # @example
  #   FileUtils.mkpath("dir/files")
  #   FileUtils.touch("dir/files/file1")
  #   FileUtils.mkpath("other_dir")
  #
  #   Pathname.new("dir/files").move("other_dir/same_files")
  #     # == Pathname.new("other_dir/same_files")
  #
  #   Dir.exist?("dir/files")                    # == false
  #   File.exist?("other_dir/same_files/file1")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def move(destination)
    FileUtils.mv(self, destination)
    destination.to_pathname
  end

  # Moves the file or directory indicated by the Pathname to
  # +destination+, replacing any existing file or directory.
  #
  # If a block is given and a file or directory does exist at the
  # destination, the block is called with the source and destination
  # Pathnames, and the return value of the block is used as the new
  # destination.  If the block returns the source Pathname or nil, the
  # move is aborted.
  #
  # Creates any necessary parent directories of the destination.
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the move is aborted).
  #
  # *WARNING:* Due to system API limitations, the move is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is moved to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @example Without a block
  #   FileUtils.touch("file")
  #
  #   Pathname.new("file").move_as("dir/file")
  #     # == Pathname.new("dir/file")
  #
  #   File.exist?("file")      # == false
  #   File.exist?("dir/file")  # == true
  #
  # @example Error on older source
  #   FileUtils.touch("file")
  #   sleep 1
  #   FileUtils.touch("file.new")
  #
  #   Pathname.new("file.new").move_as("file") do |source, destination|
  #     if source.mtime < destination.mtime
  #       raise "cannot replace newer file #{destination} with #{source}"
  #     end
  #     destination
  #   end                      # == Pathname.new("file")
  #
  #   File.exist?("file.new")  # == false
  #   File.exist?("file")      # == true
  #
  # @example Abort on conflict
  #   FileUtils.touch("file1")
  #   FileUtils.touch("file2")
  #
  #   Pathname.new("file1").move_as("file2") do |source, destination|
  #     puts "#{source} not moved to #{destination} due to conflict"
  #     nil
  #   end                   # == Pathname.new("file1")
  #
  #   File.exist?("file1")  # == true
  #   File.exist?("file2")  # == true
  #
  # @example New destination on conflict
  #   FileUtils.touch("file1")
  #   FileUtils.touch("file2")
  #
  #   Pathname.new("file1").move_as("file2") do |source, destination|
  #     destination.available_name
  #   end                     # == Pathname.new("file2_1")
  #
  #   File.exist?("file1")    # == false
  #   File.exist?("file2")    # == true
  #   File.exist?("file2_1")  # == true
  #
  # @overload move_as(destination)
  #   @param destination [Pathname, String]
  #   @return [Pathname]
  #
  # @overload move_as(destination, &block)
  #   @param destination [Pathname, String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def move_as(destination)
    destination = destination.to_pathname

    if block_given? && destination.exist? && self.exist? && !File.identical?(self, destination)
      destination = (yield self, destination) || self
    end

    if destination != self
      if File.identical?(self, destination)
        # FileUtils.mv raises an ArgumentError when both paths refer to
        # the same file.  On case-insensitive file systems, this occurs
        # even when both paths have different casing.  We want to
        # disregard the ArgumentError at all times, and change the
        # filename casing when applicable.
        File.rename(self, destination)
      else
        destination.delete!
        self.move(destination.make_dirname)
      end
    end

    destination
  end

  # Moves the file or directory indicated by the Pathname into
  # +directory+, replacing any existing file or directory of the same
  # basename.
  #
  # If a block is given and a file or directory does exist at the
  # resultant destination, the block is called with the source and
  # destination Pathnames, and the return value of the block is used as
  # the new destination.  If the block returns the source Pathname or
  # nil, the move is aborted.
  #
  # Creates any necessary parent directories of the destination.
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the move is aborted).
  #
  # *WARNING:* Due to system API limitations, the move is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is moved to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @see Pathname#move_as
  #
  # @example Without a block
  #   FileUtils.touch("file")
  #
  #   Pathname.new("file").move_into("dir")
  #     # == Pathname.new("dir/file")
  #
  #   File.exist?("file")      # == false
  #   File.exist?("dir/file")  # == true
  #
  # @example With a block
  #   FileUtils.mkpath("files")
  #   FileUtils.touch("files/file1")
  #   FileUtils.mkpath("dir/files")
  #   FileUtils.touch("dir/files/file2")
  #
  #   Pathname.new("files").move_into("dir") do |source, destination|
  #     source                        # == Pathname.new("files")
  #     destination                   # == Pathname.new("dir/files")
  #   end                             # == Pathname.new("dir/files")
  #
  #   Dir.exist?("files")             # == false
  #   File.exist?("dir/files/file1")  # == true
  #   File.exist?("dir/files/file2")  # == false
  #
  # @overload move_into(directory)
  #   @param directory [Pathname, String]
  #   @return [Pathname]
  #
  # @overload move_into(directory, &block)
  #   @param directory [Pathname, String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def move_into(directory, &block)
    self.move_as(directory / self.basename, &block)
  end

  # Copies the file or directory indicated by the Pathname to
  # +destination+, in the same manner as +FileUtils.cp_r+.  Returns
  # +destination+ as a Pathname.
  #
  # @see https://docs.ruby-lang.org/en/master/FileUtils.html#method-c-cp_r FileUtils.cp_r
  #
  # @example
  #   FileUtils.mkpath("dir/files")
  #   FileUtils.touch("dir/files/file1")
  #   FileUtils.mkpath("other_dir")
  #
  #   Pathname.new("dir/files").copy("other_dir/same_files")
  #     # == Pathname.new("other_dir/same_files")
  #
  #   File.exist?("dir/files/file1")             # == true
  #   File.exist?("other_dir/same_files/file1")  # == true
  #
  # @param destination [Pathname, String]
  # @return [Pathname]
  def copy(destination)
    FileUtils.cp_r(self, destination)
    destination.to_pathname
  end

  # Copies the file or directory indicated by the Pathname to
  # +destination+, replacing any existing file or directory.
  #
  # If a block is given and a file or directory does exist at the
  # destination, the block is called with the source and destination
  # Pathnames, and the return value of the block is used as the new
  # destination.  If the block returns the source Pathname or nil, the
  # copy is aborted.
  #
  # Creates any necessary parent directories of the destination.
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the copy is aborted).
  #
  # *WARNING:* Due to system API limitations, the copy is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is copied to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @example Without a block
  #   FileUtils.touch("file")
  #
  #   Pathname.new("file").copy_as("dir/file")
  #     # == Pathname.new("dir/file")
  #
  #   File.exist?("file")      # == true
  #   File.exist?("dir/file")  # == true
  #
  # @example Error on older source
  #   File.write("file", "A")
  #   sleep 1
  #   File.write("file.new", "B")
  #
  #   Pathname.new("file.new").copy_as("file") do |source, destination|
  #     if source.mtime < destination.mtime
  #       raise "cannot replace newer file #{destination} with #{source}"
  #     end
  #     destination
  #   end                    # == Pathname.new("file")
  #
  #   File.read("file.new")  # == "B"
  #   File.read("file")      # == "B"
  #
  # @example Abort on conflict
  #   File.write("file1", "A")
  #   File.write("file2", "B")
  #
  #   Pathname.new("file1").copy_as("file2") do |source, destination|
  #     puts "#{source} not copied to #{destination} due to conflict"
  #     nil
  #   end                 # == Pathname.new("file1")
  #
  #   File.read("file1")  # == "A"
  #   File.read("file2")  # == "B"
  #
  # @example New destination on conflict
  #   File.write("file1", "A")
  #   File.write("file2", "B")
  #
  #   Pathname.new("file1").copy_as("file2") do |source, destination|
  #     destination.available_name
  #   end                   # == Pathname.new("file2_1")
  #
  #   File.read("file1")    # == "A"
  #   File.read("file2")    # == "B"
  #   File.read("file2_1")  # == "A"
  #
  # @overload copy_as(destination)
  #   @param destination [Pathname, String]
  #   @return [Pathname]
  #
  # @overload copy_as(destination, &block)
  #   @param destination [Pathname, String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def copy_as(destination)
    destination = destination.to_pathname

    if block_given? && destination.exist? && self.exist? && !File.identical?(self, destination)
      destination = yield self, destination
      destination = nil if destination == self
    end

    if destination
      destination.delete! unless File.identical?(self, destination)
      self.copy(destination.make_dirname)
    end

    destination || self
  end


  # Copies the file or directory indicated by the Pathname into
  # +directory+, replacing any existing file or directory of the same
  # basename.
  #
  # If a block is given and a file or directory does exist at the
  # resultant destination, the block is called with the source and
  # destination Pathnames, and the return value of the block is used as
  # the new destination.  If the block returns the source Pathname or
  # nil, the copy is aborted.
  #
  # Creates any necessary parent directories of the destination.
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the copy is aborted).
  #
  # *WARNING:* Due to system API limitations, the copy is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is copied to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @see Pathname#copy_as
  #
  # @example Without a block
  #   FileUtils.touch("file")
  #
  #   Pathname.new("file").copy_into("dir")
  #     # == Pathname.new("dir/file")
  #
  #   File.exist?("file")      # == true
  #   File.exist?("dir/file")  # == true
  #
  # @example With a block
  #   FileUtils.mkpath("files")
  #   FileUtils.touch("files/file1")
  #   FileUtils.mkpath("dir/files")
  #   FileUtils.touch("dir/files/file2")
  #
  #   Pathname.new("files").copy_into("dir") do |source, destination|
  #     source                        # == Pathname.new("files")
  #     destination                   # == Pathname.new("dir/files")
  #   end                             # == Pathname.new("dir/files")
  #
  #   File.exist?("files/file1")      # == true
  #   File.exist?("dir/files/file1")  # == true
  #   File.exist?("dir/files/file2")  # == false
  #
  # @overload copy_into(directory)
  #   @param directory [Pathname, String]
  #   @return [Pathname]
  #
  # @overload copy_into(directory, &block)
  #   @param directory [Pathname, String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def copy_into(directory, &block)
    self.copy_as(directory / self.basename, &block)
  end

  # Alias of +Pathname#move_as+.
  #
  # @return [Pathname]
  alias :rename_as :move_as

  # Renames the file or directory indicated by the Pathname relative to
  # its +dirname+, replacing any existing file or directory of the same
  # basename.
  #
  # If a block is given and a file or directory does exist at the
  # resultant destination, the block is called with the source and
  # destination Pathnames, and the return value of the block is used as
  # the new destination.  If the block returns the source Pathname or
  # nil, the rename is aborted.
  #
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the rename is aborted).
  #
  # *WARNING:* Due to system API limitations, the rename is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is moved to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @see Pathname#move_as
  #
  # @example Without a block
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file")
  #
  #   Pathname.new("dir/file").rename_basename("same_file")
  #     # == Pathname.new("dir/same_file")
  #
  #   File.exist?("dir/file")       # == false
  #   File.exist?("dir/same_file")  # == true
  #
  # @example With a block
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file1")
  #   FileUtils.touch("dir/file2")
  #
  #   Pathname.new("dir/file1").rename_basename("file2") do |source, destination|
  #     source                  # == Pathname.new("dir/file1")
  #     destination             # == Pathname.new("dir/file2")
  #   end                       # == Pathname.new("dir/file2")
  #
  #   File.exist?("dir/file1")  # == false
  #   File.exist?("dir/file2")  # == true
  #
  # @overload rename_basename(new_basename)
  #   @param new_basename [Pathname, String]
  #   @return [Pathname]
  #
  # @overload rename_basename(new_basename, &block)
  #   @param new_basename [Pathname, String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def rename_basename(new_basename, &block)
    self.move_as(self.dirname / new_basename, &block)
  end

  # Changes the file extension (+extname+) of the file indicated by the
  # Pathname, replacing any existing file or directory of the same
  # resultant basename.
  #
  # If a block is given and a file or directory does exist at the
  # resultant destination, the block is called with the source and
  # destination Pathnames, and the return value of the block is used as
  # the new destination.  If the block returns the source Pathname or
  # nil, the rename is aborted.
  #
  # Returns the destination as a Pathname (or the source Pathname in the
  # case that the rename is aborted).
  #
  # *WARNING:* Due to system API limitations, the rename is performed in
  # two steps, non-atomically.  First, any file or directory existing
  # at the destination is deleted.  Next, the source is moved to the
  # destination.  The second step can fail independently of the first,
  # e.g. due to insufficient disk space, leaving the file or directory
  # previously at the destination deleted without replacement.
  #
  # @see Pathname#move_as
  #
  # @example Replace extension
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file.abc")
  #
  #   Pathname.new("dir/file.abc").rename_extname(".xyz")
  #     # == Pathname.new("dir/file.xyz")
  #
  #   File.exist?("dir/file.abc")  # == false
  #   File.exist?("dir/file.xyz")  # == true
  #
  # @example Add extension
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file")
  #
  #   Pathname.new("dir/file").rename_extname(".abc")
  #     # == Pathname.new("dir/file.abc")
  #
  #   File.exist?("dir/file")      # == false
  #   File.exist?("dir/file.abc")  # == true
  #
  # @example Remove extension
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file.abc")
  #
  #   Pathname.new("dir/file.abc").rename_extname("")
  #     # == Pathname.new("dir/file")
  #
  #   File.exist?("dir/file.abc")  # == false
  #   File.exist?("dir/file")      # == true
  #
  # @example With a block
  #   FileUtils.mkpath("dir")
  #   FileUtils.touch("dir/file.abc")
  #   FileUtils.touch("dir/file.xyz")
  #
  #   Pathname.new("dir/file.abc").rename_extname(".xyz") do |source, destination|
  #     source                     # == Pathname.new("dir/file.abc")
  #     destination                # == Pathname.new("dir/file.xyz")
  #   end                          # == Pathname.new("dir/file.xyz")
  #
  #   File.exist?("dir/file.abc")  # == false
  #   File.exist?("dir/file.xyz")  # == true
  #
  # @overload rename_extname(new_extname)
  #   @param new_extname [String]
  #   @return [Pathname]
  #
  # @overload rename_extname(new_extname, &block)
  #   @param new_extname [String]
  #   @yieldparam source [Pathname]
  #   @yieldparam destination [Pathname]
  #   @yieldreturn [Pathname, nil]
  #   @return [Pathname]
  def rename_extname(new_extname, &block)
    unless new_extname.start_with?(".") || new_extname.empty?
      new_extname = ".#{new_extname}"
    end
    self.move_as(self.sub_ext(new_extname), &block)
  end

  # Writes +text+ to the file indicated by the Pathname, overwriting the
  # file if it exists.  Creates the file if it does not exist, including
  # any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")           # == false
  #   Dir.exist?("path/to")        # == false
  #   File.exist?("path/to/file")  # == false
  #
  #   Pathname.new("path/to/file").write_text("hello world")
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "hello world"
  #
  # @param text [String]
  # @return [self]
  def write_text(text)
    self.make_dirname.open("w"){|f| f.write(text) }
    self
  end

  # Appends +text+ to the file indicated by the Pathname.  Creates the
  # file if it does not exist, including any necessary parent
  # directories.  Returns the Pathname.
  #
  # @example
  #   Dir.exist?("path")           # == false
  #   Dir.exist?("path/to")        # == false
  #   File.exist?("path/to/file")  # == false
  #
  #   Pathname.new("path/to/file").append_text("hello").append_text(" world")
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "hello world"
  #
  # @param text [String]
  # @return [self]
  def append_text(text)
    self.make_dirname.open("a"){|f| f.write(text) }
    self
  end

  # Writes each object in +lines+ as a string plus +eol+ (end-of-line)
  # characters to the file indicated by the Pathname, overwriting the
  # file if it exists.  Creates the file if it does not exist, including
  # any necessary parent directories.  Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")  # false
  #
  #   Pathname.new("path/to/file").write_lines([:one, :two])
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "one\ntwo\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @param eol [String]
  # @return [self]
  def write_lines(lines, eol: $/)
    self.make_dirname.open("w"){|f| f.write_lines(lines, eol: eol) }
    self
  end

  # Appends each object in +lines+ as a string plus +eol+ (end-of-line)
  # characters to the file indicated by the Pathname.  Creates the file
  # if it does not exist, including any necessary parent directories.
  # Returns the Pathname.
  #
  # @example
  #   File.exist?("path/to/file")  # false
  #
  #   Pathname.new("path/to/file").append_lines([:one, :two]).append_lines([:three, :four])
  #     # == Pathname.new("path/to/file")
  #
  #   File.read("path/to/file")    # == "one\ntwo\nthree\nfour\n"
  #
  # @param lines [Enumerable<#to_s>]
  # @param eol [String]
  # @return [self]
  def append_lines(lines, eol: $/)
    self.make_dirname.open("a"){|f| f.write_lines(lines, eol: eol) }
    self
  end

  # Alias of +Pathname#read+.
  #
  # @return [String]
  alias :read_text :read

  # Reads all lines from the file indicated by the Pathname, and returns
  # them with +eol+ (end-of-line) characters stripped.
  #
  # @see IO#read_lines
  #
  # @note Not to be confused with +Pathname#readlines+, which retains
  #   end-of-line characters.
  #
  # @example
  #   File.read("path/to/file")                # == "one\ntwo\n"
  #
  #   Pathname.new("path/to/file").read_lines  # == ["one", "two"]
  #
  # @param eol [String]
  # @return [Array<String>]
  def read_lines(eol: $/)
    self.open("r"){|f| f.read_lines(eol: eol) }
  end

  # Reads the file indicated by the Pathname, and yields the entire
  # contents as a String to the given block for editing.  Writes the
  # return value of the block back to the file, overwriting previous
  # contents.  Returns the return value of the block.
  #
  # @see File.edit_text
  #
  # @example Update JSON data file
  #   File.read("data.json")  # == '{"nested":{"key":"value"}}'
  #
  #   Pathname.new("data.json").edit_text do |text|
  #     data = JSON.parse(text)
  #     data["nested"]["key"] = "new value"
  #     data.to_json
  #   end                     # == '{"nested":{"key":"new value"}}'
  #
  #   File.read("data.json")  # == '{"nested":{"key":"new value"}}'
  #
  # @yield [text]
  # @yieldparam text [String]
  # @yieldreturn [String]
  # @return [String]
  def edit_text(&block)
    File.edit_text(self, &block)
  end

  # Reads the file indicated by the Pathname, and yields the entire
  # contents as an Array of lines to the given block for editing.
  # Writes the return value of the block back to the file, overwriting
  # previous contents.  +eol+ (end-of-line) characters are stripped from
  # each line when reading, and appended to each line when writing.
  # Returns the return value of the block.
  #
  # @see File.edit_lines
  #
  # @example Dedup lines of file
  #   File.read("entries.txt")  # == "AAA\nBBB\nBBB\nCCC\nAAA\n"
  #
  #   Pathname.new("entries.txt").edit_lines(&:uniq)
  #     # == ["AAA", "BBB", "CCC"]
  #
  #   File.read("entries.txt")  # == "AAA\nBBB\nCCC\n"
  #
  # @param eol [String]
  # @yield [lines]
  # @yieldparam lines [Array<String>]
  # @yieldreturn [Array<String>]
  # @return [Array<String>]
  def edit_lines(eol: $/, &block)
    File.edit_lines(self, eol: eol, &block)
  end

  # Appends the contents of file indicated by +source+ to the file
  # indicated by the Pathname.  Returns the Pathname.
  #
  # @example
  #   File.read("yearly.log")  # == "one\ntwo\n"
  #   File.read("daily.log")   # == "three\nfour\n"
  #
  #   Pathname.new("yearly.log").append_file("daily.log")
  #     # == Pathname.new("yearly.log")
  #
  #   File.read("yearly.log")  # == "one\ntwo\nthree\nfour\n"
  #
  # @param source [String, Pathname]
  # @return [self]
  def append_file(source)
    self.open("a"){|destination| IO::copy_stream(source, destination) }
    self
  end

end
