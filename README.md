# ActionkitWebhooks

This is a teeeensy Phoenix app! It implements a little server that checks for
new submissions to a form in Actionkit, and then sends webhooks with the user data
and custom action fields to an endpoint specified in an Airtable base.

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

## Configuration  

The following environment variables are required. Get secrets from Ben if you're
working with him!

```
AIRTABLE_KEY=
AIRTABLE_BASE=
AIRTABLE_TABLE_NAME=
AK_BASE=
AK_USERNAME=
AK_PASSWORD=
UPDATE_SECRET=
```

And, this app expects an Airtable base with a table named "Configuration"
that has at least three columns:
  * "Page ID" -> an Actionkit page id
  * "Endpoint" -> the endpoint to send the webhook too
  * "Stagger?" -> whether or not the outgoing webhooks should be staggered by 250ms each
    (the fourth new response would be send out a full second after the first). Zapier
    gets upset if things come all at the same time.

## Usage

Add a new line to the Airtable sheet. Wait to the nearest 5th minute `*/5 * * * *`
or force and update (instructions below). Then, youre webhooks will start coming!

## Endpoints

```
GET /heath -> returns 200 and a little message unless something is wrong (for uptime monitoring)

GET /force-update?secret=thesecretbengivesyou -> forces and update, and returns a 200 after

GET /list-hooks -> for seeing which page -> endpoint mappings are currently registered
```

## Note

If you put a page in there twice, it will execute twice! Potentially sending
it off to 2 different webhooks, if that's what you want. This also means that to
deprecate old webhooks, you'll actually need to delete the row and wait 5 minutes
or force an update (you can't overwrite it by adding a new row).

## Deployment

This is configured to use Gigalixir (https://gigalixir.com/). JD people, you can
use these endpoints by going to https://webhooks.justicedemocrats.com
