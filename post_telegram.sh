#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Use: $0 <TOKEN> <CHAT_ID>"
  exit 1
fi

TOKEN=$1
CHAT_ID=$2
VERSION=$(./musily_version.sh)
DESCRIPTION=$(./musily_description.sh)

curl -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d '{
        "chat_id": "'"${CHAT_ID}"'",
        "text": "*Musily*\n\nVersão: v'"${VERSION}"'\n\n'"${DESCRIPTION}"'",
        "parse_mode": "Markdown",
        "reply_markup": {
          "inline_keyboard": [[
            {
              "text": "Download",
              "url": "https://github.com/FelipeYslaoker/musily/releases/download/'"${VERSION}"'/musily-'"${VERSION}"'.apk"
            }
          ]]
        }
      }'
