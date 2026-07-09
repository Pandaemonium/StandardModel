import Mathlib

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# F2 — Carrier rigidity: is the four-block square forced?

This file investigates the rigidity question for the finite null-edge Dirac carrier

  `D = c₁∇₁ + c₂∇₂ + Γφ`      (two edges)

over a Krein (indefinite) inner product, whose **Krein adjoint** `#` is modeled by a
`StarRing` structure (an involutive antiautomorphism `star`), with

  * `cₑ² = 0`               (null soldering),
  * `Γ² = 1`, `star Γ = Γ`   (chiral grading, Krein–self-adjoint),
  * `{Γ, cₑ} = 0`            (grading anticommutes with the solderings),
  * `[Γ, ∇ₑ] = [Γ, φ] = 0`   (transports and turn are grade-even),
  * `star φ = φ`             (the turn is Krein–self-adjoint).

The program claims `D# D` decomposes into four "force-shaped" channels:
aperture `Q_A` (metric `g(∇,∇)`), closure `Q_C` (signed `[c,c][∇,∇]`), turn
`Q_T = φ²`, soldering `E_#`.

## Verdict — NON-RIGID, with a precise obstruction (see `ARISTOTLE_SUMMARY.md`)

The carrier axioms supply exactly one grading — the chiral `Γ` parity — together
with the Krein adjoint `#`.  We prove:

* `square_decomposition`: the exact four-block identity
  `2 • (D# D) = Q_A + Q_C + 2•E_# + 2•Q_T` — no fifth block.
* All four channels are `#`-self-adjoint (`*_selfadjoint`).
* Γ-parity: `Q_A, Q_C, Q_T` are **Γ-even**; `E_#` is **Γ-odd** (`*_even`, `solder_odd`).
* Consequently the *only* structural datum the axioms provide (the `(Γ,#)` type)
  assigns `Q_A`, `Q_C`, `Q_T` the **same** type (even, self-adjoint); the grading
  isolates **only** the soldering block (`square_oddPart`, `square_evenPart`).
* The Γ-parity (2-block) split is genuinely forced: `parity_decomposition_unique`.
* Concretely (`Concrete` section: an explicit 4×4 rational Krein carrier satisfying
  *all* axioms) `Q_A`, `Q_C`, `Q_T` are **pairwise distinct nonzero** operators of the
  *same* `(Γ,#)`-type, so the chiral grading provably **cannot** separate the
  aperture / closure / turn channels.

Hence the four-block split is **not forced** by the stated axioms: two extra
selecting structures are required — a solder-degree (number of `c`-letters: `Q_T` has
0, `Q_A`/`Q_C` have 2) and an edge-index symmetrization (`Q_A` symmetric,
`Q_C` antisymmetric). Only after adding these is the split rigid. The *count* of
channel types is nonetheless rigid: everything lives in the two `Γ`-graded sectors.
-/

namespace CarrierRigidity

/-! ## Abstract carrier over a `StarRing` (the Krein adjoint) -/

section Carrier

variable {R : Type*} [Ring R] [StarRing R]

/-- The two-edge carrier `D = c₁∇₁ + c₂∇₂ + Γφ`. -/
def Dop (c1 c2 g1 g2 Γ φ : R) : R := c1 * g1 + c2 * g2 + Γ * φ

/-- Turn channel `Q_T = φ# φ  (= φ² when `star φ = φ`)`. -/
def turnQ (φ : R) : R := star φ * φ

/-- Aperture channel `Q_A = Σ ∇ₑ# {cₑ#, c_f} ∇_f`  (edge-symmetric solder metric). -/
def apertureQ (c1 c2 g1 g2 : R) : R :=
  star g1 * (star c1 * c1 + star c1 * c1) * g1
  + star g1 * (star c1 * c2 + star c2 * c1) * g2
  + star g2 * (star c2 * c1 + star c1 * c2) * g1
  + star g2 * (star c2 * c2 + star c2 * c2) * g2

/-- Closure channel `Q_C = Σ ∇ₑ# [cₑ#, c_f]₋ ∇_f`  (edge-antisymmetric part). -/
def closureQ (c1 c2 g1 g2 : R) : R :=
  star g1 * (star c1 * c2 - star c2 * c1) * g2
  + star g2 * (star c2 * c1 - star c1 * c2) * g1

