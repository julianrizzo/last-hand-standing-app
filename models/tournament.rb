require_relative 'player'

class Tournament

  def initialize(code)
    @code = code

    @players = []
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
    player = Player.new(name, @players.count)

    @players.push(player)

    return player.get_id
  end

end