# frozen_string_literal: true

module SimpleImagesDownloader
  class Runner
    def self.invoke
      raise SimpleImagesDownloader::Errors::MissingFileArgumentError if ARGV.size.zero?

      SimpleImagesDownloader.from_file(ARGV.first)
    end
  end
end
