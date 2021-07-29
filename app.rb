class App
  STATUS_SUCCESS = 200
  STATUS_NOT_FOUND = 404
  STATUS_BAD_REQUEST = 400

  HEADERS = { 'Content-Type' => 'text/plain' }.freeze
  PATH_TIME = '/time'.freeze

  def call(env)
    request_path = env['REQUEST_PATH']
    return prepare_response(STATUS_NOT_FOUND, ["Not found #{PATH_TIME}\n"]) unless request_path == PATH_TIME

    format_values = parse_query_string(env['QUERY_STRING'])
    return prepare_response(STATUS_NOT_FOUND, ["Format not defined\n"]) if format_values.nil? || format_values == ''

    dt_obj = DateTimeFormatter.new
    time_string = dt_obj.call(format_values)
    return prepare_response(STATUS_BAD_REQUEST, ["Unknown time format #{dt_obj.invalid_params}\n"]) unless dt_obj.success_params?

    prepare_response(STATUS_SUCCESS, time_string)
  end

  private

  def prepare_response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end

  def parse_query_string(query_string)
    Rack::Utils.parse_nested_query(query_string)['format']
  end
end
