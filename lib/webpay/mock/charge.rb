require 'webpay/mock'

class WebPay::Mock::Charge < WebPay::Mock::Object
  def self.refund(params, id)
    retrieve({}, id).tap do |charge|
      charge.refund(params[:amount])
    end
  end

  def self.capture(params, id)
    retrieve({}, id).tap do |charge|
      charge.capture(params[:amount])
    end
  end

  def default
    {
      livemode: false,
      capture: true,
      amount_refunded: 0,
    }
  end

  def card
    return nil unless @attributes[:card] || @attributes[:customer]

    @card ||=
      if @attributes[:customer]
        customer.active_card
      else
        WebPay::Mock::Card.new(@attributes[:card])
      end
  end

  def customer
    WebPay::Mock::Customer.retrieve({}, @attributes[:customer])
  end

  def captured?
    !!@attributes[:capture]
  end

  def refunded?
    @attributes[:amount] == @attributes[:amount_refunded]
  end

  def refund(amount)
    amount ||= @attributes[:amount]
    @attributes[:amount_refunded] += amount
  end

  def capture(amount)
    amount ||= @attributes[:amount]
    @attributes[:amount] = amount
    @attributes[:capture] = true
  end

  def attributes
    {
      livemode: @attributes[:livemode],
      amount: @attributes[:amount],
      card: card,
      created: @created_at.to_i,
      currency: @attributes[:currency],
      paid: captured?,
      captured: captured?,
      refunded: refunded?,
      amount_refunded: @attributes[:amount_refunded],
      customer: @attributes[:customer],
      description: @attributes[:description],
      failure_message: @attributes[:failure_message],
      expire_time: nil,
    }
  end
end
