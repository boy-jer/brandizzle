World(Authlogic::TestCase)
World(ActionView::Helpers::RecordIdentificationHelper)

Before do
  activate_authlogic
end

After('@sop') do |scenario|
  if(scenario.failed?)
    save_and_open_page
  end
end

require 'spec/stubs/cucumber'
require 'email_spec'
require 'email_spec/cucumber'
require 'features/support/pickle'
require 'features/support/factory_girl'

Before do
  @result = mock("result", :success? => true, :customer => mock("customer", :id => "42"))
  Braintree::Customer.stub!(:create).and_return(@result)
end