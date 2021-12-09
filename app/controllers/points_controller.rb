class PointsController < ApplicationController
    def balance
        render json: Transaction.point_balances
    end

    def spend
        if Transaction.total_points_balance >= params[:points].to_i
            render json: Transaction.spend_points(params[:points].to_i)
        else
            render json: {error: "User does not have enough points"}, status: 400
        end
    end
end