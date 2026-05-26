# Aristotle M6: COG / cancellation dynamics moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/COGDynamics.lean
```

## Big Goal

Build a finite transition-system model from sedenion zero-product cancellation
channels and prove its conserved quantities.

The motivating physics-facing slogan is:

```text
zero divisors are exact cancellation channels, so they define local null
transitions in a discrete causal or computational dynamics.
```

The theorem should remain finite and algebraic.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.GL32Action
```

Known existing facts include:

- `ReedMuller.cZD`
- `ReedMuller.sameStrutSpan_eq_cZD`
- `CocycleQuadraticPhase.zeroProdSupportList`
- `CocycleQuadraticPhase.zeroProd_iff_linearPhase`
- `GL32Action.gl32_preserves_zpSupports`

## Desired Theorems

Define states as binary vectors on `Fin 16` or a finite quotient of them.
Define local moves by toggling a zero-product plaquette support.

Try to prove:

- The reachable set from zero under the local moves is exactly `cZD`.
- Equivalently, the transition closure is the span of the 42 zero-product
  supports.
- Any linear functional orthogonal to `cZD` is conserved by all local moves.
- The `GL(3,2)` symmetry acts by automorphisms of the transition system.
- Optional: classify connected components as cosets of `cZD`.

Suggested public theorem names:

```lean
theorem reachable_from_zero_eq_cZD : ...
theorem conserved_iff_orthogonal_to_cZD : ...
theorem gl32_acts_by_transition_automorphisms : ...
theorem connected_components_are_cZD_cosets : ...
```

## Constraints

- Keep this a finite mathematical model; do not assert a physical causal theory.
- Prefer one clean transition relation and prove it well.
- No axioms, opaque constants, unsafe code, or admits.
