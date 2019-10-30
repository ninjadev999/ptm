# frozen_string_literal: true

require "spec_helper"
require "rake"

RSpec.configure do |config|
  config.before(:all) do
    $stdout = StringIO.new
    Rake::Task.define_task :environment
  end
  # Reset stdout
  config.after(:all) do
    $stdout = STDOUT
  end
end
