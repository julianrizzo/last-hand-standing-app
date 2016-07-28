class Message

  def initialize(message)

    chunks = message.split(':')

    @action = chunks[0]
  end

  def get_action
    return @action
  end
end