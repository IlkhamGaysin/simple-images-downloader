# frozen_string_literal: true

module ImageFetcher
  module StringioToTempfile
    module_function

    def convert(stringio)
      tempfile = Tempfile.new(binmode: true)

      IO.copy_stream(stringio, tempfile)

      stringio.close

      OpenURI::Meta.init tempfile, stringio

      tempfile
    end
  end
end
