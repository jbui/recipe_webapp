class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :reload_libs if Rails.env.development?
  
  private
    # http://hemju.com/2011/02/11/rails-3-quicktip-auto-reload-lib-folders-in-development-mode/
    def reload_libs
      Dir["#{Rails.root}/lib/**/*.rb"].each { |path| require_dependency path }
    end

    def current_user
      @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user
end
