defmodule DswWeb.Router do
  use DswWeb, :router
  use Kaffy.Routes, scope: "/admin"
  require DswWeb.Plug.Jwt

  pipeline :api do
    plug :accepts, ["json"]
    plug DswWeb.Plug.Jwt
  end

  scope "/api", DswWeb do
    pipe_through :api

    get "/users", UserController, :get_users

    get "/template-editors", TemplateEditorController, :list_GET
    post "/template-editors", TemplateEditorController, :list_POST
    get "/template-editors/:id", TemplateEditorController, :detail_GET
    put "/template-editors/:id", TemplateEditorController, :detail_PUT
    delete "/template-editors/:id", TemplateEditorController, :detail_DELETE

    post "/template-editors/:id/expansions-and-publications",
         TemplateEditorController,
         :detail_expansions_and_publications_POST
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: DswWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
