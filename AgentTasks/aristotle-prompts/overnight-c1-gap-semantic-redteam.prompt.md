# Aristotle strategy/red-team job: C1 operator-gap semantic audit

You are acting as an adversarial SEMANTIC reviewer of Lean statements, not as
a prover. The Lean kernel already checked these proofs; your job is to decide
whether the kernel-checked STATEMENTS mean the intended mathematics, and where
they could mislead. Do NOT attempt a Lean build (the files depend on Mathlib
and the wider project and will not build in isolation). Read the attached
verbatim source and return a written report.

## Standalone context (assume you are blind to the repository and chat)

This is the Gate C1 lane of a lattice chiral-fermion program. The goal of C1
is a doubler-free "overlap" construction on an exotic lattice: four future
null directions arranged tetrahedrally (rank-4 Brillouin torus), signature
mostly-minus. The strategy is Wilson + overlap: build a Hermitian "sign
kernel" `H = gamma5 (D_null + W_Wilson - rho)`, prove it is gapped and
self-adjoint, then release chirality via `sign(H)` (Ginsparg-Wilson). The
"first Wilson band" is `0 < rho < 2 r`.

A milestone was just assembled tonight: the FINITE/FREE OPERATOR GAP for the
real-space Hermitian seed operator `Hfree` on the equal-side tetrahedral
torus (`SiteN N = MomN N = Fin 4 -> ZMod N`). It is claimed to be:
- regulator-level (a property of the fixed finite regulator operator, NOT a
  Lorentz-invariant or continuum claim);
- an inverse-propagator / `H^2`-level gap (the overlap branch-selection
  condition: doublers lifted by inverse-propagator gaps, not propagator
  zeros), NOT a bare-propagator no-doubling theorem;
- claim label "structural theorem" (the gap is forced once the finite Wilson
  band + `a > 0` + unitary `gamma5` are assumed).

## Intended reading of the two new declarations (file: TetraFreeOperatorGapEqualN.lean)

- `hfreeBlockDiagonalization`: the normalized finite Fourier transform
  `fourierUnitary` is a unitary that (i) preserves the finite field L2 norm
  square (`parseval`) and (ii) intertwines the real-space operator `Hfree`
  with per-momentum left-multiplication by the Hermitian Wilson symbol `H`
  (`diagonalizes`).
- `tetraFreeOperator_gap_equalN`: there exists `gamma > 0` such that for every
  finite field `Psi`, `gamma * fieldL2NormSq Psi <= fieldL2NormSq (Hfree Psi)`.
  Intended meaning: the finite/free operator `Hfree` has a strictly positive
  UNIFORM spectral gap (bounded below away from 0) over the whole finite
  momentum torus.

## Deliverable

Return a report named `GateC1_OperatorGap_SemanticAudit.md` answering:

1. STATEMENT vs INTENT. Does `tetraFreeOperator_gap_equalN` actually express
   "uniform positive spectral gap of `Hfree`"? In particular: is
   `fieldL2NormSq` the correct L2 norm square (check its definition in
   TetraFiniteTorusEqual via the attached files), and does
   `gamma * ||Psi||^2 <= ||Hfree Psi||^2` capture a spectral gap for a
   Hermitian operator, or could it be vacuous/weaker than intended (e.g. if
   `gamma` could be forced tiny, or if `Hfree` were not the operator claimed)?
2. HIDDEN HYPOTHESES / CONVENTION DRIFT. Audit every hypothesis
   (`hgamma5 : star gamma5 * gamma5 = 1`, `0 < a`, `FirstWilsonBand r rho`).
   Are any silently doing more than stated? Is `Hfree` really the
   `gamma5`-Hermitian seed `gamma5 * Kfree` (check `Hfree` and `Kfree` in
   TetraFreeOperator.lean), and is the symbol `H` in TetraScalarWilsonSymbol
   the matching object? Flag any mismatch between the real-space operator and
   the momentum symbol.
3. WHAT WOULD DEMOTE THE CLAIM. List the concrete ways a reader could
   over-read this: as a no-doubling theorem, as self-adjointness (it is NOT -
   it is only a lower bound on `||Hfree Psi||^2`), as a continuum/Lorentz
   statement, as a full overlap/GW result. For each, state the one sentence
   that keeps the claim honest.
4. IS THE GAP THE RIGHT OBJECT? The overlap construction needs the gap on
   `H` (inverse propagator). Confirm that a lower bound on `||Hfree Psi||^2`
   is the correct precondition for defining `sign(Hfree)` / the GW release,
   and identify what ELSE is still needed (self-adjointness? the exact
   `H^2 = gap` vs `>= gap`?).
5. NEXT RUNG. The proposed next target is self-adjointness of `Hfree` as a
   finite Hermitian operator in this L2 structure. Give the sharpest
   Lean-ready statement of that, and say whether the attached files already
   contain the pieces (e.g. `K_star`, `K_star_mul`, Hermiticity of `gamma5`).

## Attached verbatim source

- TetraFreeOperatorGapEqualN.lean (the milestone under review)
- TetraFreeOperatorGap.lean (the abstract obligations it discharges)
- FiniteBlockDiagonalGap.lean (the generic block-diagonalization gap theorem)
- TetraScalarWilsonSymbol.lean (the symbol `H`, `K`, and the gap lemmas)
- TetraCharactersEqual.lean (the normalized Fourier transform and Parseval)
- TetraFreeOperator.lean (the real-space `Kfree`, `Hfree`, and their symbols)

## Rules

- ASCII only in the report; spaced forms `s o r r y` / `a d m i t` if you must
  mention Lean placeholder tokens in prose.
- The proofs are kernel-checked; do NOT re-verify them. Audit the STATEMENTS.
- Be adversarial: the valuable output is a real semantic mismatch, a
  convention drift, or an over-claim risk, not reassurance.
