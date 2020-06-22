docker build -t holhar/multi-client:latest -t holhar/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t holhar/multi-server:latest -t holhar/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t holhar/multi-worker:latest -t holhar/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push holhar/multi-client:latest
docker push holhar/multi-server:latest
docker push holhar/multi-worker:latest

docker push holhar/multi-client:$SHA
docker push holhar/multi-server:$SHA
docker push holhar/multi-worker:$SHA

# Through the .travis.yaml file kubectl is already configured to interact with our Google Cloud Kubernetes cluster
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=holhar/multi-client:$SHA
kubectl set image deployments/server-deployment server=holhar/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=holhar/multi-worker:$SHA
