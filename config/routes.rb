Rails.application.routes.draw do
  

  

  

  resources :calificacions
  # get 'calificar/index'

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get 'welcome/index'
  get 'gns/index'
  get 'gns/consultaConsumos'
  post 'gns/consumos'
  get 'bi/index'
  get 'bi/compras_por_dia'
  get 'bi/consumos_por_mes'
  get 'bi/productos_mas_consumidos'
  get 'bi/recaudo_por_dia'
  get 'bi/bebidas_mas_consumidas'
  get 'movimiento/index'
  get 'ingreso_bebida/index' => 'ingreso_bebida#index', :as => :index
  get 'ingreso_bebida/agregoCantidad' 
  get 'barcode/show'
  post 'barcode/new'
  
  get 'pedido/index'
  get 'compras/pedido'


  resources :compras
  resources :barcode
  resources :pedido
  

  resources :venta
  devise_for :cuenta 

  resource :cuenta, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end


  resources :usuarios

  post 'import_from_excel' => "usuarios#import_from_excel"

  resources :menus do
  	resources :productos
  end

  resources :empresas

  

  resources :bebidas
  resources :franjas
  resources :productos
  resources :tipos


  resources :stocks
  
  


  namespace :api, defaults: {format: 'json'} do
    resources :menus, only: [:index, :show]
    resources :usuarios
    resource :compras, only: [:create, :index, :destroy]
    resource :sessions, only: [:create, :destroy]
    # resources :cuentum, only: [:index]
  end
end
