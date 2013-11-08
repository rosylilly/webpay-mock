require 'spec_helper'

describe WebPay::Mock::Client do
  let(:client) { described_class.new }

  [:get, :post, :delete].each do |http_method|
    describe "##{http_method}" do
      let(:path) { '/path' }
      let(:params) { {} }

      subject(:request_method) { client.send(http_method, path, params) }

      it "should call #request with #{http_method}" do
        client.should_receive(:request).with(http_method, path, params)
        request_method
      end
    end
  end

  describe '#request' do
    let(:http) { :get }
    let(:path) { '/customers/id' }
    let(:params) { {} }

    subject(:request) { client.request(http, path, params) }

    it 'should delegate mock class' do
      WebPay::Mock::Customer.should_receive(:retrieve).with({}, 'id')

      request
    end
  end

  describe '#class_by' do
    subject { client.class_by(obj) }

    {
      'charges' => WebPay::Mock::Charge,
      'customers' => WebPay::Mock::Customer,
      'tokens' => WebPay::Mock::Token,
      'events' => WebPay::Mock::Event,
      'account' => WebPay::Mock::Account,
    }.each_pair do |object, klass|
      context "with #{object}" do
        let(:obj) { object }
        let(:expected) { klass }

        it { should == expected }
      end
    end
  end

  describe '#method_by' do
    let(:http) { :get }
    let(:action) { nil }

    subject(:method_by) { client.method_by(http, id, action) }

    context 'with id' do
      let(:id) { 1 }

      it 'should call #instance_method_by' do
        client.should_receive(:instance_method_by).with(http, action)
        method_by
      end
    end

    context 'without id' do
      let(:id) { nil }

      it 'should call #class_method_by' do
        client.should_receive(:class_method_by).with(http)
        method_by
      end
    end
  end

  describe '#class_method_by' do
    subject { client.class_method_by(http) }

    context 'with get request' do
      let(:http) { :get }

      it { should == :all }
    end

    context 'with post request' do
      let(:http) { :post }

      it { should == :create }
    end
  end

  describe '#instance_method_by' do
    let(:action) { nil }
    subject { client.instance_method_by(http, action) }

    context 'with get request and empty action' do
      let(:http) { :get }

      it { should == :retrieve }
    end

    context 'with post request and empty action' do
      let(:http) { :post }

      it { should == :update }
    end

    context 'with delete request and empty action' do
      let(:http) { :delete }

      it { should == :delete }
    end

    context 'with post request and refund action' do
      let(:http) { :post }
      let(:action) { 'refund' }

      it { should == :refund }
    end
  end
end
