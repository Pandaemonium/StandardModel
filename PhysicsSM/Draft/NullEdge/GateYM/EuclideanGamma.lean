import Mathlib

set_option maxHeartbeats 4000000

/-!
# QMF4a: Euclidean gamma matrices and the finite Clifford algebra

First rung of QMF4 (Wilson fermion action) on the QCD mass-formalism ladder
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` section 15,
`AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`). Lattice field theory is
EUCLIDEAN, so the relevant Dirac algebra is

    {gamma_mu, gamma_nu} = 2 delta_{mu nu} I,   every gamma_mu Hermitian,

which is DIFFERENT from the repo's `PhysicsSM/Clifford/GammaMatrices.lean`
(a Minkowski mostly-minus stub). This module fixes concrete `4 x 4` complex
Euclidean gamma matrices in the chiral (Weyl) basis and proves the Clifford
relations, Hermiticity, and the chirality matrix `gamma5` properties.

## Convention (oracle-pinned)

Pinned by `Scripts/oracle/validate_wilson_dirac.py` (21/21). Chiral basis:
`gamma_mu = [[0, e_mu], [e_mu^dagger, 0]]` in `2 x 2` blocks, with
`e_1 = -i sigma_x`, `e_2 = -i sigma_y`, `e_3 = -i sigma_z`, `e_4 = I_2`.
Concretely (rows/cols `0..3`):

* `gamma1 = !![0,0,0,-I; 0,0,-I,0; 0,I,0,0; I,0,0,0]`
* `gamma2 = !![0,0,0,-1; 0,0,1,0; 0,1,0,0; -1,0,0,0]`
* `gamma3 = !![0,0,-I,0; 0,0,0,I; I,0,0,0; 0,-I,0,0]`
* `gamma4 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]`

Chirality: `gamma5 = gamma1 * gamma2 * gamma3 * gamma4`, Hermitian, `gamma5^2 = 1`,
`{gamma5, gamma_mu} = 0`.

## What is proved

The anticommutator table `{gamma_mu, gamma_nu} = 2 delta_{mu nu}` (all 16
entries), Hermiticity of each `gamma_mu`, and the `gamma5` facts
(`gamma5^2 = 1`, Hermitian, anticommutes with each `gamma_mu`). All by direct
`4 x 4` complex-matrix computation (`Matrix.mul_fin_four` / `Fin.sum_univ_four`
+ `norm_num`/`Complex.ext`), NO `decide`/`native_decide`.

Claim label: **finite identity**. Draft-trust: kernel-checked. Prerequisites:
Mathlib only. Successor: QMF4b (the Wilson-Dirac operator on a finite lattice
+ gamma5-hermiticity + paired-flavor determinant positivity).

## Provenance

Convention oracle-pinned FIRST by `Scripts/oracle/validate_wilson_dirac.py`
(21/21; the concrete matrices below were derived to match its Euclidean
chiral-basis gammas), then the six lemmas PROVED by Aristotle (Harmonic),
project `0752425e-937e-47f9-855f-5b44325883e6`, from the statement-freeze
scaffold in `AgentTasks/aristotle-standalone/qmf4a-euclidean-gamma-20260704/`
(prompt `AgentTasks/aristotle-prompts/qmf4a-euclidean-gamma-20260704.prompt.md`).
INDEPENDENTLY VERIFIED vs this project's pinned toolchain: `lake env lean`
clean (0 errors), axioms `[propext, Classical.choice, Quot.sound]`,
`s o r r y`-free, matrices + all six statements UNCHANGED from the frozen
scaffold. BUILD-COST NOTE: the anticommutator table is a 256-entry concrete
complex-matrix computation, so this leaf module needs a raised
`maxHeartbeats` and takes ~1 min on a CLEAN build (cached on incremental
builds); it is deliberately a leaf so it never blocks other modules.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace EuclideanGamma

/-- Euclidean gamma_1 (chiral basis). -/
def γ1 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 0, -Complex.I;
     0, 0, -Complex.I, 0;
     0, Complex.I, 0, 0;
     Complex.I, 0, 0, 0]

/-- Euclidean gamma_2 (chiral basis). -/
def γ2 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 0, -1;
     0, 0, 1, 0;
     0, 1, 0, 0;
     -1, 0, 0, 0]

/-- Euclidean gamma_3 (chiral basis). -/
def γ3 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, -Complex.I, 0;
     0, 0, 0, Complex.I;
     Complex.I, 0, 0, 0;
     0, -Complex.I, 0, 0]

/-- Euclidean gamma_4 (chiral basis). -/
def γ4 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 1, 0;
     0, 0, 0, 1;
     1, 0, 0, 0;
     0, 1, 0, 0]

/-- The chirality matrix `gamma5 = gamma1 gamma2 gamma3 gamma4`. -/
noncomputable def γ5 : Matrix (Fin 4) (Fin 4) ℂ := γ1 * γ2 * γ3 * γ4

/-- The four Euclidean gammas indexed by `Fin 4`. -/
noncomputable def γ : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ
  | 0 => γ1
  | 1 => γ2
  | 2 => γ3
  | 3 => γ4

/-- Each Euclidean gamma matrix squares to the identity:
`{gamma_mu, gamma_mu} = 2 I` in the diagonal case.

Proof handoff (QMF4a): direct `4 x 4` complex-matrix computation. The
per-matrix case `γ1 * γ1 = 1` closes with
`simp only [γ1]; ext i j; fin_cases i <;> fin_cases j <;>
  simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] <;>
  norm_num [Complex.ext_iff]` under a raised `maxHeartbeats` (verified);
generalize over `μ` by `fin_cases μ` + `simp only [γ]` to reduce `γ 0`..`γ 3`
to the concrete matrices. Prefer whatever tactic keeps the AGGREGATE build
fast (this file is wired into `GateYM`). -/
theorem γ_sq (μ : Fin 4) : γ μ * γ μ = 1 := by
  fin_cases μ <;>
    simp only [γ, γ1, γ2, γ3, γ4] <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- The Euclidean Clifford relation `{gamma_mu, gamma_nu} = 2 delta_{mu nu} I`. -/
theorem γ_anticomm (μ ν : Fin 4) :
    γ μ * γ ν + γ ν * γ μ = (2 * if μ = ν then 1 else 0) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  fin_cases μ <;> fin_cases ν <;>
    simp only [γ, γ1, γ2, γ3, γ4] <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply, Matrix.smul_apply] <;>
    norm_num [Complex.ext_iff]

/-- Each Euclidean gamma matrix is Hermitian. -/
theorem γ_herm (μ : Fin 4) : (γ μ)ᴴ = γ μ := by
  fin_cases μ <;>
    simp only [γ, γ1, γ2, γ3, γ4] <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose_apply]

/-- `gamma5` squares to the identity. -/
theorem γ5_sq : γ5 * γ5 = 1 := by
  simp only [γ5, γ1, γ2, γ3, γ4]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- `gamma5` is Hermitian. -/
theorem γ5_herm : (γ5)ᴴ = γ5 := by
  simp only [γ5, γ1, γ2, γ3, γ4]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose_apply, Matrix.mul_apply, Fin.sum_univ_four]

/-- `gamma5` anticommutes with each Euclidean gamma matrix. -/
theorem γ5_anticomm (μ : Fin 4) : γ5 * γ μ + γ μ * γ5 = 0 := by
  fin_cases μ <;>
    simp only [γ5, γ, γ1, γ2, γ3, γ4] <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply, Matrix.zero_apply]

end EuclideanGamma
end PhysicsSM.Draft.NullEdge.GateYM
