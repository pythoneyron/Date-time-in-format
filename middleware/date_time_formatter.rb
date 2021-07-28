class DateTimeFormatter
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    valid_params = env['valid_params']

    body << date_time_to_format(valid_params)
    prepare_response(status, headers, body)
  end

  private

  def date_time_to_format(params_format)
    format = params_format.join('-')

    DateTime.now.strftime(format)
  end

  def prepare_response(status, headers, body_data)
    Rack::Response.new(body_data, status, headers).finish
  end

end
