# frozen_string_literal: true

module ImageDownloader
  class Runner
    def self.invoke
      raise ImageDownloader::Errors::MissingFileArgumentError if ARGV.size.zero?

      ImageDownloader.from_file(ARGV.first)
    end
  end
end
