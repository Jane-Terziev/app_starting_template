module Authentication
  class ApplicationController < ::ApplicationController
    skip_before_action :authenticate_user!
  end
end
