# ==============================
# AppDynamics + NodeJS Makefile
# ==============================

# -------- Variables --------
# It is recommended to use the latest agent image.
CLUSTER_AGENT_IMAGE=appdynamics/cluster-agent:26.2.0-1710
NODEJS_AGENT_IMAGE=appdynamics/nodejs-agent:25.12.0-22-alma
APP_IMAGE=nodejs-auto-app:latest


APP_NAMESPACE=dev
APPD_NAMESPACE=appdynamics

CONTROLLER_KEY=<VALUE>
ACCESS_KEY=<VALUE>

# -------- Default Target --------
.PHONY: all
all: setup-cluster-agent build-app deploy-app

# -------- Load Images --------
.PHONY: load-cluster-agent
load-cluster-agent:
	docker pull $(CLUSTER_AGENT_IMAGE)
	minikube image load $(CLUSTER_AGENT_IMAGE)

.PHONY: load-nodejs-agent
load-nodejs-agent:
	docker pull $(NODEJS_AGENT_IMAGE)
	minikube image load $(NODEJS_AGENT_IMAGE)

# -------- Namespaces --------
.PHONY: create-namespaces
create-namespaces:
	kubectl create namespace $(APPD_NAMESPACE) || true
	kubectl create namespace $(APP_NAMESPACE) || true

# -------- Cluster Agent Setup --------
.PHONY: create-cluster-secret
create-cluster-secret:
	kubectl -n $(APPD_NAMESPACE) create secret generic cluster-agent-secret \
		--from-literal=controller-key=$(CONTROLLER_KEY) || true

.PHONY: deploy-cluster-operator
deploy-cluster-operator:
	kubectl create -f cluster-agent-operator.yaml || true

.PHONY: deploy-cluster-agent
deploy-cluster-agent:
	kubectl -n $(APPD_NAMESPACE) apply -f cluster-agent.yaml

.PHONY: setup-cluster-agent
setup-cluster-agent: load-cluster-agent load-nodejs-agent create-namespaces create-cluster-secret deploy-cluster-operator deploy-cluster-agent

# -------- Build & Load App --------
.PHONY: build-app
build-app:
	docker build -t $(APP_IMAGE) ./node-js-app
	minikube image load $(APP_IMAGE)

# -------- App Secret --------
.PHONY: create-app-secret
create-app-secret:
	kubectl -n $(APP_NAMESPACE) create secret generic appd-agent-secret \
		--from-literal=access-key=$(ACCESS_KEY) || true

# -------- Deploy App --------
.PHONY: deploy-app
deploy-app: create-app-secret
	kubectl apply -f k8s/app.yaml -n $(APP_NAMESPACE)

# -------- Logs --------
.PHONY: logs
logs:
	kubectl logs -f deployment/nodejs-app -n $(APP_NAMESPACE)

.PHONY: get-pods
get-pods:
	kubectl -n $(APPD_NAMESPACE) get pods -o wide
	kubectl -n $(APP_NAMESPACE) get pods -o wide

# -------- Cleanup --------
.PHONY: clean
clean:
	kubectl delete namespace $(APP_NAMESPACE) --ignore-not-found
	kubectl delete namespace $(APPD_NAMESPACE) --ignore-not-found