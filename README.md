# Setup
* `dc build` (dc is an alias, short for docker-compose)
* Install the dependencies on your mix_cache volume:
** `runapp mix local.hex --force`
** `runapp mix archive.install hex phx_new --force`

* To create new phoenix project, run `runapp mix phx.new . --app <app name>`
* Follow instructions at the end of the project creation output

Your source files will exist in ./src/* on your local machine

## Configuration
Because the environment runs in docker, the phoenix server needs to bind to the container's virtual network interface so our machine can get to it. Do this by updating `config/dev/exs` and changing
```
  http: [ip: {127, 0, 0, 1}, port: 4000],
```
to
```
  http: [ip: {0, 0, 0, 0}, port: 4000],
```

Also, the default generator expects a postgres database to be running on localhost, but this too is wrong.
In the same dev.exs change
```
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
```
to
```
  username: "postgres",
  password: "123Secure",    # <- Different password
  hostname: "db",           # <- Different host
```