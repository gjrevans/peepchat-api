defmodule Peepchat.Router do
  use Peepchat.Web, :router

  # Unauthenticated Requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  # Unathenticated Endpoints
  scope "/api", Peepchat do
    pipe_through :api

    # Registration
    post "/register", RegistrationController, :create

    # Route stuff to our SessionController
    post "/token", SessionController, :create, as: :login
  end

  # Authenticated Enpoints
  scope "/api", Peepchat do
    pipe_through :api_auth
    get "/user/current", UserController, :current
  end
end
