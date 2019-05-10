# frozen_string_literal: true

module API
  class Base < Grape::API
    include MyApplication

    before do
      RequestStore.store[:request_id] = SecureRandom.uuid
    end

    mount MyApplication::API::Health
  end
end
