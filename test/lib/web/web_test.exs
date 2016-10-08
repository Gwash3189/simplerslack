defmodule SimplerSlack.WebTest do
  use ExUnit.Case, aync: true

  import Mock

  describe "sending a message" do
    test "returns the API response" do
      with_mock HTTPoison, [post: mock_post_with(success)] do
        assert SimplerSlack.Web.send_message("text", "channel_id", "token") == success
      end
    end

    test "assembles the url correctly" do
      with_mock HTTPoison, [post: get_url] do
        assert SimplerSlack.Web.send_message("text", "channel_id", "token") == query_string
      end
    end
  end

  defp mock_post_with(x) do
    fn(_url, _, _, _) -> x end
  end

  defp get_url do
    fn(url, _, _, _) -> url end
  end

  defp success do
    %{}
  end

  defp query_string do
    "https://slack.com/api/chat.postMessage?channel=channel_id&text=text&token=token"
  end
end
