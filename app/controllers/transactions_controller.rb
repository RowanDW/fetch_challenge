class TransactionsController < ApplicationController
    def create
        transaction = Transaction.new(payer: params[:payer], points: params[:points], timestamp: params[:timestamp], remaining_points: params[:points])
        if transaction.save
            if transaction.points < 0
                # for points coming in as a negative value, points get changed to postive value to be subtracted
                Transaction.subtract_payer_points((transaction.points * -1), transaction.payer)
                transaction.update(remaining_points: 0)
            end
            render json: { payer: transaction.payer, points: transaction.points, timestamp: transaction.timestamp }
        else
            render json: {error: "Invalid transaction inputs"}, status: 400
        end
    end
end