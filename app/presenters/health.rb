module MyApplication
  module Presenters
    module Health
      include Roar::JSON::HAL
      include Grape::Roar::Representer

      defaults do |name|
        { as: name.to_s.camelize(:lower) }
      end

      property :status
    end
  end
end
