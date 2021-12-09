class PointsController < ApplicationController
    def balance
        Transaction.get_balances
    end
end