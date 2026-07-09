import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# The 1+1D Dirac quantum walk / Feynman checkerboard as a Krein null-edge carrier

This file casts the cleanest discrete-Dirac model — the **1+1 dimensional Dirac
quantum walk / Feynman checkerboard** (coin ⊗ shift, with mass realised as a
coin-flip amplitude `m`; cf. Foster–Jacobson arXiv:1610.01142 and
Mlodinow–Brun arXiv:1802.03910) — as an explicit finite operator in the
**null-edge Krein carrier** shape

    D = Σ_α c(α) ∇_α  +  Γ φ ,

and proves the *four-channel budget*

    4 · D^# D  =  Q_A + Q_C + 4·Q_T + 4·E_#

together with the physical identification of each channel:

* `Q_A` (aperture / kinetic) `= 4 (E² − k²) · 1`   — the d'Alembertian / kinetic term;
* `Q_C` (closure / gauge)    `= 0`                  — flat, no gauge curvature in 1+1D;
* `Q_T` (turn / Higgs)       `= φ² · 1 = m² · 1`    — the mass² (Higgs) term;
* `E_#` (soldering / geometry) `= 2m · (kinetic)`   — the mass·momentum cross term
  (its expected 1+1D form; it does *not* vanish for a genuinely Krein-self-adjoint
  scalar mass, and this is proved honestly).

The **mass shell** `E² = k² + m²` is recovered as the degeneracy locus
`det D = 0` of the Dirac symbol, and equivalently as the eigenvalue equation of the
walk Hamiltonian `H = k σ_z + m σ_x` built from the two null edges.

Everything is a finite (`2×2`) real-matrix identity in the parameters `E k m : ℝ`.
The clean-room content is entirely re-derived from the *mathematics* of the models;
no code is copied.  Kernel-checked; axiom footprint printed in-file.
-/

namespace DiracWalkCarrier

open Matrix

/-- `2×2` real matrices: the internal (coin / spinor) space of the 1+1D walk. -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℝ

/-- Transpose of a concrete `2×2` block, used to unfold the Krein adjoint. -/
theorem transpose_fin_two {α : Type*} (a b c d : α) :
    (!![a, b; c, d] : Matrix (Fin 2) (Fin 2) α)ᵀ = !![a, c; b, d] := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

/-- A uniform decision procedure for the concrete `2×2` real-matrix identities below. -/
macro "mat" : tactic =>
  `(tactic| (ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
      Matrix.smul_apply, Matrix.add_apply, Matrix.sub_apply] <;> ring))

/-! ## Clifford / Krein building blocks -/

/-- Krein (indefinite) form `J = σ_x`; it exchanges the two chiral / light-cone
components and is the metric that makes the null edges below isotropic. -/
def J : M2 := !![0, 1; 1, 0]

/-- `σ_z`: the chirality / which-mover operator (right-mover `−` left-mover). -/
def sigZ : M2 := !![1, 0; 0, -1]

/-- The right-moving null edge `c₊` (a nilpotent, i.e. **null**, Clifford element). -/
def cP : M2 := !![0, 1; 0, 0]

/-- The left-moving null edge `c₋` (a nilpotent, i.e. **null**, Clifford element). -/
def cM : M2 := !![0, 0; 1, 0]

/-- The Krein adjoint `A^# = J A^T J` (real entries, so the Hermitian conjugate is
the transpose).  This is the indefinite-metric ("Dirac-bar") adjoint. -/
def kdag (A : M2) : M2 := J * Aᵀ * J

@[inherit_doc] scoped postfix:max "^#" => kdag

/-! ### Null edges are isotropic and reproduce the metric

`c₊² = 0`, `c₋² = 0` (the edges are lightlike / nilpotent), while their
anticommutator `{c₊, c₋} = 1` reproduces the (unit) null pairing, and their
commutator `[c₊, c₋] = σ_z` is the **null-disagreement** operator that will carry
the kinetic momentum. -/

theorem cP_null : cP * cP = (0 : M2) := by unfold cP; mat

theorem cM_null : cM * cM = (0 : M2) := by unfold cM; mat

theorem null_pairing : cP * cM + cM * cP = (1 : M2) := by unfold cP cM; mat

/-- The **null disagreement** `[c₊, c₋]` of the two lightlike edges is `σ_z`. -/
theorem null_disagreement : cP * cM - cM * cP = sigZ := by unfold cP cM sigZ; mat

/-! ## The carrier `D = Σ c(α) ∇_α + Γ φ`

We work in the momentum/energy symbol picture: the two lightlike transports carry
the light-cone momenta `∇₊ = E − k` and `∇₋ = E + k`, contracted with the null
Clifford edges `2 c₊`, `2 c₋`.  Concretely the massless (kinetic) part is the Dirac
symbol `p̸`, and the turn/mass part is `Γ φ` with `Γ = 1`, `φ = m` (a chirality-flip
amplitude realised, in this covariant frame, as a Krein-self-adjoint scalar mass). -/

