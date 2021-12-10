class Transaction < ApplicationRecord
    validates_presence_of(:payer)
    validates_presence_of(:points)
    validates_presence_of(:timestamp)
    validates_presence_of(:remaining_points)

    # Returns all point balances for each payer, used for point_balances endpoint
    def self.point_balances
        payer_points = Transaction.select('payer, SUM(remaining_points) as balance')
            .group(:payer)
        result_hash = {}
        payer_points.each { |pp| result_hash[pp.payer] = pp.balance } 
        result_hash
    end

    # Returns total remaining points for all payers
    # Used by spend points endpoint to determine
    def self.total_points_balance
        sum(:remaining_points)
    end

    # Returns all transactions with postitive remaining points, order by oldest first
    def self.unspent_transactions(target_payer = '')
        if target_payer.present?
            where('remaining_points > 0').where('payer = ?', target_payer).order(:timestamp)
        else
            where('remaining_points > 0').order(:timestamp)
        end
    end

    # This is used when a user is trying to spend points
    # Returns a hash of payers and points spent
    def self.spend_points(pts, result = Hash.new(0))
        current_trans = unspent_transactions.first
        # If spending more points than the oldest transaction, then call method recursively
        # to spend multiple transactions
        if pts > current_trans.remaining_points
            result[current_trans.payer] -= current_trans.remaining_points
            pts -= current_trans.remaining_points
            current_trans.update(remaining_points: 0)
            spend_points(pts, result)
        else
            result[current_trans.payer] -= pts
            remaining = current_trans.remaining_points - pts
            current_trans.update(remaining_points: remaining)
            return result
        end
    end

    # Only used when adding a negative points transaction
    def self.subtract_payer_points(points, payer)
        current_trans = unspent_transactions(payer).first
        if points > current_trans.remaining_points
            points -= current_trans.remaining_points
            current_trans.update(remaining_points: 0)
            subtract_payer_points(points, payer)
        else
            remaining = current_trans.remaining_points - points
            current_trans.update(remaining_points: remaining)
        end
    end
end