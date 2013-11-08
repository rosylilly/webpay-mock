require 'webpay/mock'

class WebPay::Mock::Object
  def initialize(attributes)
    @attributes = attributes
    @created_at = Time.now
  end

  def id
    @id ||= WebPay::Mock::ID.new(self)
  end

  def to_hash
    string_hash({
      id: id.to_s,
      object: self.class.name.sub(/.*::/, '').downcase,
    }.merge(attributes))
  end

  def string_hash(hash)
    new_hash = {}
    hash.each_pair do |key, val|
      new_hash[key.to_s] =
        val.respond_to?(:to_hash) ? string_hash(val.to_hash) : val
    end
    new_hash
  end
end
