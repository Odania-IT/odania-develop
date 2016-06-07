#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

echo "Odania Static"
docker exec -ti odaniadevelop_odaniastatic_1 rake web:generate

echo "Core"
docker exec -ti odaniadevelop_core_1 rake odania:global:generate_config
docker exec -ti odaniadevelop_core_1 rake odania:register

echo "Varnish Public"
docker exec -ti odaniadevelop_varnish_1 rake varnish:generate

echo "Admin"
docker exec -ti odaniadevelop_core_1 rake odania:register
