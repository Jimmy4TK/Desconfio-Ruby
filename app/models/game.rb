class Game < ApplicationRecord
    belongs_to :player1, class_name: 'User'
    belongs_to :player2, class_name: 'User', optional: true

    enum state: { waiting_player: 0, in_game: 1, win_player1: 2, win_player2: 3, draw: 4 }
end
