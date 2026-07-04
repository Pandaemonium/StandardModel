# Q2 audit: shift-covariant transfer-Hilbert statement design

Scope: design + lemma DAG for `TransferHilbert.lean` (finite OS/GNS transfer
layer, made compatible with Q3 electric/center-shift sectors). ASCII only.
Escape-hatch tokens are spelled with spaces (`s o r r y`, `a x i o m`).

A companion Lean artifact, `TransferHilbert.lean`, is checked in and builds
without proof placeholders (dependency footprint: `propext`,
`Classical.choice`, `Quot.sound`). The
questions below are answered against that concrete file, not just on paper.

---

## 1. Verdict

**Accepted with changes.**

The pre-Hermitian-bridge design (antilinear-first `reflectionPairing`, finite
matrix `range (CFC.sqrt K)` route, abstract compressed transfer, no physical
Hamiltonian claim) is sound and is kept. Two changes are required, both driven
by the day-1 covariance requirement and by what turned out to be provable:

1. Add the center-shift covariance layer as first-class content. This was the
   missing piece; it is fully tractable now (see Q2 below), so it is proved,
   not deferred.

2. Split "self-adjoint / PSD transfer" into two honestly-scoped statements:
   - the physically faithful OS-form statements about `reflectionPairing`
     (`reflectionPairing_transfer_symm`, `reflectionPairing_transfer_nonneg`);
   - the auxiliary square-root-conjugated operator `compressedTransfer`
     (`= CFC.sqrt K * T * CFC.sqrt K`), which is Hermitian/PSD/shift-covariant
     but is explicitly NOT claimed to equal the physical transfer unless `T`
     preserves `ker K`. That identification (which needs a pseudo-inverse or a
     descent-to-quotient argument) is a documented handoff, not frozen here.

The single design decision that would have been an honest hypothesis --
"shift commutes with `CFC.sqrt K`" -- turns out to be a one-line consequence
of `Commute.cfcₙ_nnreal`. So it is a theorem, not a hypothesis. This is the
main correction to the day-1 worry in Q2.

---

## 2. Lean-facing API (as frozen in `TransferHilbert.lean`)

Ambient setting (deliberately generic; not tied to the torus instance):

```
variable {I Shift : Type*} [Fintype I] [DecidableEq I]
-- K T : Matrix I I ℂ  (K is the PSD reflection kernel; in the intended
--   instance the block direct sum of ReflectionPositivityKernel.cutKernel W c)
-- S : CenterFluxSector.ShiftSystem I Shift
```

Answer to the interface question in Q1: yes to all five, with `K`, `T`, and
the shift operators as `Matrix I I ℂ` (staying in the matrix API used by
`ReflectionPositivityKernel` and `TransferPositivity`), and commutation
stated as `Commute` of matrices.

Definitions:

```
def reflectionPairing (K : Matrix I I ℂ) (f g : I → ℂ) : ℂ := star f ⬝ᵥ (K *ᵥ g)
def shiftMatrix (S : ShiftSystem I Shift) (z : Shift) : Matrix I I ℂ
    := Equiv.Perm.permMatrix ℂ (S.shift z)
def KernelCommutesShifts (S) (K) : Prop := ∀ z, Commute (shiftMatrix S z) K
def rpHilbertSpace (K : Matrix I I ℂ) : Submodule ℂ (I → ℂ)
    := LinearMap.range (Matrix.mulVecLin (CFC.sqrt K))
def shiftOp (S) (z) : (I → ℂ) →ₗ[ℂ] (I → ℂ) := Matrix.mulVecLin (shiftMatrix S z)
def compressedTransfer (K T : Matrix I I ℂ) : Matrix I I ℂ
    := CFC.sqrt K * T * CFC.sqrt K
```

Theorems (all proved in the file):

