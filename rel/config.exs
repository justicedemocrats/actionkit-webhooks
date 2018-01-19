use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :".5pSS9vRo;DE!Dp0@vAPYD|?EfyfqU?,N%6L{W44=v66*vu:v$wJYpDwH.}Oe>R4"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :",MSZSy2?V;B$tC~w=zmlIwA}|Hj;X^~t*DAw`<tnDKT{8z];UR54vShnoHi0.Q!$"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :actionkit_webhooks do
  set version: current_version(:actionkit_webhooks)
end
