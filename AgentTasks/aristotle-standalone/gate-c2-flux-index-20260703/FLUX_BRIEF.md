# Gate C2: a genuine nonzero-FLUX finite overlap index (ambitious construction)

You (Aristotle) are a co-equal partner. This is an ambitious CONSTRUCTION +
PROOF request: exhibit the smallest finite lattice gauge model with a genuine
nonzero magnetic flux (nontrivial holonomy around a loop) whose overlap chiral
index is a nonzero integer equal to the flux/topological charge, and prove it,
kernel-checked. Assume you are blind to the wider repo; all needed context is in
this brief and the attached Lean files (they compile under Lean 4 `v4.28.0` +
Mathlib; draft-trust, axiom footprint `[propext, Classical.choice, Quot.sound]`).

## Context: what already exists (attached)

- `OverlapIndexToy`: the overlap Dirac matrix `Dov gamma5 eps = 1 + gamma5 . eps`
  and the lattice chiral index `overlapIndex gamma5 eps = (1/2)(Tr gamma5 -
  Tr eps)`, with `overlapIndex_eq`.
- `OverlapSignCertificate`: a **sign certificate** for a matrix `H` is
  `eps^2 = 1`, `eps * H = H * eps`, `(eps * H).PosSemidef`; `certifiedSign_unique`
  proves it is unique. `OverlapSignExistence.certifiedSign_exists` proves it EXISTS
  (`epsCFC H = CFC.sqrt(H^2) * H^-1`) for any gapped Hermitian `H`, and
  `certifiedSign_eq_epsCFC` gives `eps = |H| H^-1`. So for ANY explicit gapped
  Hermitian `H_U`, `sign(H_U)` is a well-defined certified involution.
- `OverlapIndexWindingWitness` / `OverlapWindingSignJoin`: the pattern of
  EXHIBITING an explicit `eps` and verifying the certificate against a concrete
  `H_U` (there, a diagonal mass defect). Its index is nonzero but the topology is a
  constructed signature defect, NOT a gauge flux - that is the gap you close here.

## The controlling fact (from the prior C2 red-team)

With balanced chirality `Tr gamma5 = 0`, `overlapIndex gamma5 eps = -(1/2) sig(eps)`
= minus half the signature (n_+ - n_-) of the sign involution. So a NONZERO index
requires an `eps = sign(H_U)` whose eigenvalue signature is imbalanced, and the
red-team's guardrail (gauge/basis conjugation cannot change the index - only a
genuine signature change can) means the imbalance must be forced by a real flux,
not a gauge transform of a trivial model.

## The task

Exhibit and prove the SMALLEST genuinely-fluxed finite model:

1. **A finite lattice with a real loop and nonzero holonomy.** A single link (2
   sites) or a tree has NO gauge-invariant flux (it gauges to zero) - you need a
   CYCLE. Recommended for tractability: a **pi-flux** configuration, where each
   link phase is `e^{i pi} = -1` (REAL entries, NO surds - this sidesteps the
   heavy surd-entry problem of generic flux). A minimal candidate: a 4-site square
   plaquette (or 2x2 periodic torus) whose link variables multiply to `-1` around
   the plaquette (odd number of `-1` links) - a genuine `Z_2` / pi-flux with
   nontrivial holonomy that cannot be gauged away. Tensor with a 2-component spin
   if a chirality `gamma5` is needed.

2. **The gapped Hermitian operator `H_U`.** Build the explicit Wilson/hopping
   Hermitian `H_U` on that lattice with those (real, +/-1) link variables plus a
   Wilson mass, chosen invertible (gapped). Keep entries in `Z` or small rationals.

3. **Its certified sign and index.** Either exhibit `eps_U` explicitly and prove
   `SignCertificate H_U eps_U` (then `eps_U = sign(H_U)` by uniqueness), or use the
   existence route; then compute `overlapIndex gamma5 eps_U` and prove it equals the
   flux/topological charge (expected `+/- 1` for unit pi-flux, or `0` - determine
   which and PROVE it).

4. **Honesty.** If the minimal pi-flux model has index `0` (a real possibility for
   a too-small lattice or a boundary artifact), that is a valuable NEGATIVE result -
   prove `overlapIndex = 0` and explain why (the flux does not reach the index at
   this size), and state the smallest size that WOULD give a nonzero index. Do not
   manufacture a nonzero index that is really a constructed signature defect
   dressed up as flux; the whole point is that the signature imbalance comes from a
   gauge-invariant holonomy.

## Deliverable

A self-contained Lean file (Mathlib + copied definitions as needed) with: the
explicit lattice + link variables, `H_U`, the sign `eps_U`, a proof of the
certificate (or existence), and the kernel-checked value of `overlapIndex gamma5
eps_U` with its relation to the flux stated and proved. No `sorry`, no
`native_decide`; axiom footprint `[propext, Classical.choice, Quot.sound]`. Plus a
short prose note: is this a genuine gauge index or does it collapse to 0, and why,
and what the next size up would need.
