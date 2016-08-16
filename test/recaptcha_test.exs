defmodule RecaptchaTest do
  use ExUnit.Case, async: true
  import Recaptcha

  test "render_script works without params" do
    assert render_script() == {
      :safe, "<script src='https://www.google.com/recaptcha/api.js' async defer></script>"
    }
  end

  test "render_script adds params to the query" do
    assert render_script(hl: "ru", onload: "showCaptcha") == {
      :safe, "<script src='https://www.google.com/recaptcha/api.js?hl=ru&onload=showCaptcha' async defer></script>"
    }
  end
end
