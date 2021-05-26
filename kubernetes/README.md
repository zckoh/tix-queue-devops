# help-queue-kubernetes

run the following to setup all configurations on kubernetes:
```bash
./setup.sh -u <db_username> -p <db_password> -h <db_hostname> -n <eks_cluster_name>
```

for subsequent deployments:
```bash
kubectl rollout restart deployment/<deployment_name>
```