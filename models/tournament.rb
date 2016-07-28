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

    ids = get_players.map { |p| p.get_id }

    id = ids.length > 0 ? ids.max + 1 : 0

    player = Player.new(name, id)

    @players.push(player)

    return player.get_id
  end

  def delete_player(player)
    @players.delete(player)
  end

end