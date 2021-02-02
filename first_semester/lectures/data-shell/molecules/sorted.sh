#Sorter filerne ud fra deres længde
# Brug: bash sorted.sh one_or_more_filenames
wc -l "$@" | sort -n
