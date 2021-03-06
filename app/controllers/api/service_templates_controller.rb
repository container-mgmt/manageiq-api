module Api
  class ServiceTemplatesController < BaseController
    include Subcollections::ServiceDialogs
    include Subcollections::Tags
    include Subcollections::ResourceActions
    include Subcollections::ServiceRequests
    include Api::Mixins::Pictures
    include Api::Mixins::ServiceTemplates

    before_action :set_additional_attributes, :only => [:show]

    alias fetch_service_templates_picture fetch_picture

    def create_resource(_type, _id, data)
      catalog_item_type = ServiceTemplate.class_from_request_data(data)
      catalog_item_type.create_catalog_item(data.deep_symbolize_keys, User.current_user.userid)
    rescue => err
      raise BadRequestError, "Could not create Service Template - #{err}"
    end

    def edit_resource(type, id, data)
      catalog_item = resource_search(id, type, collection_class(:service_templates))
      catalog_item.update_catalog_item(data.deep_symbolize_keys, User.current_user.userid)
    rescue => err
      raise BadRequestError, "Could not update Service Template - #{err}"
    end

    def order_resource(_type, id, data)
      order_service_template(id, data)
    end

    private

    def set_additional_attributes
      @additional_attributes = %w(config_info)
    end
  end
end