```
reflectionPairing_self_nonneg    : K.PosSemidef → 0 ≤ reflectionPairing K f f
shiftMatrix_mulVec               : shiftMatrix S z *ᵥ f = fun i => f (S.shiftConfig z i)
kernelCommutesShifts_iff         : KernelCommutesShifts S K ↔
                                     ShiftSystem.KernelInvariantUnderShifts S (fun x y => K x y)
shiftOp_commute_sqrt             : KernelCommutesShifts S K →
                                     Commute (shiftMatrix S z) (CFC.sqrt K)
shiftOp_preserves_rpHilbertSpace : KernelCommutesShifts S K →
                                     ∀ v ∈ rpHilbertSpace K, shiftOp S z v ∈ rpHilbertSpace K
reflectionPairing_transfer_symm  : K * T = Tᴴ * K →
                                     reflectionPairing K f (T *ᵥ g) = reflectionPairing K (T *ᵥ f) g
reflectionPairing_transfer_nonneg: (K * T).PosSemidef → 0 ≤ reflectionPairing K f (T *ᵥ f)
compressedTransfer_isHermitian   : T.IsHermitian → (compressedTransfer K T).IsHermitian
compressedTransfer_posSemidef    : T.PosSemidef → (compressedTransfer K T).PosSemidef
compressedTransfer_commute_shift : KernelCommutesShifts S K → (∀ z, Commute (shiftMatrix S z) T) →
                                     Commute (shiftMatrix S z) (compressedTransfer K T)
compressedTransfer_preserves_electricSector :
    KernelCommutesShifts S K → ShiftSystem.InElectricSector S character psi →
    ShiftSystem.InElectricSector S character (ShiftSystem.applyKernel (fun x y => K x y) psi)
```

Revision of the candidate name list from Q4:

- `reflectionPairing` -- kept.
- `rpBlockMatrix` -- **not frozen here.** Deliberately left generic in a PSD
  `K`. The block direct sum of `cutKernel W c` is one *instance*; keeping the
  interface generic avoids committing to an index encoding (`C × A` vs
  `A × C`) and lets the same file serve non-torus instances. Recommend adding
  `rpBlockMatrix W` and `rpBlockMatrix_posSemidef` (from
  `cutKernel_posSemidef_of_reflectionPositive`) in a thin *instantiation*
  module, not in the statement-freeze file.
- `rpHilbertSpace` -- kept, as `range (CFC.sqrt K)`.
- `shiftOp` -- kept; plus `shiftMatrix` (matrix form) and
  `shiftOp_commute_sqrt` (the crux).
- `shiftOp_preserves_rpHilbertSpace` -- kept, and **proved** (not a hypothesis).
- `compressedTransfer` -- kept, but as the sqrt-conjugation, clearly labeled
  auxiliary.
- `compressedTransfer_isSelfAdjoint` -- renamed to
  `compressedTransfer_isHermitian` (matches `Matrix.IsHermitian`); the
  physically meaningful self-adjointness is `reflectionPairing_transfer_symm`.
- `compressedTransfer_posSemidef` -- kept.
- `compressedTransfer_commutes_shift` -> `compressedTransfer_commute_shift`.
- `compressedTransfer_preserves_electricSector` -- kept, and realized as a thin
  wrapper over `ShiftSystem.inElectricSector_applyKernel` via the bridge.
- Added: `kernelCommutesShifts_iff` (matrix <-> function-kernel bridge),
  `reflectionPairing_transfer_symm/_nonneg` (the faithful OS-form statements).

---

## 3. Public hypotheses vs internal proof obligations

Public inputs a caller (Q3, or the torus instantiator) must supply:

- `K.PosSemidef` -- available from `cutKernel_posSemidef_of_reflectionPositive`.
- `KernelCommutesShifts S K` (equivalently, via `kernelCommutesShifts_iff`,
  the `ShiftSystem.KernelInvariantUnderShifts` predicate already used in
  `CenterFluxSector`/`FluxSectorZ2`). For the torus this is exactly the
  content of `plaquetteHol_torusCenterShift` lifted to the weight kernel.
- For transfer statements: `K * T = Tᴴ * K` (OS self-adjointness) and/or
  `(K * T).PosSemidef` (OS positivity), and `∀ z, Commute (shiftMatrix S z) T`
  (transfer shift covariance). These are genuine physics inputs about the
  chosen `T`; they are NOT derivable from `K` alone.

Internal (discharged in the file, no obligation on the caller):

