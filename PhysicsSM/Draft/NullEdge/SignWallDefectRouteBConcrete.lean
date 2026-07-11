import PhysicsSM.Draft.NullEdge.SignWallDefectRouteB

/-!
# Route B, concrete derived instantiation (Paper C, pillar 3 — the C-gate rung)

This file lands the **concrete, derived** instantiation of the abstract
Route-B reflection-sector machinery of `SignWallDefectRouteB.lean`.  It runs
the complete chain

> derived site field with wall(s) → reflection sectoring → per-sector
> compressed determinant → engine query → (protected mode or its absence),

on a walk whose mass data is **derived from a site field by value-only
consumption** — no hand-inserted reflection (`σ_x`) coins.  We use the K6
palindromic register `walkQ` on `Fin 4 × Fin 2` (`SignWallDefect.Concrete`),
which is exactly unitary over `ℚ` and therefore lets every algebraic fact be
discharged by exact rational arithmetic (`decide` / `native_decide`) and then
transported verbatim into the `ℂ` framework where the abstract theorems live.

## The derived field

The coin at site `p` is the genuine `SO(2)` rotation
`R(θ_p) = [[cos, −sin],[sin, cos]]` with `cos = 4/5` and
`sin = s_p ∈ {+3/5, −3/5}`.  The sign of `s_p = sin(arg z_p)` is the only
information read from the field `z` — it is the sign of `Im z_p`, i.e. the
collinearity/`Plücker` sign of the underlying spinor pair, **not** an assigned
branch label.  A **two-wall** configuration `sWall = [+,+,−,+]` has the sine
sign flip at site `2` (walls on the bonds `1|2` and `2|3`); it is
reflection-symmetric (`s₁ = s₃`), so the edge-reversal grading `gradeQ` is an
exact chiral involution for the walk.  The **zero-wall control**
`sZero = [+,+,+,+]` is the constant field.

## The reflection sectoring

`Rrefl` is the spatial reflection through the `1–3` axis (swap sites `0 ↔ 2`,
identity on chirality).  We verify, by exact arithmetic, the full
`RouteB.Sectoring` package for the derived two-wall walk: `Rrefl² = 1`,
`[Rrefl, Wwall] = 0`, `[Rrefl, gradeQ] = 0`, chirality `Γ W Γ = Wᵀ`, and
unitarity `Wᵀ W = 1`.  These transport to the `ℂ` `RouteB.Sectoring` structure,
so the landed `routeB_global_det_pm_one` applies (global `det ∈ {±1}`).

## The per-sector compressed determinants — the honest outcome

`Rrefl` splits the register into an `R = +1` sector (dimension 6, isometry
`Bplus`: the two sites `1,3` fixed by the reflection plus the symmetric
combinations `e₀ + e₂`) and an `R = −1` sector (dimension 2, isometry
`Bminus`: the antisymmetric combinations `e₀ − e₂`).  Each sector is
`Wwall`-invariant (`Wwall · B = B · M`), so `Mplus`, `Mminus` are the honest
compressions of `Wwall` to the two sectors, and — because the sector bases
have full column rank — their determinants are the genuine determinants of the
restricted operators (basis-independent; for the abstract orthonormal
isometry `Wplus = Bᴴ W B` the value is identical).

**Computed result (exact):**

* two-wall walk:  `det Mplus = +1`,  `det Mminus = +1`;
* zero-wall control: `det Mplus₀ = +1`,  `det Mminus₀ = +1`.

So in this derived family the **per-sector determinant does not read the wall
parity**: every sector has determinant `+1`, both with and without the wall.
The `det = −1` hypothesis of `routeB_sector_flip_mode` is therefore **never
met** by a derived walk, and no reflection sector carries a determinant-forced
protected mode.  This is the honest scoping conclusion required by the task:
the reflection sector determinant is as blind to the derived wall as the
global determinant is (`signWalk_det_eq_one`).  The `Assigned` witness
(`assignedWall_det_eq_neg_one`, with a **hand-inserted** `σ_x` wall coin)
remains the only `det = −1` exhibit, and the abstract engine's firing on a
genuine `−1` sector is witnessed non-vacuously by
`RouteB.Witness.witness_flip_mode`.

