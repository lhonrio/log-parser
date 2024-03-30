require 'rails_helper'

RSpec.describe LogAnalyzerService do
  let(:file) { './spec/fixtures/logs/valid.log' }

  describe '#analyze' do
    context 'when analyzing a log file' do  
      it 'returns a hash of game data' do
        result = LogAnalyzerService.analyze(file)
        expect(result).to_not eq nil
      end
    end

    context "with a nonexistent log file" do
      let(:nonexistent_file_path) { "/path/to/nonexistent/file.txt" }

      it "raises an error" do
        expect {
          described_class.analyze(nonexistent_file_path)
        }.to raise_error(StandardError, "The file was not found.")
      end
    end

    context "with a file without read permission" do
      let(:unreadable_file_path) { "/path/to/unreadable/file.txt" }

      before do
        allow(File).to receive(:foreach).and_raise(Errno::EACCES)
      end

      it "raises an error" do
        expect {
          described_class.analyze(unreadable_file_path)
        }.to raise_error(StandardError, "Permission denied to access the file.")
      end
    end
  end

  describe '#initialize' do
    it 'creates a new instance of LogAnalyzerService' do
      service = LogAnalyzerService.new(file)
      expect(service).to be_an_instance_of(LogAnalyzerService)
    end
  end

  describe '#start_game' do
    it 'initializes a new game in the games hash' do
      service = LogAnalyzerService.new(file)
      service.send(:start_game)
      expect(service.instance_variable_get(:@current_game)).to_not be_nil
      expect(service.instance_variable_get(:@games)).to have_key(service.instance_variable_get(:@current_game))
    end
  end

  describe '#end_game' do
    it 'resets the current_game variable to nil' do
      service = LogAnalyzerService.new(file)
      service.send(:start_game)
      service.send(:end_game)
      expect(service.instance_variable_get(:@current_game)).to be_nil
    end
  end

  describe '#process_kill' do
    it 'processes a kill event and updates game statistics' do
      service = LogAnalyzerService.new(file)
      service.send(:start_game)
      service.send(:process_kill, 'Isgalamido', 'Mocinha', 'MOD_ROCKET_SPLASH')
      expect(service.instance_variable_get(:@games)[service.instance_variable_get(:@current_game)][:total_kills]).to eq(1)
      expect(service.instance_variable_get(:@games)[service.instance_variable_get(:@current_game)][:kills]['Isgalamido']).to eq(0)
      expect(service.instance_variable_get(:@games)[service.instance_variable_get(:@current_game)][:kills]['Mocinha']).to eq(1)
      expect(service.instance_variable_get(:@games)[service.instance_variable_get(:@current_game)][:kills_by_means]['MOD_ROCKET_SPLASH']).to eq(1)
    end
  end

  describe '#process_player_connect' do
    it 'adds a player to the current game' do
      service = LogAnalyzerService.new(file)
      service.send(:start_game)
      service.send(:process_player_connect, '1', 'Isgalamido')
      expect(service.instance_variable_get(:@games)[service.instance_variable_get(:@current_game)][:players]).to include('Isgalamido')
    end
  end
end