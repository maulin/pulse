Rails.application.routes.draw do
  root "songs#search"

  resources :songs, :only => [] do
    collection do
      get 'search'
    end
  end
end
