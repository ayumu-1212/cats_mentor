class CreateReceiveMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :receive_messages do |t|
      t.string :user_id
      t.string :reply_token
      t.integer :message_id, :limit => 8
      t.string :message_type
      t.text :message_text
      t.timestamps
    end
  end
end
