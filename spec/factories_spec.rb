# frozen_string_literal: true

require "spec_helper"

describe "factories" do
  FactoryBot.factories.each do |factory|
    describe "#{factory.name} factory" do
      it "does not raise error when built" do
        expect { build(factory.name) }.not_to raise_error
      end

      it "does not raise error when created" do
        expect { create(factory.name) }.not_to raise_error
      end
    end
  end
end
