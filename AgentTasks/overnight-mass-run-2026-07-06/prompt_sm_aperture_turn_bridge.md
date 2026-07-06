Prove the single highest-leverage theorem for the null-edge mass thesis: the
3+1D APERTURE = TURN bridge, which puts TWO of the three obstruction modes on
ONE object at physical dimension. This upgrades the "all mass" story from a
conjunction across disjoint universes toward a genuine shared-object mechanism
for the turn/aperture pair.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateI1/ApertureEqualsTurn.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP and return
source.

## Background (all already proved - read them first)

- `GateI1/MassCoinBridge.lean` : `onshell_wedge_normSq_eq_coin_sq` proves
  EXACTLY this identity in 1+1D (`wedge^2 = coin^2 = mu^2`) - the new theorem is
  its 3+1D generalization. Also `twoNull_resolution` (the two-null decomposition
  of a momentum).
- `GateI1/CompositeApertureMass.lean` : `compositeMassSq_eq_sum_pairwise`
  (`minkowskiSq (sum p_i) = sum_{i<j} 2 minkDot p_i p_j`), the 2-body germ
  `det (minkHerm (p+q)) = 2 minkDot p q`, `minkDot`, `IsFutureNull`.
- `GateI1/Core.lean` : `det_minkHerm_eq_minkowskiSq` (`det P = m^2`), the
  Minkowski/Hermitian dictionary, `minkowskiSq`.
- `GateYM/ChiralMassStructure.lean` : `chiralEven_massVertex`
  (`chiralEven (massVertex m mu) = (m+1) . 1`), `chiralOdd_massVertex`
  (`chiralOdd (massVertex m mu) = - gamma mu`) - the (T) turn/transport channel
  decomposition.

## Target (the aperture = turn identity in 3+1D)

For an on-shell 3+1D timelike momentum `p` with `minkowskiSq p = m^2` (`m >= 0`)
and its canonical two-null resolution `p = kPlus + kMinus` (future-null
`kPlus, kMinus`; use / adapt the existing `twoNull_resolution` construction),
prove that the APERTURE mass of the two-null composite equals `m^2` AND ties to
the TURN amplitude:

```
minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus = m^2
```

so the aperture of the two-null pair (mass = failure to be one null edge) IS the
on-shell mass, i.e. the same scalar `m^2` that is the physical
(chirality-mixing) TURN amplitude of the Dirac mass vertex at mass `m`. State
the headline as a theorem `apertureEqualsTurn_onShell` whose conclusion binds:
- the aperture mass `2 * minkDot kPlus kMinus = m^2` (from
  `compositeMassSq_eq_sum_pairwise` on the two-null bundle), AND
- the turn identification: `m^2` is the (mass-carrying) content of the
  chirality-even channel `chiralEven (massVertex m mu)` (the coefficient `m`),
  cleanly separated from the chirality-odd transport channel.

Aim for the cleanest true statement that makes "aperture mass = turn mass on the
same on-shell momentum" a single kernel-checked identity. If the full Dirac-coin
tie is heavy, the CORE deliverable is the 3+1D
`minkowskiSq (kPlus + kMinus) = 2 minkDot kPlus kMinus = m^2` two-null aperture
identity (the 3+1D generalization of `onshell_wedge_normSq_eq_coin_sq`); the
turn tie can be a corollary or a documented handoff.

## Constraints

- Reuse the existing API (`minkDot`, `minkowskiSq`, `IsFutureNull`,
  `compositeMassSq_eq_sum_pairwise`, `twoNull_resolution`,
  `onshell_wedge_normSq_eq_coin_sq`, the chiral vertex lemmas) - do not redefine.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. A
  documented handoff `s o r r y` on the turn-tie corollary is acceptable if the
  core two-null 3+1D aperture identity is fully proved.
- Claim label: kinematic identity (aperture=turn on one on-shell momentum);
  draft-trust. This binds the T and A obstruction modes on a shared object - state
  that honestly (it does NOT bind the closure mode C, which lives in a different
  model with no Momentum4).
- Standard axioms for what you prove. If `lake build` stalls, SKIP; return source.
