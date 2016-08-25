require_relative 'player'
require_relative 'opponents'

class Tournament

  def initialize(code)
    @code = code

    @players = []

    @fake_player = Player.new("AI", -1)
  end

  def get_code
    return @code
  end

  def get_players
    return @players
  end

  def get_players_with_sockets
    return @players.select { |p| !p.get_socket.nil? }
  end

  def add_player(name)

    ids = get_players.map { |p| p.get_id }

    id = ids.length > 0 ? ids.max + 1 : 0

    player = Player.new(name, id)

    @players.push(player)

    return player.get_id
  end

  def delete_player(player)
    @players.delete(player)
  end

  def get_surviving_players
    return @players.select { |p| !p.has_lost }
  end

  def get_opposing_player_pairs

    opponents = []
    players = get_surviving_players

    if players.length % 2 != 0
      @fake_player.set_current_choice(GameHelper.select_random_choice)

      players.push(@fake_player)
    end

    while players.length > 0

      players = players.shuffle
      player_1  = players.pop

      players = players.shuffle
      player_2  = players.pop

      opponents.push(Opponents.new(player_1, player_2))
    end

    @current_opponents = opponents

    return opponents
  end

  def get_opponent(player)
    if !@current_opponents.nil?

      @current_opponents.each do |pair|

        if pair.get_player_1.get_id == player.get_id
          return pair.get_player_2
        end

        if pair.get_player_2.get_id == player.get_id
          return pair.get_player_1
        end
      end
    end

    return nil
  end

end