.DEFAULT_GOAL := create

pre:
	@kubectl apply -f manifests/setup-hosts.yaml
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
	@kubectl wait -n metallb-system \
		-l app=metallb,component=speaker \
		--for=condition=Ready=true \
		--timeout=300s pod

create:
	@kind create cluster --config config.yaml

pool:
	@kubectl apply -f manifests/metallb-pool.yaml

helm:
	@helmfile apply -f helmfile.yaml

up: create pre pool helm

destroy:
	@kind delete clusters kind

passwd:
	@echo 'JENKINS: user admin' 
	@kubectl get secrets -n jenkins jenkins -ojson | jq '.data."jenkins-admin-password"' | jq '@base64d' -r
	@echo "\n"