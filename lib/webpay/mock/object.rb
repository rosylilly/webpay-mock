require 'webpay/mock'

class WebPay::Mock::Object
  def self.create(params, id = nil)
    object = new(params)

    WebPay::Mock.storage[object.id.to_s] = object
  end

  def self.retrieve(params, id)
    WebPay::Mock.storage[id]
  end

  def self.update(params, id)
    retrieve({}, id).tap do |object|
      object.update(params)
    end
  end

  def self.delete(params, id)
    WebPay::Mock.storage.delete(id)

    { 'id' => id, 'deleted' => true }
  end

  def initialize(attributes)
    @attributes = attributes
    @created_at = Time.now
  end

  def update(params)
    @attributes = params
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
