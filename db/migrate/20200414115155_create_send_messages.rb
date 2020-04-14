class CreateSendMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :send_messages do |t|
      t.string :user_id
      t.string :reply_token
      t.string :message_type
      t.text :message_text
      t.integer :mentor_id
      t.timestamps
    end
  end
end
