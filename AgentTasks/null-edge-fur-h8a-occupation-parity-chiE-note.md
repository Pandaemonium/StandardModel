# FUR-H8A occupation-parity chi_E on the Furey internal spectrum -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 33eea831-aa3d-42e7-b68b-866a3b33fa85
Full-repo wave-15 package; the genuine deliverable is the single new module
`PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` (all other tree files
were unchanged context copies). This is the returned summary, preserved
verbatim as the integration record.

---

Completed task FUR-H8A: created the experimental module `PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` (namespace `PhysicsSM.NullEdge.FureyOccParity`), realizing the internal `chi_E` grading concretely as occupation-number parity on the eight-state Furey occupation model (`Occ = Finset (Fin 3)`) already used by `NullEdgeFureyInternalSpectrum`. It imports only `Mathlib` plus the two integrated drafts (`NullEdgeFureyInternalSpectrum`, `NullEdgeFureyChiE`) and is SPL-free.

Proved, all `sorry`-free and kernel-checkable:
- Parity definition `occParitySign s = (-1)^|s|` and the diagonal grading operator `chiEParity`.
- Involution / Z/2 grading: `chiEParity_mul_self : chiEParity * chiEParity = 1` and `chiEParity_isZ2Grading`.
- Distinctness from the FUR-H2 complex-structure candidate: `chiEParity_not_complexStructure` (squares to +1, not −1) and `chiEParity_ne_complexStructure` (differs from every complex structure), via the FUR-H2 framework — supplying the genuine non-complex involution that FUR-H2 showed was missing.
- Chirality-class separation in the computed spectrum: parity splits the eight J-states into two 4-element classes with disjoint charge content `{0,-2/3,-2/3,-2/3}` vs `{-1/3,-1/3,-1/3,-1}`, exchanged by charge conjugation (occupation complement).
- Anti-commutation with `Phi_H` kept as a clean named hypothesis `H7A` (not a forced bridge): `chiEParity_tachyonic_under_H7A` derives the tachyonic super-Dirac sign `(chiEParity·Phi_H)² = -(Phi_H²)` under it, and `H7A_satisfiable` shows the hypothesis is non-vacuous via an explicit complement-permutation block.

The structural algebra theorems depend only on `propext, Classical.choice, Quot.sound`; the finite-enumeration theorems use `native_decide` (matching the existing convention in the same directory). No new axioms or `@[implemented_by]` were introduced. The mass-sector result remains conditional on `H7A` (constructing `Phi_H` is out of scope, tracked as job H7A); the occupation API exposed enough data for all other items, so no missing-lemma report was needed. A narrow target build verified the module. Details are in `ARISTOTLE_SUMMARY.md`.

Note: the checkout was missing the `SpherePacking` dependency package referenced by the lakefile; I ran `lake update SpherePacking` (the workflow the lakefile documents) to restore dependency resolution. The new module does not depend on it.

# FUR-H8A — Number-parity `chi_E` on the Furey occupation/internal-spectrum API

## Deliverable

New experimental module:
`PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean`
(namespace `PhysicsSM.NullEdge.FureyOccParity`).

It builds cleanly against the existing checkout. It imports only `Mathlib` and
the two integrated drafts it builds on:

- `PhysicsSM.Draft.NullEdgeFureyInternalSpectrum` (the `Occ := Finset (Fin 3)`
  occupation model and `Occ.charge`), and
- `PhysicsSM.Draft.NullEdgeFureyChiE` (the abstract `IsZ2Grading` /
  `IsComplexStructure` / `IsOdd` framework from FUR-H2).

It does **not** depend on the octonion/ideal stack (absent from this checkout)
or on `SpherePacking`.

## What was proved (target shape, item by item)

The `chi_E` grading is realized concretely on the **same eight occupation
states** `Occ = Finset (Fin 3)` that power the computed internal spectrum, with
parity eigenvalue `occParitySign s = (-1)^|s|` and grading operator
`chiEParity = Matrix.diagonal occParitySign : Matrix Occ Occ ℚ`.

1. **Occupation-number parity defined on the existing API.**
   `occNumber`, `occParitySign`, `chiEParity`.

2. **Involution / Z/2 grading.**
   - `occParitySign_values`, `occParitySign_mul_self` (`(-1)^N ∈ {±1}`, squares to 1);
   - `chiEParity_mul_self : chiEParity * chiEParity = 1`;
   - `chiEParity_isZ2Grading : FureyChiE.IsZ2Grading chiEParity`.

