class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