/-- Soldering channel `E_#`  (the `c`–`φ` cross term). -/
def solderE (c1 c2 g1 g2 Γ φ : R) : R :=
  star g1 * star c1 * (Γ * φ) + star g2 * star c2 * (Γ * φ)
  + (φ * Γ) * (c1 * g1) + (φ * Γ) * (c2 * g2)

/-- **The four-block square identity — no fifth block.**
`2·(D# D) = Q_A + Q_C + 2·E_# + 2·Q_T`. -/
theorem square_decomposition (c1 c2 g1 g2 Γ φ : R)
    (gsq : Γ * Γ = 1) (gstar : star Γ = Γ) (fstar : star φ = φ) :
    2 * (star (Dop c1 c2 g1 g2 Γ φ) * Dop c1 c2 g1 g2 Γ φ)
      = apertureQ c1 c2 g1 g2 + closureQ c1 c2 g1 g2
        + 2 * solderE c1 c2 g1 g2 Γ φ + 2 * turnQ φ := by
  simp only [Dop, turnQ, apertureQ, closureQ, solderE, star_add, star_mul, gstar, fstar,
    mul_add, add_mul, mul_assoc, mul_sub, sub_mul]
  rw [show φ * (Γ * (Γ * φ)) = φ * φ by rw [← mul_assoc Γ Γ φ, gsq, one_mul]]
  noncomm_ring

/-! ### `#`-self-adjointness of the four channels -/

theorem aperture_selfadjoint (c1 c2 g1 g2 : R) :
    star (apertureQ c1 c2 g1 g2) = apertureQ c1 c2 g1 g2 := by
  simp only [apertureQ, star_add, star_mul, star_star]; noncomm_ring

theorem closure_selfadjoint (c1 c2 g1 g2 : R) :
    star (closureQ c1 c2 g1 g2) = closureQ c1 c2 g1 g2 := by
  simp only [closureQ, star_add, star_mul, star_star, star_sub]; noncomm_ring

theorem turn_selfadjoint (φ : R) (fstar : star φ = φ) :
    star (turnQ φ) = turnQ φ := by
  simp only [turnQ, star_mul, fstar]

theorem solder_selfadjoint (c1 c2 g1 g2 Γ φ : R) (gstar : star Γ = Γ) (fstar : star φ = φ) :
    star (solderE c1 c2 g1 g2 Γ φ) = solderE c1 c2 g1 g2 Γ φ := by
  simp only [solderE, star_add, star_mul, star_star, gstar, fstar]; noncomm_ring

/-! ### Γ-parity of the four channels.
`Q_A, Q_C, Q_T` commute with `Γ` (even); `E_#` anticommutes (odd). -/

omit [StarRing R] in
private theorem comm_mul {Γ a b : R} (ha : Γ * a = a * Γ) (hb : Γ * b = b * Γ) :
    Γ * (a * b) = (a * b) * Γ := by
  rw [← mul_assoc, ha, mul_assoc, hb, ← mul_assoc]

omit [StarRing R] in
private theorem anti_anti_mul {Γ a b : R} (ha : Γ * a = -(a * Γ)) (hb : Γ * b = -(b * Γ)) :
    Γ * (a * b) = (a * b) * Γ := by
  rw [← mul_assoc, ha, neg_mul, mul_assoc, hb, mul_neg, neg_neg, ← mul_assoc]

omit [StarRing R] in
private theorem comm_anti_mul {Γ a b : R} (ha : Γ * a = a * Γ) (hb : Γ * b = -(b * Γ)) :
    Γ * (a * b) = -((a * b) * Γ) := by
  rw [← mul_assoc, ha, mul_assoc, hb, mul_neg, ← mul_assoc]

omit [StarRing R] in
private theorem anti_comm_mul {Γ a b : R} (ha : Γ * a = -(a * Γ)) (hb : Γ * b = b * Γ) :
    Γ * (a * b) = -((a * b) * Γ) := by
  rw [← mul_assoc, ha, neg_mul, mul_assoc, hb, ← mul_assoc]

