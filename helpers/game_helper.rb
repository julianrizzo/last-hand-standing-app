class GameHelper

	def self.is_match_draw(player_choice, opponent_choice)
		return player_choice == opponent_choice
	end

	def self.did_player_win(player_choice, opponent_choice)

		if (player_choice == 'rock')

			if (opponent_choice == 'paper')
				# player lost
				return false
			end
			 # player won
				return true
		end

		if (player_choice == 'scissors')

			if(opponent_choice == 'rock')
				# player lost
				return false
			end
			# player won
			return true
		end

		if (player_choice == 'paper')

			if (opponent_choice == 'scissors')
				# player lost
				return false
			end
			# player won
			return true
		end

	end

end