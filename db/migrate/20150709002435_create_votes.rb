class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :shortened_url_id
      t.integer :voter_id

      t.timestamps
    end

    add_index :votes, :shortened_url_id
    add_index :votes, :voter_id
  end
end
