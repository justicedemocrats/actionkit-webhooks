defmodule ActionkitWebhooks.Scheduler do
  use Quantum.Scheduler,
    otp_app: :actionkit_webhooks
end
