require 'sinatra'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sinatra/reloader'
require 'sinatra/base'
require 'sinatra-websocket'
require 'sinatra/flash'
require 'sass'
require 'slim'

require_relative 'models/tournament'
require_relative 'models/message'
require_relative 'helpers/game_helper'

class App < Sinatra::Base

	set :root, File.dirname(__FILE__)
	set :public_folder, File.dirname(__FILE__) + '/public/'
	set :assets_prefix, %w(app/assets vendor/assets)

	set :assets_precompile, %w(application.js application.css vendor.js vendor.css *.png *.jpg *.svg *.eot *.ttf *.woff)

	set :tournaments, []

	enable :sessions

	register Sinatra::AssetPipeline
	register Sinatra::Flash

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

		if is_blank(name)
			flash[:error] = "Please state your name"
			redirect '/create'
		end

		code = code.upcase
		name = name.upcase

		new_tournament = Tournament.new(code)
		player_id = new_tournament.add_player(name)

		settings.tournaments.push(new_tournament)

		redirect "/game/#{code}/#{player_id}"

	end

	post '/join' do

		code = params["code"]
		name = params["name"]

		if is_blank(name)
			flash[:error] = "Please state your name"
			redirect '/join'
		end

		name = name.upcase

		if is_blank(code)
			flash[:error] = "Please enter a code"
			redirect '/join'
		end

		code = code.upcase

		tournament = find_tournament(code)

		if tournament.nil?
			flash[:error] = "Tournament not found"
			redirect '/join'
		end

		player_id = tournament.add_player(name)

		redirect "/game/#{code}/#{player_id}"
	end

	get '/game/:code/:player_id' do |code, player_id|
		@code = code
		@id = player_id
		@init_function = "InitialiseGame"
		slim :game
	end

	get '/testmatch' do
		locals = {
				player: Player.new('james', 0),
				opponent: Player.new('julian', 1),
				init_function: 'InitialiseMatch'
		}

		match = slim :"screens/match", locals: locals, layout: :js_layout

		slim :game, locals: { screen: match }
	end

	get '/testresult' do
		locals = {
				did_win: true,
				winning_choice: 'rock',
				losing_choice: 'scissors',
				init_function: 'InitialiseResult'
		}

		result = slim :'screens/result', locals: locals, layout: :js_layout

		slim :game, locals: { screen: result }
	end

	get '/communicate/:code/:player_id' do |code, player_id|
		if request.websocket?

			tournament = find_tournament(code)
			player = find_player_in_tournament(tournament, player_id.to_i)

			request.websocket do |ws|
				ws.onopen do
					puts "someone has connected"

					player.add_socket(ws)

					send_all_players_message(tournament, show_lobby(tournament))
				end
				ws.onmessage do |msg|
					message = Message.new(msg)

					if message.get_name == 'play'
						if tournament.is_ready
							players = tournament.get_opposing_player_pairs

							players.each do |opponents|
								show_player_match(opponents.get_player_1, opponents.get_player_2)
								show_player_match(opponents.get_player_2, opponents.get_player_1)
							end

						end
					end

					if message.get_name == 'submitChoice'

						player.set_current_choice(message.get_data["choice"])

						opponent = tournament.get_opponent(player)
						opponent_choice = opponent.get_current_choice

						if (!opponent_choice.nil?)

								is_draw = GameHelper.is_match_draw(player.get_current_choice, opponent.get_current_choice)
							if is_draw
								show_player_match(player, opponent)
								show_player_match(opponent, player)
							else
								did_win = GameHelper.did_player_win(player.get_current_choice, opponent.get_current_choice)

								winning_choice = did_win ? player.get_current_choice : opponent.get_current_choice
								losing_choice = did_win ? opponent.get_current_choice : player.get_current_choice

								show_player_result(player, did_win, winning_choice, losing_choice)
								show_player_result(opponent, !did_win, winning_choice, losing_choice)
							end

							player.clear_choice
							opponent.clear_choice

						end
					end

					if message.get_name == 'showLobby'
						lobby = show_lobby(tournament)

						send_player_message(player, lobby)
					end


				end
				ws.onclose do
					warn("websocket closed")

					tournament.delete_player(player)

					if tournament.get_players.length == 0
						puts "deleting tournament"
						settings.tournaments.delete(tournament)
					else
						send_all_players_message(tournament, show_lobby(tournament))	
					end
				end
			end

		end
	end

	def is_blank(thing)
		return thing.nil? || thing.empty?
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

	def send_player_message(player, message)
		if !player.get_socket.nil?
			EM.next_tick { player.get_socket.send(message) }
		end
	end

	def send_all_players_message(tournament, message)
		tournament.get_players.each do |player|
				send_player_message(player, message)
			end
	end

	def show_lobby(tournament)
		locals = {
			players: tournament.get_players_with_sockets, 
			code: tournament.get_code,
			init_function: 'InitialiseLobby'
		}

		return slim :"screens/lobby", locals: locals, layout: :js_layout
	end

	def show_player_match(player, opponent)
		locals = {
			player: player,
			opponent: opponent,
			init_function: 'InitialiseMatch'
		}

		match = slim :"screens/match", locals: locals, layout: :js_layout

		send_player_message(player, match)
	end

	def show_player_result(player, did_win, winning_choice, losing_choice)
		locals = {
				did_win: did_win,
				winning_choice: winning_choice,
				losing_choice: losing_choice,
				init_function: 'InitialiseResult'
		}

		result = slim :"screens/result", locals: locals, layout: :js_layout

		send_player_message(player, result)
	end
end