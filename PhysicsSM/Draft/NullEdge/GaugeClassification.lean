import Mathlib

/-!
# Gauge classification of the site-dependent Pluecker walk — statement set

DESIGN artifact (companion to `GAUGE_CLASSIFICATION_DESIGN.md`).

This is a Mathlib-only, self-contained statement set that turns the informal
question *"when is the Pluecker phase physical?"* into theorems, in the same
style as the landed context modules
(`PlueckerWindingDerived`, `VariablePlueckerPhaseConnection`,
`GlobalPhaseWindingNoGo`, `PlueckerPhaseObservable`).

It is deliberately independent of those modules (their transitive
dependencies `PhysicsSM.Draft.NullEdge.*` are not part of this checkout), so
this file typechecks against Mathlib alone.  Every statement below — including
the constructive completeness direction — is fully proved (no `s o r r y`).

## Model

The 1D split-step walk `W(z) = S ∘ C(z)` on `ZMod L`, one-particle sector,
two chiralities `R, L`.  Fix the coin *shape* and modulus profile; the phase
degrees of freedom of the whole operator are packaged as a discrete
**connection** on the cycle:

* `th  x` — the coin off-diagonal phase at site `x` (`= arg (z x)` for the
  bare walk `W(z)`);
* `lR  x` — the `R`-channel link phase on the edge `x → x+1`;
* `lL  x` — the `L`-channel link phase on the edge `x → x-1`.

The bare walk `W(z)` has `lR = lL = 0` (`bareConn`).

The gauge group is the per-site, diagonal-in-chirality unitary field
`V(x) = diag(a x, b x)` with `a, b : U(1)`, written additively as phases
`a, b : ZMod L → ℝ`.  Conjugating `W` by `V` acts on the connection by
`gaugeAct` (Question 1, group action (a) of the memo):

* the coin phase sees the ratio `a/b`:            `th x ↦ th x + (a x - b x)`;
* the `R`-link acquires `a(x+1) - a x`:            `lR x ↦ lR x + (a (x+1) - a x)`;
* the `L`-link acquires `b(x-1) - b x`:            `lL x ↦ lL x + (b (x-1) - b x)`.

## The invariant (answer to Question 1)

The complete invariant of a connection under `gaugeAct` is
`(holR, holL, current)`:

* `holR`, `holL` — the per-chirality **holonomies** (Wilson loops)
  `∑ lR`, `∑ lL`; on a bare walk they vanish, and gauge cannot create them;
* `current x = th(x+1) - th x - lR x - lL(x+1)` — the **local
  relative-phase current**, gauge invariant at every edge.

They satisfy exactly one relation, `∑ current = -(holR + holL)`
(`current_sum_eq`).  For the bare walk this reads: the *total* turning
`∑ current` telescopes to `0` (absorbable), while the *local* increments
`current x = arg z(x+1) - arg z x` are the surviving residue
(`current_bareConn`).  This is precisely the "total turning is always
absorbable mod 2π but the local increment differences are not" candidate.

## Answers to Questions 2–4

* **Q2 (honest gauge triviality).** `bare_gaugeTrivial_iff_const`: the bare
  walk `W(z)` is gauge-equivalent to the phase-free walk `W(|z|)` **iff**
  the coin phase `th = arg z` is constant.  Constant phase is pure gauge
  (`const_bare_gaugeTrivial`); any nonconstant phase (a gradient / wall) is
  *not* (`wall_not_gaugeTrivial`).  This reproduces the oracle: the
  two-site wall is not gauge-equivalent to the constant field.
* **Q3 (relative / multi-species).** Under a *common* gauge, the pointwise
  relative coin phase `th₁ x - th₂ x` (i.e. `arg (z₁ x * conj (z₂ x))`) is
  invariant, edge-by-edge and without any winding subtlety
  (`common_gauge_rel_invariant`, `arg_rel_common_gauge_invariant`).  The
  landed interference amplitude reads exactly this datum: `witness_rel_arg_ne`
  shows the `(3+4i)/5`-vs-`1` relative phase is nonzero, while the
  equal-field control is zero.
* **Q4 (Lean-ready set).** Everything below, with the oracle configurations
  as explicit witnesses and the constant field as the control, is ready for
  a proof job to discharge the remaining `classification_complete_*` holes.

