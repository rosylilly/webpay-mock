require 'webpay/mock'

class WebPay::Mock::Customer < WebPay::Mock::Object
  def active_card
    return nil unless @attributes[:card]

    @card ||= WebPay::Mock::Card.new(@attributes[:card])
  end

  def update(params)
    @card = nil
    super
  end

  def attributes
    {
      email: @attributes[:email],
      description: @attributes[:description],
      active_card: active_card
    }
  end
end
