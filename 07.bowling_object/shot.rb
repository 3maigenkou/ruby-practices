# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def strike?
    @mark == 'X'
  end

  def shot_point
    return 10 if strike?

    @mark.to_i
  end
end
