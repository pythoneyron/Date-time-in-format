require_relative 'middleware/check_date_time_request'
require_relative 'middleware/date_time_formatter'
require_relative 'app'

use CheckDateTimeRequest
use DateTimeFormatter
run App.new
