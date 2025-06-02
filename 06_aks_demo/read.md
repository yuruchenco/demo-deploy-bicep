
# デプロイ手順
## SSHキーペア作成
```
# Create an SSH key pair using Azure CLI
az sshkey create --name "mySSHKey" --resource-group "myResourceGroup"

# Create an SSH key pair using ssh-keygen
ssh-keygen -t rsa -b 4096
```
## Bicepファイルをデプロイ
```
az deployment group create --resource-group rg-aks --template-file main.bicep --parameters dnsPrefix=<dns-prefix> linuxAdminUsername=<linux-admin-username> sshRSAPublicKey='<ssh-key>'
```
> [!NOTE]
> - [DNS プレフィックス] : クラスターの一意の DNS プレフィックス (myakscluster など) を入力します。
> - [Linux Admin Username](Linux 管理者ユーザー名) : SSH を使用して接続するためのユーザー名 (azureuser など) を入力します。
> - [SSH RSA Public Key](SSH RSA 公開キー) : SSH キー ペアの "公開" 部分 (既定では、 ~/.ssh/id_rsa.pub の内容) をコピーして貼り付けます。

