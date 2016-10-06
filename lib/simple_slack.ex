defmodule SimplerSlack do
  defexception message: """
    an error occured when contacting the slack RTM endpoint.
  """
  @moduledoc """
  Used to create a basic slack bot which can receive `user_typing` or `message` events.
  Can also send messages back.

  An example would be
  ```
  defmodule SimpleBot do
    use SimplerSlack

    def slack_message(%{channel: channel, token: token, user: _user} = state) do
      IO.inspect state
      send_message("Hey, i got a message", channel, token)
    end

    # nothing is a function provided by SimplerSlack
    # thought it looked better than returning nil
    def slack_user_typing(_), do: nothing
  end

  SimpleBot.start_link "the-token"
 ```
  """
  defmacro __using__(_) do
    quote do
      @behaviour SimplerSlack.Client
      import SimplerSlack.Web

      @rtm_url "https://slack.com/api/rtm.start"

      @doc """
      Starts the slack bot with the provided slack token
      """
      @spec start_link(String.t) :: {:ok, pid}
      def start_link(token) do
        json = get_json_from_rtm(HTTPoison.get("#{@rtm_url}?token=#{token}"))
        {:ok, response} = Poison.Parser.parse(json)

        url = response["url"]
        id = response["self"]["id"]
        state = %{self: %{id: id}, token: token}

        SimplerSlack.Websocket.Client.start_link(url, __MODULE__, state)
      end

      @doc """
        used to make things read a bit easier.

        an example would be

        `def slack_user_typing(_, _), do: nothing`
      """
      def nothing, do: nil

      @doc """
      Gets the json from the RTM api response
      """
      def get_json_from_rtm({:ok, %{body: json}}) do
        json
      end
      @doc """
      Handles errors from the RTM api
      """
      def get_json_from_rtm({:erorr, _message}) do
        raise SimplerSlack
      end

      @doc """
      formats a user-id into a slack formatted user id
      an example is:

      `format_user_id("the-id") # => <@the-id>`
      """
      @spec format_user_id(String.t) :: String.t
      def format_user_id(user_id) do
        "<@#{user_id}>"
      end
    end
  end
end