omit [StarRing R] in
private theorem comm_add {Γ a b : R} (ha : Γ * a = a * Γ) (hb : Γ * b = b * Γ) :
    Γ * (a + b) = (a + b) * Γ := by rw [mul_add, add_mul, ha, hb]

omit [StarRing R] in
private theorem comm_sub {Γ a b : R} (ha : Γ * a = a * Γ) (hb : Γ * b = b * Γ) :
    Γ * (a - b) = (a - b) * Γ := by rw [mul_sub, sub_mul, ha, hb]

/-- Krein adjoints of the solderings inherit the anticommutation with `Γ`. -/
private theorem star_c_anti {Γ c : R} (gstar : star Γ = Γ) (hc : Γ * c = -(c * Γ)) :
    Γ * star c = -(star c * Γ) := by
  have h := congrArg star hc
  simp only [star_mul, gstar, star_neg] at h
  rw [h, neg_neg]

/-- Krein adjoints of the transports inherit the commutation with `Γ`. -/
private theorem star_g_comm {Γ g : R} (gstar : star Γ = Γ) (hg : Γ * g = g * Γ) :
    Γ * star g = star g * Γ := by
  have := congrArg star hg
  simpa [star_mul, gstar] using this.symm

theorem aperture_even (c1 c2 g1 g2 Γ : R) (gstar : star Γ = Γ)
    (hc1 : Γ * c1 = -(c1 * Γ)) (hc2 : Γ * c2 = -(c2 * Γ))
    (hg1 : Γ * g1 = g1 * Γ) (hg2 : Γ * g2 = g2 * Γ) :
    Γ * apertureQ c1 c2 g1 g2 = apertureQ c1 c2 g1 g2 * Γ := by
  have hsc1 := star_c_anti gstar hc1
  have hsc2 := star_c_anti gstar hc2
  have hsg1 := star_g_comm gstar hg1
  have hsg2 := star_g_comm gstar hg2
  have e11 : Γ * (star c1 * c1) = (star c1 * c1) * Γ := anti_anti_mul hsc1 hc1
  have e12 : Γ * (star c1 * c2) = (star c1 * c2) * Γ := anti_anti_mul hsc1 hc2
  have e21 : Γ * (star c2 * c1) = (star c2 * c1) * Γ := anti_anti_mul hsc2 hc1
  have e22 : Γ * (star c2 * c2) = (star c2 * c2) * Γ := anti_anti_mul hsc2 hc2
  unfold apertureQ
  exact comm_add (comm_add (comm_add
    (comm_mul (comm_mul hsg1 (comm_add e11 e11)) hg1)
    (comm_mul (comm_mul hsg1 (comm_add e12 e21)) hg2))
    (comm_mul (comm_mul hsg2 (comm_add e21 e12)) hg1))
    (comm_mul (comm_mul hsg2 (comm_add e22 e22)) hg2)

theorem closure_even (c1 c2 g1 g2 Γ : R) (gstar : star Γ = Γ)
    (hc1 : Γ * c1 = -(c1 * Γ)) (hc2 : Γ * c2 = -(c2 * Γ))
    (hg1 : Γ * g1 = g1 * Γ) (hg2 : Γ * g2 = g2 * Γ) :
    Γ * closureQ c1 c2 g1 g2 = closureQ c1 c2 g1 g2 * Γ := by
  have hsc1 := star_c_anti gstar hc1
  have hsc2 := star_c_anti gstar hc2
  have hsg1 := star_g_comm gstar hg1
  have hsg2 := star_g_comm gstar hg2
  have e12 : Γ * (star c1 * c2) = (star c1 * c2) * Γ := anti_anti_mul hsc1 hc2
  have e21 : Γ * (star c2 * c1) = (star c2 * c1) * Γ := anti_anti_mul hsc2 hc1
  unfold closureQ
  exact comm_add
    (comm_mul (comm_mul hsg1 (comm_sub e12 e21)) hg2)
    (comm_mul (comm_mul hsg2 (comm_sub e21 e12)) hg1)

