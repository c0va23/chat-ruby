require "bundler"
Bundler.require(:default)

Message = Struct.new(:text, :time)

connections = []
messages = []

def write_message(connection, message)
  connection << "data: #{message.to_h.to_json}\n\n"
end

get "/messages", provides: "text/event-stream" do
  stream :keep_open do |connection|
    connections << connection
    connection.callback do
      connections.delete(connection)
    end
  end
end

post "/messages" do
  message_data = JSON.parse(request.body.read)

  message = Message.new(message_data['text'], Time.now)
  messages << message

  connections.each do |connection|
    write_message(connection, message)
  end

  message.to_h.to_json
end


