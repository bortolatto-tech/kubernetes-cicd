# Simulando um ambiente de entrega contínua
Um ambiente completo de CI/CD rodando em um cluster k8s, utilizando a estratégia de pull com ArgoCD e Jenkins.

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

### Instalando helm-chart da aplicação de exemplo "java-microservice"
Esta é uma aplicação Java que se conecta em um banco relacional PostgreSQL. O chart da aplicação declara uma dependência para o chart do postgresql.
Ao instalar o chart da aplicação automaticamente o postgresql será instanciado.

*Importante:* ao desinstalar o chart precisa remover manualmente o PVC criado pelo postgresql, por algum motivo esses recursos não são limpos. É necessário fazer isso pois na próxima instalação começa a dar erro de autenticação pelo fato de existir um PVC criado anteriormente. [Este é um bug conhecido](https://github.com/helm/helm/issues/5156). 

Ver mais em: https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-helm-chart-issues/


Exemplo de instalação do chart:
```bash
helm upgrade --install teste-microservice java-microservice/ \
--set app.dbUser=teste \
--set app.dbPass=teste \
--set app.dbName=teste \
--set postgresql.auth.database=teste \
--set postgresql.auth.username=teste \
--set postgresql.auth.password=teste
```
