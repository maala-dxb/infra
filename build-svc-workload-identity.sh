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
