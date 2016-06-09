class Player

  def initialize(name, id)
    @name = name
    @id = id
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

  def add_socket(socket)
    @socket = socket
  end

end