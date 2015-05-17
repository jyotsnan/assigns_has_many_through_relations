module AssignsHasManyThroughRelations
  module ModelConcern
    def assigns_has_many_relationships_with(left_relation, right_relation)
      @join_name = AssignsHasManyThroughRelations.join_name_for left_relation, right_relation

      has_many @join_name.to_sym, dependent: :delete_all
      has_many right_relation.to_s.pluralize.to_sym, through: @join_name.to_sym
      accepts_nested_attributes_for @join_name.to_sym, allow_destroy: true
      
      unless defined? ActionController::StrongParameters
        attr_accessible "#{@join_name}_attributes"
      end

      include AssignsHasManyThroughRelations::ModelInstanceMethods
    end

    def join_name; @join_name end
  end

  module ModelInstanceMethods
    def get_join_model_for(relation)
      send(self.class.join_name).where("#{relation.class.name.underscore}_id" => relation.id).first
    end
  end
end
