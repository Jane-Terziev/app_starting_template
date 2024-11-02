Rails.application.routes.draw do
  mount Authentication::Engine, at: "/authentication"
end

Authentication::Engine.routes.draw do
  devise_for :users,
             class_name: "Authentication::User",
             controllers: { registrations: "authentication/registrations", sessions: "authentication/sessions" }
end
