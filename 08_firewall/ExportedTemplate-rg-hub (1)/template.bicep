@secure()
param workbooks_c1e168de_f5c0_4e02_ac92_5772b48b607c_serializedData string

@secure()
param workbooks_c1e168de_f5c0_4e02_ac92_5772b48b60ef_serializedData string
param routeTables_rt_hub_fw_name string = 'rt-hub-fw'
param azureFirewalls_azfw_test_name string = 'azfw-test'
param virtualNetworks_vnet_hub_name string = 'vnet-hub'
param firewallPolicies_fw_policy_hub_name string = 'fw-policy-hub'
param workbooks_c1e168de_f5c0_4e02_ac92_5772b48b607c_name string = 'c1e168de-f5c0-4e02-ac92-5772b48b607c'
param workbooks_c1e168de_f5c0_4e02_ac92_5772b48b60ef_name string = 'c1e168de-f5c0-4e02-ac92-5772b48b60ef'
param networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name string = 'vnet-hub-VmSubnet-nsg-japaneast'
param publicIPAddresses_pip_fw_test_externalid string = '/subscriptions/7fd24fa5-b36e-4da0-bb40-2cd734d5fb2b/resourceGroups/rg-AppGW2FW/providers/Microsoft.Network/publicIPAddresses/pip-fw-test'
param virtualNetworks_vnet_function_japaneast_externalid string = '/subscriptions/7fd24fa5-b36e-4da0-bb40-2cd734d5fb2b/resourceGroups/rg-function-japaneast/providers/Microsoft.Network/virtualNetworks/vnet-function-japaneast'
param virtualNetworks_my_linux_vm_vnet_externalid string = '/subscriptions/7fd24fa5-b36e-4da0-bb40-2cd734d5fb2b/resourceGroups/rg-bicep-monitor/providers/Microsoft.Network/virtualNetworks/my-linux-vm-vnet'

resource workbooks_c1e168de_f5c0_4e02_ac92_5772b48b607c_name_resource 'microsoft.insights/workbooks@2023-06-01' = {
  name: workbooks_c1e168de_f5c0_4e02_ac92_5772b48b607c_name
  location: 'eastus'
  tags: {
    'hidden-title': 'Sample-Book'
  }
  kind: 'shared'
  identity: {
    type: 'None'
  }
  properties: {
    displayName: 'Sample-Book'
    version: 'Notebook/1.0'
    category: 'workbook'
    sourceId: 'azure monitor'
    serializedData: workbooks_c1e168de_f5c0_4e02_ac92_5772b48b607c_serializedData
  }
}

resource workbooks_c1e168de_f5c0_4e02_ac92_5772b48b60ef_name_resource 'microsoft.insights/workbooks@2023-06-01' = {
  name: workbooks_c1e168de_f5c0_4e02_ac92_5772b48b60ef_name
  location: 'japaneast'
  tags: {
    'hidden-title': 'APRL_QueriesBook'
  }
  kind: 'shared'
  identity: {
    type: 'None'
  }
  properties: {
    displayName: 'APRL_QueriesBook'
    version: 'Notebook/1.0'
    category: 'workbook'
    sourceId: 'azure monitor'
    serializedData: workbooks_c1e168de_f5c0_4e02_ac92_5772b48b60ef_serializedData
  }
}

resource firewallPolicies_fw_policy_hub_name_resource 'Microsoft.Network/firewallPolicies@2023-09-01' = {
  name: firewallPolicies_fw_policy_hub_name
  location: 'japaneast'
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
  }
}

resource networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_resource 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name
  location: 'japaneast'
  properties: {
    securityRules: [
      {
        name: 'AllowCorpnet'
        id: networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_AllowCorpnet.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2700
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowSAW'
        id: networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_AllowSAW.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2701
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource routeTables_rt_hub_fw_name_resource 'Microsoft.Network/routeTables@2023-09-01' = {
  name: routeTables_rt_hub_fw_name
  location: 'japaneast'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'rt-internet'
        id: routeTables_rt_hub_fw_name_rt_internet.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource firewallPolicies_fw_policy_hub_name_DefaultApplicationCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-09-01' = {
  parent: firewallPolicies_fw_policy_hub_name_resource
  name: 'DefaultApplicationCollectionGroup'
  location: 'japaneast'
  properties: {
    priority: 300
    ruleCollections: []
  }
}

resource firewallPolicies_fw_policy_hub_name_DefaultApplicationRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-09-01' = {
  parent: firewallPolicies_fw_policy_hub_name_resource
  name: 'DefaultApplicationRuleCollectionGroup'
  location: 'japaneast'
  properties: {
    priority: 300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'zuka'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'apis.kedamakawaii.com'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'kakunin'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'www.ugtop.com'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'blob1'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'rgfunctionjapaneastaef8.blob.core.windows.net'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'oryx'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'github.com'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'oryx2'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'oryx-cdn.microsoft.io'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'pypi'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
              'pypi.org'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
            httpHeadersToInsert: []
          }
        ]
        name: 'RuleCollection01'
        priority: 300
      }
    ]
  }
}

