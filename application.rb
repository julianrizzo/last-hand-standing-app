require 'sinatra'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/base'
require 'sinatra-websocket'
require 'sass'
require 'slim'

require_relative 'models/tournament'

class App < Sinatra::Base

	set :root, File.dirname(__FILE__)
	set :public_folder, File.dirname(__FILE__) + '/public/'
	set :assets_prefix, %w(app/assets vendor/assets)

	set :tournaments, []

	register Sinatra::AssetPipeline

	configure :development do
		register Sinatra::Reloader
	end

	get '/' do
		slim :index
	end

	get '/join' do
		slim :join
	end

	get '/create' do
		slim :create
	end

	post '/create' do

		code = params["code"]
		name = params["name"]

		new_tournament = Tournament.new(code)
		id = new_tournament.add_player(name)

		settings.tournaments.push(new_tournament)

		redirect "/game/#{code}/#{id}"
	end

	get '/game/:code/:id' do |code, id|
		@code = code
		@id = id
		@init_function = "InitialiseGame"
		slim :game
	end

	get '/communicate' do
		if request.websocket?

			request.websocket do |ws|
				ws.onopen do
					puts "someone has connected"
					ws.send("Hello World!")
				end
				ws.onmessage do |msg|
					#EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
					EM.next_tick { ws.send(msg) }
				end
				ws.onclose do
					warn("websocket closed")
				end
			end

		end
	end

end