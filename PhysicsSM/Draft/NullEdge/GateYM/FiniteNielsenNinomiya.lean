import Mathlib

/-!
# The finite (1D) Nielsen–Ninomiya TOPOLOGICAL SKELETON on a discrete Brillouin torus

This file develops an **honest, kernel-checked, finite** version of the
topological *ingredients* behind the Nielsen–Ninomiya theorem, on the
*one-dimensional* discrete Brillouin torus `ZMod N`.  It deliberately does **not**
claim the full 4D continuum Nielsen–Ninomiya theorem.

**SCOPE / AUDIT CAVEAT (semantic audit 2026-07-06, job `7805c7f8`).** This is a
genuine improvement over the withdrawn `DoublingTurnPrice` framing, but its own
"no-go + necessity" headline is BROADER than the formal content, so read it as a
topological SKELETON, not a proof of "chiral symmetry ⟹ zero signed count":
- `signed_sum_telescope` is a GENERIC telescoping identity for a FREE parameter
  `h : ZMod N → ℤ`; it is never tied to `ChiralSym`/`γ5`/`fCanon`, so the
  "chirality" reading is by naming, not proof.
- `signedNodeCount4_eq_zero` runs on the HAND-WRITTEN vector
  `naiveSin4 = ![0,1,0,-1]`; the chirality/node/count-`0` are honestly computed
  FROM that vector (not a bare tautology), but the "genuine naive dispersion ⟹
  doubler at p=2" link is STIPULATED, not derived. (Indeed `fCanon_eq_zero_iff`
  shows the forward-difference symbol `exp(2πip/N)-1` has a SINGLE zero.)
- `odd_signedCount_impossible` is VACUOUS: its hypothesis `Odd (∑ (h(p+1)-h p))`
  is unsatisfiable for every `h` (the sum is identically `0` by
  `signed_sum_telescope`), it carries NO `ChiralSym` hypothesis, and its "requires
  a Wilson term / necessity" reading lives only in prose.
The SOUND, citable pieces are `winding_exists`/`winding`/`winding_eq` (genuine
integer winding, not forced to 0), `chiralSym_iff_offDiag`/`chiralSym_offDiag_form`/
`gamma5_sq`/`trace_gamma5`, and the kernel-`decide` computation
`signedNodeCount4_eq_zero` (read as a computed EXAMPLE). The genuine necessity
theorem (signed count DEFINED from a chirally-symmetric `D`, with an explicit
`ChiralSym (D p)` hypothesis) is an OPEN follow-up; see `JOB_BACKLOG.md`.

Everything here is the 1D finite lattice version, with clearly separated "fully
proved" and "informal generalization" parts.

## Physical setup

We use `2×2` complex matrices with the chirality involution
`γ5 = ![![1,0],![0,-1]]`.  A *lattice Dirac symbol* is a function
`D : ZMod N → Matrix (Fin 2) (Fin 2) ℂ`.  *Chiral symmetry* is `{γ5, D p} = 0`,
equivalently `γ5 * D p * γ5 = - D p`, which forces each `D p` to be **off
diagonal**: `D p = ![![0, f p],![g p, 0]]`.

## What is proved (sorry-free)

* `gamma5_sq`, `trace_gamma5` : `γ5^2 = 1`, `tr γ5 = 0`.
* `chiralSym_iff_offDiag`, `chiralSym_offDiag_form` : chiral symmetry ⇔ off diagonal.
* `winding_exists` : the discrete winding total
  `∑_p arg (f(p+1)/f p)` of a nowhere-zero symbol `f` is an **integer multiple of
  `2π`** (well-definedness of the winding number).
* `winding_eq` : with the integer-valued `winding f`, `windingSum f = 2π · winding f`.
* `fCanon_eq_zero_iff` : the standard naive symbol `f p = exp(2πi p/N) - 1` has
  zeros exactly at `p = 0`.
* **Concrete `N = 4` no-go** (`signedNodeCount4_eq_zero` etc.): the naive real
  dispersion `sin(2π p/4) = ![0,1,0,-1]` has a node at `p = 0` of chirality `+1`
  and its Brillouin-zone doubler at `p = 2` of chirality `-1`; the
  chirality-weighted count of nodes is **exactly `0`**, fully computed by `decide`.
* `signed_sum_telescope` : the general **boundaryless** identity — the signed sum
  of any discrete chirality/branch density over the closed loop `ZMod N` is `0`.
* `odd_signedCount_impossible` : necessity corollary — an odd signed chirality
  count is impossible, so lifting a lone Weyl node requires breaking `{γ5,D}=0`.

## Honesty note

