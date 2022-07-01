class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :state, default: 0
      t.belongs_to :player1
      t.belongs_to :player2
<<<<<<< HEAD
      t.integer :suit
      t.boolean :turn, default: true
=======
      t.string :suit
      t.boolean :turn
>>>>>>> b35c58206d22fd6882ff5598252e70bf2984d7d3
      t.string :discard_pile, default: ""

      t.timestamps
    end
  end
end
