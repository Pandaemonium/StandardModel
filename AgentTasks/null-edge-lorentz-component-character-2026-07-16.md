# Null-edge Lorentz component characters

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: Aristotle proof integrated, kernel-checked, and built

## Result

`PhysicsSM/Draft/NullEdge/LorentzComponentCharacter.lean` proves that both
discrete signs of an eta-Lorentz transition are multiplicative:

```text
timeSign(M*N) = timeSign(M) + timeSign(N)       in ZMod 2
detSign(M*N)  = detSign(M)  + detSign(N)        in ZMod 2.
```

The time theorem covers all four sign combinations.  Its key estimate is

```text
((M*N)[0,0] - M[0,0]*N[0,0])^2
  <= (M[0,0]^2 - 1) * (N[0,0]^2 - 1),
```

obtained from the row/column Lorentz norm identities and a concrete
three-dimensional Cauchy--Schwarz argument.  This closes the algebraic gap
identified by the component-obstruction program: time orientation really is a
group character, not merely a locally assigned sign.

## Provenance

Aristotle project `f3a64d3b-b82b-42c9-8bce-715a9a5f4447`, task
`b2d30a9c-00da-463d-abb7-2a45cdf6b020`, returned all five proofs without
definition or theorem-statement changes.  The focused source passed locally
after integration.  The project module reuses the existing
`MinkowskiConvention.eta` and `IsEtaLorentz` predicate.

Focused source SHA-256:
`a6bd10206d4649dae11b95493228fcf0a9617b927dfe97f50fd71a45b920b126`.

## Consequence

Together with `AtlasComponentCharacter.lean`, these theorems establish the
finite algebra for two independent first obstruction classes:

- spatial orientability from determinant sign;
- time orientability from time-component sign.

The remaining packaging step is to bundle eta-Lorentz matrices as a group and
expose these two functions as `MonoidHom`s into
`Multiplicative (ZMod 2)`.  Vanishing of the resulting classes on a
graph-derived atlas remains open.

## Verification record

- Module SHA-256:
  `d5e81b62dfa5ec09f410a203f63aff163e4c33504b3ee2d853a3c966d27977b6`.
- The focused Aristotle source passed `lake env lean` locally with no proof
  holes.
- `lake build PhysicsSM.Draft.NullEdge.LorentzComponentCharacter` passed
  (`8043` jobs), including `AtlasComponentCharacter.lean`.
- Build-enforced axiom guards report only `propext`, `Classical.choice`, and
  `Quot.sound` for both component multiplication laws.
