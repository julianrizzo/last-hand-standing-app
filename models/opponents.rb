class Opponents

  def initialize(player_1, player_2)
    @player_1 = player_1
    @player_2 = player_2
  end

  def get_player_1
    return @player_1
  end

  def get_player_2
    return @player_2
  end
end