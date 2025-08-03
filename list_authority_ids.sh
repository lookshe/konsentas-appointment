#!/usr/bin/env bash

curl -s "https://stuttgart.konsentas.de" | sed -e '/<ol>/,/<\/ol>/!d;s/<li>/\n/g' | sed -e 's#<a href=.*form/##;s#/[^>]*># -> #;s#<.*##' | grep '^[0-9].*'
