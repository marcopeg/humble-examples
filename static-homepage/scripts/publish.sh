echo "Publish project to DockerHUB..."

# Repository informations
HUB_REPO=marcopeg
HUB_IMAGE=humble-static-homepage

# Build version informations
VERSION_MAJOR=1
VERSION_MINOR=0
VERSION_FIX=0

docker build -t "$HUB_REPO"/"$HUB_IMAGE":latest -t "$HUB_REPO"/"$HUB_IMAGE":$VERSION_MAJOR -t "$HUB_REPO"/"$HUB_IMAGE":$VERSION_MAJOR.$VERSION_MINOR -t "$HUB_REPO"/"$HUB_IMAGE":$VERSION_MAJOR.$VERSION_MINOR.$VERSION_FIX "$PROJECT_CWD/services/nginx"
docker push "$HUB_REPO"/"$HUB_IMAGE"
