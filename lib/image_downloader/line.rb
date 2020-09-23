# frozen_string_literal: true

module ImageDownloader
  class Line
    def initialize(string)
      @string = string
    end

    def uri
      parsed_uri = URI.parse(@string)

      ImagePathValidator.new(@string).validate

      parsed_uri
    rescue URI::Error
      raise Errors::BadUrl, @string
    end
  end
end
