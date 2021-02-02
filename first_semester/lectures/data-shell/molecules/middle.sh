#Vælg linjer fra midt i en fil.
# Brug: bash middle.sh file_name end_line num_lines
head -n "$2" "$1" | tail -n "$3"
