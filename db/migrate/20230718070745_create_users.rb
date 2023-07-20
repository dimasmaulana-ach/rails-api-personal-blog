class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.text :personal_token
      t.boolean :verify
      t.references :role, type: :uuid, foreign_key: true

      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
  end
end