3. **Distinct from the complex-structure candidate ruled out in FUR-H2.**
   - `chiEParity_not_complexStructure : ¬ FureyChiE.IsComplexStructure chiEParity`
     (it squares to `+1`, not `-1`);
   - `chiEParity_ne_complexStructure (J) (hJ : IsComplexStructure J) : J ≠ chiEParity`
     — the parity grading differs from *every* complex structure on the
     eight-state space, via `FureyChiE.complexStructure_ne_grading`. This is
     exactly the genuine non-complex involution that FUR-H2 showed was missing.

4. **Separation of the chirality classes of the computed spectrum.**
   - `occEven`, `occOdd` with `occEven_card = occOdd_card = 4`,
     `occEven_occOdd_disjoint`, `occEven_union_occOdd = univ`;
   - `mem_occEven_iff` / `mem_occOdd_iff` tie membership to parity `±1`;
   - charge content is disjoint and matches the computed `J` spectrum:
     `occEven_chargeMultiset = {0, -2/3, -2/3, -2/3}`,
     `occOdd_chargeMultiset  = {-1/3, -1/3, -1/3, -1}`,
     `occEven_occOdd_charges_disjoint`;
   - charge conjugation = occupation complement exchanges the classes:
     `occParitySign_compl`, `charge_add_charge_compl`,
     `compl_mem_occOdd_of_mem_occEven`, `compl_mem_occEven_of_mem_occOdd`.

5. **Anti-commutation with `Phi_H` kept as a clean named hypothesis (no forced
   bridge to H7A).**
   - `oddBlock_sq_neg` (general ring fact: a `Z/2`-grading making `Ph` odd gives
     `(Xe·Ph)² = -(Ph²)`);
   - `H7A PhiH := FureyChiE.IsOdd chiEParity PhiH` — the named hypothesis;
   - `chiEParity_tachyonic_under_H7A` — the tachyonic super-Dirac sign *under*
     `H7A`, matching the `chi_E`-odd branch of
     `FureyChiE.sign_bridge_with_grading`;
   - `H7A_satisfiable` — the hypothesis is non-vacuous: the explicit
     complement-permutation block `complPerm` is nonzero and `chi_E`-odd.

## Conventions and scope

- The grading lives in the all-left charge-conjugate occupation lattice that
  `NullEdgeFureyInternalSpectrum` already computes; charges are read off
  `Occ.charge s = -(1/3)·|s|`.
- `chiEParity` is the *internal* `chi_E` grading; it is kept strictly separate
  from spacetime chirality `Gamma_s` and from the Furey/Krasnov complex
  structure. No `Phi_H`, Yukawa, or mass data is constructed.
- The physical reading of the two parity classes (the up-type/`ν` half vs. the
  down-type/charged-lepton half, i.e. SU(2) isospin partners differing by one
  occupation quantum) is recorded only in docstrings; the formal claims are the
  cardinalities, the disjoint charge multisets, and the conjugation swap.

## What remains conditional

- The mass-sector statement is **conditional** on the named hypothesis
  `H7A` (that `Phi_H` anti-commutes with `chiEParity`). Discharging it requires
  the actual internal mass map `Phi_H`, which is job H7A and is deliberately not
  attempted here. `H7A_satisfiable` shows the hypothesis is consistent.

## Axioms / soundness

No new `axiom` or `@[implemented_by]`. The structural algebra theorems
(`chiEParity_mul_self`, `chiEParity_ne_complexStructure`,
`chiEParity_tachyonic_under_H7A`, …) depend only on
`propext, Classical.choice, Quot.sound`. The finite-enumeration theorems use
`native_decide` (adding `Lean.ofReduceBool, Lean.trustCompiler`), matching the
existing convention in `NullEdgeFureyInternalSpectrum.lean` in the same
directory.

## Build note

The checkout was missing the `SpherePacking` dependency package referenced by
`lakefile.toml`; `lake update SpherePacking` (the workflow the lakefile itself
documents) was run to restore dependency resolution. The new module is SPL-free
and was verified with a narrow target build
(`lake build PhysicsSM.Draft.NullEdgeFureyOccupationParityChiE`).

## Occupation-API adequacy

The occupation API exposed enough data for every target item; no missing lemma
blocked the construction. The only piece intentionally left open is the
construction of `Phi_H` itself (out of scope, tracked as H7A).
