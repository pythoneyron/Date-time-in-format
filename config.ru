require_relative 'middleware/date_time_formatter'
require_relative 'app'

use App
run DateTimeFormatter.new
