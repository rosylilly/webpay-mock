require 'webpay'
require 'webpay/mock/version'
require 'webpay/mock/client'
require 'webpay/mock/charge'
require 'webpay/mock/customer'
require 'webpay/mock/token'
require 'webpay/mock/event'
require 'webpay/mock/account'

module WebPay::Mock
  class << self
    attr_accessor :original_client
  end

  def self.enable!(&block)
    self.original_client = WebPay.client
    WebPay.instance_eval do
      @client = WebPay::Mock::Client.new
    end

    if block
      yield
      disable!
    end
  end

  def self.disable!
    WebPay.instance_eval do
      @client = WebPay::Mock.original_client
    end
  end
end
