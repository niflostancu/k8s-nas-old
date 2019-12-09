DEPLOYMENT_NAME=mysql
SHELL=/bin/bash

install:
	kubectl create secret generic mysql --namespace default \
		--from-file=mysql-root-password=<(read -s -p "Enter root password: " p; echo -n "$$p")
	helm install "$(DEPLOYMENT_NAME)" stable/mysql -f helm-values.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" stable/mysql -f helm-values.yaml

helm_repo:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/

get_password:
	kubectl get secret --namespace default "$(DEPLOYMENT_NAME)" \
		-o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo

run_client:
	kubectl run -it --rm --image=mysql --restart=Never mysql-client -- mysql -h mysql -p
