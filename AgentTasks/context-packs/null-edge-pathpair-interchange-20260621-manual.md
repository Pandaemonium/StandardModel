# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
causal diamond path-pair vertical horizontal interchange law and Abelian grid
defect product
```

## Target idea

The updated program asks whether the trusted causal-diamond path-pair API is
genuinely double-categorical. The first finite test is the interchange law:

```text
(P horizontal Q) vertical (R horizontal S)
  =
(P vertical R) horizontal (Q vertical S).
```

Because `PathPair` remembers only outside branch holonomies, this should be a
small structural theorem. The physics value is that it certifies the path-pair
composition API before building crossed-module/fake-flatness wrappers.

## Included copied dependency

The package includes:

```text
PhysicsSM/Gauge/CausalDiamondHolonomy.lean
```

Important declarations:

```lean
structure PathPair (G : Type*) where
  left : G
  right : G

def pathPairDefect [Group G] (P : PathPair G) : G :=
  P.left⁻¹ * P.right

def verticalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left * Q.left
  right := P.right * Q.right

def horizontalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left
  right := Q.right
```

## Theorem targets

```lean
pathPair_vertical_horizontal_interchange
pathPairDefect_interchange
pathPairDefect_grid_comm
```

## Claim boundary

This job proves only the finite structural interchange sanity check and an
Abelian defect product corollary. It does not yet define a crossed module,
fake-flatness, or surface transport.
