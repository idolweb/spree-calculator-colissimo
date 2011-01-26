require 'test/unit'
# Load the environment
unless defined? SPREE_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["SPREE_ENV_FILE"]
    require File.dirname(ENV["SPREE_ENV_FILE"]) + "/boot"
  when File.dirname(__FILE__) =~ %r{vendor/spree/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/boot"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/boot"
  end
end
require "#{SPREE_ROOT}/test/test_helper"

class ActiveSupport::TestCase
  self.fixture_path = File.join(CalculatorColissimoExtension.root, "test", "fixtures")

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
end

Spree::Config.set(:default_country_id => Country.find_by_name("France").id) if Country.find_by_name("France")
