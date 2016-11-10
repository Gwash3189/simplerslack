# SimplerSlack

A way to make simple slack bots that receive message, and respond to them.

The idea behind this package is that it has a very small surface area. As such, it only supports `message` and `user_typing` events.


## Installation

  1. Add `simpler_slack` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:simpler_slack, "~> 0.0.6"}]
    end
    ```
  2. Ensure the following OTP applications are started

    ```elixir
    def application do
      [applications: [:logger, :crypto, :ssl, :httpoison]]
    end
    ```

## Usage

To use SimplerSlack, you need to `use` it

```elixir
defmodule SimpleBot do
 use SimplerSlack

 def slack_message(%{channel: channel, token: token, user: user} = state) do
   IO.inspect state
   send_message("Hey <@#{format_user_id(user)}>", channel, token)
 end
end

SimpleBot.start_link("your-slack-token")
```

This adds the behaviour `SimplerSlack.Client` to the module. This means to get messages, you must
implement either `slack_message(state)` or `slack_user_typing(state)`.

`slack_message` is for when a message is sent to your bot, but not by your bot.
`slack_user_typing` is for when a user is typing in a channel that your bot is in.

Both of those function must also return `nil`. These functions are `cast`'s, so
they are concurrent. If you want to keep things quick, i'd suggest keeping These
functions small, and call `cast`'s on other `GenServer`'s from here
