require 'rails_helper'

RSpec.describe Transaction , type: :model do
    describe "validations" do
        it { should validate_presence_of(:payer) }
        it { should validate_presence_of(:points) }
        it { should validate_presence_of(:timestamp) }
        it { should validate_presence_of(:remaining_points) }
    end

    describe '#class_methods' do
        before :each do
            @transaction1 = Transaction.create(payer: "DANNON", points: 300, timestamp: "2020-10-31T10:00:00Z", remaining_points: 300)
            @transaction2 = Transaction.create(payer: "UNILEVER", points: 200, timestamp: "2020-10-31T11:00:00Z", remaining_points: 200)
            @transaction3 = Transaction.create(payer: "DANNON", points: 200, timestamp: "2020-10-31T15:00:00Z", remaining_points:  0)
            @transaction4 = Transaction.create(payer: "MILLER COORS", points: 10000, timestamp: "2020-11-01T14:00:00Z", remaining_points: 10000)
            @transaction5 = Transaction.create(payer: "DANNON", points: 1000, timestamp: "2020-11-02T14:00:00Z", remaining_points: 1000)
        end

        describe 'point_balances' do
            it 'can return points balances for each payer' do
                result = Transaction.point_balances
                expect(result["DANNON"]).to eq(1300)
                expect(result["UNILEVER"]).to eq(200)
                expect(result["MILLER COORS"]).to eq(10000)
            end

            it 'returns payers with zero point balances' do
                transaction6 = Transaction.create(payer: "NINTENDO", points: 1000, timestamp: "2020-11-02T14:00:00Z", remaining_points: 0)
                result = Transaction.point_balances
                expect(result["DANNON"]).to eq(1300)
                expect(result["UNILEVER"]).to eq(200)
                expect(result["MILLER COORS"]).to eq(10000)
                expect(result["NINTENDO"]).to eq(0)
            end
        end

        describe 'total_points_balance' do
            it 'can calculate the total points for a user' do
                expect(Transaction.total_points_balance).to eq(11500)
            end

            it 'returns zero if there are no transactions' do
                Transaction.destroy_all
                expect(Transaction.total_points_balance).to eq(0)
            end
        end
    end
end