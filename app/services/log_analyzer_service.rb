require 'set'

class LogAnalyzerService
    def self.analyze(file)
        begin
            new(file).analyze
          rescue Errno::ENOENT
            raise StandardError.new("The file was not found.")
          rescue Errno::EACCES
            raise StandardError.new("Permission denied to access the file.")
          rescue => e
            raise StandardError.new("Error during file processing: #{e.message}")
          end
     end

    def initialize(file)
        @file = file
        @games = {}
        @current_game = nil
    end

    def analyze
        File.foreach(@file) do |line|
            analyze_line(line)
        end
        @games
    end

    private

    def analyze_line(line)
        case line
        when /InitGame/
            start_game if @current_game.nil? || game_finished? 
        when /ShutdownGame/
            end_game
        when /ClientUserinfoChanged: (\d+) n\\(.+?)\\ /
            process_player_connect($1, $2) if @current_game
        when /Kill: (\d+) (\d+) (\d+): (.+) killed (.+) by (.+)/
            process_kill($4, $5, $6) if @current_game
        end
    end
  
    def start_game
        @current_game = "game_#{@games.length + 1}"
        @games[@current_game] = {
            total_kills: 0,
            players: Set.new,
            kills: Hash.new(0),
            kills_by_means: Hash.new(0)
        }
    end

    def end_game
        @current_game = nil
    end

    def process_kill(killer, killed, means)
        @games[@current_game][:total_kills] += 1

        adjust_kill_count(killer, killed)

        @games[@current_game][:kills_by_means][means] += 1
        @games[@current_game][:players].add(killed) unless killed == "<world>"
        @games[@current_game][:players].add(killer) unless killer == "<world>"
    end

    def adjust_kill_count(killer, killed)
        if killer == "<world>"
          @games[@current_game][:kills][killed] -= 1
        else
          @games[@current_game][:kills][killed] += 1
        end
    
        @games[@current_game][:kills][killer] -= 1 if killer == killed || killed == "<world>"
    end

    def game_finished?
        @last_event == "ShutdownGame"
    end

    def process_player_connect(client_id, player_name)
        @games[@current_game][:players] << player_name if @current_game 
    end
end