The `winding` number of a *nowhere-zero* symbol `f` can be any integer (this is
the SSH topological invariant); it is **not** forced to be zero.  What *is* forced
to vanish is the signed count assembled from a globally consistent
phase/chirality branch around the boundaryless loop, which is exactly
`signed_sum_telescope`.  The full continuum degree-theoretic argument in `d`
dimensions is outside the scope of this finite 1D file and is discussed only
informally at the end.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.FiniteNielsenNinomiya

open Complex Matrix BigOperators
open scoped Real

/-! ## 1. The chirality involution `γ5` and chiral symmetry -/

/-- The chirality involution `γ5 = diag(1, -1)`. -/
def gamma5 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

@[simp] theorem gamma5_sq : gamma5 * gamma5 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [gamma5, Matrix.mul_apply, Fin.sum_univ_two]

@[simp] theorem trace_gamma5 : Matrix.trace gamma5 = 0 := by
  simp [gamma5, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/-- Chiral symmetry of a Dirac symbol block: `{γ5, D} = 0`, i.e.
`γ5 * D * γ5 = - D`. -/
def ChiralSym (D : Matrix (Fin 2) (Fin 2) ℂ) : Prop := gamma5 * D * gamma5 = - D

/-- Conjugating any `2×2` matrix by `γ5` flips the sign of the off-diagonal
entries and keeps the diagonal ones. -/
theorem gamma5_conj (D : Matrix (Fin 2) (Fin 2) ℂ) :
    gamma5 * D * gamma5 = !![D 0 0, - D 0 1; - D 1 0, D 1 1] := by
  rw [Matrix.eta_fin_two D]
  simp only [gamma5, Matrix.mul_fin_two]
  norm_num

/-- **Chiral symmetry ⇔ off-diagonal.**  `{γ5, D} = 0` holds iff both diagonal
entries of `D` vanish. -/
theorem chiralSym_iff_offDiag (D : Matrix (Fin 2) (Fin 2) ℂ) :
    ChiralSym D ↔ D 0 0 = 0 ∧ D 1 1 = 0 := by
  unfold ChiralSym
  rw [gamma5_conj, Matrix.eta_fin_two (- D)]
  constructor
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    have h11 := congrFun (congrFun h 1) 1
    simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.neg_apply] at h00 h11
    constructor
    · linear_combination (h00) / 2
    · linear_combination (h11) / 2
  · rintro ⟨h0, h1⟩
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.neg_apply, h0, h1]

/-- The explicit off-diagonal form forced by chiral symmetry:
`D = ![![0, f],![g, 0]]`. -/
theorem chiralSym_offDiag_form {D : Matrix (Fin 2) (Fin 2) ℂ} (h : ChiralSym D) :
    D = !![0, D 0 1; D 1 0, 0] := by
  obtain ⟨h0, h1⟩ := (chiralSym_iff_offDiag D).mp h
  ext i j; fin_cases i <;> fin_cases j <;> simp [h0, h1]

/-! ## 2. The discrete winding number and its well-definedness -/

/-- Coercion `ℝ → Real.Angle` commutes with finite sums over `ZMod N`. -/
theorem coe_angle_sum {N : ℕ} [NeZero N] (g : ZMod N → ℝ) :
    ((∑ p : ZMod N, g p : ℝ) : Real.Angle) = ∑ p : ZMod N, ((g p : ℝ) : Real.Angle) := by
  induction (Finset.univ : Finset (ZMod N)) using Finset.induction with
  | empty => simp
  | insert h ih => simp [Finset.sum_insert, *]

/-- **Well-definedness of the discrete winding.**  For a *nowhere-zero* symbol
`f : ZMod N → ℂ`, the total discrete arg-increment
`∑_p arg (f(p+1)/f p)` is an integer multiple of `2π`.  This is the discrete,
telescoping winding number: the product `∏_p f(p+1)/f p = 1` forces the total
angle to close up. -/
theorem winding_exists {N : ℕ} [NeZero N] (f : ZMod N → ℂ) (hf : ∀ p, f p ≠ 0) :
    ∃ k : ℤ, (∑ p : ZMod N, (f (p + 1) / f p).arg) = 2 * π * k := by
  have hangle : ((∑ p : ZMod N, (f (p + 1) / f p).arg : ℝ) : Real.Angle) = 0 := by
    rw [coe_angle_sum]
    have hstep : ∀ p : ZMod N, (((f (p + 1) / f p).arg : ℝ) : Real.Angle)
        = ((f (p + 1)).arg : Real.Angle) - ((f p).arg : Real.Angle) := by
      intro p; exact Complex.arg_div_coe_angle (hf _) (hf _)
    simp_rw [hstep]
    rw [Finset.sum_sub_distrib]
    have hshift : (∑ p : ZMod N, ((f (p + 1)).arg : Real.Angle))
        = ∑ p : ZMod N, ((f p).arg : Real.Angle) :=
      Fintype.sum_equiv (Equiv.addRight (1 : ZMod N)) _ _ (fun p => rfl)
    rw [hshift, sub_self]
  rw [Real.Angle.coe_eq_zero_iff] at hangle
  obtain ⟨n, hn⟩ := hangle
  exact ⟨n, by rw [← hn, zsmul_eq_mul]; ring⟩

