
PROJECT_URL=${3:-"http://localhost:$HUMBLE_PORT"}

echo ""
echo ""
echo "### Tearing down existing project..."
humble down

echo ""
echo ""
echo "### Build and boot new project..."
humble up -d --build

echo ""
echo ""
echo "Waiting for: $PROJECT_URL"
HTTP_DATA=$(fetch "$PROJECT_URL")
while [ "$HTTP_DATA" == "" ]; do
    HTTP_DATA=$(fetch "$PROJECT_URL")
    echo "Waiting for: $PROJECT_URL"
    sleep 2.5
done

IS_WP_INSTALL=$(indexOf "$DATA" "wp-core-ui language-chooser")
if [ "$IS_WP_INSTALL" != "-1" ]; then
    echo ""
    echo ""
    echo "Wordpress: install page detected,"
    echo "Run seeding script..."
    humble run seed
fi

echo ""
echo ""
echo "System is ready at:"
echo "$PROJECT_URL"
sleep 5

echo ""
echo ""
echo "### Attaching to the logs:"
humble logs -f
