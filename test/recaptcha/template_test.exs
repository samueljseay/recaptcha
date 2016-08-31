defmodule RecaptchaTemplateTest do
  use ExUnit.Case, async: true

  test "supplying options to display/1 renders them in the g-recaptcha div" do
    template_string = Recaptcha.Template.display(theme: "dark", type: "audio", tabindex: 1, size: "compact")

    assert template_string =~ "data-theme=\"dark\""
    assert template_string =~ "data-type=\"audio\""
    assert template_string =~ "data-tabindex=\"1\""
    assert template_string =~ "data-size=\"compact\""
  end

  test "supplying a public key in options to display/1 overrides it in the g-recaptcha-div" do
    template_string = Recaptcha.Template.display(public_key: "override_test_public_key")

    assert template_string =~ "data-sitekey=\"override_test_public_key\""
  end

  test "supplying noscript option displays the noscript fallback" do
    template_string = Recaptcha.Template.display(noscript: true)

    assert template_string =~ "<noscript>"
    assert template_string =~ "https://www.google.com/recaptcha/api/fallback?k=test_public_key"
  end
end
