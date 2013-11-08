require 'webpay/mock'

class WebPay::Mock::Customer < WebPay::Mock::Object
  def self.create(params, id = nil)
    self.new(params)
  end

  def active_card
    return nil unless @attributes[:card]

    @card ||= WebPay::Mock::Card.new(@attributes[:card])
  end

  def attributes
    {
      email: @attributes[:email],
      description: @attributes[:description],
      active_card: active_card
    }
  end
end
