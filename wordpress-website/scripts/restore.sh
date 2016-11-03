#
# Restore latest available backup for current environment
#

PRINT_FEEDBACK="yes"
P3=$3

for last; do true; done
if [ "--now" == "$last" ]; then
    PRINT_FEEDBACK="no"
    [ "$P3" == "$last" ] && P3=""
fi

BACKUP_DELAY=${BACKUP_DELAY:-3}
RESTORE_SOURCE=${P3:-$RESTORE_SOURCE}
if [ "" == "$RESTORE_SOURCE" ]; then
    AVAILABLE_BACKUPS=$(find $BACKUP_ROOT/$HUMBLE_ENV.* -maxdepth 0 -type d)
    for RESTORE_SOURCE in $AVAILABLE_BACKUPS; do :; done
    RESTORE_SOURCE=$(basename $RESTORE_SOURCE)
fi

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo ""
    echo "====== RESTORE BACKUP ($HUMBLE_ENV) ======"
    echo "from: backup/$RESTORE_SOURCE"
    echo "(sleep "$BACKUP_DELAY"s, you can abort now)"
    sleep $BACKUP_DELAY
    echo ""
    echo ""
fi

echo "wp-uploads..."
humble utils fs-seed      $RESTORE_SOURCE/wp-uploads.tar.gz     storage://var/www/html/wp-content/uploads     --now >/dev/null 2>/dev/null

echo "wp-plugins..."
humble utils fs-seed      $RESTORE_SOURCE/wp-plugins.tar.gz     storage://var/www/html/wp-content/plugins     --now >/dev/null 2>/dev/null

echo "change file owner to www-data..."
humble run storage chown -R www-data:www-data /var/www/html/wp-content

echo "import database..."
humble utils mysql-seed   $RESTORE_SOURCE/wp-mysql.sql.gz       mysql://wordpress                             --now >/dev/null 2>/dev/null

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo ""
    echo "--> restore complete!"
    echo ""
    echo ""
fi
exit
