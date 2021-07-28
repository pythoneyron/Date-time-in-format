require_relative 'app'
require_relative 'middleware/date_time_formatter'

use App
run DateTimeFormatter.new
