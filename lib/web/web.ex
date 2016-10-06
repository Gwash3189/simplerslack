defmodule SimplerSlack.Web do
  @moduledoc """
    Handles web calls to slacks API.

    only supports the `chat.postMessage` endpoint.

    Can be used as `send_message("the message", "channel_id", "token")`
  """
  @slack_message_url "https://slack.com/api/chat.postMessage"

  @type success :: {:ok, any}
  @type error :: {:error, any}

  @doc """
  sends the provided text to the provided channel

  `send_message("send this text", "channel_id", "token")`
  """
  @spec send_message(String.t, String.t, String.t) :: success | error
  def send_message(text, channel_id, token) do
    query_string = create_query_string(text, channel_id, token)

    "#{@slack_message_url}?#{query_string}"
      |> HTTPoison.post('', [], [])
  end

  defp create_query_string(text, channel_id, token) do
    URI.encode_query(%{
      text: text,
      channel: channel_id,
      token: token
    })
  end
end
