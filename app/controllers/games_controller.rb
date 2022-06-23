class GamesController < ApplicationController
    before_action :set_game, only: [:show, :assign_player]
    before_action :set_player, only: [:create, :assign_player]

    def show
        render status: 200, json: {
            id: @game.id,
            state: @game.state,
            player1: @game.player1&.name,
            player2: @game.player2&.name
        }
    end

    def create
        @game = Game.new
        @game.player1 = @user
        if @game.save
            render status: 200, json: {
                id: @game.id,
                state: @game.state,
                player1: @game.player1&.name,
                player2: @game.player2&.name
            }
        else
            render_errors_response
        end
    end

    def incomplete
        @games = Game.waiting_player
        if @games.length >= 1
            games_incomplete = []
            @games.each { |g| games_incomplete.push({ id: g.id, player1: g.player1.name }) }
            render status: 200, json: { games: games_incomplete }
        else
            render status: 400, json: { error: 'Games with 1 player not found' }
        end
    end

    def assign_player
        return render status: 400, json: { error: "Game #{@game.id} already has 2 players" } if @game.player2.present?
        @game.player2 = @user
        @game.state = :in_game
        if @game.save
            render status: 200, json: {
                id: @game.id,
                state: @game.state,
                player1: @game.player1&.name,
                player2: @game.player2&.name
            }
        else
            render status: 400, json: { error: @game.errors.full_messages }
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

    def check_token(player)
        return if request.headers["Authorization"] == "Bearer #{player.token}"
        
        render status: 400, json: { error: 'User Token isnt valid' }
        false
    end
end
