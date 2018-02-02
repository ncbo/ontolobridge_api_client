class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  ONTOLOBRIDGE_BASE_URL = $ONTOLOBRIDGE_BASE_URL
end
