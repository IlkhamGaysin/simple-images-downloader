# frozen_string_literal: true

require 'tempfile'

RSpec.describe ImageDownloader::Dispenser do
  describe '#place' do
    subject(:place) { dispenser.place }

    let(:source)      { Tempfile.new('dispenser-test-source.png', fixtures_path) }
    let(:remote_path) { fixtures_path('dispenser-test-moved.png') }
    let(:dispenser)   { described_class.new(source, remote_path) }

    context 'when source and remote_path are right typed' do
      before do
        allow(dispenser).to receive(:destination).and_return(remote_path)
      end

      after do
        source.close
        FileUtils.remove_entry_secure(remote_path) if File.exist?(remote_path)
      end

      it 'moves source file to destination' do
        expect(File).not_to be_exist(remote_path)

        place

        expect(File).to be_exist(remote_path)
      end
    end

    context 'when destination_dir is not writable' do
      before do
        allow(dispenser).to receive(:destination_dir).and_return(remote_path)
        allow(File).to receive(:writiable?).with(remote_path).and_return(false)
      end

      after do
        source.close!
      end

      it do
        expect { place }.to raise_error(ImageDownloader::Errors::DestinationIsNotWritable)
      end
    end
  end
end
