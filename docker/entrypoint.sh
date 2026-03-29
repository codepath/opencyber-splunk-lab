#!/usr/bin/env bash
set -e

g='\033[0;32m'
y='\033[0;33m'
n='\033[0m'

echo
echo -e "   __   __   __   ___ "
echo -e "  /  \` /  \ |  \ |__  "
echo -e "  \__, \__/ |__/ |___ "
echo -e "   __       ___       "
echo -e "  |__)  /\   |   |__|  "
echo -e "  |    /--\  |   |  |  "
echo -e "        __   __   ___  "
echo -e "  ${g}\|/  ${n}/  \ |__) / _   "
echo -e "  ${g}/|\  ${n}\__/ |  \ \__/  "
echo
echo -e "Welcome to the ${g}Splunk Lab${n} environment!"
echo

INIT_SENTINEL="/opt/splunk/var/.lab-initialized"

echo "Keep this terminal open while you work — closing it stops Splunk."
echo

if [ ! -f "$INIT_SENTINEL" ]; then
    echo -e "${y}First-run setup required.${n} Splunk needs to initialize and index"
    echo "the lab data. This takes about 2 minutes."
else
    echo "Splunk takes 60–90 seconds to start."
fi

echo
read -rp "Ready to get started? [y/N] " answer
case "$answer" in
    [yY]|[yY][eE][sS]) ;;
    *)
        echo
        echo "No problem — run the same command again when you're ready."
        exit 0
        ;;
esac
echo

# Start Splunk (suppress verbose startup output)
echo "Starting Splunk..."
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt > /dev/null 2>&1

# Wait for Splunk to be ready
echo -n "Waiting for Splunk to initialize"
until /opt/splunk/bin/splunk status 2>/dev/null | grep -q 'is running'; do
    printf '.'
    sleep 3
done
echo

if [ ! -f "$INIT_SENTINEL" ]; then
    echo
    echo "Indexing lab data..."
    # Free license is pre-configured in the image (server.conf) — no runtime activation needed.

    /opt/splunk/bin/splunk add index pathcode \
        -auth 'admin:codepath' > /dev/null

    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/netflix_titles.csv \
        -index main -sourcetype csv -host Netflix -auth 'admin:codepath' > /dev/null
    /opt/splunk/bin/splunk add oneshot "/opt/splunk-data/Top Video Game sales.csv" \
        -index main -sourcetype csv -host SalesData -auth 'admin:codepath' > /dev/null
    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/webauth.csv \
        -index main -sourcetype csv -host WebServer01 -auth 'admin:codepath' > /dev/null

    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/webserver02.csv \
        -index pathcode -sourcetype csv -host webserver02 -auth 'admin:codepath' > /dev/null
    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/uploadedhashes.csv \
        -index pathcode -sourcetype csv -host uploadedhashes -auth 'admin:codepath' > /dev/null
    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/failedlogins64.csv \
        -index pathcode -sourcetype csv -host failedlogins64 -auth 'admin:codepath' > /dev/null
    /opt/splunk/bin/splunk add oneshot /opt/splunk-data/BlueCoatProxy01.csv \
        -index pathcode -sourcetype csv -host BluecoatProxy01 -auth 'admin:codepath' > /dev/null

    sleep 30
    touch "$INIT_SENTINEL"
fi

echo
echo -e "${g}============================================${n}"
echo -e "${g}  Splunk is ready!${n}"
echo
echo -e "  Open your browser and go to:"
echo -e "    ${g}http://localhost:8000${n}"
echo
echo -e "  Log in with:"
echo -e "    Username: ${g}admin${n}"
echo -e "    Password: ${g}codepath${n}"
echo -e "${g}============================================${n}"
echo
echo "Press Ctrl+C to stop Splunk and exit."
echo

# Keep container alive
sleep infinity
