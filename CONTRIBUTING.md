# Contributing

## Pull Requests Welcome

1. Fork the project
2. Create a topic branch
3. Make logically-grouped commits with clear commit messages
4. Push commits to your fork
5. Open a pull request against `recaptcha/master`

## Issues

If you believe there to be a bug, please provide the maintainers with enough
detail to reproduce or a link to an app exhibiting unexpected behavior. For
help, please start with Stack Overflow.

## Development and testing

To set up the development environment you would have to follow several steps:

0. setup `elixir`, we are using the latest release, but supporting everything from `1.2`
1. clone the repo
2. `mix deps.get && mix compile`

To test if everything is working:

1. `mix test` will run unit-tests
2. `mix credo --strict` will run linting
3. `mix dialyzer` will run static analyzer tool to check that everything is fine with your code. It may take some time at the first run

If everything is fine - feel free to submit your code!
