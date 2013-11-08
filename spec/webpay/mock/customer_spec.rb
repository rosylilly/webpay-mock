require 'spec_helper'

describe WebPay::Mock::Customer do
  let(:params) do
    {
      email: 'rosylilly@aduca.org',
      description: 'webpay-mock',
    }
  end
  let(:customer) { WebPay::Customer.create(params) }

  describe '#create' do
    subject { customer }

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

  describe '#retrieve' do
    subject { WebPay::Customer.retrieve(customer.id) }

    it { should == customer }
  end

  describe '#update' do
    before do
      customer.email = 'example@webpay.jp'
      customer.save
    end

    it { expect(customer.email).to eq('example@webpay.jp') }
  end
end
