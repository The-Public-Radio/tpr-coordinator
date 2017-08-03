def random_tracking_number
  number = "9374889691090496#{Random.new.rand(99999)}"
  chars = number.gsub(/^420\d{5}/, '').chars.to_a

  total = 0
  chars.reverse.each_with_index do |c, i|
    x = c.to_i
    x *= 3 if i.even?

    total += x
  end

  check_digit = total % 10
  check_digit = 10 - check_digit unless (check_digit.zero?)
  # TrackingNumber.new("#{number}#{check_digit}")
  "#{number}#{check_digit}"
end

module FactoryGirl
  class Singleton
    @@singletons = {}

    def self.execute(factory_key, attributes = {})

      # form a unique key for this factory and set of attributes
      key = [factory_key.to_s, '?', attributes.to_query].join

      begin
        @@singletons[key] = FactoryGirl.create(factory_key, attributes)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        # already in DB so return nil
      end

      @@singletons[key]
    end
  end
end