theorem turn_even (Γ φ : R) (hf : Γ * φ = φ * Γ) (fstar : star φ = φ) :
    Γ * turnQ φ = turnQ φ * Γ := by
  have hsf : Γ * star φ = star φ * Γ := by rw [fstar]; exact hf
  unfold turnQ
  exact comm_mul hsf hf

theorem solder_odd (c1 c2 g1 g2 Γ φ : R) (gstar : star Γ = Γ)
    (hc1 : Γ * c1 = -(c1 * Γ)) (hc2 : Γ * c2 = -(c2 * Γ))
    (hg1 : Γ * g1 = g1 * Γ) (hg2 : Γ * g2 = g2 * Γ) (hf : Γ * φ = φ * Γ) :
    Γ * solderE c1 c2 g1 g2 Γ φ = -(solderE c1 c2 g1 g2 Γ φ * Γ) := by
  have hsc1 := star_c_anti gstar hc1
  have hsc2 := star_c_anti gstar hc2
  have hsg1 := star_g_comm gstar hg1
  have hsg2 := star_g_comm gstar hg2
  have hgf : Γ * (Γ * φ) = (Γ * φ) * Γ := comm_mul rfl hf
  have hfg : Γ * (φ * Γ) = (φ * Γ) * Γ := comm_mul hf rfl
  have oddA : Γ * (star g1 * star c1 * (Γ * φ)) = -((star g1 * star c1 * (Γ * φ)) * Γ) :=
    anti_comm_mul (comm_anti_mul hsg1 hsc1) hgf
  have oddB : Γ * (star g2 * star c2 * (Γ * φ)) = -((star g2 * star c2 * (Γ * φ)) * Γ) :=
    anti_comm_mul (comm_anti_mul hsg2 hsc2) hgf
  have oddC : Γ * ((φ * Γ) * (c1 * g1)) = -(((φ * Γ) * (c1 * g1)) * Γ) :=
    comm_anti_mul hfg (anti_comm_mul hc1 hg1)
  have oddD : Γ * ((φ * Γ) * (c2 * g2)) = -(((φ * Γ) * (c2 * g2)) * Γ) :=
    comm_anti_mul hfg (anti_comm_mul hc2 hg2)
  unfold solderE
  rw [mul_add, mul_add, mul_add, add_mul, add_mul, add_mul, oddA, oddB, oddC, oddD]
  abel

end Carrier

/-! ## The Γ-parity (2-block) split is forced -/

section Parity

variable {R : Type*} [Ring R] [Invertible (2 : R)]

/-- The Γ-even projection `½(x + ΓxΓ)`. -/
def evenPart (Γ x : R) : R := ⅟(2 : R) * (x + Γ * x * Γ)

/-- The Γ-odd projection `½(x − ΓxΓ)`. -/
def oddPart (Γ x : R) : R := ⅟(2 : R) * (x - Γ * x * Γ)

theorem even_add_odd (Γ x : R) : evenPart Γ x + oddPart Γ x = x := by
  unfold evenPart oddPart
  rw [← mul_add, show (x + Γ * x * Γ) + (x - Γ * x * Γ) = 2 * x by noncomm_ring,
    ← mul_assoc, invOf_mul_self, one_mul]

theorem evenPart_of_even (Γ x : R) (hΓ : Γ * Γ = 1) (h : Γ * x = x * Γ) :
    evenPart Γ x = x := by
  unfold evenPart
  have hh : Γ * x * Γ = x := by rw [h, mul_assoc, hΓ, mul_one]
  rw [hh, ← two_mul, ← mul_assoc, invOf_mul_self, one_mul]

theorem oddPart_of_even (Γ x : R) (hΓ : Γ * Γ = 1) (h : Γ * x = x * Γ) :
    oddPart Γ x = 0 := by
  unfold oddPart
  have : Γ * x * Γ = x := by rw [h, mul_assoc, hΓ, mul_one]
  rw [this, sub_self, mul_zero]

theorem evenPart_of_odd (Γ x : R) (hΓ : Γ * Γ = 1) (h : Γ * x = -(x * Γ)) :
    evenPart Γ x = 0 := by
  unfold evenPart
  have : Γ * x * Γ = -x := by rw [h, neg_mul, mul_assoc, hΓ, mul_one]
  rw [this, add_neg_cancel, mul_zero]

