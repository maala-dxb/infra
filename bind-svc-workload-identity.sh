. ./colors.sh


echo "${yel}Binding the Workload identity of KSA and GSA ${yel} ${end}"
gcloud iam service-accounts add-iam-policy-binding $TARGET@$PROJECT.iam.gserviceaccount.com \
--role roles/iam.workloadIdentityUser \
--member="serviceAccount:$PROJECT.svc.id.goog[default/$TARGET]"
