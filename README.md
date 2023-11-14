# Sandbox

## Files

1. Merkle tree

```
├── script
├── src
└── test
    ├── MerkleTree.t.sol // Gas comparison for merkle tree validation
    └── utils
        └── Utilities.sol
```

## NFT Tests

```
[PASS] testHugeMint_ERC721() (gas: 25616026588)
[PASS] testHugeMint_ERC721A() (gas: 1933072200)
```

```
| test/NFT.s.sol:StandardERC721 contract |                 |       |        |       |         |
|----------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                        | Deployment Size |       |        |       |         |
| 729658                                 | 3925            |       |        |       |         |
| Function Name                          | min             | avg   | median | max   | # calls |
| mint                                   | 25082           | 25082 | 25082  | 46982 | 1000000 |

```

```
| test/NFT.s.sol:BatchERC721 contract |                 |            |            |            |         |
|-------------------------------------|-----------------|------------|------------|------------|---------|
| Deployment Cost                     | Deployment Size |            |            |            |         |
| 793128                              | 4237            |            |            |            |         |
| Function Name                       | min             | avg        | median     | max        | # calls |
| mint                                | 1933067042      | 1933067042 | 1933067042 | 1933067042 | 1       |
```

Using this:https://www.cryptoneur.xyz/en/gas-fees-calculator

- Standard Gas = 136 gwei
- Matic = 1.15 rn.
- ERC721: `25082000000 gwei` == **3922.8248 USD**
- ERC721A: `1933067042 gwei` == **302.3317 USD**
