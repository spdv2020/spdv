docker rm -f postgres | true
docker build -t postgrespy .
docker run --name postgres \
  -p 5432:5432 \
  -e POSTGRES_DB=spdv \
  -e POSTGRES_PASSWORD=admin \
  -d postgrespy
docker logs --follow postgres