DEPLOYMENT_NAME=mysql

install:
	helm install "$(DEPLOYMENT_NAME)" stable/mysql -f helm-values.yaml

get_password:
	kubectl get secret --namespace default "$(DEPLOYMENT_NAME)" \
		-o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo

run_client:
	kubectl run -it --rm --image=mysql --restart=Never mysql-client -- mysql -h mysql -p

