# frozen_string_literal: true

class ServiceResponse
  attr_reader :code, :data, :error

  class << self
    def ok(data)
      new(code: 200, data: data)
    end

    def internal_server_error(message)
      new(code: 500, error: message)
    end

    def bad_request(message)
      new(code: 400, error: message)
    end

    def unauthorized(message)
      new(code: 401, error: message)
    end

    def not_found(message)
      new(code: 404, error: message)
    end
  end

  def initialize(code:, data: nil, error: nil)
    @code = code
    @data = data
    @error = error
  end

  def body
    {
      success: success?,
      data: data,
      error: error
    }
  end

  def success?
    code.to_s.starts_with?('2')
  end
end