/-- The total discrete arg-increment of a symbol `f` around the torus. -/
noncomputable def windingSum {N : ℕ} [NeZero N] (f : ZMod N → ℂ) : ℝ :=
  ∑ p : ZMod N, (f (p + 1) / f p).arg

/-- The integer-valued discrete winding number. -/
noncomputable def winding {N : ℕ} [NeZero N] (f : ZMod N → ℂ) : ℤ :=
  round (windingSum f / (2 * π))

/-- For a nowhere-zero symbol the winding total equals `2π · winding f`, so
`winding f` is the genuine integer winding number. -/
theorem winding_eq {N : ℕ} [NeZero N] (f : ZMod N → ℂ) (hf : ∀ p, f p ≠ 0) :
    windingSum f = 2 * π * winding f := by
  obtain ⟨k, hk⟩ := winding_exists f hf
  have h2 : (2 : ℝ) * π ≠ 0 := by positivity
  have hks : windingSum f = 2 * π * (k : ℝ) := hk
  rw [winding, hks, show (2 * π * (k : ℝ)) / (2 * π) = (k : ℝ) by field_simp, round_intCast]

/-! ## 3. The concrete no-go instance (fully computed, sorry-free) -/

/-- The standard naive lattice symbol `f p = exp(2πi p/N) - 1` (the discrete
`e^{ik} - 1 ≈ i k` forward-difference dispersion). -/
noncomputable def fCanon (N : ℕ) (p : ZMod N) : ℂ :=
  Complex.exp (2 * π * Complex.I * (p.val : ℂ) / (N : ℂ)) - 1

/-- **Zeros of the naive symbol.**  `f p = exp(2πi p/N) - 1` vanishes exactly at
the origin `p = 0` of the Brillouin torus. -/
theorem fCanon_eq_zero_iff (N : ℕ) [NeZero N] (p : ZMod N) :
    fCanon N p = 0 ↔ p = 0 := by
  have hN : (N : ℂ) ≠ 0 := by exact_mod_cast NeZero.ne N
  rw [fCanon, sub_eq_zero, Complex.exp_eq_one_iff]
  constructor
  · rintro ⟨n, hn⟩
    field_simp at hn
    have hz : (p.val : ℤ) = (N : ℤ) * n := by exact_mod_cast hn
    have hdvd : N ∣ p.val := by
      have : (N : ℤ) ∣ (p.val : ℤ) := ⟨n, hz⟩
      exact_mod_cast this
    exact (ZMod.val_eq_zero p).mp (Nat.eq_zero_of_dvd_of_lt hdvd (ZMod.val_lt p))
  · rintro rfl
    exact ⟨0, by simp⟩

/-- Integer sign function. -/
def sgnZ (q : ℤ) : ℤ := if 0 < q then 1 else if q < 0 then -1 else 0

/-- The genuine naive (symmetric-difference, Hermitian & chirally symmetric)
real dispersion `sin(2π p/4)` on the `N = 4` torus, taking the exact values
`sin(0), sin(π/2), sin(π), sin(3π/2) = 0, 1, 0, -1`.  Its off-diagonal Dirac
block is `D p = ![![0, i·s p],![-i·s p, 0]]`, which is chirally symmetric.  (The
forward-difference building block `fCanon` above is the non-Hermitian half of
this symmetric difference.) -/
def naiveSin4 : ZMod 4 → ℤ := ![0, 1, 0, -1]

/-- Chirality of a node at momentum `p`: the sign of the central (symmetric)
difference `s(p+1) - s(p-1)`, i.e. whether the dispersion crosses zero upward
(`+1`, right-handed) or downward (`-1`, left-handed). -/
def chirality4 (p : ZMod 4) : ℤ := sgnZ (naiveSin4 (p + 1) - naiveSin4 (p - 1))

/-- The chirality-weighted count of nodes over the whole `N = 4` Brillouin torus. -/
def signedNodeCount4 : ℤ :=
  ∑ p : ZMod 4, if naiveSin4 p = 0 then chirality4 p else 0

