import Mathlib

/-!
# FUR-H2 — Furey/Krasnov complex structure vs. the internal `chi_E` grading

This module answers, **formally and self-containedly**, the question of job
`FUR-H2`: can the abstract internal grading `chi_E` of the null-edge super-Dirac
layer be *discharged* by the existing Furey/Krasnov complex-structure data
("right multiplication by `e111` acts as multiplication by `i`")?

## The headline answer (item 4 of the task)

The Furey/Krasnov datum is a **complex structure**, not a Z/2 grading:

* "right multiplication by `e111` = multiplication by the scalar `i`" is an
  operator `J` with `J ∘ J = -1` (`IsComplexStructure`).  It makes the Furey
  ideal an 8-dimensional **complex** vector space.  It is *not* an involution.
* `chi_E` (like the spacetime chirality `Gamma_s`) is a **Z/2 grading**, i.e. an
  involution `g` with `g ∘ g = +1` (`IsZ2Grading`).

These are different invariants:

* `complexStructure_not_grading` / `complexStructure_ne_grading` — a complex
  structure is never a Z/2 grading (whenever `(1 : A) ≠ -1`).  So "multiplication
  by `i`" must **not** be conflated with a chirality grading.
* `grading_of_complexStructure_mul_central` — the *only* clean way to manufacture
  a grading from a complex structure `J` is to combine it with a **second**,
  independent, central square-root of `-1` `i` that commutes with `J`: then
  `i * J` is an involution.  This makes the missing extra data explicit.
* `complexStructure_self_mul_is_trivial` — on the Furey ideal the Krasnov
  identification says the internal `i` *is* `J` (they coincide), so `i * J =
  J * J = -1`, the **trivial central** involution — it grades nothing.
* `central_cannot_be_internal_grading` — and a central involution can never make
  the off-diagonal mass block `Phi_H` *odd* (it commutes with everything),
  whereas `chi_E` is *defined* by `{chi_E, Phi_H} = 0`.

Conclusion: the Furey/Krasnov complex structure **does not** supply `chi_E`.
`chi_E` is separate data — a genuine, non-central chirality/parity involution on
the ideal (e.g. the number-operator parity `(-1)^N` distinguishing the
particle/antiparticle or `L/R` halves).  See the report
`Sources/FUR_H2_chiE_report.md` for the mapping to the repository's concrete
objects (`omega = (1 - i·e111)/2`, `omega_bar = (1 + i·e111)/2`, the number
operators `N1,N2,N3`, `InternalGrading`, and the concrete `chiE` matrix grading
in `NullEdgeSuperDiracSignBridge`).

## Interaction with `Phi_H` oddness and the Gate A sign theorem (item 5)

`sign_bridge_with_grading` reproduces, self-containedly, the Gate A sign
dichotomy of `super_dirac_sign_bridge`: with a grading `Gs` that **commutes**
with the mass `Ph` one gets the physical `+Ph²`; with a grading `Xe` under which
`Ph` is **odd** one gets the tachyonic `-Ph²`.  The slot that pairs with `Ph`
must be an involution (`Xe * Xe = 1`).  `complexStructure_cannot_fill_grading_slot`
shows a complex structure (square `-1`) cannot fill that slot, so the Furey
complex structure can play neither `Gamma_s` nor `chi_E`.

## Build note

Everything here is abstract associative-ring algebra and imports only Mathlib,
so it compiles independently of the (separately-delivered) octonion/ideal files.
Each abstract symbol maps to a repository object as documented above; wiring the
theorems to the concrete `ComplexOctonion`/`MinimalLeftIdeal`/`NullEdgeInternal`
files is a matter of instantiating `A` and the elements once those files are in
the build.

## Guardrail

`Gamma_s` (spacetime chirality), `chi_E` (internal grading), the complex
structure `J`, and any form/cochain-degree grading are kept strictly separate;
no theorem here silently identifies any two of them.
-/

namespace PhysicsSM.NullEdge.FureyChiE

