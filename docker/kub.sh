#!/bin/bash

## K8s
alias ka="kubectl get cm,pods,deployment,daemonsets,statefulsets,hpa,pvc,services,ing"
alias kp="kubectl get pods"
alias kpd="kubectl delete pods"
alias kpl="kubectl logs -f"
alias kpdb="kubectl get pdb"
alias kj="kubectl get jobs"
alias kcj="kubectl get cronjobs"
alias ks="kubectl get service"
alias ke="kubectl get endpoints"
alias ki="kubectl get ing"
alias kd="kubectl get deployment"
alias kds="kubectl get daemonsets"
alias kss="kubectl get statefulsets"
alias kse="kubectl get secrets"
alias kc="kubectl get configmap"
alias kh="kubectl get hpa"
alias kpv="kubectl get pv"
alias kpvc="kubectl get pvc"
alias kn="kubectl get ns"
alias kno="kubectl get nodes"
alias ksc="kubectl get storageclass"
alias ktp="kubectl top pods"
alias ktn="kubectl top nodes"
alias kcss="kubectl get ClusterSecretStore"
alias kes="kubectl get ExternalSecret"
alias kfc="kubectl get frontendconfig"
alias kbc="kubectl get backendconfig"

kl() { kubectl logs -f --all-containers=true -l app.kubernetes.io/name="${1}" "${@:2}"; }
kpe() { kubectl "${@:3}" exec -it ${1} -- ${2:-/bin/bash}; }
kdep() { kubectl describe pods "$@"; }
kden() { kubectl describe nodes "$@"; }
kdeh() { kubectl describe hpa "$@"; }
kded() { kubectl describe deployment "$@"; }
kdess() { kubectl describe statefulsets "$@"; }
kdepv() { kubectl describe pv "$@"; }
kdepvc() { kubectl describe pvc "$@"; }
kdes() { kubectl describe svc "$@"; }
kdei() { kubectl describe ing "$@"; }
kdej() { kubectl describe jobs "$@"; }
kdecj() { kubectl describe cronjobs "$@"; }
kdesc() { kubectl describe storageclass "$@"; }
kdecm() { kubectl describe cm "$@"; }
kdecss() { kubectl describe ClusterSecretStore "$@"; }
kdees() { kubectl describe ExternalSecret "$@"; }
kdefc() { kubectl describe frontendconfig "$@"; }
kdebc() { kubectl describe backendconfig "$@"; }
ksee() { kubectl get secret "$@" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'; }

khelp() {
cat << EOF
commands :
    ka                    :       List all the K8s objects
    kp                    :       List all the pods
    kpd                   :       Delete pod
    kpl                   :       Fetch logs from a pod
    kpdb                  :       List all the pod disruption budgets (pdb)
    kj                    :       List all the jobs
    kcj                   :       List all the cronjobs
    ks                    :       List all the service
    ke                    :       List all the endpoints
    ki                    :       List all the ingress
    kd                    :       List all the deployments
    kds                   :       List all the daemonsets
    kss                   :       List all the statefulsets
    kse                   :       List all the secrets
    kc                    :       List all the configmap
    kh                    :       List all the hpa
    kpv                   :       List all the persistent volume (pv)
    kpvc                  :       List all the persistent volume claim (pvc)
    kns                   :       List all the namespaces
    kno                   :       List all the worker nodes
    ksc                   :       List all the storageclass
    kcss                  :       List all the ClusterSecretStore
    kes                   :       List all the ExternalSecret
    kfc                   :       List all the frontendconfig
    kbc                   :       List all the backendconfig
    ktp                   :       Top command for pods
    ktn                   :       Top command for nodes
    kl [deploy-name]      :       Show logs for the specific deployment
    kpe [pod-name]        :       Execute into the pod
    kdep [pod-name]       :       Describe pod
    kden [node-name]      :       Describe node
    kdeh [hpa-name]       :       Describe hpa
    kded [deploy-name]    :       Describe deploy
    kdepv [pv-name]       :       Describe persistent volume (pv)
    kdepvc [pvc-name]     :       Describe persistent volume claim (pvc)
    kdes [service-name]   :       Describe service
    kdei [ing-name]       :       Describe Ingress    
    kdesc [sc-name]       :       Describe Storageclass
    kdecm [cm-name]       :       Describe Configmap
    kdecss [sc-name]      :       Describe ClusterSecretStore
    kdees [sc-name]       :       Describe ExternalSecret
    kdefc [sc-name]       :       Describe frontendconfig
    kdebc [sc-name]       :       Describe backendconfig
    ksee [secret-name]    :       Get the decrypted data from the Secret
EOF
}