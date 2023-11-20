## Basic contract

```text
sui move build
```

```text
sui client publish --gas-budget 3000000000 --skip-dependency-verification
```

### Version 1

```text
Created Objects:
  - ID: 0x62476829781066ed7e30e0dc18459879b350202ac8098e824a1b87d8980b2304 , Owner: Immutable
  - ID: 0x7fc63ce49b9bb3a3d88d59c23b3f0c1fd5e248499af6a101eb00edf8e2d8bcf6 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
  - ID: 0xa68192cf3072b4edc64731b88016f62096dbedd4fbd63a0d1d43b50827214acc , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
Mutated Objects:
  - ID: 0x9fe4246cd5e94c842e7b970df16b85abe4d743d379b694ef2358c7a10c251709 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
```

|  Address | Description  |
|---|---|
| 0x62476829781066ed7e30e0dc18459879b350202ac8098e824a1b87d8980b2304 | address of sui contract  |
| 0x7fc63ce49b9bb3a3d88d59c23b3f0c1fd5e248499af6a101eb00edf8e2d8bcf6  | UpgradeCap - use to upgrade  |
| 0xa68192cf3072b4edc64731b88016f62096dbedd4fbd63a0d1d43b50827214acc |  object id of created wallet |
|  0x9fe4246cd5e94c842e7b970df16b85abe4d743d379b694ef2358c7a10c251709 |  sui coin charged as network fee |
|   |   |

 ### Version 2: add function create_wallet

 ```text
 Created Objects:
  - ID: 0x313430e040df061acc555268f240b8a2506d16a4a1563242b83428ad39daa276 , Owner: Immutable
  - ID: 0x5b41d87c30533cd440e506ab179dea94ba0ddfa112b367cb1252f69d85b0aabf , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
  - ID: 0xad001e0f355fc1dd30dfd5f04e1358671d547ceaa877a8648e7bbf7a54ea8366 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
Mutated Objects:
  - ID: 0x9fe4246cd5e94c842e7b970df16b85abe4d743d379b694ef2358c7a10c251709 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
 ```

 ```text
 sui client call --package 0x313430e040df061acc555268f240b8a2506d16a4a1563242b83428ad39daa276 --module DEMO --function create_wallet --gas-budget 3000000000
 ```

 ### Version 3: add function change_balance

 ```text
Created Objects:
  - ID: 0x3e45f8bb574c6084e650def19ef2ee7a2c7e987436a8816afcc8d58af51167b6 , Owner: Immutable
  - ID: 0xac72a899a1649fa4178080081f52f89b20ec4f70bd7b5c3abb7a9bf12b5c5dcb , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
  - ID: 0xf0335405878ec1b5441f74212c2c4d12eeddbe735cb46e462bef57ff43320be0 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
 ```

```text
 sui client call --package 0x3e45f8bb574c6084e650def19ef2ee7a2c7e987436a8816afcc8d58af51167b6 --module DEMO --function change_balance --args 0xf0335405878ec1b5441f74212c2c4d12eeddbe735cb46e462bef57ff43320be0  --gas-budget 3000000000
```
