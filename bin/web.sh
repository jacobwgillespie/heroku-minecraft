#!/bin/bash

export MC_HEROKU_SERVER_PORT=${PORT}
foreman start -f Procfile-web