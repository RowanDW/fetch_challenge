class TransactionsController < ApplicationController
    def create
        transaction = Transaction.new(
            payer: params[:payer], 
            points: params[:points], 
            timestamp: params[:timestamp], 
            remaining_points: params[:points]
            )
        if transaction.save
            render json: {
                payer: transaction.payer,
                points: transaction.points,
                timestamp: transaction.timestamp
            }
        else
            render json: {error: "Invalid transaction inputs"}, status: 400
        end
    end

    private

    def valid_inputs

    end
end