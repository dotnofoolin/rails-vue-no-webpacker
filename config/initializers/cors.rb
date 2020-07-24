# This adds CORS headers to the response. Useful for developing frontend code with 'yarn serve'
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'localhost:8080'
      resource '*',
        headers: :any,
        methods: %i(get post put patch delete options head)
    end
  end