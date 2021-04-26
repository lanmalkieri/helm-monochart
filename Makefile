# Usage:
# make package # Creates release binary
# make publish  # Updates index.yaml with SHA and address of package

define yq
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq $1 $2 $3
endef

define saveChart
	helm chart save stable/monochart $1
endef

define pushChart
	HELM_REGISTRY_CONFIG=~/.docker/config.json helm chart push $1
endef

.PHONY = all

.EXPORT_ALL_VARIABLES:
HELM_EXPERIMENTAL_OCI = 1

all-aws: package-aws publish-aws
all-gcp: package-gcp publish-gcp

package-aws:
	@echo "Packaging monochart"
	$(call saveChart,780662665147.dkr.ecr.us-east-1.amazonaws.com/monochart:$$(yq e .version stable/monochart/Chart.yaml))

publish-aws:
	@echo "Pushing chart to ECR"
	@aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 780662665147.dkr.ecr.us-east-1.amazonaws.com
	$(call pushChart,780662665147.dkr.ecr.us-east-1.amazonaws.com/monochart:$$(yq e .version stable/monochart/Chart.yaml))

package-gcp:
	@echo "Packaging monochart"
	$(call saveChart,gcr.io/spin-infra/monochart:$$(yq e .version stable/monochart/Chart.yaml))

publish-gcp:
	@echo "Pushing chart to GCR" 
	@echo y | gcloud auth configure-docker 
	gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io
	$(call pushChart,gcr.io/spin-infra/monochart:$$(yq e .version stable/monochart/Chart.yaml))
