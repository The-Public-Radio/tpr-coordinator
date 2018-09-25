require 'rails_helper'

RSpec.describe OrderReport, type: :model do
  # TODO: These are horribly named
  let!(:prev_month) { create(:order, created_at: 1.month.ago )}
  let!(:curr_month) { create(:order, created_at: Date.today )}
  let!(:next_month) { create(:order, created_at: 1.month.from_now )}

  describe '#from_range' do
    it 'only grabs orders from within the date range' do
      from = Date.today.beginning_of_month
      to = 1.month.from_now.beginning_of_month
      report = OrderReport.new(from, to)

      expect(report.orders.count).to eq 1
      expect(report.orders.first).to eq curr_month
    end
  end
end
