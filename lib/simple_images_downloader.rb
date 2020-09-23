# frozen_string_literal: true

require 'open-uri'
require 'tempfile'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module SimpleImagesDownloader
  def self.from_file(path)
    source_file = SourceFile.new(path)

    source_file.each_line do |line|
      uri = Line.new(line).uri
      Downloader.new(uri).download
    rescue Errors::BaseError => e
      puts e.message
      next
    end
  end

  def self.from_url(url)
    uri = Line.new(url).uri
    Downloader.new(uri).download
  end

  def self.root
    File.dirname __dir__
  end
end
