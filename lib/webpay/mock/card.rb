require 'webpay/mock'
require 'digest/md5'

class WebPay::Mock::Card < WebPay::Mock::Object
  def fingerprint
    @fingerprint ||= Digest::MD5.hexdigest([
      @attributes[:number],
      @attributes[:exp_month],
      @attributes[:exp_year]
    ].map(&:to_s).join('/'))
  end

  def last4
    @last4 ||= @attributes[:number].to_s[-4 .. -1]
  end

  def to_hash
    string_hash(
      object: 'card',
      exp_month: @attributes[:exp_month],
      exp_year: @attributes[:exp_year],
      fingerprint: fingerprint,
      last4: last4,
      type: 'unknown',
      cvc_check: 'pass',
      name: @attributes[:name]
    )
  end
end
