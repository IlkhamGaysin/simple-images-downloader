# frozen_string_literal: true

module ImageFetcher
  class Runner
    def self.invoke
      raise ImageFetcher::Errors::MissingFileArgumentError if ARGV.size.zero?

      ImageFetcher.from_file(ARGV.first)
    end
  end
end
