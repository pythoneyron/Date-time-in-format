class CheckDateTimeRequest
  AVAILABLE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  PATH_TIME = '/time'.freeze

  STATUS_SUCCESS = 200
  STATUS_NOT_FOUND = 404
  STATUS_BAD_REQUEST = 400

  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env['REQUEST_PATH']

    return prepare_response(STATUS_NOT_FOUND, ["Not found #{request_path}\n"]) unless request_uri_time?(request_path)

    format_vals = parse_query_string(env['QUERY_STRING'])
    return prepare_response(STATUS_NOT_FOUND, ["Format not defined\n"]) if format_vals.nil? || format_vals == ''

    valid_params, invalid_params = check_valid_or_invalid_format_params(format_vals)
    return prepare_response(STATUS_BAD_REQUEST, ["Unknown time format #{invalid_params}\n"]) if invalid_params.any?

    env['valid_params'] = valid_params

    @app.call(env)
  end

  private

  def prepare_response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end

  def request_uri_time?(request_path)
    request_path == PATH_TIME
  end

  def check_valid_or_invalid_format_params(values)
    valid_params = []
    invalid_params = []

    params_array = values.split(',')

    params_array.each do |param|
      invalid_params << param unless AVAILABLE_FORMAT.keys.include?(param.to_sym)
      valid_params << AVAILABLE_FORMAT[param.to_sym] if AVAILABLE_FORMAT.keys.include?(param.to_sym)
    end

    [valid_params, invalid_params]
  end

  def parse_query_string(query_string)
    Rack::Utils.parse_nested_query(query_string)['format']
  end

end
