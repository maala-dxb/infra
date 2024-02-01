# read the roles from the app target roles file, in infra/roles/$TARGET.yaml directory
roles=$(yq '.iam.roles[]' ./roles/$TARGET.yaml)


wli=$(kubectl get sa -o=name | grep $TARGET)
gsa=$(gcloud iam service-accounts list --project=$PROJECT | grep -w $TARGET)

. ./colors.sh

if [[ -z "$wli" ]]; then
	echo "${yel}No k8s service account found for $TARGET. Creating a one.. ${yel}${end}"
  kubectl create serviceaccount $TARGET
else
  echo "${green}K8s service account already exist for $TARGET ${green}${end}"
fi


if [[ -z "$gsa" ]]; then
	echo "${yel}No google service account found for $TARGET. Creating a one.. ${yel}${end}"
  gcloud iam service-accounts create $TARGET --project=$PROJECT
else
  echo "${green}Google service account already exist for $TARGET${green}${end}"
fi



echo "${yel}Binding service roles ${yel}${end}"
for role in $roles; do
  # remove double quotes
  role=$(echo "$role" | tr -d '"')
  gcloud projects add-iam-policy-binding $PROJECT \
   --member="serviceAccount:$TARGET@$PROJECT.iam.gserviceaccount.com" \
   --role="$role" \
   --condition=None
done



echo "${yel}Binding the Workload identity of KSA and GSA..${yel} ${end}"
gcloud iam service-accounts add-iam-policy-binding $TARGET@$PROJECT.iam.gserviceaccount.com \
--role roles/iam.workloadIdentityUser \
--member="serviceAccount:$PROJECT.svc.id.goog[default/$TARGET]"


kubectl annotate serviceaccount \
$TARGET  \
iam.gke.io/gcp-service-account=$TARGET@root-cortex-387409.iam.gserviceaccount.com

