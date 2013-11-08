require 'spec_helper'

describe WebPay::Mock::Customer do
  describe '#create' do
    let(:params) do
      {
        email: 'rosylilly@aduca.org',
        description: 'webpay-mock',
      }
    end
    subject(:customer) { WebPay::Customer.create(params) }

    it { should_not be_nil }
    it { should be_kind_of(WebPay::Customer) }
    it { expect(customer.id).to_not be_nil }
    it { expect(customer.active_card).to be_nil }

    context 'with card' do
      let(:params)  do
        {
          card: {
            number: '4242424242424242',
            name: 'Sho Kusano',
            exp_month: '06',
            exp_year: '2013',
            cvc: '000'
          }
        }
      end

      it { expect(customer.active_card).to be_kind_of(WebPay::Card) }
    end
  end
end
