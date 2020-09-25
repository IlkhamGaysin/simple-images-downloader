# frozen_string_literal: true

module SimpleImagesDownloader
  class Dispenser
    extend Forwardable

    def_delegator 'SimpleImagesDownloader::Configuration', :destination, :destination_dir

    def initialize(source, remote_path)
      @source      = source
      @remote_path = remote_path
    end

    def place
      raise Errors::DestinationIsNotWritable, destination unless File.writable?(destination_dir)

      FileUtils.mv @source, destination
    end

    def destination
      @destination ||= destination_dir + file_name
    end

    def file_name
      @file_name ||= File.basename(@source) + File.extname(@remote_path)
    end

    private :destination_dir, :destination, :file_name
  end
end
