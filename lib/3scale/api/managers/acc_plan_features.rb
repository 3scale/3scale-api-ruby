module ThreeScale
  module API
    module Managers
      class AccountPlanFeatures < DefaultManager
        # @api public
        # Associate an account feature to an account plan.
        # @param [String] acc_plan_id ID of the account plan.
        # @param [String] acc_feature_id ID of the feature.
        # @return [Hash] of created account plan feature
        def create(acc_plan_id, acc_feature_id)
          response = http_client.post("/admin/api/account_plans/#{acc_plan_id}/features/#{acc_feature_id}")
          extract(entity: 'feature', from: response)
        end

        # @api public
        # Returns the list of the features associated to an account plan.
        # @param [String] acc_plan_id ID of the account plan.
        # @return [Hash] of account plan feature
        def list(acc_plan_id)
          response = http_client.get("/admin/api/account_plans/#{acc_plan_id}/features")
          extract(entity: 'feature', from: response)
        end

        # @api public
        # Deletes the association of an account feature to an account plan.
        # @param [String] acc_plan_id ID of the account plan.
        # @param [String] acc_feature_id ID of the feature.
        # @return [bool]
        def delete(acc_plan_id, acc_feature_id)
          http_client.delete("/admin/api/account_plans/#{acc_plan_id}/features/#{acc_feature_id}")
          true
        end
      end
    end
  end
end