- `shiftOp_commute_sqrt` (functional-calculus commutation),
- `shiftOp_preserves_rpHilbertSpace`,
- `kernelCommutesShifts_iff`,
- the Hermitian/PSD/commute facts about `compressedTransfer`,
- `reflectionPairing_transfer_symm/_nonneg`.

Not claimed at all (documented handoff, see Q2/Q6): that `compressedTransfer`
equals the physical transfer on the OS space; that requires `T (ker K) ⊆ ker K`
plus a descent argument.

---

## 4. Mathlib API notes

- `CFC.sqrt` (namespace `CFC`) is the current API; `Matrix.PosSemidef.sqrt`,
  `.posSemidef_sqrt`, `.sqrt_mul_self`, `.sq_sqrt` are all **deprecated** in
  this Mathlib. Use `CFC.sqrt`, `CFC.sqrt_nonneg`, `CFC.sqrt_mul_sqrt_self`,
  `CFC.sq_sqrt`.
- The matrix Loewner order is a scoped instance: you must
  `open scoped MatrixOrder` (and `ComplexOrder`) for `CFC.sqrt (K : Matrix ..)`
  and for `0 ≤ K` to elaborate. `CFC.sqrt K` is `noncomputable`.
- `0 ≤ M` (Loewner) to `M.PosSemidef`: use `Matrix.LE.le.posSemidef`. Hence
  `(Matrix.LE.le.posSemidef (CFC.sqrt_nonneg K)).isHermitian` gives
  `(CFC.sqrt K).IsHermitian` (so `(CFC.sqrt K)ᴴ = CFC.sqrt K`).
- **CFC.sqrt commutation (the key worry) is easy.** For matrices:
  `Commute.cfcₙ_nnreal : Commute a b → ∀ f : NNReal → NNReal, Commute (cfcₙ f a) b`,
  and `CFC.sqrt` unfolds to `cfcₙ (⇑NNReal.sqrt)`. So from `Commute K P`,
  `simpa [CFC.sqrt] using Commute.cfcₙ_nnreal (h) (fun x => NNReal.sqrt x)`
  gives `Commute (CFC.sqrt K) P`. (Mind the argument order: apply
  `Commute.cfcₙ_nnreal` to the *K-first* orientation and `.symm` as needed.)
  There is also `IsSelfAdjoint.commute_cfc` / `Commute.cfc` for the unital
  RCLike CFC over ℂ or ℝ if you prefer that route. **Recommendation: prove
  the commutation; do not keep it as a hypothesis.**
- Range as a submodule: `LinearMap.range (Matrix.mulVecLin M)` gives
  `Submodule ℂ (I → ℂ)`. Range-preservation from commutation is a two-line
  argument: `Matrix.mulVec_mulVec` + `Commute.eq`.
- **Matrices vs `Module.End`.** Stay with `Matrix` for `K`, `T`, and the shift
  permutation, to reuse `Matrix.PosSemidef`, `mulVec`, `dotProduct`, and the
  existing `TransferPositivity`/`ReflectionPositivityKernel` API. Expose the
  operator view only through `Matrix.mulVecLin` where a `Submodule`/`LinearMap`
  is needed (`rpHilbertSpace`, `shiftOp`).
- Permutation matrices: `Equiv.Perm.permMatrix ℂ σ`. Useful facts:
  `permMatrix σ *ᵥ f = fun i => f (σ i)`; entrywise
  `(permMatrix σ * K) i j = K (σ i) j` and `(K * permMatrix σ) i j = K i (σ.symm j)`
  (via `Matrix.mul_apply`, `PEquiv.toMatrix`, `Equiv.toPEquiv`). These give the
  `kernelCommutesShifts_iff` bridge.
- Transfer OS-form: `Matrix.mulVec_mulVec`, `Matrix.star_mulVec`
  (`star (A *ᵥ v) = star v ᵥ* Aᴴ`), `Matrix.dotProduct_mulVec`
  (`v ⬝ᵥ A *ᵥ w = v ᵥ* A ⬝ᵥ w`), and `Matrix.PosSemidef.dotProduct_mulVec_nonneg`.
