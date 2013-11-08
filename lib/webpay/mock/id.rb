require 'webpay/mock'
require 'securerandom'

class WebPay::Mock::ID
  def initialize(object_or_klass)
    @object = object_or_klass
  end

  def prefix
    case @object
    when WebPay::Mock::Customer
      'cus'
    when WebPay::Mock::Charge
      'ch'
    when WebPay::Mock::Token
      'tok'
    when WebPay::Mock::Event
      'evt'
    when WebPay::Mock::Account
      'acct'
    else
      'unknown'
    end
  end

  def id
    @id ||= SecureRandom.hex(8)
  end

  def to_s
    "#{prefix}_#{id}"
  end
end