Provenance: Sol strategy memo section 3 (gauge classification), designed
and FULLY PROVED by Aristotle project `ae6393d3-1ef3-4d93-af50-6d93662be1cc`
(run `d32e73e9`) with my oracle constraints as hard data; integrated with
local kernel re-check.  Headline results: complete gauge-orbit invariant
(holR, holL, current) with the single relation sum(current) = -(holR+holL);
gauge-triviality iff constant phase; wall witness not gauge-trivial
(matching the 821/3125 vs 49/625 oracle); common-gauge relative invariant
arg(z1 * conj z2) - exactly the datum the landed 4/5 interference
probability reads.  Lean 4.28.0.
-/

noncomputable section
open scoped BigOperators
open Complex

namespace PhysicsSM.Draft.NullEdge.GaugeClassification

/-! ## Connections and the gauge action -/

/-- Phase content of the split-step walk operator as a discrete connection on
the cycle: coin phase `th`, and per-chirality link phases `lR`, `lL`. -/
@[ext] structure Conn (L : Nat) where
  th : ZMod L → ℝ
  lR : ZMod L → ℝ
  lL : ZMod L → ℝ

/-- The per-site diagonal-in-chirality gauge action `V(x) = diag(a x, b x)`
on a connection (memo group (a)). -/
def gaugeAct {L : Nat} (a b : ZMod L → ℝ) (D : Conn L) : Conn L where
  th := fun x => D.th x + (a x - b x)
  lR := fun x => D.lR x + (a (x + 1) - a x)
  lL := fun x => D.lL x + (b (x - 1) - b x)

