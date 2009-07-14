begin
  require 'metric_fu'
  
  MetricFu::Configuration.run do |config|
    config.graphs = []
  end
rescue LoadError
  abort 'install metric_fu to run this task'
end
