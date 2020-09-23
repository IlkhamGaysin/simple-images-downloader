# frozen_string_literal: true

module SimpleImagesDownloader
  class ImagePathValidator
    VALID_EXTENSIONS = %w[.png .jpg .gif .jpeg].freeze

    def initialize(path)
      @path = path
    end

    def validate
      raise Errors::MissingImageInPath, @path unless VALID_EXTENSIONS.include?(extension)
    end

    private

    def extension
      File.extname(@path)
    end
  end
end
