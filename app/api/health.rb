# frozen_string_literal: true

module MyApplication
  module API
    class Health < Grape::API
      format :json

      resource :status do
        get do
          status = OpenStruct.new(status: :ok)

          present status, with: Presenters::Health
        end
      end
    end
  end
end
