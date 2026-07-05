import Mathlib
import Qmf4bWilson.EuclideanGamma

set_option maxHeartbeats 4000000

/-!
# QMF4b: the Wilson-Dirac operator, gamma5-hermiticity, paired-flavor positivity

Second rung of QMF4 on the QCD mass-formalism ladder. Builds on the proved
Euclidean gamma matrices (`EuclideanGamma`, all six Clifford/gamma5 lemmas
kernel-checked) to define the finite lattice Wilson-Dirac operator and prove
its two STRUCTURAL properties, both numerically pre-verified by the oracle
`Scripts/oracle/validate_wilson_dirac.py` (21/21):

* **gamma5-hermiticity** `Γ5 * D * Γ5 = Dᴴ`, where `Γ5` is `gamma5` lifted to the
  full (site x spin x color) space. THIS IS THE REAL CONTENT: it holds because
  `gamma5 (r - gamma_mu) gamma5 = r + gamma_mu` pairs the forward hop with the
  (daggered) backward hop.
* **paired-flavor determinant positivity**: `gamma5`-hermiticity forces
  `det D` to be REAL, so two degenerate flavors give `det(D)^2 >= 0` (the
  Wilson determinant of a mass-degenerate pair is nonnegative). Equivalently
  `(Dᴴ * D).PosSemidef` (generic Gram fact) together with `det D` real.

Everything is finite-lattice, fixed-coupling, fixed-volume - NO continuum.

## Convention (oracle-pinned; do not drift)

Euclidean, spacing `a = 1`, Wilson parameter `r = 1`. Lattice
`Site := Fin 4 → Fin L` (4D periodic; direction `mu : Fin 4`). Full index
`Idx := Site × Fin 4 × Fin nc` (site, Dirac spin in `Fin 4`, color in `Fin nc`).
Link field `U mu x : Matrix (Fin nc) (Fin nc) ℂ`, assumed UNITARY. Operator:

    D (x,s,c) (y,t,d)
      = (m + 4) • [x=y, s=t, c=d]
        - (1/2) Σ_mu [ [y = x+mu] * (1 - γ_mu) s t * (U mu x) c d
                     + [y = x-mu] * (1 + γ_mu) s t * (U mu (x-mu))ᴴ c d ]

with `x+mu`/`x-mu` the periodic neighbor in direction `mu`. (`γ_mu` here is the
`EuclideanGamma.γ mu`; `[P]` is the 0/1 indicator.)

## Status: statement-design + proof target

The scaffold below fixes the types, the unitarity hypothesis, and states the
two theorems as `s o r r y`. YOU (Aristotle) may keep or refine the `wilsonDirac`
definition - but the two theorem SHAPES and the oracle convention must be
preserved. If a cleaner operator encoding makes the proofs shorter, use it, as
long as it is the same operator (check against the oracle: on `L=2`, `nc=1`,
`m=0.3`, gamma5-hermiticity holds and `det D` is real).
-/

open scoped Matrix BigOperators

namespace Qmf4bWilson

variable {L nc : ℕ}

/-- 4D periodic lattice sites. -/
abbrev Site (L : ℕ) := Fin 4 → Fin L

/-- Full Wilson-fermion index: site, Dirac spin (`Fin 4`), colour (`Fin nc`). -/
abbrev Idx (L nc : ℕ) := Site L × Fin 4 × Fin nc

/-- Periodic neighbour one step up in direction `mu`. -/
def shiftUp [NeZero L] (mu : Fin 4) (x : Site L) : Site L := Function.update x mu (x mu + 1)

/-- Periodic neighbour one step down in direction `mu`. -/
def shiftDn [NeZero L] (mu : Fin 4) (x : Site L) : Site L := Function.update x mu (x mu - 1)

/-- The finite lattice Wilson-Dirac operator (Euclidean, `r = 1`), as a matrix on
`Idx L nc`. Mass `m`, unitary link field `U`. -/
noncomputable def wilsonDirac [NeZero L] (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) :
    Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun (I J : Idx L nc) =>
    let x := I.1; let s := I.2.1; let c := I.2.2
    let y := J.1; let t := J.2.1; let d := J.2.2
    ((m : ℂ) + 4) * (if x = y ∧ s = t ∧ c = d then 1 else 0)
      - (1 / 2) * ∑ mu : Fin 4,
          ((if y = shiftUp mu x then (1 - EuclideanGamma.γ mu) s t * U mu x c d else 0)
            + (if y = shiftDn mu x then (1 + EuclideanGamma.γ mu) s t * (U mu (shiftDn mu x))ᴴ c d else 0))

/-- `gamma5` lifted to the full `Idx` space (acts on the Dirac spin factor only). -/
noncomputable def Γ5 (L nc : ℕ) : Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun I J =>
    (if I.1 = J.1 ∧ I.2.2 = J.2.2 then EuclideanGamma.γ5 I.2.1 J.2.1 else 0)

/-- **gamma5-hermiticity of the Wilson-Dirac operator.** `Γ5 D Γ5 = Dᴴ`.
The structural fact underlying reality of the Wilson determinant.

Proof handoff: expand `Γ5 * D * Γ5` and `Dᴴ` entrywise; the diagonal mass term
commutes with `Γ5` and is real; on the hop terms use
`gamma5 (1 - γ_mu) gamma5 = 1 + γ_mu` (from `EuclideanGamma.γ5_anticomm` +
`γ5_sq`) and unitarity/`conjTranspose` bookkeeping so the forward hop maps to the
(daggered) backward hop. -/
theorem gamma5_hermiticity [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    Γ5 L nc * wilsonDirac m U * Γ5 L nc = (wilsonDirac m U)ᴴ := by
  sorry

/-- **Reality of the Wilson determinant** (consequence of gamma5-hermiticity).
Since `Γ5^2 = 1`, `det (Dᴴ) = det (Γ5 D Γ5) = det D`, while
`det (Dᴴ) = conj (det D)`; hence `det D` is real. -/
theorem det_wilsonDirac_real [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    (wilsonDirac m U).det.im = 0 := by
  sorry

/-- **Paired-flavor determinant positivity.** For two mass-degenerate flavors the
Wilson determinant is `det(D)^2`, which is `>= 0` because `det D` is real. -/
theorem pairedFlavor_det_nonneg [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    0 ≤ ((wilsonDirac m U).det ^ 2).re ∧ ((wilsonDirac m U).det ^ 2).im = 0 := by
  sorry

end Qmf4bWilson
