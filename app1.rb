require 'vertx'
require 'json'

server = Vertx::HttpServer.new

server.request_handler do |request|
  request.response.put_header('Content-Type', 'application/json')
  hash = {status: 'ok'}
  request.response.end(hash.to_json)
end.listen(9292) do |err|
  puts "Now listening!" if !err
end
