defmodule ActionkitWebhooks.AirtableCache do
  use AirtableConfig
  import ShortMaps

  def key, do: Application.get_env(:actionkit_webhooks, :airtable_key) |> IO.inspect()
  def base, do: Application.get_env(:actionkit_webhooks, :airtable_base)
  def table, do: Application.get_env(:actionkit_webhooks, :airtable_table_name)
  def view, do: "Grid view"
  def into_what, do: []

  def filter_record(~m(fields)) do
    Map.has_key?(fields, "Page ID")
  end

  def process_record(~m(fields)) do
    {fields["Page ID"], fields["Endpoint"], fields["Stagger?"] || false}
  end
end
