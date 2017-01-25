defmodule RecaptchaTest do
  use ExUnit.Case, async: true

  # see https://developers.google.com/recaptcha/docs/faq#id-like-to-run-automated-tests-with-recaptcha-v2-what-should-i-do
  @google_test_secret "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"

  test "When the supplied g-recaptcha-response is invalid, multiple errors are returned" do
    assert {:error, messages} = Recaptcha.verify("not_valid")
    assert messages == [:invalid_input_response, :invalid_input_secret]
  end

  test "When the correct secret is supplied but g-recaptcha-response is invalid :invalid_input_response' is returned" do
    assert {:error, messages} = Recaptcha.verify("not_valid", secret: @google_test_secret)
    assert messages == [:invalid_input_response]
  end

  test "When a valid response is supplied, a success response is returned" do
    assert {:ok, %{challenge_ts: _, hostname: _}} = Recaptcha.verify("valid_response", secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe")
  end

  test "When secret is not overridden the configured secret is used" do
    Recaptcha.verify("valid_response")

    assert_received {:request_verification, "response=valid_response&secret=test_secret", _}
  end

  test "When the timeout is overridden that config is passed to verify/2 as an option" do
    Recaptcha.verify("valid_response", timeout: 25000)

    assert_received {:request_verification, _, [timeout: 25000]}
  end

  test "Remote IP is used in the request body when it is passed into verify/2 as an option" do
    Recaptcha.verify("valid_response", remote_ip: "192.168.1.1")

    assert_received {:request_verification, "response=valid_response&secret=test_secret&remote_ip=192.168.1.1", _}
  end

  test "Adding unsupported options does not append them to the request body" do
    Recaptcha.verify("valid_response", unsupported_option: "not_valid")

    assert_received {:request_verification, "response=valid_response&secret=test_secret", _}
  end
end
