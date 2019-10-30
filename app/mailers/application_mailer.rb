# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  append_view_path Rails.root.join("app", "views", "mailers")
  default from: "PassTheMicrophone <no-reply@passthemicrophone.com>"
  layout "mailer"
end
