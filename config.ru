require "./bootstrap.rb"
require "./app.rb"

map "/assets" do
  environment = Sprockets::Environment.new
  environment.append_path "assets"
  run environment
end

map "/" do
  run Chat
end
