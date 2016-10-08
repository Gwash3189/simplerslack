defmodule SimpleBot do
  use SimplerSlack

  def slack_message(%{channel: channel, token: token, user: _user} = state) do
    IO.inspect state
    send_message("Hey, i got a message", channel, token)
  end
end

SimpleBot.start_link "xoxb-55186220962-BiFAMrlSs47k77yAoy44GxRc"