Provenance: concrete Route-B instantiation by Aristotle project
`d749ad20-b67d-4283-b3ff-120939ceaf83` (run `1614ebf9`) on the K6
palindromic register with a value-only derived two-wall field; integrated
with local kernel re-check.  HONEST SCOPING RESULT: every reflection-sector
compressed determinant equals `+1` for the derived family, with and without
walls (`sector_dets_all_one`), so the det = -1 hypothesis of the abstract
protection theorem is never met by a derived walk in this family - the
sector determinant is blind to derived wall parity, mirroring the global
determinant kill one level down.  The remaining protection bridge for
derived walls is the trace-type (Lefschetz) sector index, a separate race.
Documented `native_decide` on explicit rational matrices (draft-trust per
repo policy).
-/

namespace SignWallDefect
namespace RouteBConcrete

open Concrete
open Matrix

/-! ## 1.  The derived two-wall walk and the reflection, over `ℚ` -/

/-- Constant cosine field `cos = 4/5` (the `3-4-5` coin). -/
def cW : Fin 4 → ℚ := fun _ => 4 / 5

/-- **Derived two-wall sine field.**  `sin = +3/5` except at the wall site `2`
where the collinearity sign flips to `-3/5`.  Value-only consumption: the sign
is `sign (Im z_p)`.  Reflection-symmetric (`s₁ = s₃`). -/
def sWall : Fin 4 → ℚ := ![3 / 5, 3 / 5, -3 / 5, 3 / 5]

/-- **Zero-wall control** sine field: constant `+3/5`. -/
def sZero : Fin 4 → ℚ := fun _ => 3 / 5

/-- The derived two-wall walk `W = S · C(cW, sWall) · S`. -/
def Wwall : Matrix V8 V8 ℚ := walkQ cW sWall

/-- The zero-wall control walk. -/
def Wzero : Matrix V8 V8 ℚ := walkQ cW sZero

/-- **Spatial reflection** through the `1–3` axis: swap sites `0 ↔ 2`, fix
`1,3`, identity on the chirality index. -/
def Rrefl : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = (![2, 1, 0, 3] : Fin 4 → Fin 4) j.1 ∧ i.2 = j.2 then 1 else 0

/-! ## 2.  The reflection-sectoring facts over `ℚ` (exact arithmetic) -/

theorem Rrefl_invol : Rrefl * Rrefl = 1 := by native_decide

theorem Wwall_unitary : Wwallᵀ * Wwall = 1 := by native_decide

theorem Wwall_chiral : gradeQ * Wwall * gradeQ = Wwallᵀ := by native_decide

theorem Rrefl_comm_Wwall : Rrefl * Wwall = Wwall * Rrefl := by native_decide

theorem Rrefl_comm_grade : Rrefl * gradeQ = gradeQ * Rrefl := by native_decide

theorem Wzero_unitary : Wzeroᵀ * Wzero = 1 := by native_decide

theorem Wzero_chiral : gradeQ * Wzero * gradeQ = Wzeroᵀ := by native_decide

theorem Rrefl_comm_Wzero : Rrefl * Wzero = Wzero * Rrefl := by native_decide

/-! ## 3.  Transport to `ℂ` and the abstract `RouteB.Sectoring` -/

/-- The entrywise `ℚ → ℂ` ring homomorphism on matrices. -/
noncomputable def toC : Matrix V8 V8 ℚ →+* Matrix V8 V8 ℂ := (algebraMap ℚ ℂ).mapMatrix

@[simp] theorem toC_apply (A : Matrix V8 V8 ℚ) (i j) :
    toC A i j = algebraMap ℚ ℂ (A i j) := rfl

theorem toC_conjTranspose (A : Matrix V8 V8 ℚ) :
    (toC A)ᴴ = toC Aᵀ := by
  ext i j
  simp [Matrix.conjTranspose_apply, Matrix.transpose_apply]

