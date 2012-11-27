require 'base/cf_inner'

class CfLbCookieStickinessPolicy
  include CfInner
  
  def initialize(cookie_expiration_period, policy_name)
    @cookie_expiration_period = cookie_expiration_period
    @policy_name = policy_name
  end
      
  def get_cf_attributes
    {"CookieExpirationPeriod" => @cookie_expiration_period, "PolicyName" => @policy_name}
  end
    
end