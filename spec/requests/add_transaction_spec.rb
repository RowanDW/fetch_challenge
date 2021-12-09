require 'rails_helper'

RSpec.describe 'The add transacrion endpoint' do
    before :each do
        @params = { "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }
        @invalid1 = { "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }
        @invalid1 = { "payer": "DANNON", "points": "abc", "timestamp": "2020-11-02T14:00:00Z" }
    end

    it 'can add a transacrion' do
        expect(Transaction.count).to eq(0)
        post '/add_transaction', params: @params

        expect(response).to be_successful

        expect(Transaction.count).to eq(1)
        new_transaction = Transaction.last
        expect(new_transaction.payer).to eq(@params[:payer]) 
        expect(new_transaction.points).to eq(@params[:points]) 
        expect(new_transaction.timestamp).to eq(@params[:timestamp]) 
        expect(new_transaction.remaining_points).to eq(@params[:points]) 
    end

    it 'should return the new transaction' do
        post '/add_transaction', params: @params

        expect(response).to be_successful
        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:payer]).to eq(@params[:payer])
        expect(result[:points]).to eq(@params[:points])
        expect(result[:timestamp].to_datetime).to eq(@params[:timestamp].to_datetime)
    end

    it 'returns an error given bad inputs' do
        post '/add_transaction', params: @invalid

        expect(response).to have_http_status(400)
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:error]).to eq("Invalid transaction inputs")
    end
end