/-- The kinetic Dirac symbol `p̸ = (E−k)·c₊ + (E+k)·c₋` (light-cone transports). -/
def slashp (E k : ℝ) : M2 := !![0, E - k; E + k, 0]

/-- `p̸` written directly from the null edges and the light-cone momenta. -/
theorem slashp_eq_null_edges (E k : ℝ) :
    slashp E k = (E - k) • cP + (E + k) • cM := by unfold slashp cP cM; mat

/-- The turn / mass term `Γ φ` with `Γ = 1`, `φ = m`. -/
def turn (m : ℝ) : M2 := m • (1 : M2)

/-- The full carrier `D = p̸ + Γ φ`. -/
def Dop (E k m : ℝ) : M2 := slashp E k + turn m

theorem Dop_eq (E k m : ℝ) : Dop E k m = !![m, E - k; E + k, m] := by
  unfold Dop slashp turn; mat

/-! ### Krein self-adjointness

Both the kinetic and the turn parts are Krein-self-adjoint (`A^# = A`), hence so is
the whole carrier.  Thus `D^# D = D²` and the budget is a genuine indefinite-metric
square. -/

theorem kdag_slashp (E k : ℝ) : (slashp E k)^# = slashp E k := by
  simp only [kdag, J, slashp, transpose_fin_two, Matrix.mul_fin_two]; norm_num

theorem kdag_turn (m : ℝ) : (turn m)^# = turn m := by
  unfold kdag J turn; mat

theorem kdag_Dop (E k m : ℝ) : (Dop E k m)^# = Dop E k m := by
  rw [Dop_eq]
  simp only [kdag, J, transpose_fin_two, Matrix.mul_fin_two]; norm_num

/-! ## The four channels -/

/-- Aperture / kinetic channel `Q_A = 4 p̸²`. -/
def Q_A (E k : ℝ) : M2 := (4 : ℝ) • (slashp E k * slashp E k)

/-- Closure / gauge channel `Q_C = 0` (flat connection, no gauge curvature). -/
def Q_C : M2 := 0

/-- Turn / Higgs channel `Q_T = (Γφ)² = φ² = m²`. -/
def Q_T (m : ℝ) : M2 := turn m * turn m

/-- Soldering / geometry channel `E_# = {p̸, Γφ}` (kinetic–mass cross term). -/
def E_sharp (E k m : ℝ) : M2 := slashp E k * turn m + turn m * slashp E k

/-! ### The four-channel budget -/

/-- **Four-channel budget.**  The Krein square of the 1+1D Dirac-walk carrier splits
exactly into the aperture, closure, turn and soldering channels:

    4 · D^# D  =  Q_A + Q_C + 4·Q_T + 4·E_# . -/
