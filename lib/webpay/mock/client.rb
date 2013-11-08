require 'webpay/mock'

class WebPay::Mock::Client
  def get(path, params = {})
    request(:get, path, params)
  end

  def post(path, params)
    request(:post, path, params)
  end

  def delete(path, params)
    request(:delete, path, params)
  end

  def request(method, path, params)
    object, id, action = *(path.sub(%r{^/}, '').split('/'))

    ret = class_by(object)\
      .send(
        method_by(method, id, action),
        symbolize(params),
        id
      )

    ret ? ret.to_hash : nil
  end

  def class_by(object)
    case object
    when 'charges'
      WebPay::Mock::Charge
    when 'customers'
      WebPay::Mock::Customer
    when 'tokens'
      WebPay::Mock::Token
    when 'events'
      WebPay::Mock::Event
    when 'account'
      WebPay::Mock::Account
    end
  end

  def method_by(http, id, action)
    if id.nil?
      class_method_by(http)
    else
      instance_method_by(http, action)
    end
  end

  def class_method_by(http)
    case http
    when :post then :create
    when :get  then :all
    end
  end

  def instance_method_by(http, action)
    if action.nil?
      case http
      when :post   then :update
      when :get    then :retrieve
      when :delete then :delete
      end
    else
      action.to_sym
    end
  end

  private

  def symbolize(hash)
    new_hash = {}
    hash.each_pair do |key, val|
      new_hash[key.to_s.to_sym] = val === Hash ? symbolize(val) : val
    end
    new_hash
  end
end
