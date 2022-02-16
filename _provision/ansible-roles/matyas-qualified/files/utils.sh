export PATH=/usr/local/bin/utils:/usr/local/bin/utils/tiny:$PATH
if [ -d /usr/local/bin/utils/shellfn ]; then
    for x in /usr/local/bin/utils/shellfn/*.sh; do
        . $x
    done
fi
