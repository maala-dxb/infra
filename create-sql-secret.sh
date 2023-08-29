echo "${yel}Creating Secret generic..${yel}${end}"
kubectl create secret generic $TARGET-gke-cloud-sql-secrets \
  --from-literal=username=$TARGET \
  --from-literal=password=$PASSWORD \
  --from-literal=host=$HOST
