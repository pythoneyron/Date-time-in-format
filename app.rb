class App
  STATUS_SUCCESS = 200
  STATUS_NOT_FOUND = 404
  STATUS_BAD_REQUEST = 400

  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    return prepare_response(STATUS_NOT_FOUND, ["Not found #{@app.request_path}\n"]) unless @app.success_request_path?

    return prepare_response(STATUS_NOT_FOUND, ["Param 'format' not found\n"]) unless @app.success_format_value?

    return prepare_response(STATUS_NOT_FOUND, ["Format not defined\n"]) unless @app.success_query_string?

    return prepare_response(STATUS_BAD_REQUEST, ["Unknown time format #{@app.invalid_params}\n"]) unless @app.success_params?

    [status, headers, body]
  end

  private

  def request_uri_time?(request_path)
    request_path == PATH_TIME
  end

  def prepare_response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end
end
