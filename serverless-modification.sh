export FUNCTION_NAME=$(echo "$cloudFunction" | tr '_' '-')
echo "{\"function-name\":\"$FUNCTION_NAME\"}">> function-name.json
cat serverless.yaml