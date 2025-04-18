#!/bin/bash

# Definir os monitores conectados
PRIMARY_MONITOR="HDMI-1"
SECONDARY_MONITOR="eDP-1"

# Pega a lista de monitores conectados
CONNECTED_MONITORS=$(xrandr --query | grep " connected" | cut -d " " -f1)

# Função para definir workspaces para um monitor
assign_workspaces_to_monitor() {
  local monitor=$1
  shift
  for ws in "$@"; do
    i3-msg "workspace $ws; move workspace to output $monitor"
  done
}

# Verifica se os monitores estão conectados e ajusta os workspaces
if echo "$CONNECTED_MONITORS" | grep -q "$PRIMARY_MONITOR"; then
  # Se ambos os monitores estiverem conectados
  if echo "$CONNECTED_MONITORS" | grep -q "$SECONDARY_MONITOR"; then
    assign_workspaces_to_monitor "$PRIMARY_MONITOR" 5 4 3 2 1
    assign_workspaces_to_monitor "$SECONDARY_MONITOR" 10 9 8 7 6
  else
    # Se apenas o PRIMARY_MONITOR estiver conectado
    assign_workspaces_to_monitor "$PRIMARY_MONITOR" 10 9 8 7 6 5 4 3 2 1
  fi
else
  # Se apenas o SECONDARY_MONITOR estiver conectado ou se nenhum dos dois
  assign_workspaces_to_monitor "$SECONDARY_MONITOR" 10 9 8 7 6 5 4 3 2 1
fi
