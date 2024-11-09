Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "up" => "rails/health#show", as: :rails_health_check
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "homes#index"
end
