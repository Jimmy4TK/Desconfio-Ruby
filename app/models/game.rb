class Game < ApplicationRecord
    #Relations
    belongs_to :player1, class_name: 'User'
    belongs_to :player2, class_name: 'User', optional: true
    has_many :cards
    
    #Callbacks
    after_create :create_cards

    #Methods
    SUITS=["espada","basto","copa","oro"]
    def create_cards
        for i in 1..12 do
            for j in SUITS
                self.cards.create(number:i,suit:j)
            end
        end
    end

    def cards_shuffle
        switch=true
        self.cards.shuffle.each do |card|
            switch ? (card.user=self.player1;switch=false) : (card.user=self.player2;switch=true)
            card.save
        end
    end

    def desconfio(last_card)
        if last_card.suit==self.suit
            player= self.turn ? self.player1 : self.player2
        else
            player= self.turn ? self.player2 : self.player1
        end
        self.cards_switch(player)
        self.discard_pile=""
        self.toggle(:turn)
        self.suit=nil
    end

    def cards_switch(player)
        card_discard_pile=[]
        self.discard_pile.split(',').map { |x| card_discard_pile.push(Card.find_by(id: x.to_i))  }
        card_discard_pile.each do |card|
            card.user=player
            card.save
        end
    end

    def check_winner
        if self.cards.where(user: self.player1).size==0
            self.state= :win_player1
        elsif  self.cards.where(user: self.player2).size==0
            self.state= :win_player2
        end
    end

    enum state: { waiting_player: 0, in_game: 1, win_player1: 2, win_player2: 3}
    enum suit: { oro: 0, basto: 1, espada: 2, copa: 3}
end
