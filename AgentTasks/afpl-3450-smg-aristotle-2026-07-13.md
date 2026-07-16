# Aristotle task: finite 3-4-5-0 symmetric mass generation

## Objective

Build the smallest faithful finite many-fermion theorem that can replace a
quadratic mirror mass in a chiral `3-4-5-0` charge model.  The target is an
explicit gauge-invariant quartic (or minimal higher-body) Hamiltonian on a
finite fermionic Fock space, with an exact nonzero rational spectral gap on the
mirror sector and a proved protected target sector.

## Required semantic gates

1. Use the charge/chirality convention from the `3-4-5-0` symmetric-mass-
   generation literature, correcting the seed if its signs or left/right
   assignment are not faithful.  State the convention explicitly.
2. Define a genuine fermionic Fock basis and CAR signs.  A diagonal projector
   or chemical potential is a rejected vacuous solution.
3. The interaction must commute with the explicit gauge-charge action and be
   genuinely many-body: prove it is not representable by the one-particle
   bilinear mass predicate used in the supplied target/mirror audit.
4. Prove a concrete nonzero witness and compute the exact finite spectrum or a
   sum-of-squares lower bound giving a sharp positive gap on the declared
   mirror subspace.
5. Prove the intended target subspace is annihilated and has no matrix elements
   coupling it to the gapped mirror sector.
6. Audit vacuity, spontaneous-symmetry-breaking assumptions, anomaly input,
   locality, volume dependence, and the thermodynamic limit.  Do not call a
   finite gap a physical mirror-decoupling theorem.
7. No new assumptions, no compiled evaluation, and no proof placeholders in
   any claimed result.  Add build-enforced axiom guards.

If the requested interaction cannot exist in the smallest model, return a
kernel-checked no-go and the smallest enlarged mode/cell content that escapes
it.  Correctness and a sharp missing axiom are more valuable than a cosmetic
gap.

## Reference inputs

- `PhysicsSM/Draft/NullEdge/TargetMirrorBilinearNoGo.lean` in the live repo:
  bilinear no-go and chemical-potential vacuity control.
- Zeng et al., symmetric mass generation in the chiral `3-4-5-0` model,
  arXiv:2202.12355.  Use the mathematics as clean-room guidance; do not copy
  external implementation text.

Run the narrow file first:

```text
lake env lean SMG3450/Core.lean
```
