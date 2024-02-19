#! /bin/bash

export api=${ApiGateway}
export Apiconfig=${config}
gcloud api-gateway api-configs describe ${Apiconfig} --api=${api} --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swaggerv2.yaml
cat swaggerv2.yaml
diff swaggerv2.yaml swagger.yaml --unified=0 || true
