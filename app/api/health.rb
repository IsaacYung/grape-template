module MyApplication
  module API
    class Health < Grape::API
      format :json

      resource :status do
        get do
          return { status: :ok }
        end
      end
    end
  end
end