/-- The set of nodes of the naive symbol is exactly `{0, 2}`: the physical node
at the origin and its Brillouin-zone doubler at the corner `p = N/2 = 2`. -/
theorem nodes4 :
    (Finset.univ.filter fun p : ZMod 4 => naiveSin4 p = 0) = {0, 2} := by decide

/-- The origin node `p = 0` has chirality `+1` (right-handed / upward crossing). -/
theorem chirality4_zero : chirality4 0 = 1 := by decide

/-- The doubler node `p = 2` has chirality `-1` (left-handed / downward crossing). -/
theorem chirality4_two : chirality4 2 = -1 := by decide

/-- **Computed `N = 4` example (kernel `decide`).**  For the hand-written vector
`naiveSin4 = ![0,1,0,-1]` (the intended stand-in for the naive `sin(2πp/4)`
dispersion), the chirality-weighted node count is exactly `0`: a `+1` node at
`p = 0` and a `-1` doubler at `p = 2`. CAVEAT (audit `7805c7f8`): `naiveSin4` is
STIPULATED, not derived from a dispersion (the forward-difference symbol
`fCanon` actually has a SINGLE zero, `fCanon_eq_zero_iff`), so read this as a
computed EXAMPLE of the `+1`/`-1` doubler cancellation, not a proof that a
chirally symmetric symbol must have signed count `0`. -/
theorem signedNodeCount4_eq_zero : signedNodeCount4 = 0 := by decide

/-! ## 4. The general boundaryless statement and the necessity corollary -/

/-- **Boundaryless telescoping (generic).**  For *any* `ℤ`-valued function
`h : ZMod N → ℤ`, `∑_p (h(p+1) - h p) = 0` (a total difference telescopes on the
boundaryless cyclic group).  CAVEAT (audit `7805c7f8`): `h` is a FREE parameter -
this lemma is NOT tied to `ChiralSym`/`γ5`; the "chirality/winding branch" reading
is the intended interpretation, not part of the proof. It is the honest 1D
topological SKELETON of "sum of chiralities = 0", not a proof of it for an actual
chirally-symmetric Dirac symbol (that would define `h` FROM such a `D`). -/
theorem signed_sum_telescope {N : ℕ} [NeZero N] (h : ZMod N → ℤ) :
    ∑ p : ZMod N, (h (p + 1) - h p) = 0 := by
  rw [Finset.sum_sub_distrib]
  have hshift : (∑ p : ZMod N, h (p + 1)) = ∑ p : ZMod N, h p :=
    Fintype.sum_equiv (Equiv.addRight (1 : ZMod N)) _ _ (fun p => rfl)
  rw [hshift, sub_self]

/-- **Odd telescoping sum is impossible (VACUOUS necessity skeleton).**  Since
`∑_p (h(p+1)-h p) = 0` for every `h`, the hypothesis `Odd (∑ …)` is
UNSATISFIABLE, so this theorem is vacuously true. CAVEAT (audit `7805c7f8`): it
carries NO `ChiralSym` hypothesis and is the contrapositive of the generic
telescoping fact - the "requires a Wilson term / necessity" reading is prose only,
NOT formalized. The genuine necessity statement (an explicit `ChiralSym (D p)`
hypothesis with the signed count DEFINED from `D`'s off-diagonal branch) is an
open follow-up. -/
theorem odd_signedCount_impossible {N : ℕ} [NeZero N] (h : ZMod N → ℤ)
    (hodd : Odd (∑ p : ZMod N, (h (p + 1) - h p))) : False := by
  rw [signed_sum_telescope] at hodd
  simp at hodd

/-!
### Informal generalization (out of scope of this finite file)

The full continuum Nielsen–Ninomiya no-go states that for a chirally symmetric
lattice Dirac operator on the `d`-dimensional Brillouin torus `Tᵈ` with isolated
simple zeros, the sum of the chiralities of the zeros vanishes.  The argument is
degree-theoretic: the chirality of a zero is the local degree of the map
`k ↦ D(k)` near that zero, and the sum of local degrees over a *closed* manifold
without boundary equals the total degree, which is a boundary term and hence `0`
(equivalently, the Euler-characteristic / index density integrates to a boundary
that vanishes on `Tᵈ`).

`signed_sum_telescope` is precisely the finite 1D avatar of this: the "total
degree" is the telescoping sum of a globally consistent branch `h` around the
loop, and it is forced to `0` by the absence of a boundary.  The higher
dimensional degree machinery is not developed here.
-/

end PhysicsSM.Draft.NullEdge.GateYM.FiniteNielsenNinomiya
