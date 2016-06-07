#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

ODANIA_GEM_FOLDER_NAME=$(cat config/config.yml | grep odania-gem | awk '{ print $1 }' | tr -d ':')
VERSION=$(cat git/odania-gem/lib/odania/version.rb | grep VERSION | awk '{ print $3 }' | tr -d "'")
ODANIA_GEM_FOLDER=git/$ODANIA_GEM_FOLDER_NAME

echo "Odania Version: ${VERSION} (${ODANIA_GEM_FOLDER})"
cd $ODANIA_GEM_FOLDER
rake build
cd ..

echo "Odania Core"
cp $ODANIA_GEM_FOLDER_NAME/pkg/odania-${VERSION}.gem odania-core
docker exec -ti odaniadevelop_core_1 gem install odania-${VERSION}.gem
docker exec -ti odaniadevelop_core_1 bundle install

echo "Varnish Public"
cp $ODANIA_GEM_FOLDER_NAME/pkg/odania-${VERSION}.gem odania-varnish
docker exec -ti odaniadevelop_varnish_1 gem install odania-${VERSION}.gem
docker exec -ti odaniadevelop_varnish_1 bundle install

echo "Odania Static"
cp $ODANIA_GEM_FOLDER_NAME/pkg/odania-${VERSION}.gem odania-static
docker exec -ti odaniadevelop_odaniastatic_1 gem install odania-${VERSION}.gem
docker exec -ti odaniadevelop_odaniastatic_1 bundle install

echo "Odania Admin"
cp $ODANIA_GEM_FOLDER_NAME/pkg/odania-${VERSION}.gem odania-admin
docker exec -ti odaniadevelop_admin_1 gem install odania-${VERSION}.gem
docker exec -ti odaniadevelop_admin_1 bundle install
