# frozen_string_literal: true

class OrdersMailer < ApplicationMailer
  def invite(order_id)
    @order = Order.find(order_id)
    mail(to: @order.email, subject: "#{@order.user.email} wants to send you a mic - PTM4")
  end

  def shipped(order_id)
    @order = Order.find(order_id)
    mail(to: @order.email, subject: "Your microphone from #{@order.user.name} has been shipped - PTM5")
  end
end
