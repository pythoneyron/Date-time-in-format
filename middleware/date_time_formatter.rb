class DateTimeFormatter
  AVAILABLE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze
  PATH_TIME = '/time'.freeze

  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  attr_reader :valid_params, :invalid_params, :request_path, :format_values

  def call(env)
    body = []

    @request_path = env['REQUEST_PATH']
    @format_values = parse_query_string(env['QUERY_STRING'])

    if success_format_value?
      @valid_params, @invalid_params = check_valid_or_invalid_format_params(format_values)
      body << date_time_to_format(valid_params)
    end

    [200, HEADERS, body]
  end

  def success_request_path?
    request_path == PATH_TIME
  end

  def success_query_string?
    !format_values.nil? || !format_values == ''
  end

  def success_params?
    invalid_params.none?
  end

  def success_format_value?
    !format_values.nil?
  end

  private

  def date_time_to_format(params_format)
    format = params_format.join('-')

    DateTime.now.strftime("#{format}\n")
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
