class OrderReport
  attr_reader :from, :to

  def initialize(from, to)
    @from = from
    @to = to
  end

  # NOTE: the result is inclusive of `from` and exclusive of `to`
  def orders
    @orders ||= Order.where(created_at: from...to)
  end
end
