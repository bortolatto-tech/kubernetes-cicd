# kubernetes-cicd
Um ambiente completo de CI/CD rodando em um cluster k8s, utilizando a estratégia de pull com ArgoCD e Jenkins

### Configuração webhook gitea
Adicionar configuração no gitea para adicionar o host do jenkins na lista de hosts confiáveis para webhook.
```
additionalConfigFromEnvs:
  - name: GITEA__webhook__ALLOWED_HOST_LIST
    value: jenkins.jenkins.svc.cluster.local
```    

### Configuração hosts Jenkins
Adicionar o ip do ingress controller no node do jenkins para que seja possível alcançar os serviços
```
hostAliases:   
  - ip: 172.18.0.50
    hostnames:
      - gitea.localhost.com
```
Alterar configuração em Manage Jenkins/Security/Git Host Key Verification Configuration para "Accept first connection" para que não dê erro de known-hosts na primeira tentativa de conexão ssh. Nas próximas conexões fará a verificação.

### Configuração nginx ingress controle - expondo a porta 22
Adicionar configuração para que seja possível fazer git clone via ssh de dentro do Jenkins com contas de serviço
```
tcp:
  22: "gitea/gitea-ssh:22"
```