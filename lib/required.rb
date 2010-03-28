module Kernel

  # Searches through the given directory or array of directories, and will
  # `require` all ruby files found.  Returns an array of files that were
  # actually loaded in the order which they were loaded.
  # Available options:
  #   :recurse => [true|false]         # Descend into subdirectories or not
  #   :include => /filename_pattern/   # Only require files matching this regex
  #   :exclude => /filename_pattern/   # Don't require files matching this regex
  #
  # Note: required files are loaded only once.
  def required(directories, options={})
    # TODO AS: Set the sort order for required files...
    loaded_files = []
    directories.each do |directory|
      next unless File.directory? directory
      loaded_files << require_within(directory, options)

      next unless options[:recurse]
      sub_dirs = Dir["#{directory}/*"].select { |d| File.directory? d }
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
    ruby_files.each { |file| loaded_files << file if require file }
    loaded_files
  end

end
