# Use the official Elixir image from Docker Hub
FROM elixir:latest

ARG MIX_ENV=dev
ARG KATA_DISCORD_TOKEN=""
ENV MIX_ENV $MIX_ENV
ENV KATA_DISCORD_TOKEN $KATA_DISCORD_TOKEN

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app
RUN rm -fr _build
# Install dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Compile the project
RUN mix compile
RUN mix release

# Start the application
CMD ["sh", "-c", "/app/_build/${MIX_ENV}/rel/kata_bot/bin/kata_bot start"]
