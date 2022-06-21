DEPLOYMENT_NAME=mysql
SHELL=/bin/bash

install:
	kubectl create secret generic mysql --namespace default \
		--from-file=mysql-root-password=<(read -s -p "Enter root password: " p; echo -n "$$p")
	helm install "$(DEPLOYMENT_NAME)" stable/mysql \
		-f helm-values.yaml -f helm-values.local.yaml

volumes:
	kubectl apply -f "volumes.local.yaml"

cron:
	[ -f "backup-cron.local.yaml" ] && kubectl apply -f "backup-cron.yaml" || \
		kubectl apply -f "backup-cron.yaml"

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" stable/mysql \
		-f helm-values.yaml -f helm-values.local.yaml

helm_repo:
	helm repo add stable https://charts.helm.sh/stable

get_password:
	kubectl get secret --namespace default "$(DEPLOYMENT_NAME)" \
		-o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo

run_client:
	kubectl run -it --rm --image=mysql --restart=Never mysql-client -- mysql -h mysql -p

