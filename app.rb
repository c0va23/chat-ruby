
class Message < Struct.new(:id, :text, :time)
  def initialize(text)
    self.id = SecureRandom.uuid
    self.text = text
    self.time = Time.now
  end

  def write_to(connection)
    connection << "id:#{self.id}\ndata: #{self.to_h.to_json}\n\n"
  end
end

class Chat < Sinatra::Application
  connections = []
  messages = []

  get "/" do
    slim :index
  end

  get "/messages", provides: "text/event-stream" do
    last_event_id = request.env['HTTP_LAST_EVENT_ID']

    undelivered_messages = if last_event_id
      last_message_index = messages.find_index { |m| m.id == last_event_id }
      if last_message_index && last_message_index < messages.size
        messages[last_message_index+1..-1]
      else
        []
      end
    else
      messages
    end

    stream :keep_open do |connection|
      undelivered_messages.each do |message|
        message.write_to(connection)
      end

      connections << connection
      connection.callback do
        connections.delete(connection)
      end
    end
  end

  post "/messages" do
    message_data = JSON.parse(request.body.read)

    message = Message.new(message_data['text'])
    messages << message

    connections.each do |connection|
      message.write_to(connection)
    end

    message.to_h.to_json
  end
end


