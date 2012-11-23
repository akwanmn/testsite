require 'spec_helper'

describe Order do
  let(:current_order) { Fabricate(:order) }

  context 'Fabricators' do 
    subject { current_order }
    it { should be_valid }
  end

  context 'create order' do 
    subject { current_order }
    its(:price_in_cents) { should eql 1295.0 }
    its(:ip_address) { should_not be_nil }
    context 'credit card' do 
      let(:credit_card) { subject.credit_card }
      it 'is valid' do 
        subject.send(:validate_card).should be_nil
      end
      it 'is not valid' do 
        subject.credit_card.stub!(:brand).and_return('Visa')        
        subject.send(:validate_card)
        expect(subject.errors.messages[:base]).to include('Brand is not the correct card brand')
      end
    end

    its(:purchase) { should be_true }

    context 'order transaction' do
      let(:purchase) do 
        subject.purchase
        subject.transactions.first
      end
      it 'action' do 
        purchase.action.should eql 'purchase'
      end
      it 'amount' do 
        purchase.amount.should eql 1295
      end
      it 'success' do 
        purchase.success.should be_true
      end
      it 'message' do 
        purchase.message.should eql 'Bogus Gateway: Forced success'
      end
    end

    context 'purchase options' do
      subject { current_order.send(:purchase_options) }
      its([:ip]) { should_not be_blank }
      context 'billing address' do
        let(:address) { subject[:billing_address] }
        let(:user_profile) { current_order.user.user_profile }
        it 'name' do 
          expect(address[:name]).to eql user_profile.user.full_name
        end
        it 'address1' do 
          expect(address[:address1]).to eql user_profile.address_street
        end
        it 'city' do 
          expect(address[:city]).to eql user_profile.address_city
        end
        it 'state' do 
          expect(address[:state]).to eql user_profile.address_state
        end
        it 'country' do 
          expect(address[:country]).to eql user_profile.address_country
        end
        it 'zip' do 
          expect(address[:zip]).to eql user_profile.address_zip
        end
      end
    end

  end
end