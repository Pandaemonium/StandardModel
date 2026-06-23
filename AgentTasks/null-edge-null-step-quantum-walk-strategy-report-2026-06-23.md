# Null-step quantum-walk strategy report

Date: 2026-06-23

Aristotle job: `00dd71c5-70bd-477f-9b40-6770b2024bd9`

Integrated module:
`PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`

## Scientific significance

This is a high-value P2/P4 dynamics bridge. It gives a finite single-particle
null-step quantum-walk model in which a chirality-diagonal transport phase and a
chirality-flip rotation combine into the standard lattice Dirac dispersion and
an `m/E` chirality-coherence limit.

The compact spine is:

```text
U_a(k) = Rz(k a) Rx(mu a)
trace(U_a) = 2 cos(k a) cos(mu a)
det(U_a) = 1
cos(omega a) = cos(k a) cos(mu a)
coherenceSq -> mu^2 / (k^2 + mu^2)
```

This connects the ontology-facing slogan "elementary visible motion is
lightlike/null-step" to an actual first-order transfer operator. It is stronger
than a kinematic null decomposition because the same finite model contains
transport, chirality mixing, dispersion, and the continuum `m/E` ratio.

## Proved declarations

The integrated draft module proves:

```lean
trace_Ua
det_Ua
IsQuasienergy
isQuasienergy_iff_trace
sinOmegaSq
sinOmegaSq_eq
coherenceSq
tendsto_sin_mul_div
coherenceSq_continuum
coherenceSq_continuum_mE
```

The module deliberately defines `Rz` and `Rx` by their Euler closed forms rather
than by `Matrix.exp`. This keeps the theorem package small and proof-only. The
optional next provenance job is to prove that those closed forms equal the
matrix exponentials of the Pauli generators.

## Claim boundary

- `k` is a lattice quasimomentum; finite-`a` statements should not be advertised
  as continuum momentum facts away from the small-spacing limit.
- The quasienergy is branch/sign ambiguous. The formal statements use trace,
  cosine, and squared sine data rather than a global `omega(k)` branch.
- The module proves squared coherence limits. Unsquared absolute-value
  statements need nonzero-denominator hypotheses.
- The physical identification `m = mu` is a continuum-limit calibration, not a
  finite-spacing identity.
- Step ordering can affect phases. The trace, determinant, and squared
  coherence facts are the safe invariant layer.

## Next theorem targets

1. `Rz_eq_exp` and `Rx_eq_exp`: prove the closed-form rotations agree with
   `Matrix.exp` of the Pauli generators.
2. `coherence_matches_chiral_projector`: connect the walk coherence to the
   existing two-level chirality-coherence theorem.
3. `nullStepWalk_continuum_dispersion`: package the trace/quasienergy result as
   the P2/P4 paper's dynamics theorem, with all branch caveats explicit.

## Verification

```powershell
lake env lean PhysicsSM\Draft\NullEdgeNullStepQuantumWalkCore.lean
lake build PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore
```

Both checks passed after integration.
