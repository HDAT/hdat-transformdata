echo "Create Minard Segment Function"
psql -d bgb -f $PWD/sql/minard/0-minardSegments.sql

echo "Running Minard: 1-minard.sql"
psql -d bgb -f $PWD/sql/minard/1-minard.sql

echo "Running Minard: 2-minardGui.sql"
psql -d bgb -f $PWD/sql/minard/2-minardGui.sql

echo "Running Minard: 3-minardSplit.sql"
psql -d bgb -f $PWD/sql/minard/3-minardSplit.sql

echo "Running Minard Export: exportMinard.sh"
psql -d bgb -f $PWD/sql/minard/exportMinard.sh

# echo "Running Minard Gui Export: exportGui.sh"
# psql -d bgb -f $PWD/sql/minard/exportGui.sh