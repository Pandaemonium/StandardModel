# Strategy + proof: extremal mass configurations are spherical-code theory (Conjecture I / paper P-K)

## Context (blind to the wider repo)

A finite null-edge program has mass = null-direction disagreement `det P = Σ w_i w_j
|ψ_i ∧ ψ_j|²`. For UNIT spinors, `|ψ_i ∧ ψ_j|² = sin²(θ_ij/2)` = quarter squared
chordal distance of the celestial directions `n̂_i` on S² (the Bloch sphere). So bundle
mass is a **pairwise energy functional on S²**. This is pure §3-layer kinematics with
zero physics risk — and it imports spherical-code / sphere-packing theory wholesale.

## Targets

1. **`bundle_mass_eq_chordal_energy`**: `det P` (or the pairwise-disagreement sum)
   equals a sum of `sin²(θ_ij/2)` = chordal-distance² energy over the celestial
   directions. Prove the `|ψ∧φ|² = sin²(θ/2)` identity for unit spinors and lift it
   to the bundle.
2. **First-moment triviality + the partition spectrum.** `det P` alone depends only
   on the first moment (`balanced ⇔ Σ w_i n̂_i = 0 ⇔ rest`), so it cannot distinguish
   an antipodal pair from a tetrahedron. But the **sub-bundle mass spectrum**
   `{m²(S) : S ⊆ bundle}` (organized by mass monogamy) sees higher moments. Prove
   that `k`-sub-bundle masses determine the `k`-th moments of the direction
   distribution.
3. **Design hierarchy (the prize, [C→M-target]).** Conjecture and prove as far as
   possible: *sub-bundle mass spectra are maximally uniform exactly on spherical
   t-designs*. Since the pair energy `sin²(θ/2)` is completely monotone in chordal
   distance², **Cohn–Kumar universal optimality** applies verbatim, giving LP bounds
   on mass budgets under angular constraints. Prove a clean instance (e.g. the
   tetrahedron/`SIC` as the mass-extremal 4-direction bundle), and state the general
   design hierarchy with its kill.

**Kill (Conjecture I):** two non-isomorphic 2-designs with distinguishable pair-mass
multisets (or vice versa).

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md`: the
chordal-energy identity, the moment/partition result, the design-extremality instance
proved, and the general hierarchy stated with its kill. This is the direction where
the program's sphere-packing toolkit transfers directly — prioritize clean §3-layer M.
