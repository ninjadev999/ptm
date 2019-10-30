# frozen_string_literal: true

class StripeEvent

  private

    def charge_updated
    end

    def charge_succeeded
      charge_updated
    end

    def charge_captured
      charge_updated
    end

    def charge_pending
      charge_updated
    end

    def charge_failed
      charge_updated
    end
end
