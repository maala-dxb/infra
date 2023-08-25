roles=$(yq '.iam.roles[]' ./roles/fooapp.yaml)

for role in $roles; do
  # remove double quotes
  role=$(echo "$role" | tr -d '"')
  gcloud projects add-iam-policy-binding $PROJECT \
   --member="serviceAccount:$TARGET@$PROJECT.iam.gserviceaccount.com" \
   --role="$role" \
   --condition=None
done
