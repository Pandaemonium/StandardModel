/-
# The T2 carrier IS the Cl(4) Kronecker assembly (closes the provenance audit gap)

DRAFT (kernel-clean; no `s o r r y`). Closes an audit gap (2026-07-08): the
flagship `T2_positive_mass` proves a positive squared mass of the `12×12` Krein
form `SectorGroundMassWitness.HAC` and metric `Jmet`, which are entered as
*hand-typed literal matrices*. Their Clifford provenance — that they are the
two-edge `Cl(4)` carrier's `J(Q_A+Q_C)` and fundamental symmetry `J = Js⊗I3` — was
previously asserted only in docstrings + an oracle. Here it is **kernel-certified**:
the Clifford assembly built from Pauli-Kronecker products equals the hand-typed
matrices *verbatim, with no convention change*.

## Conventions (verified to reproduce the hand-typed matrices exactly)

Kronecker order is the row-major one from `finProdFinEquiv` (`(i,k) ↦ n*i + k`);
gammas `g1=σx⊗I2, g2=σy⊗I2, g3=σz⊗σx, g4=σz⊗σy`; `omega=g1*g2`, `Js=i(g3*g4)`,
`J_cl=Js⊗I3`, `Q_A=I4⊗(2·I3)`, `Q_C=omega⊗K` with `K=!![0,1,0;-1,0,0;0,0,0]`.
One computes `omega=diag(I,I,-I,-I)`, `Js=diag(-1,1,-1,1)`, so `J_cl=Jmet` and
`J_cl(Q_A+Q_C)=HAC`.

## Results (both M, kernel-clean)

- `Jmet_eq_clifford : J_cl = SectorGroundMassWitness.Jmet`. (The metric identity is
  *forced* — `Js = i g3 g4` has no free input — so this one is unconditional.)
- `HAC_eq_clifford : J_cl * (Q_A + Q_C) = SectorGroundMassWitness.HAC`.

**What this earns, precisely (per the batch-2 audit — do not over-read).** These
prove the hand-typed `HAC`/`Jmet` **equal the program's documented Clifford recipe**
(the gammas `g1..g4`, `omega`, `Js`, `Q_A = I4⊗2I3`, `Q_C = omega⊗K` with the
stated `K` and the `finProdFinEquiv` Kronecker order) — closing the earlier gap
that the recipe lived *only* in docstrings. What they do **not** certify is
*canonicity*: `K` (the closure kernel) and the `Q_A` scale are supplied inputs
matching the program's convention, not *derived* from closure geometry, and the
tensor order is not shown to be the unique one reproducing `HAC` (a rigidity lemma
— gammas forced by the Clifford relations, `K` forced as the unique closure
operator — would be needed for that). So: "the hand-typed carrier realizes the
documented Cl(4) recipe" is **M**; "this is the *canonical/unique* Cl(4) carrier"
is not claimed here.

## Provenance

