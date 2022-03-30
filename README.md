# AIM of the project
Estimate the evolutionary histories of natural and domesticated yeast

## KIT 
<img src="https://img.icons8.com/color/48/000000/python.png"/><img src="https://img.icons8.com/color/48/000000/docker.png"/>

![Python](https://img.shields.io/badge/-Python-yellow)![Docker](https://img.shields.io/badge/-Docker-blue)

## Display
 $RESULTAT FINAL$

## Requirement:

Having docker and git installed </br>
-get docker her : https://docs.docker.com/engine/install/ </br>
-get git her :    https://git-scm.com/downloads </br>

## Installation

## MAC/Windows
![Alt text](settings.png)
into the shell
```
git clone Sykzen/Project-bio-info 
cd server Project-bio-info
docker-compose up
docker exec -it valtest bash
```
## Linux 
![Alt text](settings.png)
if you don't have docker desktop installed then
```
git clone Sykzen/Project-bio-info 
cd server Project-bio-info
docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=50000000 
docker buildx build .
```
if you don't have buildx installed then in a dockerfile
```
FROM docker
COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx
RUN docker buildx version
```
## Contributors

- [Sykzen](https://github.com/Sykzen) 
- [Sarmedd](https://github.com/Sarmedd)
- [BOUNEGTAMohamedRami](https://github.com/BOUNEGTAMohamedRami)




