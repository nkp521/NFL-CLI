class Position < ActiveRecord::Base
  has_many :players

  def player_count
    players.count
  end
end
