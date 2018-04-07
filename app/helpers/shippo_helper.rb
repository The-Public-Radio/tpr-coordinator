require 'shippo'

module ShippoHelper
    attr_reader :shippo_client
    
    def self.parcel(number_of_items)
        if number_of_items == 2
            {
              :length => 6,
              :width => 5,
              :height => 4,
              :distance_unit => :in,
              :weight => 1.75,
              :mass_unit => :lb
            }
        elsif number_of_items == 3
            {
              :length => 9,
              :width => 5,
              :height => 4,
              :distance_unit => :in,
              :weight => 2.60,
              :mass_unit => :lb
            }
        else
            {
              :length => 5,
              :width => 4,
              :height => 3,
              :distance_unit => :in,
              :weight => 12,
              :mass_unit => :oz
            }
        end
    end
end