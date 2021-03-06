require 'simplecov'
SimpleCov.start

require 'bundler/setup'
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.around do |e|
    WebPay::Mock.enable! { e.run }
  end

  config.after(:each) do
    WebPay::Mock.clear!
  end
end
