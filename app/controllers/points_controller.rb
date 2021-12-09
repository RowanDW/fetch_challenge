class PointsController < ApplicationController
    def balance
        render json: Transaction.point_balances
    end
end