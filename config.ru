require_relative 'app'
require_relative 'middleware/date_time_in_format'

use DateTimeInFormat
run App.new
