# frozen_string_literal: true

class Array
  def except(*values)
    self - values
  end
end