variable {A : Type*} [Ring A]

/-- A **complex structure** on `A`: an element squaring to `-1`.

Models the Furey/Krasnov datum "right multiplication by `e111` acts as
multiplication by the scalar `i`" on the minimal left ideal `J`. -/
def IsComplexStructure (J : A) : Prop := J * J = -1

/-- A **Z/2 grading** (chirality involution) on `A`: an element squaring to `+1`.

Models both the spacetime chirality `Gamma_s` and the internal chirality
`chi_E`. -/
def IsZ2Grading (g : A) : Prop := g * g = 1

/-- An element that anticommutes with `Ph` (`{g, Ph} = 0`).  This is the precise
sense in which the internal mass block `Phi_H` is `chi_E`-**odd**. -/
def IsOdd (g Ph : A) : Prop := g * Ph = -(Ph * g)

/-- An element that commutes with `Ph` (`[g, Ph] = 0`).  This is the precise
sense in which `Phi_H` is `Gamma_s`-**even**. -/
def IsEven (g Ph : A) : Prop := g * Ph = Ph * g

/-! ### A complex structure is not a Z/2 grading -/

/-
A complex structure is **never** a Z/2 grading, as long as `(1 : A) ≠ -1`
(true in any ring of characteristic `≠ 2`, e.g. an algebra over `ℂ`).
-/
theorem complexStructure_not_grading (x : A) (hchar : (1 : A) ≠ -1)
    (h : IsComplexStructure x) : ¬ IsZ2Grading x := by
  intro hx
  have h_neg_one : (-1 : A) = 1 := by
    exact h.symm.trans hx;
  exact hchar h_neg_one.symm

/-
A complex structure and a Z/2 grading can never be the *same* element
(when `(1 : A) ≠ -1`).  This is the formal "do not conflate `i` with a chirality
grading" statement.
-/
theorem complexStructure_ne_grading (J g : A) (hchar : (1 : A) ≠ -1)
    (hJ : IsComplexStructure J) (hg : IsZ2Grading g) : J ≠ g := by
  contrapose! hchar; have := hJ; simp_all +decide [ IsComplexStructure, IsZ2Grading ] ;

/-! ### Manufacturing a grading from a complex structure requires extra data -/

/-
**Extra data needed.**  Given a complex structure `J` together with an
*independent* central square-root of `-1` `i` that commutes with `J`, the
product `i * J` is a Z/2 grading (`(i J)² = i² J² = (-1)(-1) = 1`).

This isolates exactly the missing ingredient: a complex structure alone does not
give a grading; one needs a *second* commuting complex structure to twist it
into an involution.
-/
theorem grading_of_complexStructure_mul_central
    (i J : A) (hi : i * i = -1) (hcomm : i * J = J * i)
    (hJ : IsComplexStructure J) : IsZ2Grading (i * J) := by
  unfold IsZ2Grading; simp +decide [ *, mul_assoc ] ;
  simp_all +decide [ ← mul_assoc, IsComplexStructure ]

/-- **Why the naive identification collapses on the Furey ideal.**  Krasnov's
statement is that the internal complex structure *is* multiplication by the
scalar `i`; i.e. on the ideal `J` the two coincide (`i = J`).  Then the twisted
product degenerates: `i * J = J * J = -1`, the *trivial central* involution,
which grades nothing. -/
theorem complexStructure_self_mul_is_trivial (J : A)
    (hJ : IsComplexStructure J) : J * J = -1 := hJ

/-! ### A central involution cannot make the mass block odd -/

/-
**A central grading cannot realize `chi_E`.**  If `g` is central (commutes
with everything) and yet `Phi_H` is `g`-odd, then `2 · (g * Phi_H) = 0`.  In a
ring without `2`-torsion (e.g. a `ℂ`-algebra) this forces `g * Phi_H = 0`, hence
`Phi_H = 0` whenever `g` is invertible (as any grading is).

