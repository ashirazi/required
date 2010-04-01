module Kernel

  # Searches through the given directory or array of directories, and will
  # `require` all ruby files found.  Returns an array of files that were
  # actually loaded in the order which they were loaded.
  # Available options:
  #   :recurse => true       # Descend into subdirectories (default is false)
  #   :include => /pattern/  # Only require files with names matching this regex
  #   :exclude => /pattern/  # Don't require files matching this regex
  #   :sort => lambda { |x, y| y <=> x }
  #                # Specify a custom file sort order within each directory
  #
  # Note: required files are loaded only once.
  def required(directories, options={})
    validate_options(options)
    loaded_files = []
    directories.each do |directory|
      next unless File.directory? directory
      loaded_files << require_within(directory, options)

      next unless options[:recurse]
      sub_dirs = Dir["#{directory}/*"].select { |d| File.directory? d }
      options[:sort] ? sub_dirs.sort!(&options[:sort]) : sub_dirs.sort!
      # TODO AS: Reject sub_dir for includes and excludes
      sub_dirs.each { |sub_dir| loaded_files << required(sub_dir, options) }
    end
    loaded_files.flatten
  end

  private
  def require_within(directory, opt)
    next unless File.directory? directory
    loaded_files = []
    ruby_files = Dir["#{directory}/*.rb"].reject{ |f| File.directory? f }
    ruby_files = ruby_files.select { |f| f =~ opt[:include] } if opt[:include]
    ruby_files = ruby_files.reject { |f| f =~ opt[:exclude] } if opt[:exclude]
    opt[:sort] ? ruby_files.sort!(&opt[:sort]) : ruby_files.sort!
    ruby_files.each { |file| loaded_files << file if require file }
    loaded_files
  end

  def validate_options(options)
    valid = [:recurse, :include, :exclude, :sort]
    given = options.keys
    unless valid.size - given.size == (valid - given).size
      puts "warn: required recognizes only #{valid.inspect}, " +
          "but was given #{given.inspect}\n#{caller[1].sub(/:in.*/, '')}"
    end
  end

end
