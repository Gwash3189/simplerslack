# SimplerSlack

A way to make simple slack bots that receive message, and respond to them.

The idea behind this package is that it has a very small surface area. As such, it only supports `message` and `user_typing` events.


## Installation

  1. Add `simpler_slack` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:simpler_slack, "~> 0.1.0"}]
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

 def slack_user_typing(_), do: nothing
end

SimpleBot.start_link("your-slack-token")
```

This adds the behaviour `SimplerSlack.Client` to the module. This means you must
implement both `slack_message(state)` and `slack_user_typing(state)`.

Both of those function must also return `nil`. These functions are `cast`'s, so
they are concurrent. If you want to keep things quick, i'd suggest keeping These
functions small, and call `cast`'s on other `GenServer`'s from here
