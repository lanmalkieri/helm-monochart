## [0.8.8] - 2021-05-05

### Added

- Added new Argo Rollout Resource
- Added HPA targetting Argo Rollouts

## [0.8.6] - 2021-04-29

### Changed

- Remove old unused variables relating to Istio (Will add them back if we deploy Istio)
- Make Ingress specifiction more generic

## [0.8.5] - 2021-04-26

### Changed

- Allow externalsecrets name to be overridden 
- Allow namespace name to be overriden


## [0.8.4] - 2021-04-26

### Added

- Updated PDB to use new API - policy/v1 on k8s clusters 1.21+

### Changed

- Updated Makefile to remove yq.sh script dependency 
