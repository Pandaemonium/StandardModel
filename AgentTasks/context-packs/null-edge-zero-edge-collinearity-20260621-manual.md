# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
zero-edge collinearity completion finite Pluecker mass vanishes iff all
spinors are zero or share a common nonzero projective direction
```

The semantic Neo4j context pack generator was unavailable when this job was
prepared because the `ne_chunk_embedding` vector index was missing. This manual
pack contains the high-signal repo context needed for the focused proof job.

## Target idea

`PhysicsSM.Spinor.PluckerMass` already proves a finite massless-collinearity
criterion assuming a chosen nonzero base spinor. The missing wrapper is the
total version:

- if every spinor is zero, pairwise wedges and the bundle determinant vanish;
- otherwise choose a nonzero spinor as base and apply the existing common
  direction theorem.

This closes the zero-edge case without forcing downstream users to supply a
base index.

## Trusted API to use

The focused package includes a copied trusted file:

```lean
import PhysicsSM.Spinor.PluckerMass
```

Important existing declarations:

```lean
abbrev CSpinor := Fin 2 -> ℂ

def spinorWedge (psi phi : CSpinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ i : Fin n, rankOneHermitian (psi i)

def PairwiseWedgeZero {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  ∀ i j : Fin n, spinorWedge (psi i) (psi j) = 0

theorem pairwise_wedge_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    PairwiseWedgeZero psi ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base

theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi

theorem finPairwisePluckerMass_eq_zero_iff_pair_terms_zero
    {n : Nat} (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass psi = 0 ↔
      ∀ p ∈ finPairIndexSet n,
        spinorWedge (psi p.1) (psi p.2) = 0

theorem pair_terms_zero_iff_pairwise
    {n : Nat} (psi : Fin n -> CSpinor) :
    (∀ p ∈ finPairIndexSet n, spinorWedge (psi p.1) (psi p.2) = 0) ↔
      PairwiseWedgeZero psi

theorem all_smul_implies_pairwise_wedge_zero
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (c : Fin n -> ℂ) (h : ∀ i : Fin n, psi i = c i • psi base) :
    PairwiseWedgeZero psi
```

## Proof sketch

For the pairwise theorem:

1. Forward direction: if `PairwiseWedgeZero psi`, split on `AllZero psi`.
2. If not all zero, use classical logic to obtain an index `base` with
   `psi base ≠ 0`.
3. Convert function nonzero into `psi base 0 ≠ 0 ∨ psi base 1 ≠ 0`; otherwise
   both coordinates vanish and function extensionality gives `psi base = 0`.
4. Apply `pairwise_wedge_zero_iff_common_direction psi base hbase`.
5. Backward direction: all-zero case by unfolding `PairwiseWedgeZero` and
   `spinorWedge`; common-direction case by
   `all_smul_implies_pairwise_wedge_zero`.

For the determinant theorem, rewrite with:

```lean
fin_bundle_plucker_mass_identity
finPairwisePluckerMass_eq_zero_iff_pair_terms_zero
pair_terms_zero_iff_pairwise
```

then apply the pairwise theorem.

## Statement risks

- `Fin 0` should be handled correctly: `AllZero` is vacuously true and no base
  is required.
- The theorem should not choose an arbitrary base in the all-zero case.
- Do not weaken the common-direction branch by dropping the nonzero-base
  condition.