/-- Gauge equivalence of connections: conjugacy by some diagonal phase field. -/
def GaugeEquiv {L : Nat} (D D' : Conn L) : Prop := ∃ a b, gaugeAct a b D = D'

/-- The phase-free (real modulus) walk `W(|z|)`. -/
def zeroConn (L : Nat) : Conn L := ⟨fun _ => 0, fun _ => 0, fun _ => 0⟩

/-- The bare walk `W(z)`: coin phase `th`, no supplied link data. -/
def bareConn {L : Nat} (th : ZMod L → ℝ) : Conn L := ⟨th, fun _ => 0, fun _ => 0⟩

/-! ## The complete invariant -/

/-- `R`-channel holonomy (Wilson loop) `∑ lR`. -/
def holR {L : Nat} [NeZero L] (D : Conn L) : ℝ := ∑ x : ZMod L, D.lR x

/-- `L`-channel holonomy (Wilson loop) `∑ lL`. -/
def holL {L : Nat} [NeZero L] (D : Conn L) : ℝ := ∑ x : ZMod L, D.lL x

/-- The local gauge-invariant relative-phase current on the edge at `x`. -/
def current {L : Nat} (D : Conn L) (x : ZMod L) : ℝ :=
  D.th (x + 1) - D.th x - D.lR x - D.lL (x + 1)

/-- **Q1a.** The `R`-holonomy is gauge invariant (link telescopes on the cycle). -/
theorem gaugeAct_holR {L : Nat} [NeZero L] (a b : ZMod L → ℝ) (D : Conn L) :
    holR (gaugeAct a b D) = holR D := by
  unfold holR gaugeAct; simp only
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  have : (∑ x : ZMod L, a (x + 1)) = ∑ x : ZMod L, a x :=
    Fintype.sum_equiv (Equiv.addRight (1 : ZMod L)) _ _ (fun _ => rfl)
  rw [this]; ring

/-- **Q1a.** The `L`-holonomy is gauge invariant. -/
theorem gaugeAct_holL {L : Nat} [NeZero L] (a b : ZMod L → ℝ) (D : Conn L) :
    holL (gaugeAct a b D) = holL D := by
  unfold holL gaugeAct; simp only
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  have : (∑ x : ZMod L, b (x - 1)) = ∑ x : ZMod L, b x :=
    (Fintype.sum_equiv (Equiv.addRight (1 : ZMod L)) (fun x => b x) (fun x => b (x - 1))
      (fun x => by simp)).symm
  rw [this]; ring

/-- **Q1b.** The local current is gauge invariant, edge by edge and exactly. -/
theorem gaugeAct_current {L : Nat} (a b : ZMod L → ℝ) (D : Conn L) (x : ZMod L) :
    current (gaugeAct a b D) x = current D x := by
  unfold current gaugeAct; simp only
  have h : (x + 1) - 1 = x := by ring
  rw [h]; ring

/-- **Q1c.** The single relation between the invariants: the total current is
minus the total holonomy.  On a bare walk both holonomies vanish, so the total
turning `∑ current` is `0` — always absorbable — while the local `current x`
survive. -/
theorem current_sum_eq {L : Nat} [NeZero L] (D : Conn L) :
    (∑ x : ZMod L, current D x) = -(holR D + holL D) := by
  unfold current holR holL
  rw [Finset.sum_sub_distrib, Finset.sum_sub_distrib, Finset.sum_sub_distrib]
  have h1 : (∑ x : ZMod L, D.th (x + 1)) = ∑ x : ZMod L, D.th x :=
    Fintype.sum_equiv (Equiv.addRight (1 : ZMod L)) _ _ (fun _ => rfl)
  have h2 : (∑ x : ZMod L, D.lL (x + 1)) = ∑ x : ZMod L, D.lL x :=
    Fintype.sum_equiv (Equiv.addRight (1 : ZMod L)) _ _ (fun _ => rfl)
  rw [h1, h2]; ring

/-- Invariants of a bare walk: holonomies vanish. -/
@[simp] theorem holR_bareConn {L : Nat} [NeZero L] (th : ZMod L → ℝ) :
    holR (bareConn th) = 0 := by simp [holR, bareConn]

@[simp] theorem holL_bareConn {L : Nat} [NeZero L] (th : ZMod L → ℝ) :
    holL (bareConn th) = 0 := by simp [holL, bareConn]

/-- The surviving residue of a bare walk is the coin-phase increment field. -/
theorem current_bareConn {L : Nat} (th : ZMod L → ℝ) (x : ZMod L) :
    current (bareConn th) x = th (x + 1) - th x := by
  simp [current, bareConn]

/-- **Q1 (forward completeness).** Gauge-equivalent connections share every
invariant.  (The converse is `classification_complete`.) -/
theorem gaugeEquiv_invariants {L : Nat} [NeZero L] {D D' : Conn L}
    (h : GaugeEquiv D D') :
    holR D = holR D' ∧ holL D = holL D' ∧ ∀ x, current D x = current D' x := by
  obtain ⟨a, b, rfl⟩ := h
  exact ⟨(gaugeAct_holR a b D).symm, (gaugeAct_holL a b D).symm,
    fun x => (gaugeAct_current a b D x).symm⟩

/-- **Q1 (completeness).** Two connections with identical invariants are gauge
equivalent: solve the finite-difference equations for `a`, `b` by cumulative
sums (consistent because the holonomies agree), then fix the coin phase up to a
single global constant. -/
theorem classification_complete {L : Nat} [NeZero L] {D D' : Conn L}
    (hR : holR D = holR D') (hL : holL D = holL D')
    (hcur : ∀ x, current D x = current D' x) : GaugeEquiv D D' := by
  revert hcur hR hL;
  intro hR hL hcur
  obtain ⟨a, b, h_eq⟩ : ∃ a b : ZMod L → ℝ, (∀ x, a (x + 1) - a x = D'.lR x - D.lR x) ∧ (∀ x, b (x - 1) - b x = D'.lL x - D.lL x) ∧ (∀ x, a x - b x = D'.th x - D.th x) := by
    -- Define `a` such that `a (x + 1) - a x = D'.lR x - D.lR x`.
    obtain ⟨a, ha⟩ : ∃ a : ZMod L → ℝ, (∀ x, a (x + 1) - a x = D'.lR x - D.lR x) := by
      use fun x => ∑ k ∈ Finset.range x.val, (D'.lR k - D.lR k);
      intro x;
      by_cases hx : x.val = L - 1;
      · rcases L with ( _ | _ | L ) <;> simp_all +decide [ ZMod, Fin.ext_iff ];
        · unfold holR at hR; simp_all +decide [ Fin.eq_zero ] ;
        · simp_all +decide [ ZMod.val, Fin.add_def ];
          simp_all +decide [ holR ];
          simp_all +decide [ Finset.sum_range, ZMod, Fin.sum_univ_castSucc ];
          rw [ show x = Fin.last ( L + 1 ) from Fin.ext hx ] ; linarith!;
      · have h_sum : (x + 1).val = x.val + 1 := by
          rcases L with ( _ | _ | L ) <;> simp_all +decide [ ZMod.val_add ];
          · fin_cases x ; contradiction;
          · simp +decide [ ZMod.val ];
            exact Nat.le_of_lt_succ ( lt_of_le_of_ne ( Nat.le_of_lt_succ x.val_lt ) hx );
        simp +decide [ h_sum, Finset.sum_range_succ ];
        ring;
    refine' ⟨ a, fun x => a x - ( D'.th x - D.th x ), ha, _, _ ⟩ <;> simp +decide;
    intro x; have := hcur ( x - 1 ) ; have := ha ( x - 1 ) ; have := hcur x; have := ha x; norm_num [ current ] at *; linarith;
  use a, b;
  cases D ; cases D' ; ext x <;> simp +decide [ gaugeAct ] <;> linarith [ h_eq.1 x, h_eq.2.1 x, h_eq.2.2 x ]

/-! ## Q2 — honest gauge triviality -/

/-- Constant coin phase forces the constant helper: a link-free `a` on the
cycle is constant. -/
private theorem const_of_step_eq {L : Nat} [NeZero L] {a : ZMod L → ℝ}
    (ha : ∀ x, a (x + 1) = a x) : ∀ x, a x = a 0 := by
  intro x
  have key : ∀ n : Nat, a (n : ZMod L) = a 0 := by
    intro n; induction n with
    | zero => simp
    | succ k ih =>
        have hcast : ((k + 1 : Nat) : ZMod L) = (k : ZMod L) + 1 := by push_cast; ring
        rw [hcast, ha, ih]
  have := key x.val; rwa [ZMod.natCast_val, ZMod.cast_id] at this

private theorem const_of_stepBack_eq {L : Nat} [NeZero L] {b : ZMod L → ℝ}
    (hb : ∀ x, b (x - 1) = b x) : ∀ x, b x = b 0 := by
  intro x
  have key : ∀ n : Nat, b (-(n : ZMod L)) = b 0 := by
    intro n; induction n with
    | zero => simp
    | succ k ih =>
        have hcast : (-((k + 1 : Nat) : ZMod L)) = (-(k : ZMod L)) - 1 := by push_cast; ring
        rw [hcast, hb, ih]
  have := key ((-x).val); rw [ZMod.natCast_val, ZMod.cast_id] at this; simpa using this

/-- **Q2 (main gauge-triviality theorem).**  The bare walk `W(z)` is
gauge-equivalent to the phase-free walk `W(|z|)` **iff** its coin phase is
constant.  Equivalently: the gauge group removes a *global* constant phase
and nothing else. -/
theorem bare_gaugeTrivial_iff_const {L : Nat} [NeZero L] (th : ZMod L → ℝ) :
    GaugeEquiv (bareConn th) (zeroConn L) ↔ ∃ c : ℝ, ∀ x, th x = c := by
  constructor
  · rintro ⟨a, b, h⟩
    unfold gaugeAct bareConn zeroConn at h
    have hth := congrArg Conn.th h
    have hR := congrArg Conn.lR h
    have hL := congrArg Conn.lL h
    simp only at hth hR hL
    have hA : ∀ x, a (x + 1) = a x := by
      intro x; have := congrFun hR x; simp at this; linarith
    have hB : ∀ x, b (x - 1) = b x := by
      intro x; have := congrFun hL x; simp at this; linarith
    have hac := const_of_step_eq hA
    have hbc := const_of_stepBack_eq hB
    refine ⟨-(a 0 - b 0), fun x => ?_⟩
    have := congrFun hth x
    rw [hac x, hbc x] at this; linarith
  · rintro ⟨c, hc⟩
    exact ⟨fun _ => -c, fun _ => 0, by unfold gaugeAct bareConn zeroConn; ext x <;> simp [hc x]⟩

/-- **Q2 (constant phase is pure gauge, control).** -/
theorem const_bare_gaugeTrivial {L : Nat} [NeZero L] (c : ℝ) :
    GaugeEquiv (bareConn (fun _ => c)) (zeroConn L) :=
  (bare_gaugeTrivial_iff_const _).2 ⟨c, fun _ => rfl⟩

/-- **Q2 (gradient / wall obstruction).**  Any nonconstant coin phase — in
particular a wall where two sites disagree — is *not* gauge-trivial. -/
theorem wall_not_gaugeTrivial {L : Nat} [NeZero L] (th : ZMod L → ℝ)
    {x y : ZMod L} (hxy : th x ≠ th y) :
    ¬ GaugeEquiv (bareConn th) (zeroConn L) := by
  rw [bare_gaugeTrivial_iff_const]
  rintro ⟨c, hc⟩
  exact hxy (by rw [hc x, hc y])

/-! ## Q2 — the oracle two-site witness (`L = 2`)

The oracle wall field: `z 0 = (3 + 4i)/5`, `z 1 = 1`, equal moduli `1`.  Its
coin-phase profile is `arg` of the field, which disagrees at the two sites,
hence the wall is not gauge-trivial.  The constant field is the control. -/

/-- The oracle wall coin phase on `ZMod 2`. -/
def wallPhase : ZMod 2 → ℝ := ![Complex.arg ((3 + 4 * Complex.I) / 5), 0]

/-- The oracle wall phase genuinely differs between the two sites. -/
theorem wallPhase_sites_ne : wallPhase 0 ≠ wallPhase 1 := by
  have h : Complex.arg ((3 + 4 * Complex.I) / 5) ≠ 0 := by
    intro h
    rw [Complex.arg_eq_zero_iff] at h
    obtain ⟨_, him⟩ := h
    rw [Complex.div_im] at him
    norm_num [Complex.normSq] at him
  simpa [wallPhase] using h

/-- **Q2 (oracle non-equivalence).**  The two-site wall walk is *not*
gauge-equivalent to the phase-free walk: matching the oracle datum that the
`(3+4i)/5`-vs-`1` wall has 2-step return probability `821/3125 ≠ 49/625`. -/
theorem wall_witness_not_gaugeTrivial :
    ¬ GaugeEquiv (bareConn wallPhase) (zeroConn 2) :=
  wall_not_gaugeTrivial wallPhase wallPhase_sites_ne

/-! ## Q3 — relative (multi-species) invariants under a common gauge -/

/-- **Q3 (relative pointwise invariant).**  Under one *common* gauge acting on
two species, the pointwise difference of coin phases is invariant — no
telescoping, no winding: it is a genuine local observable. -/
theorem common_gauge_rel_invariant {L : Nat} (a b : ZMod L → ℝ)
    (D₁ D₂ : Conn L) (x : ZMod L) :
    (gaugeAct a b D₁).th x - (gaugeAct a b D₂).th x = D₁.th x - D₂.th x := by
  unfold gaugeAct; simp only; ring

/-- **Q3 (complex reading).**  For two Pluecker fields evolving under a common
gauge, `arg (z₁ x * conj (z₂ x))` is the invariant relative datum: the
bare coin phases are `arg z₁`, `arg z₂`, whose difference the common gauge
leaves fixed. -/
theorem arg_rel_common_gauge_invariant {L : Nat} (a b : ZMod L → ℝ)
    (z₁ z₂ : ZMod L → ℂ) (x : ZMod L) :
    (gaugeAct a b (bareConn (fun q => Complex.arg (z₁ q)))).th x
      - (gaugeAct a b (bareConn (fun q => Complex.arg (z₂ q)))).th x
    = Complex.arg (z₁ x) - Complex.arg (z₂ x) := by
  simpa [bareConn] using
    common_gauge_rel_invariant a b (bareConn (fun q => Complex.arg (z₁ q)))
      (bareConn (fun q => Complex.arg (z₂ q))) x

/-- **Q3 (witness reads the invariant).**  The landed interference amplitude
`u₂ * conj u₁` (see context `PlueckerPhaseObservable.doubleKick_return_amplitude`)
is `z₂ * conj z₁` up to positive scaling; for the equal-modulus witness pair
`z₁ = 3 + 4i`, `z₂ = 5` the relative phase datum is nonzero, while the
equal-field control gives zero. -/
theorem witness_rel_arg_ne :
    Complex.arg ((3 + 4 * Complex.I) * (starRingEnd ℂ) (5 : ℂ)) ≠ 0 ∧
    Complex.arg ((5 : ℂ) * (starRingEnd ℂ) (5 : ℂ)) = 0 := by
  constructor
  · intro h
    rw [Complex.arg_eq_zero_iff] at h
    obtain ⟨_, him⟩ := h
    simp [Complex.mul_im] at him
  · have h25 : (5 : ℂ) * (starRingEnd ℂ) (5 : ℂ) = ((25 : ℝ) : ℂ) := by
      simp [Complex.ext_iff]; norm_num
    rw [h25]
    rw [Complex.arg_eq_zero_iff]
    norm_num

end PhysicsSM.Draft.NullEdge.GaugeClassification