theorem toC_det (A : Matrix V8 V8 ℚ) :
    (toC A).det = algebraMap ℚ ℂ A.det :=
  (RingHom.map_det (algebraMap ℚ ℂ) A).symm

/-- **The derived two-wall walk carries a genuine reflection sectoring.** -/
theorem sectoring_wall :
    RouteB.Sectoring (toC Wwall) (toC gradeQ) (toC Rrefl) := by
  refine ⟨⟨?_, ?_⟩, ?_, ?_, ?_, ?_⟩
  · rw [← map_mul, control_grade_involution, map_one]
  · rw [← map_mul, ← map_mul, Wwall_chiral, toC_conjTranspose]
  · rw [toC_conjTranspose, ← map_mul, Wwall_unitary, map_one]
  · rw [← map_mul, Rrefl_invol, map_one]
  · rw [← map_mul, ← map_mul, Rrefl_comm_Wwall]
  · rw [← map_mul, ← map_mul, Rrefl_comm_grade]

/-- **The zero-wall control also carries the reflection sectoring.** -/
theorem sectoring_zero :
    RouteB.Sectoring (toC Wzero) (toC gradeQ) (toC Rrefl) := by
  refine ⟨⟨?_, ?_⟩, ?_, ?_, ?_, ?_⟩
  · rw [← map_mul, control_grade_involution, map_one]
  · rw [← map_mul, ← map_mul, Wzero_chiral, toC_conjTranspose]
  · rw [toC_conjTranspose, ← map_mul, Wzero_unitary, map_one]
  · rw [← map_mul, Rrefl_invol, map_one]
  · rw [← map_mul, ← map_mul, Rrefl_comm_Wzero]
  · rw [← map_mul, ← map_mul, Rrefl_comm_grade]

/-- **Global determinant `∈ {±1}`** for the derived two-wall walk, from the
landed core `routeB_global_det_pm_one` applied to the reflection sectoring. -/
theorem wall_global_det_pm_one :
    (toC Wwall).det = 1 ∨ (toC Wwall).det = -1 :=
  RouteB.routeB_global_det_pm_one sectoring_wall

/-! ## 4.  The sector isometries and compressed operators -/

/-- Isometry onto the `R = −1` sector (antisymmetric combinations
`e₀ − e₂`, one per chirality). -/
def Bminus : Matrix V8 (Fin 2) ℚ := Matrix.of fun x j =>
  (if x = ((0 : Fin 4), (j : Fin 2)) then 1 else 0)
    - (if x = ((2 : Fin 4), (j : Fin 2)) then 1 else 0)

/-- Isometry onto the `R = +1` sector (the two reflection-fixed sites `1,3`
plus the symmetric combinations `e₀ + e₂`). -/
def Bplus : Matrix V8 (Fin 6) ℚ := Matrix.of fun x j =>
  match j with
  | 0 => if x = ((1 : Fin 4), (0 : Fin 2)) then 1 else 0
  | 1 => if x = ((1 : Fin 4), (1 : Fin 2)) then 1 else 0
  | 2 => if x = ((3 : Fin 4), (0 : Fin 2)) then 1 else 0
  | 3 => if x = ((3 : Fin 4), (1 : Fin 2)) then 1 else 0
  | 4 => (if x = ((0 : Fin 4), (0 : Fin 2)) then 1 else 0)
          + (if x = ((2 : Fin 4), (0 : Fin 2)) then 1 else 0)
  | 5 => (if x = ((0 : Fin 4), (1 : Fin 2)) then 1 else 0)
          + (if x = ((2 : Fin 4), (1 : Fin 2)) then 1 else 0)

/-- The sector bases lie in the correct reflection eigenspaces. -/
theorem Rrefl_Bplus : Rrefl * Bplus = Bplus := by native_decide
theorem Rrefl_Bminus : Rrefl * Bminus = -Bminus := by native_decide

/-- The sector bases have full column rank (Gram matrices are invertible:
`Bplus` is `diag(1,1,1,1,2,2)`, `Bminus` is `2·I`). -/
theorem Bplus_gram :
    Bplusᵀ * Bplus = Matrix.of (fun i j : Fin 6 =>
      if i = j then (if (i : ℕ) < 4 then (1 : ℚ) else 2) else 0) := by native_decide
theorem Bminus_gram : Bminusᵀ * Bminus = (2 : ℚ) • (1 : Matrix (Fin 2) (Fin 2) ℚ) := by
  native_decide

/-- **Compressed `R = +1` operator** of the two-wall walk (exact `6×6`). -/
def Mplus : Matrix (Fin 6) (Fin 6) ℚ :=
  !![0, -3/5, 4/5, 0, 0, 0;
     -3/5, 0, 0, 4/5, 0, 0;
     4/5, 0, 0, 3/5, 0, 0;
     0, 4/5, 3/5, 0, 0, 0;
     0, 0, 0, 0, 4/5, -3/5;
     0, 0, 0, 0, 3/5, 4/5]

/-- **Compressed `R = −1` operator** of the two-wall walk (exact `2×2`). -/
def Mminus : Matrix (Fin 2) (Fin 2) ℚ := !![-4/5, -3/5; 3/5, -4/5]

/-- `Bplus` intertwines `Wwall` with its `+`-sector compression: the sector is
`Wwall`-invariant and `Mplus` is the honest restricted operator. -/
theorem Wwall_Bplus : Wwall * Bplus = Bplus * Mplus := by native_decide
/-- `Bminus` intertwines `Wwall` with its `−`-sector compression. -/
theorem Wwall_Bminus : Wwall * Bminus = Bminus * Mminus := by native_decide

/-- **Per-sector compressed determinant, `R = +1` sector: `+1`.** -/
theorem Mplus_det : Mplus.det = 1 := by native_decide
/-- **Per-sector compressed determinant, `R = −1` sector: `+1`.** -/
theorem Mminus_det : Mminus.det = 1 := by native_decide

/-! ## 5.  The zero-wall control sectors -/

/-- Compressed `R = +1` operator of the control walk. -/
def Mplus0 : Matrix (Fin 6) (Fin 6) ℚ :=
  !![0, -3/5, 4/5, 0, 0, 0;
     3/5, 0, 0, 4/5, 0, 0;
     4/5, 0, 0, -3/5, 0, 0;
     0, 4/5, 3/5, 0, 0, 0;
     0, 0, 0, 0, 4/5, -3/5;
     0, 0, 0, 0, 3/5, 4/5]

/-- Compressed `R = −1` operator of the control walk. -/
def Mminus0 : Matrix (Fin 2) (Fin 2) ℚ := !![-4/5, -3/5; 3/5, -4/5]

theorem Wzero_Bplus : Wzero * Bplus = Bplus * Mplus0 := by native_decide
theorem Wzero_Bminus : Wzero * Bminus = Bminus * Mminus0 := by native_decide

/-- **Control per-sector determinant, `R = +1` sector: `+1`.** -/
theorem Mplus0_det : Mplus0.det = 1 := by native_decide
/-- **Control per-sector determinant, `R = −1` sector: `+1`.** -/
theorem Mminus0_det : Mminus0.det = 1 := by native_decide

/-! ## 6.  The honest scoping conclusion -/

/-- **The C-gate scoping result.**  For the derived two-wall walk *and* for the
zero-wall control, both reflection-sector compressed determinants equal `+1`.
Hence the reflection sector determinant does **not** read the derived wall
parity, and the `det = −1` hypothesis of `routeB_sector_flip_mode` is never
met by a derived walk: no reflection sector carries a determinant-forced
protected mode.  (The `Assigned` witness, with a hand-inserted `σ_x` coin,
remains the sole `det = −1` exhibit; the abstract engine's firing on a genuine
`−1` sector is witnessed by `RouteB.Witness.witness_flip_mode`.) -/
theorem sector_dets_all_one :
    Mplus.det = 1 ∧ Mminus.det = 1 ∧ Mplus0.det = 1 ∧ Mminus0.det = 1 :=
  ⟨Mplus_det, Mminus_det, Mplus0_det, Mminus0_det⟩

end RouteBConcrete
end SignWallDefect
