# frozen_string_literal: true

module ImageDownloader
  class FilePersistanceValidator
    def initialize(path)
      @path = path
    end

    def validate
      raise Errors::MissingFileError, @path unless File.exist?(@path)
    end
  end
end
