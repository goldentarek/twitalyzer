class AddTwitterSecretsToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_token, :string
    add_index :users, :twitter_token
    add_column :users, :twitter_token_secret, :string
    add_index :users, :twitter_token_secret
  end
end
