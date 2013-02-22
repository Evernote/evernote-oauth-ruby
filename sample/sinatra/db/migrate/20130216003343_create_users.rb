class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :username
      t.string :token
      t.boolean :active, default: true
    end
  end
end
