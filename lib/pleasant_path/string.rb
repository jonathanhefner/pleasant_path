class String

  # Converts the string to a +Pathname+ object.
  #
  # @return [Pathname]
  def to_pathname
    Pathname.new(self)
  end

  # Alias of +String#to_pathname+.
  #
  # @return [Pathname]
  alias :path :to_pathname

end
