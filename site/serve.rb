require 'webrick'

server = WEBrick::HTTPServer.new(Port: 8088, DocumentRoot: File.dirname(__FILE__))
trap 'INT' do
  server.shutdown
end
server.start
