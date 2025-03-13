class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_canonical_domain

  private

  def ensure_canonical_domain
    canonical_domain = 'membership.sheffieldviking.org.uk'
    return unless request.host != canonical_domain

    redirect_to "#{request.protocol}#{canonical_domain}#{request.fullpath}", status: :found
  end
end
