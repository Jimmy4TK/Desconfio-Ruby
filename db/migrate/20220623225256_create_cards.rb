class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.integer :number
      t.integer :suit
      t.belongs_to :user
      t.belongs_to :game

      t.timestamps
    end
  end
end
