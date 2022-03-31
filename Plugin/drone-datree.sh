#!/bin/sh

token="${PLUGIN_TOKEN}"
inputpath="${PLUGIN_PATH}"
cliArgs="${PLUGIN_CLIARGUMENTS}"
isHelmChart="${PLUGIN_ISHELMCHART}"
helmArgs="${PLUGIN_HELMARGUMENTS}"
isKustomization="${PLUGIN_ISKUSTOMIZATION}"
kustomizeArgs="${PLUGIN_KUSTOMIZEARGUMENTS}"


if [ -z "$token" ]; then
    echo "No account token configured, see https://github.com/datreeio/action-datree for instructions"
    exit 1
fi

if [ "$isHelmChart" = true ]; then
    helm datree test $inputpath $cliArgs -- $helmArgs
elif [ "$isKustomization" = true ]; then
    datree kustomize test $inputpath $cliArgs -- $kustomizeArgs
else
    datree test $inputpath $cliArgs  
fi
