# frozen_string_literal: true

require_relative "config/environment"

# Allow CORS (Cross-Origin Resource Sharing) requests
use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: %i[get post delete put patch options head]
  end
end

# Parse JSON from the request body into the params hash
use Rack::JSONBodyParser

# Mount our controllers
use OwnersController
use PetsController

# Our main application
run ApplicationController
