#!/bin/bash

mix ecto.create
mix ecto.migrate
./_build/$1/rel/kata_bot/bin/kata_bot start
