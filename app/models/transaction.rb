class Transaction < ApplicationRecord
    validates_presence_of(:payer)
    validates_presence_of(:points)
    validates_presence_of(:timestamp)
    validates_presence_of(:remaining_points)
end