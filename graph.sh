echo "Running Graph: 0-graphCalc.sql"
psql -d bgb -f $PWD/sql/graph/0-graphCalc.sql

echo "Running Graph: exportGraph.sh"
sh $PWD/sql/graph/exportGraph.sh
