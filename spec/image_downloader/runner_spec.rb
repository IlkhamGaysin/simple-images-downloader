# frozen_string_literal: true

RSpec.describe ImageDownloader::Runner do
  describe '.invoke' do
    context 'when ARGV has first argument' do
      let(:path) { 'file/path' }

      before do
        stub_const('ARGV', [path])
      end

      it do
        expect(ImageDownloader).to receive(:from_file).with(path).once

        described_class.invoke
      end
    end

    context "when ARGV doesn't have first argument" do
      before do
        allow(ARGV).to receive(:size).and_return(0)
      end

      it do
        expect { described_class.invoke }.to raise_error(ImageDownloader::Errors::MissingFileArgumentError)
      end
    end
  end
end
