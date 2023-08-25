
export TARGET
export PROJECT=root-cortex-387409

all: user_cluster_context build_svc_workload bind_svc_roles bind_svc_workload_identity

user_cluster_context:
	gcloud container clusters get-credentials autopilot-cluster-1 --region europe-west1 --project root-cortex-387409

build_svc_workload:
	bash ./build-svc-workload-identity.sh

bind_svc_roles:
	bash ./bind-svc-roles.sh

bind_svc_workload_identity:
	bash ./bind-svc-workload-identity.sh