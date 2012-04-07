ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...

  include FactoryGirl::Syntax::Methods

  def teardown
    Mongoid.database.collections.each do |coll|
      coll.remove if coll.name !~ /system/
    end
  end
end

class ActionController::TestCase
  attr_reader :controller
  delegate :login_as, :logout, :current_user, :logined?, :to => :controller
end
