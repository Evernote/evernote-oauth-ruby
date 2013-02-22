class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :guid
      t.string :user_id
      t.string :title
      t.string :content
    end
  end
end