- Avoid: matrix Moore-Penrose pseudo-inverse (not needed for the frozen
  statements; only for the deferred "compressed = physical transfer" identity).

---

## 5. Minimal next proof package (after this freeze)

The statement file is already placeholder-free; the next package is *instantiation*
and *strengthening*, in this order:

1. Thin instantiation module: define `rpBlockMatrix W` as the direct sum of
   `cutKernel W c` over `c : C`, prove `rpBlockMatrix_posSemidef` from
   `cutKernel_posSemidef_of_reflectionPositive`, and a lemma relating
   `reflectionPairing (rpBlockMatrix W) · ·` to `reflectionForm W`.
2. Torus wiring: from `plaquetteHol_torusCenterShift` (and the weight's
   dependence on plaquette holonomies), discharge
   `KernelCommutesShifts (torusCenterShiftSystem ..) (rpBlockMatrix W)`,
   feeding `shiftOp_preserves_rpHilbertSpace` and
   `compressedTransfer_preserves_electricSector` for the concrete model.
3. Connect `FluxSectorZ2.ElectricKernelInvariant` to `KernelCommutesShifts`
   (both are "kernel commutes with the two generating shifts"); prove the
   bridge lemma so `inElectricFluxSector_applyElectricTransfer` and the Q2
   layer share one predicate.
4. Only then, if wanted: the honest "compressed = physical transfer"
   refinement -- introduce `T (ker K) ⊆ ker K`, build the descent to the
   quotient / the pseudo-inverse, and prove the sqrt-model operator agrees
   with the induced transfer on `rpHilbertSpace K`. Keep this as a separate,
   clearly labeled module.

---

## 6. Scope statement (how the file avoids overclaiming)

The module docstring states plainly that everything is **finite and
algebraic** and that it does NOT construct a physical transfer matrix,
Hamiltonian, continuum/infinite-volume Hilbert space, or spectral gap. Two
specific guardrails are wired into the statements themselves:

- `rpHilbertSpace K = range (CFC.sqrt K)` is a finite-dimensional submodule of
  `I → ℂ` with the ambient Hermitian inner product; it is the GNS/OS space of
  the *given finite kernel*, nothing more.
- `compressedTransfer` is documented as the square-root-conjugated auxiliary
  operator. Its Hermitian/PSD/covariance lemmas are true of that matrix, and
  the docstring states it is not asserted to be the physical transfer unless
  `T` preserves `ker K`. The physically meaningful "transfer is symmetric and
  positive w.r.t. the OS inner product" content lives in the OS-form lemmas
  `reflectionPairing_transfer_symm/_nonneg`, which are exactly the finite,
  checkable statements and carry no dynamical/spectral claim.

The center-shift covariance condition is not dropped: `KernelCommutesShifts`
(equivalently `ShiftSystem.KernelInvariantUnderShifts`) is a public hypothesis
of every covariance conclusion, and `shiftOp_preserves_rpHilbertSpace` is the
theorem guaranteeing Q3's electric sectors survive the OS/GNS construction.

### Sanity checks / counterexamples worth encoding before wider use

- If `T` does not commute with the shifts, `compressedTransfer_commute_shift`
  is simply not applicable (its `∀ z, Commute ..` hypothesis fails); the
  electric-sector conclusion should then be unavailable -- confirm no lemma
  yields it unconditionally. `compressedTransfer_preserves_electricSector`
  correctly requires `KernelCommutesShifts S K`.
- If `K` commutes with the shifts but `T` does not preserve `ker K`, the
  sqrt-model `compressedTransfer` is still a well-defined PSD matrix, but it is
  NOT the physical transfer -- which is exactly why that identity is deferred.
  A good regression check: exhibit a small `K`, `T` where `T` moves `ker K`
  and show `compressedTransfer K T` differs from any operator induced on the
  quotient.
- Non-degeneracy check: pick a nonzero `psi` in a nontrivial electric sector
  (character not identically 1) on a small torus and confirm
  `compressedTransfer_preserves_electricSector` is non-vacuous (the sector is
  inhabited), so the theorem is not trivially satisfied by an empty sector.