theorem four_channel_budget (E k m : ℝ) :
    (4 : ℝ) • ((Dop E k m)^# * Dop E k m)
      = Q_A E k + Q_C + (4 : ℝ) • Q_T m + (4 : ℝ) • E_sharp E k m := by
  rw [kdag_Dop, Dop_eq]
  unfold Q_A Q_C Q_T E_sharp slashp turn
  mat

/-! ### Channel identifications: the names are physics -/

/-- **Aperture = kinetic.**  `Q_A = 4(E² − k²)·1`, the (light-cone) d'Alembertian. -/
theorem aperture_is_kinetic (E k : ℝ) :
    Q_A E k = (4 * (E ^ 2 - k ^ 2)) • (1 : M2) := by
  unfold Q_A slashp; mat

/-- **Closure = 0.**  No gauge curvature in flat, source-free 1+1D. -/
theorem closure_vanishes : Q_C = (0 : M2) := rfl

/-- **Turn = mass².**  `Q_T = φ² = m²·1`; the coin-flip amplitude `φ = m` is the Higgs
/mass field, and the turn channel is exactly its square. -/
theorem turn_is_mass_squared (m : ℝ) : Q_T m = (m ^ 2) • (1 : M2) := by
  unfold Q_T turn; mat

/-- **Soldering = mass · momentum.**  In 1+1D the soldering channel takes its expected
cross-term form `E_# = 2m · p̸`; it is genuinely non-zero for a Krein-self-adjoint
scalar mass (honest statement: it does *not* vanish here). -/
theorem soldering_form (E k m : ℝ) : E_sharp E k m = (2 * m) • slashp E k := by
  unfold E_sharp turn slashp; mat

/-- The soldering channel is not identically zero (it vanishes only on the
`m = 0` or `E = ±k` locus): e.g. it is non-zero at `E = 1, k = 0, m = 1`. -/
theorem soldering_nonzero : E_sharp 1 0 1 ≠ (0 : M2) := by
  rw [soldering_form]
  intro h
  have := congrFun (congrFun h 0) 1
  simp [slashp, Matrix.smul_apply] at this

/-! ## The mass shell `E² = k² + m²`

The Dirac equation `D ψ = 0` has a non-trivial solution iff the symbol is singular,
`det D = 0`.  For the carrier this degeneracy locus is exactly the relativistic mass
shell. -/

/-- `det D = m² − (E² − k²)`: the mass-shell function (kinetic minus mass²). -/
theorem det_carrier (E k m : ℝ) : (Dop E k m).det = m ^ 2 - (E ^ 2 - k ^ 2) := by
  rw [Dop_eq]; simp [Matrix.det_fin_two]; ring

/-- **Mass shell.**  The carrier is singular exactly on `E² = k² + m²`. -/
theorem mass_shell (E k m : ℝ) : (Dop E k m).det = 0 ↔ E ^ 2 = k ^ 2 + m ^ 2 := by
  rw [det_carrier]; constructor <;> intro h <;> nlinarith [h]

/-! ## The walk-Hamiltonian frame (coin ⊗ shift generator)

The same physics in the quantum-walk (Hamiltonian) frame: the one-step generator is
`H = k σ_z + m σ_x`, i.e. **kinetic = the null-disagreement `[c₊,c₋] = σ_z`** carrying
the shift momentum `k`, and **mass = the coin flip `σ_x = c₊ + c₋`** with amplitude
`m`.  Here the coin flip anticommutes with the shift, so in this frame the soldering
channel *does* vanish and the budget is manifestly positive:

    4 H² = 4k²·1 + 4m²·1  =  Q_A^H + Q_C + 4·Q_T + 4·E_#^H ,   Q_C = E_#^H = 0.

The energy `E` enters as the eigenvalue, and the mass shell `E² = k² + m²` is the
eigenvalue equation `det(E·1 − H) = 0`. -/

/-- The coin-flip operator `σ_x = c₊ + c₋` (the mass move of the walk). -/
def sigX : M2 := !![0, 1; 1, 0]

theorem sigX_eq_null_sum : sigX = cP + cM := by unfold sigX cP cM; mat

/-- The 1+1D Dirac-walk Hamiltonian `H = k·σ_z + m·σ_x`
= `k·[c₊,c₋] + m·(c₊+c₋)`. -/
def Hwalk (k m : ℝ) : M2 := k • sigZ + m • sigX

theorem Hwalk_from_edges (k m : ℝ) :
    Hwalk k m = k • (cP * cM - cM * cP) + m • (cP + cM) := by
  rw [Hwalk, ← null_disagreement, ← sigX_eq_null_sum]

/-- **Walk energy operator.**  `H² = (k² + m²)·1`: the coin flip anticommutes with the
shift, so kinetic² and mass² add with no cross term. -/
theorem Hwalk_sq (k m : ℝ) : Hwalk k m * Hwalk k m = (k ^ 2 + m ^ 2) • (1 : M2) := by
  unfold Hwalk sigZ sigX; mat

/-- **Positive four-channel budget in the walk frame.**  `4 H² = 4k²·1 + 4m²·1`,
with `Q_C = 0` and soldering `E_#^H = 0`. -/
theorem walk_budget (k m : ℝ) :
    (4 : ℝ) • (Hwalk k m * Hwalk k m)
      = (4 * k ^ 2) • (1 : M2) + Q_C + (4 : ℝ) • ((m ^ 2) • (1 : M2))
        + (4 : ℝ) • (0 : M2) := by
  rw [Hwalk_sq]; unfold Q_C; mat

/-- **Mass shell, walk frame.**  `det(E·1 − H) = 0 ↔ E² = k² + m²`: the energy is
on-shell exactly when it is an eigenvalue `±√(k²+m²)` of the walk generator. -/
theorem mass_shell_walk (E k m : ℝ) :
    ((E : ℝ) • (1 : M2) - Hwalk k m).det = 0 ↔ E ^ 2 = k ^ 2 + m ^ 2 := by
  have h : ((E : ℝ) • (1 : M2) - Hwalk k m) = !![E - k, -m; -m, E + k] := by
    unfold Hwalk sigZ sigX; mat
  rw [h]; simp [Matrix.det_fin_two]
  constructor <;> intro h <;> nlinarith [h]

/-! ## Axiom footprint

The proved theorems rest only on the permitted kernel axioms
`[propext, Classical.choice, Quot.sound]`. -/

#print axioms four_channel_budget
#print axioms aperture_is_kinetic
#print axioms turn_is_mass_squared
#print axioms soldering_form
#print axioms closure_vanishes
#print axioms mass_shell
#print axioms cP_null
#print axioms cM_null
#print axioms null_pairing
#print axioms null_disagreement
#print axioms kdag_Dop
#print axioms Hwalk_sq
#print axioms walk_budget
#print axioms mass_shell_walk

end DiracWalkCarrier
