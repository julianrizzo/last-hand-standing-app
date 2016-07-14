class Player

  def initialize(name, id)
    @name = name
    @id = id

    @colour = ["#ff7473", "#ede574", "#79bd9a", "#A593E0"].sample
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

end