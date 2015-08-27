defmodule RecaptchaTest do
  use ExUnit.Case
  use ExVCR.Mock

  @remote_ip {127, 0, 0, 0}
  @request_url "https://www.google.com/recaptcha/api/siteverify"
  @response_input "RESPONSE"

  test "verify returns :ok if recaptcha verification succeeded" do

    response_body = "{ \"success\": true }"

    use_cassette :stub, [url: @request_url,
                         method: "post",
                         status_code: 200,
                         body: response_body] do

      verification = Recaptcha.verify(@remote_ip, @response_input)
      assert :ok = verification
    end
  end

  test "verify returns :error if recaptcha response is missing or invalid" do

    response_body = "{ \"success\": false, \"error-codes\": [\"missing-input-response\"] }"

    use_cassette :stub, [url: @request_url,
                         method: "post",
                         status_code: 200,
                         body: response_body] do

      verification = Recaptcha.verify(@remote_ip, @response_input)
      assert :error = verification
    end
  end

  test "verify raises an error if input secret was missing or invalid" do

    response_body = "{ \"success\": false, \"error-codes\": [\"missing-input-secret\"] }"

    use_cassette :stub, [url: @request_url,
                         method: "post",
                         status_code: 200,
                         body: response_body] do

      assert_raise RuntimeError, fn ->
        Recaptcha.verify(@remote_ip, @response_input)
      end
    end
  end

end
