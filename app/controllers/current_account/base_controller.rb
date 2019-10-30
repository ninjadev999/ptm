# frozen_string_literal: true

module CurrentAccount
  class BaseController < ApplicationController
    before_action :ensure_account_admin!
    layout "account"

    def root
    end
  end
end
