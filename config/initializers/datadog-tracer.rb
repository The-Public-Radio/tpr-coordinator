Rails.configuration.datadog_trace = {
  auto_instrument: true,
  auto_instrument_redis: true,
  default_service: 'tpr-coordinator',
  trace_agent_hostname: ENV['DD_TRACE_AGENT_HOSTNAME'] || 'localhost',
  trace_agent_port: ENV['DD_TRACE_AGENT_PORT'] || 8126,
  env: Rails.env
}