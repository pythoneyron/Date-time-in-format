class DateTimeFormatter

  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  STATUS_SUCCESS = 200

  def call(env)
    valid_params = env['valid_params']

    body = date_time_to_format(valid_params)
    prepare_response(STATUS_SUCCESS, body)
  end

  private

  def date_time_to_format(params_format)
    format = params_format.join('-')

    DateTime.now.strftime(format)
  end

  def prepare_response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end

end
