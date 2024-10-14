Rails.application.routes.draw do

  scope module: "api" do
    namespace :v1 do
      resources :jobs
      resources :geeks do
        get "job/:job_id", to: "geeks#applies_for_geek", on: :collection
        get "company/:company_id", to: "geeks#geeks_for_company", on: :collection
      end
      resources :applies do
        get "company/:company_id", to: "applies#applies_for_company", on: :collection
      end
      resources :companies do
        resources :jobs
      end

    end
  end

  match "*path", to: "application#catch_404", via: :all

end
