module Spree
  module Api
    module V2
      module Logistics
        class OrdersController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers
          before_action :require_spree_current_user

          def index
            #list all orders by current ability
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          #Add methods to assign deliveries to delivery heroes, mark delivery as complete, record payment, see payment details, see order details
          #

          def show
            spree_authorize! :show, resource

            render_serialized_payload { serialize_resource(resource) }
          end

          private

          def sorted_collection
            collection_sorter.new(collection, params).call
          end

          def collection
            collection_finder.new(user: spree_current_user).execute
          end

          def resource
            resource = resource_finder.new(user: spree_current_user, number: params[:id]).execute.take
            raise ActiveRecord::RecordNotFound if resource.nil?

            resource
          end

          def collection_serializer
            Spree::Api::Dependencies.storefront_order_serializer.constantize
          end

          def resource_serializer
            Spree::Api::Dependencies.storefront_order_serializer.constantize
          end

          def collection_finder
            Spree::Api::Dependencies.storefront_completed_order_finder.constantize
          end

          def resource_finder
            Spree::Api::Dependencies.storefront_completed_order_finder.constantize
          end

          def collection_sorter
            Spree::Api::Dependencies.storefront_order_sorter.constantize
          end

          def collection_paginator
            Spree::Api::Dependencies.storefront_collection_paginator.constantize
          end
        end
      end
    end
  end
end
