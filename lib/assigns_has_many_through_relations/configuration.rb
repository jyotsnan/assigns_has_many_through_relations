module AssignsHasManyThroughRelations
  class Configuration
    PROPERTIES = %w[
      auth_filter
      left_relation_scope
      selected_right_relation_scope
      available_right_relation_scope
    ]

    # Assign the name of a controller class method that you want to run for authorization
    # e.g. Cancan's :load_and_authorize_resource, or a custom method you define 
    # in your ApplicationController
    def auth_filter(val = nil)
      @auth_filter ||= val
    end

    # Set a block that will return an ActiveRecord scope of the left side models.
    # the block will receive 2 arguments when it is called in the index action: 
    #   left_relation_class: class of the left side relation
    #   user: the current user
    def left_relation_scope(&block)
      @left_relation_scope ||= block_given? ? block : method(:default_left_relation_scope)
    end

    # Set a block that will return an ActiveRecord scope of the selected left side model's
    # right side relations. The block will receive 2 arguments when it is called in the 
    # index action: 
    #   left_side_model: the selected left side model
    #   right_relation_class: class of the right side relation
    #   user: the current user
    def selected_right_relation_scope(&block)
      @selected_right_relation_scope ||= block_given? ? block : method(:default_selected_right_relation_scope)
    end

    def available_right_relation_scope(&block)
      @available_right_relation_scope ||= block_given? ? block : method(:default_available_right_relation_scope)
    end

    private

    # The default scope just loads all of the left side models
    #
    # e.g. n the case where you declare assigns_has_many_relationships_with :location, :user
    # then the scope would essentially load:
    #   Location.all
    def default_left_relation_scope(left_relation_class, user)
      left_relation_class.all
    end

    # The default selected right relation  scope loads all of the selected left model's 
    # right side relations.
    #
    # e.g. in the case where you declare assigns_has_many_relationships_with :location, :user
    # then this scope would essentially load:
    #   @location.users
    def default_selected_right_relation_scope(left_side_model, right_relation_class, user)
      left_side_model.send right_relation_class.name.demodulize.underscore.pluralize
    end

    # The default available right relation scope loads all of the right relation model
    # except for the selected right models returned by selected_right_relation_scope
    #
    # e.g. in the case where you declare assigns_has_many_relationships_with :location, :user
    # then this scope would essentially load:
    #   User.all - @location.users
    def default_available_right_relation_scope(right_relation_class, right_models, user)
      right_relation_class.all - right_models
    end
  end
end
