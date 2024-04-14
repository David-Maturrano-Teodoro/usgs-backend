class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :Comm_Body
      t.references :feature, null: false, foreign_key: true

      t.timestamps
    end
  end
end
