require 'json'

class Message
  def initialize(msg)
    @message = JSON.parse(msg)
  end

  def get_name
    return @message["name"]
  end

  def get_data
    return @message["data"]
  end


end