
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
az deployment group create --resource-group <your-resource-group> --template-file main.bicep --parameters sshRSAPublicKey='<ssh-key>'
```

オプションパラメータを含む完全なコマンド例:
```
az deployment group create --resource-group <your-resource-group> --template-file main.bicep --parameters clusterName='<cluster-name>' dnsPrefix='<dns-prefix>' linuxAdminUsername='<linux-admin-username>' agentCount=<node-count> agentVMSize='<vm-size>' osDiskSizeGB=<disk-size> sshRSAPublicKey='<ssh-key>'
```

> [!NOTE]
> **必須パラメータ:**
> - [SSH RSA Public Key](SSH RSA 公開キー) : SSH キー ペアの "公開" 部分 (既定では、 ~/.ssh/id_rsa.pub の内容) をコピーして貼り付けます。
> 
> **オプションパラメータ (既定値が設定されています):**
> - [Cluster Name](クラスター名) : AKS クラスターの名前 (既定値: 'aksTestcluster')
> - [DNS プレフィックス] : クラスターの一意の DNS プレフィックス (既定値: '${clusterName}-dns')
> - [Linux Admin Username](Linux 管理者ユーザー名) : SSH を使用して接続するためのユーザー名 (既定値: 'adminuser')
> - [Agent Count](ノード数) : クラスターのノード数 (既定値: 3, 範囲: 1-50)
> - [Agent VM Size](VM サイズ) : ノードの仮想マシンサイズ (既定値: 'standard_d2s_v3')
> - [OS Disk Size GB](OS ディスクサイズ) : ノードの OS ディスクサイズ (GB) (既定値: 0 = 既定サイズ, 範囲: 0-1023)

