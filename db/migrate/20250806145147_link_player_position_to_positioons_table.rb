class LinkPlayerPositionToPositioonsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :position, :string
    add_reference :players, :position, foreign_key: true
  end
end
