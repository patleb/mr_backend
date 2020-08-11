# TODO https://www.ecalamia.com/blog/show-ip-api-nginx/
class JavascriptRescuesController < ActionController::API
  def create
    exception = create_class.new(*create_args)
    log exception, subject: 'Javascript Error', throttle_key: 'javascript'
    head :created
  end

  private

  def create_class
    ActiveSupport::Dependencies.safe_constantize((create_params[:exception] || '').camelize) || JavascriptError
  end

  def create_args
    message, backtrace = create_params.values_at(:message, :backtrace)
    data = (create_params[:data]&.to_unsafe_h || {}).merge(
      user_ip: request.remote_ip,
      user_agent: request.user_agent,
      host: Process.host.snapshot,
    )
    [message, backtrace, data]
  end

  def create_params
    @_create_params ||= params.require(:javascript_rescue).permit(:exception, :message, backtrace: [], data: {})
  end
end