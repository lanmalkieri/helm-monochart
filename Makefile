# Usage:
# make package # Creates release binary
# make publish  # Updates index.yaml with SHA and address of package

.PHONY = all

.EXPORT_ALL_VARIABLES:
HELM_EXPERIMENTAL_OCI = 1

all-aws: package-aws publish-aws
all-gcp: package-gcp publish-gcp

package-aws:
	@echo "Packaging monochart" && \
	source yq.sh && \
	TAG=$(yq e .version stable/monochart/Chart.yaml) && \
	helm chart save stable/monochart 780662665147.dkr.ecr.us-east-1.amazonaws.com/monochart:${TAG}

publish-aws:
	make package-aws
	@echo "Pushing chart to ECR" && \
	source yq.sh && \
	TAG=$$(yq e .version stable/monochart/Chart.yaml) && \
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 780662665147.dkr.ecr.us-east-1.amazonaws.com && \
	HELM_REGISTRY_CONFIG=~/.docker/config.json helm chart push 780662665147.dkr.ecr.us-east-1.amazonaws.com/monochart:$${TAG}

package-gcp:
	@echo "Packaging monochart" && \
	source yq.sh && \
	TAG=$(yq e .version stable/monochart/Chart.yaml) && \
	helm chart save stable/monochart gcr.io/spin-infra/monochart:${TAG}

publish-gcp:
	make package-gcp
	@echo "Pushing chart to GCR" && \
	source yq.sh && \
	TAG=$$(yq e .version stable/monochart/Chart.yaml) && \
	echo y | gcloud auth configure-docker && \
	gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io && \
	HELM_REGISTRY_CONFIG=~/.docker/config.json helm chart push gcr.io/spin-infra/monochart:$${TAG}
