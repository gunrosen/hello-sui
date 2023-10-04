## CRUD


### Version 1
```text
Created Objects:
  - ID: 0x88abd929335cbf4ecd3d969a9a850495688e55d69e27b5045cc3f1afbe97ba51 , Owner: Immutable
  - ID: 0xd0efcddfaa91fe891235b2d2320b49ab917cf9f3fa32ad13567da4e35ae50f7b , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
  - ID: 0xf12e57486046613c7fae4311321980e15f381a4d6a073bedb9cc4137518bd417 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
Mutated Objects:
  - ID: 0xf63793cb85043768f11a9876152565148e457bdf5060db7e4a23fcaf89fd24cd , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )
```


### Version 2: add create_bank create_account

```text
Created Objects:
  - ID: 0x2cf7aff3ffc839c3788b8fc796d50c9ebaab93923681d0ddeb3fe8ffbe017bf1 , Owner: Immutable
  - ID: 0xc7efa69d05b54e25a1251e44016ad12981e1ea5fcfa1ff87d4f7c2f52fa401d9 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )    ----> Bank
  - ID: 0xdd5f75e7d28eb1f9b638e51b2f798e98287ad46a3ebe5e32ac3295c4cc8df773 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )   ---> Upgrade Cap
```

```text
sui client call --package 0x2cf7aff3ffc839c3788b8fc796d50c9ebaab93923681d0ddeb3fe8ffbe017bf1 --module HULK --function create_account --args b"Hulk_user_account"   --gas-budget 3000000000
```

### Version 2: update create_account, &Bank 

```text 
Created Objects:
  - ID: 0x391d7fd9ccbe0ca0153e04bad183edae6222ad32480613b730f4a2d052165bf8 , Owner: Account Address ( 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de )  ----> BANK
  - ID: 0xbd47883d3f587bac6aa86bfe226ce9e8b2ad6d337e0bda5f384856d6dee7fef4 , Owner: Immutable
```

```text
sui client active-address
0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de

sui client switch --address another_address
```


```text
sui client call --package 0xbd47883d3f587bac6aa86bfe226ce9e8b2ad6d337e0bda5f384856d6dee7fef4 --module HULK --function create_account --args 0x391d7fd9ccbe0ca0153e04bad183edae6222ad32480613b730f4a2d052165bf8 b"Hulk_user_account"   --gas-budget 3000000000
```

```text
 Transaction was not signed by the correct sender: Object 0x391d7fd9ccbe0ca0153e04bad183edae6222ad32480613b730f4a2d052165bf8 is owned by account address 0x506a8ade0c519c61182f0e3ded568122de5d256018d03f4378c4e0784192f8de, but given owner/signer address is 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70.", data: None }
```

### Version 3: create shared object 