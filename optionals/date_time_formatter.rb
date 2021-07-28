class DateTimeFormatter
  AVAILABLE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  attr_reader :valid_params, :invalid_params, :time_string

  def call(format_values)
    @valid_params, @invalid_params = check_valid_or_invalid_format_params(format_values)
    @time_string = date_time_to_format(valid_params)
  end

  def success_params?
    invalid_params.none?
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

end
