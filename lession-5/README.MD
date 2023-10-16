### NFT

```text
sui client publish --gas-budget 3000000 --skip-dependency-verification 
sui client call --package <package> --module NFT --function mint --args b"Hulk NFT" b"This is an example NFT" b"www.abc.com" --gas-budget 30000000
```