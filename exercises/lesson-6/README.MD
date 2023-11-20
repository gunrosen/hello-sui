Build

```text
sui move build
```

Publish
```text
sui client publish --gas-budget 3000000000
```

Env
```text
export CONTRACT=0x13c95b2490d586945be2024b8a55e7c364ff4f36dcef00bbfaf0106a0c08c6bc
export GAME_INFO=0xc079dd7c946c113d0563db536d218a9e72b3b4e6e38d3df42235a4b5ab62606b
```

Get game 
```text
sui client call --package $CONTRACT --module hero_game --function get_game_id --args $GAME_INFO --gas-budget 3000000000
#+end_src
```