Consequence: since the Krasnov complex structure acts as the *scalar* `i` and is
therefore central on the complex ideal `J`, it can never make a nonzero mass
block `Phi_H` odd — so it cannot be `chi_E`, which is defined by `{chi_E,
Phi_H} = 0`.
-/
theorem central_cannot_be_internal_grading
    (g Ph : A) (hcentral : ∀ x : A, g * x = x * g) (hodd : IsOdd g Ph) :
    (2 : A) * (g * Ph) = 0 := by
  have := hodd.symm ▸ hcentral Ph; simp_all +decide [ two_mul, IsOdd ] ;
  grind

/-
Corollary: a central, invertible involution forces any block it makes odd to
vanish, provided `2` is left-cancellable.  Concretely, the central scalar `i`
cannot make a nonzero `Phi_H` odd.
-/
theorem central_invertible_odd_block_zero
    (g Ph : A) (hg : IsZ2Grading g) (hcentral : ∀ x : A, g * x = x * g)
    (hodd : IsOdd g Ph) (h2 : ∀ y : A, (2 : A) * y = 0 → y = 0) :
    Ph = 0 := by
  have hgrams : g * Ph = 0 := by
    exact h2 _ ( central_cannot_be_internal_grading g Ph hcentral hodd );
  convert congr_arg ( fun x => g * x ) hgrams using 1 <;> simp +decide [ ← mul_assoc ];
  rw [ hg, one_mul ]

/-! ### Interaction with the Gate A super-Dirac sign theorem -/

/-
**Gate A sign dichotomy (self-contained restatement).**  With a grading `Gs`
that *commutes* with the mass block `Ph` the super-Dirac mass square is the
physical `+Ph²`; with a grading `Xe` under which `Ph` is *odd* it is the
tachyonic `-Ph²`.  (This is the abstract core of
`PhysicsSM.Draft.SuperDiracSignBridge.super_dirac_sign_bridge`.)
-/
theorem sign_bridge_with_grading
    (Gs Xe Ph : A)
    (hGs2 : IsZ2Grading Gs) (hXe2 : IsZ2Grading Xe)
    (hGsPh : IsEven Gs Ph) (hXePh : IsOdd Xe Ph) :
    (Gs * Ph) * (Gs * Ph) = Ph * Ph ∧
      (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) := by
  simp_all +decide [ mul_assoc, IsZ2Grading, IsEven, IsOdd ];
  simp_all +decide [ ← mul_assoc ];
  simp_all +decide [ mul_assoc ]

/-- **A complex structure cannot fill the grading slot of the super-Dirac
square.**  The element paired with `Ph` in `D = i D_N + g Ph` must be an
involution (`g² = 1`) for the sign bridge to apply.  A complex structure (`g² =
-1`) is not such an element (when `(1 : A) ≠ -1`); hence the Furey complex
structure can play neither `Gamma_s` nor `chi_E`. -/
theorem complexStructure_cannot_fill_grading_slot
    (g : A) (hchar : (1 : A) ≠ -1) (h : IsComplexStructure g) :
    ¬ IsZ2Grading g :=
  complexStructure_not_grading g hchar h

/-! ### Non-vacuity witnesses

`ℂ` itself separates the two notions: `Complex.I` is a complex structure but not
a grading, while `-1` and `1` are gradings but not complex structures. -/

/-
`Complex.I` is a complex structure on `ℂ`.
-/
theorem complexI_isComplexStructure : IsComplexStructure (Complex.I) := by
  exact Complex.I_mul_I

/-
`Complex.I` is not a Z/2 grading on `ℂ`.
-/
theorem complexI_not_grading : ¬ IsZ2Grading (Complex.I) := by
  exact fun h => absurd h ( by norm_num [ Complex.ext_iff, IsZ2Grading ] )

/-
`(-1 : ℂ)` is a Z/2 grading but, being central, is the trivial one.
-/
theorem negOne_isZ2Grading : IsZ2Grading (-1 : ℂ) := by
  norm_num [ IsZ2Grading ]

end PhysicsSM.NullEdge.FureyChiE
