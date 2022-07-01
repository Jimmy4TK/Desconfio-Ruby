# API Desconfio

# Clone Repository
```bash
cd /path
git clone https://github.com/Jimmy4TK/Tateti-Ruby.git
cd Tateti-Ruby
```

# Set Up

## Install bundle

```bash
cd ~Tateti-Ruby
gem install bundle
bundle install
```

## Set Up Database

```bash
Rails db:create
Rails db:migrate
Rails db:seed
```

# Use Api

# Model Game

## Create cards

### The method creates all the cards to game

## Cards shuffle

### The method shuffles the cards and randomly assigns cards to player 1 and player 2

## Desconfio

### The method checks if the last card in the discard pile is the same suit as the first card

## Cards switch

### The method assigns all cards in the discard pile to the player

## Check winner

### the method checks if all the cards in the game are not assigned to a player, if there are no cards assigned, it returns that the player won

# User Controller

## Create User (Register)

### The method needs params: password, password2 and user with name, email and password. Method returns user token

## Login

### The method needs params: email and password. Method returns user and user token

## Password

### The method needs params: user token, currentPassword, newPassword and newPassword2. Method returns password changed


# Game Controller

## Create

### The method needs params: user token. Method returns game created with its creator

## Show

### The method needs params game id. Method returns game with players

## Assign player

### The method needs params game id and user token. Method return game with 2 players

## Incomplete

### The method return games with only 1 player

## Drop card

### The method needs params: card id and game id. Method change card user to nil and add it to discard pile, turn change and check win

## Desconfio

### The method needs params game id. Method checks if the player was right to distrust or not. Return player 1 or player 2 with all cards from the discard pile

