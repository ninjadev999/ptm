# frozen_string_literal: true

module Site
  class PagesController < Site::BaseController
    skip_before_action :authenticate_user!

    def root
    	render layout: false
    end

    def privacy_policy; end

    def terms; end

  end
end
