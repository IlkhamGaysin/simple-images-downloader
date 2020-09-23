# frozen_string_literal: true

module ImageFetcher
  class SourceFile
    def initialize(path, validator = nil)
      @path      = path
      @validator = validator || ImageFetcher::FilePersistanceValidator.new(path)
    end

    def each_line(&block)
      @validator.validate

      begin
        file.each(chomp: true, &block)
      ensure
        file.close
      end
    end

    private

    def file
      @file ||= File.open(@path, 'r')
    end
  end
end
