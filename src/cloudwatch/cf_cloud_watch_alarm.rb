require 'base/cf_base'
require 'base/cf_helper'

class CfCloudWatchAlarm
  include CfBase
  
  GREATER_THAN_OR_EQUAL_TO_THRESHOLD  = "GreaterThanOrEqualToThreshold"
  GREATER_THAN_THRESHOLD  = "GreaterThanThreshold"
  LESS_THAN_THRESHOLD  = "LessThanThreshold"
  LESS_THAN_OR_EQUAL_TO_THRESHOLD  = "LessThanOrEqualToThreshold"
  
  def initialize(name, comparison_operator, evaluation_periods, metric_name, metric_name_space, 
    period, statistic, threshold, options = {})
    @name = name
    @comparison_operator = comparison_operator
    @evaluation_periods = evaluation_periods
    @metric_name = metric_name
    @metric_name_space = metric_name_space
    @period = period
    @statistic = statistic
    @threshold = threshold
    #TODO: optional values
    @alarm_actions = options[:alarm_actions]
    validate()
  end
    
  def validate
    if ![GREATER_THAN_OR_EQUAL_TO_THRESHOLD, GREATER_THAN_THRESHOLD, LESS_THAN_OR_EQUAL_TO_THRESHOLD, LESS_THAN_THRESHOLD].include?(@comparison_operator)
      raise Exception.new("comparison operator #{@comparison_operator} not valid")
    end
    if !["SampleCount", "Average", "Sum", "Minimum", "Maximum"].include?(@statistic)
      raise Exception.new("statistic #{@statistic} not a valid value")
    end
  end
  
  def get_cf_type
    "AWS::CloudWatch::Alarm"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "ComparisonOperator" => @comparison_operator,
      "EvaluationPeriods" => @evaluation_periods,
      "MetricName" => @metric_name,
      "Namespace" => @metric_name_space,
      "Period" => @period,
      "Statistic" => @statistic,
      "Threshold" => @threshold
    }
    result["AlarmActions"] = CfHelper.generate_ref_array(@alarm_actions) unless @alarm_actions.nil?
    result
  end
    
end
