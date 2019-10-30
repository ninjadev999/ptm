# frozen_string_literal: true

class OrderStep
  attr_reader :title, :description, :index

  def initialize(title, description, index)
    @title = title
    @description = description
    @index = index
  end

  def state
    @title.downcase
  end

  def past?(stepper)
    stepper.steps.index(stepper.current_step) >= stepper.steps.index(self)
  end
end

class OrderStepper
  attr_reader :steps

  def initialize(order)
    @order = order
    @steps = load_steps
  end

  def current_step
    @steps.detect { |step| step.state == @order.aasm_state }
  end

private

  def load_steps
    array = []
    array << OrderStep.new("Confirmed", "The order has been placed and it hasn't been assigned a microphone yet. You're able to modify the order at this time.", 0)
    array << OrderStep.new("Processing", "The order has been assigned a microphone. You're able to cancel the order if you want.", 1)
    array << OrderStep.new("Packaging", "The microphone has been packaged and is almost ready to ship. You're able to cancel the order if you want.", 2)
    array << OrderStep.new("Shipping", "The shipping and return labels have been generated. You're not able to cancel the order anymore.", 3)
    array << OrderStep.new("Shipped", "The package has left our facility and is on the way.", 4)
    array << OrderStep.new("Delivered", "The package has arrived at the destination.", 5)
    array << OrderStep.new("Returning", "The microphone is due to be returned to PassTheMicrophone.", 6)
    array << OrderStep.new("Received", "The microphone has arrived back at the PassTheMicrophone facility.", 7)
    array << OrderStep.new("Completed", "The microphone has been checked back into inventory and you're able to order another microphone.", 8)
    array
  end
end
