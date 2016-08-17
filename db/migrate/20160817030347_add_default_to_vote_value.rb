class AddDefaultToVoteValue < ActiveRecord::Migration[5.0]
  def change
    change_column :votes, :value, :integer, default: 0
  end
end
