require "assigns_has_many_through_relations/version"
require "assigns_has_many_through_relations/engine"
require "assigns_has_many_through_relations/configuration"
require "assigns_has_many_through_relations/controller_concern"
require "assigns_has_many_through_relations/model_concern"

module AssignsHasManyThroughRelations
  BOOTSTRAP_FLASH_MAP = {
    notice: 'success',
    error: 'danger'
  }
  BOOTSTRAP_FLASH_MAP.default = 'info'

  class << self
    attr_reader :config
    delegate *Configuration::PROPERTIES, to: :config

    def configure(&block)
      @config ||= Configuration.new
      @config.instance_exec &block
    end
  end

  module_function

  def join_name_for(left_relation, right_relation)
    "#{left_relation.to_s.pluralize}_#{right_relation.to_s.pluralize}"
  end

  def routes_for(left_relation, right_relation, routes)
    name = join_name_for left_relation, right_relation
    left_name = left_relation.to_s.pluralize
    right_name = right_relation.to_s.pluralize

    routes.get "/#{left_name}/#{right_name}/:id", to: "#{name}#index", as: name
    routes.put "/#{left_name}/#{right_name}/:id", to: "#{name}#update", as: "assign_#{name}"
  end
end

AHMTR = AssignsHasManyThroughRelations
AHMTR.configure {} # so that @config is never nil
