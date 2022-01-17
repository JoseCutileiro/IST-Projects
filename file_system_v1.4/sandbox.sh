# Use this to execute the specified test in a sandbox.
# This way it wont fill your working dir with trash

EXEC=Bateria1

echo "Executing " + $EXEC + " in sandbox..."
mkdir _sandbox
cp ./tests/$EXEC _sandbox/
cd _sandbox
./$EXEC
cd ..
rm -rf _sandbox