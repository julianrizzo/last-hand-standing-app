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
require_relative 'models/message'

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
		@init_function = "InitialiseJoin"
		slim :join
	end

	get '/create' do
		@init_function = "InitialiseCreate"
		slim :create
	end

	post '/create' do

		code = params["code"]
		name = params["name"]

		new_tournament = Tournament.new(code)
		player_id = new_tournament.add_player(name)

		settings.tournaments.push(new_tournament)

		redirect "/game/#{code}/#{player_id}"
	end

	post '/join' do

		code = params["code"]
		name = params["name"]

		tournament = find_tournament(code)

		player_id = tournament.add_player(name)

		redirect "/game/#{code}/#{player_id}"
	end

	get '/game/:code/:player_id' do |code, player_id|
		@code = code
		@id = player_id
		@init_function = "InitialiseGame"
		slim :game
	end

	get '/communicate' do
		if request.websocket?

			request.websocket do |ws|
				ws.onopen do
					puts "someone has connected"
				end
				ws.onmessage do |msg|

					message = Message.new(msg)
					tournament = find_tournament(message.get_code)
					player = find_player_in_tournament(tournament, message.get_player_id)

					if message.get_action == 'init'
						player.add_socket(ws)

						lobby = slim :"screens/lobby", locals: { players: tournament.get_players_with_sockets, code: tournament.get_code }, layout: false
						send_all_players_message(tournament, lobby)
					end
				end
				ws.onclose do
					warn("websocket closed")
				end
			end

		end
	end

	def find_tournament(code)
		tours = settings.tournaments.select { |t| t.get_code == code }
		if tours.length > 0
			return tours[0]
		end

		return nil
	end

	def find_player_in_tournament(tournament, player_id)
		players = tournament.get_players.select { |p| p.get_id == player_id }
		if players.length > 0
			return players[0]
		end

		return nil
	end

	def send_all_players_message(tournament, message)

		tournament.get_players.each do |player|
			if !player.get_socket.nil?

				EM.next_tick { player.get_socket.send(message) }
			end
		end

	end

end