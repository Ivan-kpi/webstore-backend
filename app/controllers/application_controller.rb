class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def cors_preflight
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = 'authorization, content-type, accept'
    head :ok
  end
end