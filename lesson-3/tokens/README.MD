## Tokens

### Ex1: Token init
```text
Created Objects:
  - ID: 0x1a1c8ad08c9f3905480a7372dc8165081a76e03232a1d09670d91a0f11599b8c , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )
  - ID: 0x6676474dd6d1cf9176134e7289cfa52a4c47c9b9ab99ae6e0200ec8afe659287 , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )
  - ID: 0x68d7a9992bb764d91db6a8680521787bbf1f8058b6aa232670043a9d8ece2d27 , Owner: Immutable
  - ID: 0xa751e3e8c8ecba78b06335b288d88a488d3cafb5297632160cfdcb6bbb32fc5a , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )
```

```text
sui client object 0x68d7a9992bb764d91db6a8680521787bbf1f8058b6aa232670043a9d8ece2d27 --json
```

Metadata and treasury cap are two objects.

### Ex2: add mint function
```text
Created Objects:
  - ID: 0x63f1bf335341e67487fa49c93d7cfa256caf34bc011d1022e2e0de33d33c7101 , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )
  - ID: 0x7d0ec40a0eb2f4672ec1b68c165d9ca149dddc333159b90fdc53767905a82680 , Owner: Immutable
  - ID: 0xe20ee06ce22f4ad9e7716ef6db1e7e05282f819b70ec4a427b0f98a034734f7e , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )  ->  :TreasuryCap
  - ID: 0xec4d0700d878d36bee20956db0daace17f3df71ce19fc6c5bfc974429880b73d , Owner: Account Address ( 0x48e52f6fcc0b4a308e3c078e770f0426c0435984be5d2ec5c09a93607e52fa70 )  -> Metadata
```

call mint token

```text
sui client call --package 0x7d0ec40a0eb2f4672ec1b68c165d9ca149dddc333159b90fdc53767905a82680 --module TOKEN --function mint --args 0xe20ee06ce22f4ad9e7716ef6db1e7e05282f819b70ec4a427b0f98a034734f7e 12800000000 0xeb02877a1ab63db222c7e331fc3e61a42a7f9cb7f9dc8e4aa38522807124eb41 --gas-budget 3000000000
```

```text
move disassemble --name TOKEN
```

Web Assembly
0x0001: standard
0x0002: SUI
