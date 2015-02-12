module AssignsHasManyThroughRelations
  class Configuration
    # Assign the name of a controller class method that you want to run for authorization
    # e.g. Cancan's :load_and_authorize_resource, or a custom method you define 
    # in your ApplicationController
    def auth_filter(val = nil)
      @auth_filter ||= val
    end
  end
end
