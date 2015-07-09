class AddUpvoteToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :upvote, :boolean, default: true
  end
end
