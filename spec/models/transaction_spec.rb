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
            @transaction1 = Transaction.create(payer: "UNILEVER", points: 200, timestamp: "2020-10-31T11:00:00Z", remaining_points: 200)
            @transaction2 = Transaction.create(payer: "DANNON", points: 300, timestamp: "2020-10-31T10:00:00Z", remaining_points: 300)
            @transaction3 = Transaction.create(payer: "DANNON", points: 200, timestamp: "2020-10-31T15:00:00Z", remaining_points:  0)
            @transaction4 = Transaction.create(payer: "MILLER COORS", points: 10000, timestamp: "2020-11-01T14:00:00Z", remaining_points: 10000)
            @transaction5 = Transaction.create(payer: "DANNON", points: 1000, timestamp: "2020-11-02T14:00:00Z", remaining_points: 1000)
        end

        describe '.point_balances' do
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

        describe '.total_points_balance' do
            it 'can calculate the total points for a user' do
                expect(Transaction.total_points_balance).to eq(11500)
            end

            it 'returns zero if there are no transactions' do
                Transaction.destroy_all
                expect(Transaction.total_points_balance).to eq(0)
            end
        end

        describe '.unspent_transactions' do
            it 'returns all transactions with positive remaining points' do
                result = Transaction.unspent_transactions
                
                expect(Transaction.count).to eq(5)
                expect(result.count).to eq(4)
            end

            it 'returns transactions oldest timestamp first' do
                result = Transaction.unspent_transactions
                
                expect(result.first).to eq(@transaction2)
                expect(result.second).to eq(@transaction1)
                expect(result.third).to eq(@transaction4)
                expect(result.fourth).to eq(@transaction5)
            end

            it 'return all transactions for a given payer with postitive remaining points' do
                result = Transaction.unspent_transactions("DANNON")
                
                expect(Transaction.count).to eq(5)
                expect(result.count).to eq(2)
            end
        end

        describe '.spend_points' do
            it 'can deduct points from a single transaction' do
                expect(@transaction2.remaining_points).to eq(300)
                Transaction.spend_points(100)
                @transaction2.reload
                expect(@transaction2.remaining_points).to eq(200)
            end

            it 'can deduct points from multiple transactions' do
                expect(@transaction2.remaining_points).to eq(300)
                expect(@transaction1.remaining_points).to eq(200)

                Transaction.spend_points(400)
                @transaction2.reload
                @transaction1.reload

                expect(@transaction2.remaining_points).to eq(0)
                expect(@transaction1.remaining_points).to eq(100)
            end

            it 'returns a hash of points deducted from each payer' do
                result = Transaction.spend_points(400)
                
                expect(result.keys.count).to eq(2)
                expect(result["DANNON"]).to eq(-300)
                expect(result["UNILEVER"]).to eq(-100)
            end
        end

        describe '.subtract_payer_points' do
            it 'subtracts points from a single payers unspent transaction' do
                expect(@transaction2.remaining_points).to eq(300)
                Transaction.subtract_payer_points(200, "DANNON")

                @transaction2.reload

                expect(@transaction2.remaining_points).to eq(100)
            end

            it 'subtracts points from mulitple payers unspent transactions' do
                expect(@transaction2.remaining_points).to eq(300)
                expect(@transaction5.remaining_points).to eq(1000)
                Transaction.subtract_payer_points(600, "DANNON")

                @transaction2.reload
                @transaction5.reload

                expect(@transaction2.remaining_points).to eq(0)
                expect(@transaction5.remaining_points).to eq(700)
            end
        end
    end
end