theorem oddPart_of_odd (Γ x : R) (hΓ : Γ * Γ = 1) (h : Γ * x = -(x * Γ)) :
    oddPart Γ x = x := by
  unfold oddPart
  have hh : Γ * x * Γ = -x := by rw [h, neg_mul, mul_assoc, hΓ, mul_one]
  rw [hh, sub_neg_eq_add, ← two_mul, ← mul_assoc, invOf_mul_self, one_mul]

/-- **Rigidity of the coarse (2-block) split.** The decomposition of any element into a
Γ-even and a Γ-odd part is unique. -/
theorem parity_decomposition_unique (Γ a b a' b' : R) (hΓ : Γ * Γ = 1)
    (hae : Γ * a = a * Γ) (hbo : Γ * b = -(b * Γ))
    (ha'e : Γ * a' = a' * Γ) (hb'o : Γ * b' = -(b' * Γ))
    (hsum : a + b = a' + b') : a = a' ∧ b = b' := by
  have hz : Γ * (a - a') = (a - a') * Γ := by rw [mul_sub, sub_mul, hae, ha'e]
  have hz' : Γ * (a - a') = -((a - a') * Γ) := by
    have h1 : a - a' = b' - b := by rw [sub_eq_sub_iff_add_eq_add, hsum]; abel
    rw [h1, mul_sub, sub_mul, hb'o, hbo]; abel
  have h3 : (a - a') * Γ = -((a - a') * Γ) := hz.symm.trans hz'
  have hxx : (a - a') * Γ + (a - a') * Γ = 0 := add_eq_zero_iff_eq_neg.mpr h3
  have key : (a - a') * Γ = 0 := by
    have hh : ⅟(2 : R) * ((a - a') * Γ + (a - a') * Γ) = 0 := by rw [hxx, mul_zero]
    rwa [← two_mul, ← mul_assoc, invOf_mul_self, one_mul] at hh
  have ha : a - a' = 0 := by
    have := congrArg (fun t => t * Γ) key
    simpa [mul_assoc, hΓ] using this
  have haa : a = a' := sub_eq_zero.mp ha
  refine ⟨haa, ?_⟩
  rw [haa] at hsum
  exact add_left_cancel hsum

end Parity

/-! ## Verdict: the axiom-grading isolates only the soldering channel -/

section Verdict

variable {R : Type*} [Ring R] [StarRing R] [Invertible (2 : R)]

omit [StarRing R] in
theorem oddPart_add (Γ x y : R) : oddPart Γ (x + y) = oddPart Γ x + oddPart Γ y := by
  unfold oddPart; noncomm_ring

omit [StarRing R] in
theorem oddPart_two_mul (Γ x : R) : oddPart Γ (2 * x) = 2 * oddPart Γ x := by
  unfold oddPart; noncomm_ring

omit [StarRing R] in
theorem evenPart_add (Γ x y : R) : evenPart Γ (x + y) = evenPart Γ x + evenPart Γ y := by
  unfold evenPart; noncomm_ring

omit [StarRing R] in
theorem evenPart_two_mul (Γ x : R) : evenPart Γ (2 * x) = 2 * evenPart Γ x := by
  unfold evenPart; noncomm_ring

/-- **The Γ-odd part of the square is exactly (twice) the soldering channel.**
So the chiral grading canonically *does* isolate soldering. -/
theorem square_oddPart (c1 c2 g1 g2 Γ φ : R)
    (gsq : Γ * Γ = 1) (gstar : star Γ = Γ) (fstar : star φ = φ)
    (hc1 : Γ * c1 = -(c1 * Γ)) (hc2 : Γ * c2 = -(c2 * Γ))
    (hg1 : Γ * g1 = g1 * Γ) (hg2 : Γ * g2 = g2 * Γ) (hf : Γ * φ = φ * Γ) :
    oddPart Γ (2 * (star (Dop c1 c2 g1 g2 Γ φ) * Dop c1 c2 g1 g2 Γ φ))
      = 2 * solderE c1 c2 g1 g2 Γ φ := by
  rw [square_decomposition c1 c2 g1 g2 Γ φ gsq gstar fstar,
    oddPart_add, oddPart_add, oddPart_add,
    oddPart_of_even Γ _ gsq (aperture_even c1 c2 g1 g2 Γ gstar hc1 hc2 hg1 hg2),
    oddPart_of_even Γ _ gsq (closure_even c1 c2 g1 g2 Γ gstar hc1 hc2 hg1 hg2),
    oddPart_two_mul,
    oddPart_of_odd Γ _ gsq (solder_odd c1 c2 g1 g2 Γ φ gstar hc1 hc2 hg1 hg2 hf),
    oddPart_two_mul, oddPart_of_even Γ _ gsq (turn_even Γ φ hf fstar)]
  simp

/-- **The Γ-even part of the square is the aperture + closure + turn "bulk".**
The chiral grading lumps these three channels together; it cannot separate them. -/
theorem square_evenPart (c1 c2 g1 g2 Γ φ : R)
    (gsq : Γ * Γ = 1) (gstar : star Γ = Γ) (fstar : star φ = φ)
    (hc1 : Γ * c1 = -(c1 * Γ)) (hc2 : Γ * c2 = -(c2 * Γ))
    (hg1 : Γ * g1 = g1 * Γ) (hg2 : Γ * g2 = g2 * Γ) (hf : Γ * φ = φ * Γ) :
    evenPart Γ (2 * (star (Dop c1 c2 g1 g2 Γ φ) * Dop c1 c2 g1 g2 Γ φ))
      = apertureQ c1 c2 g1 g2 + closureQ c1 c2 g1 g2 + 2 * turnQ φ := by
  rw [square_decomposition c1 c2 g1 g2 Γ φ gsq gstar fstar,
    evenPart_add, evenPart_add, evenPart_add,
    evenPart_of_even Γ _ gsq (aperture_even c1 c2 g1 g2 Γ gstar hc1 hc2 hg1 hg2),
    evenPart_of_even Γ _ gsq (closure_even c1 c2 g1 g2 Γ gstar hc1 hc2 hg1 hg2),
    evenPart_two_mul,
    evenPart_of_odd Γ _ gsq (solder_odd c1 c2 g1 g2 Γ φ gstar hc1 hc2 hg1 hg2 hf),
    evenPart_two_mul, evenPart_of_even Γ _ gsq (turn_even Γ φ hf fstar)]
  simp

end Verdict

/-! ## A concrete 4×4 rational Krein carrier witnessing non-rigidity

An explicit carrier satisfying **all** the axioms in which the three Γ-even,
`#`-self-adjoint channels `Q_A`, `Q_C`, `Q_T` are **pairwise distinct and nonzero**.
Since the axiom grading assigns them the *same* `(Γ,#)`-type, it provably cannot
separate them: the four-block split is not a function of the axiom data. -/

namespace Concrete

open Matrix

/-- The concrete carrier space: 4×4 rational matrices. -/
abbrev N := Matrix (Fin 4) (Fin 4) ℚ

/-- Indefinite Krein metric `η = diag(1,−1,1,−1)` (signature (2,2)). -/
def eta : N := !![1,0,0,0; 0,-1,0,0; 0,0,1,0; 0,0,0,-1]

/-- The concrete **Krein adjoint** `A# = η Aᵀ η`. -/
def kadj (A : N) : N := eta * Aᵀ * eta

theorem eta_sq : eta * eta = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [eta, Matrix.mul_apply, Fin.sum_univ_four]

theorem eta_T : etaᵀ = eta := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [eta]

/-- `η` is genuinely indefinite (a positive and a negative diagonal entry). -/
theorem eta_indefinite : eta 0 0 = 1 ∧ eta 1 1 = -1 := by
  constructor <;> simp [eta]

/-- The Krein adjoint is an involution. -/
theorem kadj_invol (A : N) : kadj (kadj A) = A := by
  simp only [kadj]
  rw [Matrix.transpose_mul, Matrix.transpose_mul, eta_T, Matrix.transpose_transpose,
    show eta * (eta * (A * eta)) * eta = (eta * eta) * A * (eta * eta) by noncomm_ring,
    eta_sq, one_mul, mul_one]

/-- The Krein adjoint is an antiautomorphism. -/
theorem kadj_antimul (A B : N) : kadj (A * B) = kadj B * kadj A := by
  simp only [kadj]
  rw [Matrix.transpose_mul,
    show (eta * Bᵀ * eta) * (eta * Aᵀ * eta) = eta * Bᵀ * (eta * eta) * Aᵀ * eta by noncomm_ring,
    eta_sq, show eta * Bᵀ * 1 * Aᵀ * eta = eta * (Bᵀ * Aᵀ) * eta by noncomm_ring]

/-- The Krein adjoint is additive.  (Together with the two lemmas above this exhibits a
genuine `StarRing`/Krein-adjoint structure on `N`.) -/
theorem kadj_add (A B : N) : kadj (A + B) = kadj A + kadj B := by
  simp only [kadj, Matrix.transpose_add]; noncomm_ring

/-- Solder on edge 1. -/
def c1 : N := !![0,0,1,0; 0,0,0,1; 0,0,0,0; 0,0,0,0]
/-- Solder on edge 2. -/
def c2 : N := !![0,0,0,1; 0,0,1,0; 0,0,0,0; 0,0,0,0]
/-- Chiral grading `Γ = diag(1,1,−1,−1)`. -/
def Gam : N := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]
/-- Transport on edge 1 (grade-even). -/
def g1 : N := !![1,0,0,0; 0,2,0,0; 0,0,1,0; 0,0,0,2]
/-- Transport on edge 2 (grade-even, non-commuting with `g1`). -/
def g2 : N := !![0,1,0,0; 1,0,0,0; 0,0,0,1; 0,0,1,0]
/-- Turn field `φ = 1`. -/
def phi : N := 1

/-! ### All the carrier axioms hold for the concrete data. -/

theorem ax_c1_sq : c1 * c1 = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [c1, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_c2_sq : c2 * c2 = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [c2, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_gsq : Gam * Gam = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_anti1 : Gam * c1 = -(c1 * Gam) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, c1, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_anti2 : Gam * c2 = -(c2 * Gam) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, c2, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_comm1 : Gam * g1 = g1 * Gam := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, g1, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_comm2 : Gam * g2 = g2 * Gam := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, g2, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_commf : Gam * phi = phi * Gam := by
  simp [phi]
theorem ax_gstar : kadj Gam = Gam := by
  have h : Gamᵀ = Gam := by ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, Matrix.mul_apply, Fin.sum_univ_four]
theorem ax_fstar : kadj phi = phi := by
  simp only [kadj, phi, Matrix.transpose_one, mul_one, eta_sq]

/-! ### The concrete channels and their values. -/

/-- Concrete aperture channel. -/
def apertureC : N :=
  kadj g1 * (kadj c1 * c1 + kadj c1 * c1) * g1
  + kadj g1 * (kadj c1 * c2 + kadj c2 * c1) * g2
  + kadj g2 * (kadj c2 * c1 + kadj c1 * c2) * g1
  + kadj g2 * (kadj c2 * c2 + kadj c2 * c2) * g2

/-- Concrete closure channel. -/
def closureC : N :=
  kadj g1 * (kadj c1 * c2 - kadj c2 * c1) * g2
  + kadj g2 * (kadj c2 * c1 - kadj c1 * c2) * g1

/-- Concrete turn channel. -/
def turnC : N := kadj phi * phi

theorem kadj_c1 : kadj c1 = !![0,0,0,0; 0,0,0,0; 1,0,0,0; 0,1,0,0] := by
  have h : c1ᵀ = !![0,0,0,0; 0,0,0,0; 1,0,0,0; 0,1,0,0] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [c1, Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem kadj_c2 : kadj c2 = !![0,0,0,0; 0,0,0,0; 0,-1,0,0; -1,0,0,0] := by
  have h : c2ᵀ = !![0,0,0,0; 0,0,0,0; 0,1,0,0; 1,0,0,0] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [c2, Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem kadj_g1 : kadj g1 = !![1,0,0,0; 0,2,0,0; 0,0,1,0; 0,0,0,2] := by
  have h : g1ᵀ = !![1,0,0,0; 0,2,0,0; 0,0,1,0; 0,0,0,2] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [g1, Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem kadj_g2 : kadj g2 = !![0,-1,0,0; -1,0,0,0; 0,0,0,-1; 0,0,-1,0] := by
  have h : g2ᵀ = !![0,1,0,0; 1,0,0,0; 0,0,0,1; 0,0,1,0] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [g2, Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem aperture_val : apertureC = !![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,10] := by
  simp only [apertureC, kadj_c1, kadj_c2, kadj_g1, kadj_g2]
  simp only [c1, c2, g1, g2]
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, Fin.sum_univ_four]

theorem closure_val : closureC = !![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,8] := by
  simp only [closureC, kadj_c1, kadj_c2, kadj_g1, kadj_g2]
  simp only [c1, c2, g1, g2]
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, Fin.sum_univ_four]

theorem turn_val : turnC = 1 := by
  simp only [turnC, kadj, phi, Matrix.transpose_one, mul_one, eta_sq]

/-! ### The three even channels share the `(Γ,#)`-type but are distinct. -/

theorem aperture_selfadj : kadj apertureC = apertureC := by
  rw [aperture_val]
  have h : (!![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,10] : N)ᵀ
      = !![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,10] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem closure_selfadj : kadj closureC = closureC := by
  rw [closure_val]
  have h : (!![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,8] : N)ᵀ
      = !![0,0,0,0; 0,0,0,0; 0,0,4,0; 0,0,0,8] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply]
  simp only [kadj, h, eta]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem turn_selfadj : kadj turnC = turnC := by
  rw [turn_val]; exact ax_fstar

theorem aperture_even : Gam * apertureC = apertureC * Gam := by
  rw [aperture_val]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, Matrix.mul_apply, Fin.sum_univ_four]

theorem closure_even : Gam * closureC = closureC * Gam := by
  rw [closure_val]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gam, Matrix.mul_apply, Fin.sum_univ_four]

theorem turn_even : Gam * turnC = turnC * Gam := by
  rw [turn_val, mul_one, one_mul]

/-- **Concrete non-rigidity witness.** In this axiom-satisfying Krein carrier the three
`Γ`-even, `#`-self-adjoint channels are pairwise distinct and nonzero; the `(Γ,#)`
grading — the only structure the axioms provide — therefore cannot separate the
aperture, closure and turn channels. -/
theorem channels_pairwise_distinct :
    apertureC ≠ closureC ∧ apertureC ≠ turnC ∧ closureC ≠ turnC ∧
    apertureC ≠ 0 ∧ closureC ≠ 0 ∧ turnC ≠ 0 := by
  rw [aperture_val, closure_val, turn_val]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro h; simpa using congrFun (congrFun h 3) 3
  · intro h; simpa using congrFun (congrFun h 3) 3
  · intro h; simpa using congrFun (congrFun h 3) 3
  · intro h; simpa using congrFun (congrFun h 3) 3
  · intro h; simpa using congrFun (congrFun h 3) 3
  · intro h; simpa using congrFun (congrFun h 0) 0

/-- The three even channels have *identical* `(Γ,#)`-type (Γ-even and `#`-self-adjoint),
yet are pairwise distinct — the grading cannot tell them apart. -/
theorem shared_type_but_distinct :
    (kadj apertureC = apertureC ∧ Gam * apertureC = apertureC * Gam) ∧
    (kadj closureC = closureC ∧ Gam * closureC = closureC * Gam) ∧
    (kadj turnC = turnC ∧ Gam * turnC = turnC * Gam) ∧
    apertureC ≠ closureC ∧ apertureC ≠ turnC ∧ closureC ≠ turnC := by
  refine ⟨⟨aperture_selfadj, aperture_even⟩, ⟨closure_selfadj, closure_even⟩,
    ⟨turn_selfadj, turn_even⟩, ?_, ?_, ?_⟩
  · rw [aperture_val, closure_val]; intro h; simpa using congrFun (congrFun h 3) 3
  · rw [aperture_val, turn_val]; intro h; simpa using congrFun (congrFun h 3) 3
  · rw [closure_val, turn_val]; intro h; simpa using congrFun (congrFun h 3) 3

end Concrete

end CarrierRigidity
