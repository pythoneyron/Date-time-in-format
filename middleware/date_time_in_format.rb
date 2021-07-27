class DateTimeInFormat

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
    return prepare_res(STATUS_NOT_FOUND, ["Not found #{request_path}\n"]) unless request_uri_time?(request_path)

    format_vals = parse_query_string(env['QUERY_STRING'])
    return prepare_res(STATUS_NOT_FOUND, ["Format not defined\n"]) if format_vals.nil? || format_vals == ''

    values_format_arr, extra_values_arr = check_format_fo_extra_values(format_vals)
    return prepare_res(STATUS_BAD_REQUEST, ["Unknown time format #{extra_values_arr}\n"]) if extra_values_arr.any?

    time_to_format(values_format_arr)
  end

  private

  def time_to_format(values_format_arr)
    format = []

    values_format_arr.each do |val|
      format << AVAILABLE_FORMAT[val.to_sym]
    end

    format = format.join('-')

    date_time = DateTime.now.strftime(format)

    [STATUS_SUCCESS, HEADERS, [date_time]]
  end

  def prepare_res(status, body_data)
    [status, HEADERS, body_data]
  end

  def request_uri_time?(request_path)
    request_path == PATH_TIME
  end

  def parse_query_string(query_string)
    Rack::Utils.parse_nested_query(query_string)['format']
  end

  def check_format_fo_extra_values(values)
    values_arr = values.split(',')
    extra_values_arr = []

    values_arr.each do |val|
      extra_values_arr << val unless AVAILABLE_FORMAT.keys.include?(val.to_sym)
    end

    [values_arr, extra_values_arr]
  end

end
