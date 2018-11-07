#!/bin/sh

release_ctl eval --mfa "Auth.ReleaseTasks.migrate/1" --argv -- "$@"
