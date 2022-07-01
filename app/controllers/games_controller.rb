class GamesController < ApplicationController
    before_action :set_game, only: [:show, :assign_player,:drop_card,:desconfio]
    before_action :set_player, only: [:create, :assign_player]
    before_action :set_card, only: [:drop_card]
    before_action :check_token, only: [:drop_card,:desconfio]

    def show
        render status:200, json:{
                id: @game.id,
                state: @game.state,
                turn: @game.turn,
                discard_pile: @game.discard_pile.split(',').size,
                player1: @game.player1,
                player2: @game.player2,
                suit: @game.suit,
                cards_player1: @game.cards.where(user: @game.player1),
                cards_player2: @game.cards.where(user: @game.player2)
            }
    end

    def create
        @game = Game.new
        @game.player1 = @user
        if @game.save
            render status: 200, json: {
                id: @game.id,
                state: @game.state,
                player1: @game.player1,
                player2: @game.player2
            }
        else
            render status: 400, json: { error: @game.errors.full_messages }
        end
    end

    def incomplete
        @games = Game.waiting_player
        if @games.length >= 1
            games_incomplete = []
            @games.each { |g| games_incomplete.push({ id: g.id, player1: g.player1 }) }
            render status: 200, json: { games: games_incomplete }
        else
            render status: 400, json: { error: 'Games with 1 player not found' }
        end
    end

    def assign_player
        return render status: 400, json: { error: "Game #{@game.id} already has 2 players" } if @game.player2.present?
        @game.player2 = @user
        @game.state = :in_game
        @game.cards_shuffle
        if @game.save
            render status:200, json:{
                id: @game.id,
                state: @game.state,
                turn: @game.turn,
                discard_pile: @game.discard_pile.split(',').size,
                suit: @game.suit,
                player1: @game.player1,
                player2: @game.player2,
                cards_player1: @game.cards.where(user: @game.player1),
                cards_player2: @game.cards.where(user: @game.player2)
            }
        else
            render status: 400, json: { error: @game.errors.full_messages }
        end
    end

    def drop_card
        if @game.discard_pile.blank?
            @game.suit=@card.suit
        end
        @game.discard_pile+="#{params[:card_id]},"
        @card.user=nil
        if @card.save
            @game.check_winner
            @game.toggle(:turn)
            if @game.save
                render status:200, json:{
                    id: @game.id,
                    state: @game.state,
                    turn: @game.turn,
                    discard_pile: @game.discard_pile.split(',').size,
                    player1: @game.player1,
                    player2: @game.player2,
                    suit: @game.suit,
                    cards_player1: @game.cards.where(user: @game.player1),
                    cards_player2: @game.cards.where(user: @game.player2)
                }
            else
                render status: 400, json: { error: @game.errors.full_messages }
            end
        else
            render status: 400, json: { error: @game.errors.full_messages }
        end
        
    end

    def desconfio
        if @game.discard_pile? && @game.discard_pile.split(',').size>=2
            last_card=@game.discard_pile.split(',').last
            last_card=Card.find_by(id:last_card.to_i)
            @game.desconfio(last_card)
            @game.check_winner
            if @game.save
                render status:200, json:{
                    id: @game.id,
                    state: @game.state,
                    turn: @game.turn,
                    discard_pile: @game.discard_pile.split(',').size,
                    player1: @game.player1,
                    player2: @game.player2,
                    cards_player1: @game.cards.where(user: @game.player1),
                    cards_player2: @game.cards.where(user: @game.player2)
                }
            else
                render status:400, json: { error: @game.errors.full_messages }
            end
        else
            render status:400, json:{ error: "Must have passed the second turn to distrust"}
        end
    end

    private

    def set_game
        @game = Game.find_by(id: params[:id])
        return if @game.present?

        render status: 404, json: { error: "Game #{params[:id]} doesn't exist" }
        false
    end

    def set_player
        @user = User.find_by(token: params[:token])
        return if @user.present?

        render status: 404, json: { error: 'User doesnt exist' }
        false
    end

    def set_card
        @card = Card.find_by(id: params[:card_id])
        return if @card.present?

        render status: 404, json: { error: 'Card doesnt exist' }
        false
    end


    def check_token
        player = @game.turn? ? @game.player1 : @game.player2
    
        return if request.headers["Authorization"] == "Bearer #{player.token}"
    
        render status: 400, json: { error: 'User Token isnt valid' }
        false
    end
end
