Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations",
               passwords: "users/passwords",
             }
  get "/member-data", to: "members#show"
  namespace :api do
    namespace :v1 do
      resources :users
      get "/dev_users", to: "users#dev_users"
      resources :teams
      resources :developers
      get "/current_developers", to: "developers#current_developers"
      resources :companies
      resources :projects
      get "/project_phases", to: "projects#project_phases"
      get "/project_statuses", to: "projects#project_statuses"
      get "/current_projects", to: "projects#current_projects"
      resources :sprints
      resources :batch_logs
      get "/profile", to: "profile#show"
      put "/profile", to: "profile#update"
      post "/profile/update_avatar", to: "profile#update_avatar"
      post "/profile/delete_avatar", to: "profile#delete_avatar"
      put "/passwords", to: "passwords#update"
      resources :tool_masters
      resources :skill_masters
      get "/all_skill_masters", to: "skill_masters#all_skill_masters"
      resources :domain_masters
      get "/all_domain_masters", to: "domain_masters#all_domain_masters"
      resources :developer_careers
      resources :project_tool_infos
      resources :developer_tool_maps
      resources :developer_team_maps
      resources :project_team_maps
      get "/company_reports", to: "companies#reports"
      get "/project_reports", to: "projects#reports"
      get "/developer_reports", to: "developers#reports"
    end
  end

  root "application#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
