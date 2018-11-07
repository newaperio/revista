#!/bin/sh

release_ctl eval --mfa "CMS.ReleaseTasks.migrate/1" --argv -- "$@"
