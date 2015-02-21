require 'vertx'
require 'json'

server = Vertx::HttpServer.new
eb = Vertx::EventBus

Vertx.deploy_module('io.vertx~mod-mongo-persistor~2.1.0', {address: "mongodb-persistor", host: "localhost", db_name: "test"}) do
  server.request_handler do |request|
    request.response.put_header('Content-Type', 'application/json')
    find_request = {
      collection: 'test',
      action: 'findone',
      matcher: {}
    }
    eb.send('mongodb-persistor', find_request) do |message|
      if message.body["status"] == "ok"
        request.response.end(message.body["result"].to_json)
      else
        request.response.end({status: 'not_found'}.to_json)
      end 
    end
  end.listen(9292) do
    puts "Server started to listen"
  end
end
