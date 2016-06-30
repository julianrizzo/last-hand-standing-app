class Message

  def initialize(message)

    chunks = message.split(':')

    @code = chunks[0]
    @player_id = chunks[1].to_i
    @action = chunks[2]
  end

  def get_code
    return @code
  end

  def get_player_id
    return @player_id
  end

  def get_action
    return @action
  end

end