module AssignsHasManyThroughRelations
  module ControllerConcern
    def assigns_has_many_relationships_with(left_relation, right_relation)
      @left_relation_param_name = left_relation
      @left_relation_class = left_relation.to_s.camelize.constantize
      @left_relation_class_name = @left_relation_class.name
      @right_relation_class = right_relation.to_s.camelize.constantize
      @join_name = AssignsHasManyThroughRelations.join_name_for left_relation, right_relation

      include AssignsHasManyThroughRelations::ControllerInstanceMethods
      helper_method :left_relation_class_name, :join_name
    end

    def left_relation_param_name; @left_relation_param_name end
    def left_relation_class; @left_relation_class end
    def left_relation_class_name; @left_relation_class_name end
    def right_relation_class; @right_relation_class end
    def join_name; @join_name end
  end

  module ControllerInstanceMethods
    def index
      @left_side_models = self.class.left_relation_class.order :name
      @selected_left_side_model = self.class.left_relation_class.find params[:id]
      @left_side_models = @left_side_models - [@selected_left_side_model]
      @selected_right_side_models = @selected_left_side_model.users
      @available_right_side_models = User.active - @selected_right_side_models
    end

    def update
      left_side_model = self.class.left_relation_class.find params[:id]

      if left_side_model.update_attributes params[self.class.left_relation_param_name]
        flash[:notice] = "Successfully set #{self.class.left_relation_param_name} assignments"
      else
        flash[:error] = left_side_model.errors.full_messages.to_sentence
      end

      redirect_to :back
    end

    private

    def left_relation_class_name; self.class.left_relation_class_name end
    def join_name; self.class.join_name end
  end
end
