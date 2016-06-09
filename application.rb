require 'sinatra'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/base'
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
		new_tournament.add_player(name)

		settings.tournaments.push(new_tournament)

		redirect "/game/#{code}"
	end

	get '/game/:code' do |code|
		@code = code
		slim :game
	end

end