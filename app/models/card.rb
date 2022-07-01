class Card < ApplicationRecord
    #Relations
    belongs_to :user, optional: true
    belongs_to :game

    enum suit: { oro: 0, basto: 1, espada: 2, copa: 3}

end