All-mass solo run 2026-07-08 [orig]. Proofs from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-proof-clifford-20260708`), reviewed for
semantic alignment (no gamma-sign / Kronecker-order / K-orientation discrepancy)
and re-based here onto the project's `SectorGroundMassWitness.HAC`/`.Jmet`. Builds
on `SectorGroundMassWitness`; uses Mathlib `Matrix.kronecker` / `finProdFinEquiv`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly

open Matrix Complex
open scoped Kronecker
open PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness

/-! ## The Clifford assembly -/

/-- Pauli `σx`. -/
def sx : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
/-- Pauli `σy`. -/
def sy : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
/-- Pauli `σz`. -/
def sz : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `2×2` identity. -/
def I2 : Matrix (Fin 2) (Fin 2) ℂ := 1
/-- `3×3` identity. -/
def I3 : Matrix (Fin 3) (Fin 3) ℂ := 1
/-- `4×4` identity. -/
def I4 : Matrix (Fin 4) (Fin 4) ℂ := 1

/-- Kronecker product of two `2×2` matrices, reindexed to `Fin 4` (row-major). -/
noncomputable def kron4 (A B : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.reindex finProdFinEquiv finProdFinEquiv (A ⊗ₖ B)

/-- Kronecker product of a `4×4` and a `3×3` matrix, reindexed to `Fin 12`. -/
noncomputable def kron12 (A : Matrix (Fin 4) (Fin 4) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 12) (Fin 12) ℂ :=
  Matrix.reindex finProdFinEquiv finProdFinEquiv (A ⊗ₖ B)

/-- Hermitian gamma `g1 = sx ⊗ I2`. -/
noncomputable def g1 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sx I2
/-- Hermitian gamma `g2 = sy ⊗ I2`. -/
noncomputable def g2 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sy I2
/-- Hermitian gamma `g3 = sz ⊗ sx`. -/
noncomputable def g3 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sz sx
/-- Hermitian gamma `g4 = sz ⊗ sy`. -/
noncomputable def g4 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sz sy

/-- `omega = g1 * g2`. -/
noncomputable def omega : Matrix (Fin 4) (Fin 4) ℂ := g1 * g2
/-- Fundamental symmetry `Js = I • (g3 * g4)`. -/
noncomputable def Js : Matrix (Fin 4) (Fin 4) ℂ := Complex.I • (g3 * g4)

/-- Krein metric `J_cl = Js ⊗ I3`. -/
noncomputable def J_cl : Matrix (Fin 12) (Fin 12) ℂ := kron12 Js I3

/-- Aperture `Q_A = I4 ⊗ (2 • I3)`. -/
noncomputable def Q_A : Matrix (Fin 12) (Fin 12) ℂ := kron12 I4 ((2 : ℂ) • I3)

/-- Closure kernel `K`. -/
def K : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; -1, 0, 0; 0, 0, 0]

/-- Closure `Q_C = omega ⊗ K`. -/
noncomputable def Q_C : Matrix (Fin 12) (Fin 12) ℂ := kron12 omega K

/-! ## Explicit small-matrix forms -/

/-- `Js` computes to `diag(-1, 1, -1, 1)`. -/
theorem Js_eq : Js = !![(-1 : ℂ), 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1] := by
  unfold Js g3 g4 kron4 sz sx sy
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.reindex_apply,
      Matrix.kroneckerMap_apply, finProdFinEquiv, Fin.divNat, Fin.modNat]

/-- `omega` computes to `diag(I, I, -I, -I)`. -/
theorem omega_eq :
    omega = !![Complex.I, 0, 0, 0; 0, Complex.I, 0, 0; 0, 0, -Complex.I, 0; 0, 0, 0, -Complex.I] := by
  unfold omega g1 g2 kron4 sx sy I2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.reindex_apply,
      Matrix.kroneckerMap_apply, finProdFinEquiv, Fin.divNat, Fin.modNat,
      Matrix.one_apply]

/-- Explicit form of the aperture-plus-closure operator `Q_A + Q_C`. -/
def QAC : Matrix (Fin 12) (Fin 12) ℂ :=
  !![ (2 : ℂ), Complex.I, 0,   0, 0, 0,   0, 0, 0,   0, 0, 0;
      -Complex.I, 2, 0,       0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 2,               0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   (2:ℂ), Complex.I, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   -Complex.I, 2, 0,      0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 2,              0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 0,   (2:ℂ), -Complex.I, 0,  0, 0, 0;
      0, 0, 0,   0, 0, 0,   Complex.I, 2, 0,       0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 2,              0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   (2:ℂ), -Complex.I, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   0, 0, 2]

set_option maxHeartbeats 1600000 in
/-- `Q_A + Q_C` computes to the explicit matrix `QAC`. -/
theorem QAC_eq : Q_A + Q_C = QAC := by
  unfold Q_A Q_C kron12 I4 I3 K QAC
  rw [omega_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.reindex_apply, Matrix.kroneckerMap_apply, finProdFinEquiv,
      Fin.divNat, Fin.modNat, Matrix.add_apply]

/-! ## Targets: the hand-typed T2 carrier IS the Clifford assembly -/

set_option maxHeartbeats 1600000 in
/-- The Clifford metric `J_cl = Js ⊗ I3` equals the hand-typed `Jmet`, verbatim. -/
theorem Jmet_eq_clifford : J_cl = Jmet := by
  unfold J_cl kron12 I3
  rw [Js_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.reindex_apply, Matrix.kroneckerMap_apply, finProdFinEquiv,
      Fin.divNat, Fin.modNat, Matrix.diagonal, Jmet]

set_option maxHeartbeats 1600000 in
/-- The Clifford assembly `J_cl * (Q_A + Q_C)` equals the hand-typed `HAC`, verbatim.
So the flagship `HAC` **realizes the program's documented Cl(4) recipe** (gammas,
`omega`, `Js`, `Q_A`, `Q_C` with the stated `K` and Kronecker order) — the earlier
docstring-only-provenance gap is closed. This certifies *a* Clifford presentation,
not its canonicity (`K`/order are inputs; see the module docstring). -/
theorem HAC_eq_clifford : J_cl * (Q_A + Q_C) = HAC := by
  rw [Jmet_eq_clifford, QAC_eq]
  unfold QAC
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.diagonal, Jmet, HAC]

end PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly
