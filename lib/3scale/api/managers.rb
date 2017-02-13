require '3scale/api/version'

module ThreeScale
  module API

    module Managers
      autoload :AccountFeatures, '3scale/api/managers/acc_feature'
      autoload :Services, '3scale/api/managers/services'
      autoload :Applications, '3scale/api/managers/applications'
      autoload :AccountPlans, '3scale/api/managers/acc_plans'
      autoload :AccountPlanFeatures, '3scale/api/managers/acc_plan_features'
      autoload :Accounts, '3scale/api/managers/accounts'
      autoload :ApplicationPlans, '3scale/api/managers/app_plans'
      autoload :ApplicationPlanLimits, '3scale/api/managers/app_plan_limits'
      autoload :DefaultManager, '3scale/api/managers/default_manager'
      autoload :Mappings, '3scale/api/managers/mappings'
      autoload :Methods, '3scale/api/managers/methods'
      autoload :Metrics, '3scale/api/managers/metrics'
      autoload :Proxy, '3scale/api/managers/proxy'
      autoload :ServicePlans, '3scale/api/managers/service_plans'
    end
  end
end