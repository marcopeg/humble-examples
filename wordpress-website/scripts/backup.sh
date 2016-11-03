#
# Perform a Versioned Full Backup
#

PRINT_FEEDBACK="yes"
for last; do true; done
if [ "--now" == "$last" ]; then
    PRINT_FEEDBACK="no"
fi

BACKUP_DELAY=${BACKUP_DELAY:-3}
BACKUP_TARGET="$HUMBLE_ENV.$BACKUP_DATE"

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo ""
    echo "====== BACKUP ($HUMBLE_ENV) ======"
    echo "to: backup/$BACKUP_TARGET"
    echo "(sleep 3s, you can abort now)"
    sleep 3
    echo ""
    echo ""
fi

mkdir -p "$BACKUP_ROOT/$BACKUP_TARGET"

echo "wp-uploads..."
humble utils fs-dump      storage://var/www/html/wp-content/uploads       $BACKUP_TARGET/wp-uploads       --now >/dev/null 2>/dev/null

echo "wp-plugins..."
humble utils fs-dump      storage://var/www/html/wp-content/plugins       $BACKUP_TARGET/wp-plugins       --now >/dev/null 2>/dev/null

echo "database..."
humble utils mysql-dump   mysql://wordpress                               $BACKUP_TARGET/wp-mysql         --now >/dev/null 2>/dev/null

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo ""
    echo "--> backup complete!"
    echo ""
    echo ""
fi
exit
