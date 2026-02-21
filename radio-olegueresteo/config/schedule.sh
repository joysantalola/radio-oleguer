#!/bin/sh

COMPOSE="docker compose"

case "$1" in
  start_main)
    echo "Iniciant stream principal"
    $COMPOSE start streamer-olegueresteo
    $COMPOSE stop streamer-olegueresteo-hq streamer-olegueresteo-opus
    ;;
    
  start_alt)
    echo "Canviant a stream HQ"
    $COMPOSE start streamer-olegueresteo-hq
    $COMPOSE stop streamer-olegueresteo streamer-olegueresteo-opus
    ;;

  stop_all)
    echo "Aturant tots els streams"
    $COMPOSE stop streamer-olegueresteo streamer-olegueresteo-hq streamer-olegueresteo-opus
    ;;
    
  *)
    echo "Opció no vàlida"
    ;;
esac
