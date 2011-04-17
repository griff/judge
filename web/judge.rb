require "bundler/setup"

Bundler.require

get '/hi' do
  "Hello World!"
end

get '/' do
  haml :index
end