resource firewallPolicies_fw_policy_hub_name_DefaultDnatRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-09-01' = {
  parent: firewallPolicies_fw_policy_hub_name_resource
  name: 'DefaultDnatRuleCollectionGroup'
  location: 'japaneast'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        action: {
          type: 'Dnat'
        }
        rules: [
          {
            ruleType: 'NatRule'
            name: 'sftp'
            translatedAddress: '10.15.0.4'
            translatedPort: '22'
            ipProtocols: [
              'TCP'
              'UDP'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '20.210.234.183'
            ]
            destinationPorts: [
              '22'
            ]
          }
        ]
        name: 'rulecollection03'
        priority: 100
      }
    ]
  }
}

resource firewallPolicies_fw_policy_hub_name_DefaultNetworkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-09-01' = {
  parent: firewallPolicies_fw_policy_hub_name_resource
  name: 'DefaultNetworkRuleCollectionGroup'
  location: 'japaneast'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: []
        name: 'rulecollection02'
        priority: 1100
      }
    ]
  }
}

resource networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_AllowCorpnet 'Microsoft.Network/networkSecurityGroups/securityRules@2023-09-01' = {
  name: '${networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name}/AllowCorpnet'
  properties: {
    description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'CorpNetPublic'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 2700
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_resource
  ]
}

resource networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_AllowSAW 'Microsoft.Network/networkSecurityGroups/securityRules@2023-09-01' = {
  name: '${networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name}/AllowSAW'
  properties: {
    description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'CorpNetSaw'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 2701
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_resource
  ]
}

resource routeTables_rt_hub_fw_name_rt_internet 'Microsoft.Network/routeTables/routes@2023-09-01' = {
  name: '${routeTables_rt_hub_fw_name}/rt-internet'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'Internet'
    hasBgpOverride: false
  }
  dependsOn: [
    routeTables_rt_hub_fw_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_resource 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: virtualNetworks_vnet_hub_name
  location: 'japaneast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_vnet_hub_name_AzureFirewallSubnet.id
        properties: {
          addressPrefix: '10.1.0.0/26'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: true
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'VmSubnet'
        id: virtualNetworks_vnet_hub_name_VmSubnet.id
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_resource.id
          }
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: '${virtualNetworks_vnet_hub_name}-vnet-function'
        id: virtualNetworks_vnet_hub_name_virtualNetworks_vnet_hub_name_vnet_function.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_function_japaneast_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: true
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
      {
        name: 'hub-vnet-2-my-linux-vm-vnet'
        id: virtualNetworks_vnet_hub_name_hub_vnet_2_my_linux_vm_vnet.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_my_linux_vm_vnet_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.15.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.15.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_hub_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: '${virtualNetworks_vnet_hub_name}/AzureFirewallSubnet'
  properties: {
    addressPrefix: '10.1.0.0/26'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_hub_vnet_2_my_linux_vm_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${virtualNetworks_vnet_hub_name}/hub-vnet-2-my-linux-vm-vnet'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_my_linux_vm_vnet_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.15.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.15.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_virtualNetworks_vnet_hub_name_vnet_function 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${virtualNetworks_vnet_hub_name}/${virtualNetworks_vnet_hub_name}-vnet-function'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_function_japaneast_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource azureFirewalls_azfw_test_name_resource 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: azureFirewalls_azfw_test_name
  location: 'japaneast'
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    ipConfigurations: [
      {
        name: 'pip-fw-test'
        id: '${azureFirewalls_azfw_test_name_resource.id}/azureFirewallIpConfigurations/pip-fw-test'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_pip_fw_test_externalid
          }
          subnet: {
            id: virtualNetworks_vnet_hub_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
    firewallPolicy: {
      id: firewallPolicies_fw_policy_hub_name_resource.id
    }
  }
}

resource virtualNetworks_vnet_hub_name_VmSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: '${virtualNetworks_vnet_hub_name}/VmSubnet'
  properties: {
    addressPrefix: '10.1.1.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_vnet_hub_VmSubnet_nsg_japaneast_name_resource.id
    }
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource

  ]
}