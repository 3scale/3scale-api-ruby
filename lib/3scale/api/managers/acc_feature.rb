module ThreeScale
  module API
    module Managers
      class AccountFeatures < DefaultManager
        
        # @api public
        # Create an account feature. The features of the account are globally scoped.
        # Creating a feature does not associate the feature with an account plan.
        # @param [String] name Name of the feature.
        # @param [String] system_name System Name of the object to be created. System names cannot be modified after
        #                             creation, they are used as the key to identify the objects.
        # @return [Hash] of created feature
        def create(name, system_name)
          body = { name: name, system_name: system_name }
          response = http_client.post('/admin/api/features', body: body)
          extract(entity: 'feature', from: response)
        end

        # @api public
        # Returns an account feature.
        # @param [String] id ID of the feature.
        # @return [Hash] of feature
        def read(id)
          response = http_client.get("/admin/api/features/#{id}")
          extract(entity: 'feature', from: response)
        end

        # @api public
        # Updates an account feature.
        # @param [String] id ID of the feature.
        # @param [String] attr attributes to be updated
        # @return [Hash] of updated feature
        def update(id, attr)
          response = http_client.put("/admin/api/features/#{id}", body: attr)
          extract(entity: 'feature', from: response)
        end

        # @api public
        # Deletes an account feature.
        # @param [String] id ID of the feature.
        # @return [bool] if features was deleted
        def delete(id)
          http_client.delete("/admin/api/features/#{id}")
          true
        end

        # @api public
        # Returns the list of the features available to accounts. Account features are globally scoped.
        # @return [Hash] of features
        def list
          response = http_client.get('/admin/api/features')
          extract(collection: 'features', entity: 'feature', from: response)
        end
      end
    end
  end
end