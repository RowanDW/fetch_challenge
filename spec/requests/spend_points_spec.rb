require 'rails_helper'

RSpec.describe 'The add transacrion endpoint' do
    before :each do
        @transaction1 = Transaction.create(payer: "DANNON", points: 300, timestamp: "2020-10-31T10:00:00Z", remaining_points: 300)
        @transaction2 = Transaction.create(payer: "UNILEVER", points: 200, timestamp: "2020-10-31T11:00:00Z", remaining_points: 200)
        @transaction3 = Transaction.create(payer: "DANNON", points: 200, timestamp: "2020-10-31T15:00:00Z", remaining_points:  0)
        @transaction4 = Transaction.create(payer: "MILLER COORS", points: 10000, timestamp: "2020-11-01T14:00:00Z", remaining_points: 10000)
        @transaction5 = Transaction.create(payer: "DANNON", points: 1000, timestamp: "2020-11-02T14:00:00Z", remaining_points: 1000)
        @transaction6 = Transaction.create(payer: "NINTENDO", points: 1000, timestamp: "2020-11-02T14:00:00Z", remaining_points: 0)
    end

    it 'can return payer points balances' do
        post '/spend_points', params: {points: 400}

        expect(response).to be_successful
        result = JSON.parse(response.body)

        expect(result["DANNON"]).to eq(-300)
        expect(result["UNILEVER"]).to eq(-100)
    end

    it 'returns an error if user doesnt have enough points' do
        post '/spend_points', params: {points: 50000000}

        expect(response).to have_http_status(400)
        result = JSON.parse(response.body)

        expect(result["error"]).to eq("User does not have enough points")
    end
end