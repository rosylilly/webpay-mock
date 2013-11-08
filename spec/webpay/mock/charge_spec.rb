require 'spec_helper'

describe WebPay::Mock::Charge do
  let(:customer_params) do
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
  let(:customer) { WebPay::Customer.create(customer_params) }
  let(:params) do
    {
      customer: customer.id,
      amount: 200,
      currency: 'jpy',
    }
  end
  let(:charge) { WebPay::Charge.create(params) }

  describe '#create' do
    it { expect(charge).to be_kind_of(WebPay::Charge) }
  end

  describe '#retrieve' do
    subject { WebPay::Charge.retrieve(charge.id) }

    it { should == charge }
  end

  describe '#refund' do
    before { charge.refund }

    it { expect(charge.refunded).to be_true }
  end

  describe '#capture' do
    let(:params) do
      {
        customer: customer.id,
        amount: 200,
        currency: 'jpy',
        capture: false
      }
    end

    it do
      expect(charge.captured).to be_false
      charge.capture
      expect(charge.captured).to be_true
    end
  end
end
