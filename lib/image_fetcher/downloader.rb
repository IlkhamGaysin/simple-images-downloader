# frozen_string_literal: true

module ImageFetcher
  class Downloader
    REQUEST_OPTIONS = {
      'User-Agent' => "ImageFetcher/#{ImageFetcher::VERSION}",
      redirect: false,
      open_timeout: 30,
      read_timeout: 30
    }.freeze

    def initialize(uri)
      @uri = uri
    end

    def download
      puts "Downloading #{@uri}"

      @downloaded_file = StringIOToTempfile.convert(downloaded_file) if downloaded_file.is_a?(StringIO)

      Dispenser.new(downloaded_file, @uri.path).place

      puts 'Downloading is finished'
    ensure
      downloaded_file.close
    end

    private

    def downloaded_file
      @downloaded_file ||= @uri.open(REQUEST_OPTIONS)
    rescue OpenURI::HTTPRedirect
      raise Errors::RedirectError, @uri
    rescue OpenURI::HTTPError
      raise Errors::ConnectionError, @uri
    end
  end
end
