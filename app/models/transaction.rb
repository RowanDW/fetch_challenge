class Transaction < ApplicationRecord
    validates_presence_of(:payer)
    validates_presence_of(:points)
    validates_presence_of(:timestamp)
    validates_presence_of(:remaining_points)

    def self.point_balances
        payer_points = Transaction.select('payer, SUM(remaining_points) as balance')
            .group(:payer)
        result_hash = {}
        payer_points.each { |pp| result_hash[pp.payer] = pp.balance } 
        result_hash
    end
end