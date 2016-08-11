class Player

  def initialize(name, id)
    @name = name
    @id = id

    @colour = ["#ff7473", "#ede574", "#79bd9a", "#A593E0"].sample

    @has_lost = false
  end

  def get_name
    return @name
  end

  def get_id
    return @id
  end

  def get_socket
    return @socket
  end

  def get_colour
    return @colour
  end

  def add_socket(socket)
    @socket = socket
  end

  def has_lost
    return @has_lost
  end

  def set_lost
    @has_lost = true
  end

  def set_current_choice(choice)
    @choice = choice
  end

  def get_current_choice
    return @choice
  end

end