import PhysicsSM.Draft.NullEdge.Finite3Plus1BrillouinAudit
import PhysicsSM.Draft.NullEdge.StrictQCAMinimalArchitecture
import PhysicsSM.Draft.NullEdge.FloquetDeterminantCriterion

/-!
# Strict local 3+1 frontier: determinant-level alias predicate and the doubling gate

This module is the Lean-ready attack surface for the strict local `3+1` null-step
problem.  It separates the *architecture-scoped* results already landed in the
project from the single genuinely open topological gate, and it phrases every
alias statement at the **determinant / Floquet-eigenvalue level**
`det (U(q) - 1) = 0` demanded by the audit — never by sampled numerics,
retardedness, or coefficient nonvanishing.

## What is proved here (fully, axiom-audited)

* `zeroQuasienergyAlias_iff_fixedVector` — the determinant predicate
  `det (U - 1) = 0` is exactly the existence of a nonzero exact `+1` Floquet
  mode (via `FloquetDeterminantCriterion`).  This is the object a genuine,
  non-doubled mode must *not* satisfy at nonzero momentum.
* `split_step_zero_mode_doubling` — the **live** massless successive-axis walk
  carries an exact zero-quasienergy mode at the origin *and* at all three
  even-parity nonzero Brillouin corners, at distinct momenta, each with an
  explicit nonzero fixed vector.  This is the determinant-level upgrade of the
  corner-value aliases in `Finite3Plus1BrillouinAudit`.
* `body_center_persistent_crossings` — at the body-center momentum
  `(π/2, π/2, π/2)` the *massive* step has both `det(U-1)=0` and `det(U+1)=0`
  for **every** mass angle: a momentum-independent mass coin cannot open a
  Floquet gap there.
* `factorized_degree_one_forced_corner_aliases` — the sharply scoped no-go.  In
  the range-one, single-factor-per-axis, four-channel *factorized* class with the
  three exact Dirac tangents and the physical normalization `U(0)=1`, the three
  even nonzero corners are forced to satisfy `det(U-1)=0` regardless of the
  momentum-independent onsite coin `Q`.  Nonvacuity: `factorized_no_go_nonvacuous`.
  Escape: `escape_architecture` (a non-involutory tangent breaks a hypothesis and
  separates the zone edge).
* `doubling_from_balance` — the abstract Nielsen–Ninomiya *gate*, fully proved:
  given a finite zero-mode set `S`, a chirality functional `χ` whose total charge
  over `S` vanishes and an origin crossing of nonzero charge, a second zero-mode
  momentum must exist.  This isolates the external input: the balance law `hbal`
  (the ported degree theorem) and the origin charge `hχ0` (a finite computation
  on the `α`-tangent).
* `admissible_origin_alias` — the origin is always a zero-quasienergy mode of an
  admissible walk (`U 0 = 1`); it is the mode the frontier must show is doubled.

## The single documented frontier hole

`admissible_doubling` is the only `s o r r y`: every admissible strict local walk has
a *second*, nonzero Brillouin momentum with `det(U q - 1) = 0`.  This is the
universal Nielsen–Ninomiya doubling gate.  Its intended discharge is the proved
tool `doubling_from_balance` fed by two isolated follow-up sub-facts — a canonical
chiral charge `χ` with Brillouin-zone balance `∑ χ = 0` (a clean-room port of the
degree theorem for `q ↦ det(U(q) - 1)`), and a nonzero origin charge `χ 0 ≠ 0`
(a finite computation on the massless `α`-tangent).  The statement is stated over
the `AdmissibleWalk` structure, which is nonvacuous: `splitStepWalk` is an
explicit inhabitant (the live successive-axis walk), for which
`split_step_zero_mode_doubling` already exhibits the doubling.

Cross-family audit after return found that the zero-only universal statement is
likely too strong for a discrete-time Floquet walk: the compensating partner may
occur at quasienergy pi, detected by `det (U(q) + 1) = 0`. The hole below is
therefore parked as an intentionally unproved historical target. The active
successor asks for a nonzero zero-OR-pi crossing and a chirality balance over the
combined crossing set. None of the guarded declarations depends on this hole.

Honest scope: the fixed finite direction set does **not** have exact Lorentz
symmetry; only the discrete Brillouin-corner and body-center identities are
proved, and the scaling-limit obligation is separate.  The scoped no-go is
architecture-scoped by construction and is **not** promoted to a universal
theorem: that promotion is exactly the `admissible_doubling` hole.
-/

noncomputable section

open Matrix Complex
open PhysicsSM.Draft.NullEdge

namespace PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

/-! ## 1. The determinant-level zero-quasienergy alias predicate -/

/-- Determinant-level zero-quasienergy predicate: the one-step Floquet operator
`U` has an exact quasienergy-`0` mode iff `det (U - 1) = 0`. -/
def ZeroQuasienergyAlias (U : Mat4) : Prop := Matrix.det (U - 1) = 0

/-- The determinant predicate is exactly the existence of a nonzero exact `+1`
Floquet eigenvector. -/
theorem zeroQuasienergyAlias_iff_fixedVector (U : Mat4) :
    ZeroQuasienergyAlias U ↔ ∃ v : Fin 4 → ℂ, v ≠ 0 ∧ U *ᵥ v = v :=
  (FloquetDeterminantCriterion.exists_plus_mode_iff_det_sub_one_eq_zero U).symm

/-- Any operator equal to the identity trivially carries a zero-quasienergy
mode: the physical Dirac point sits at such momenta. -/
theorem alias_of_eq_one {U : Mat4} (h : U = 1) : ZeroQuasienergyAlias U := by
  rw [zeroQuasienergyAlias_iff_fixedVector]
  refine ⟨fun _ => 1, ?_, ?_⟩
  · intro hh; simpa using congrFun hh 0
  · rw [h, Matrix.one_mulVec]

/-! ## 2. Determinant-level doubling of the live massless split step -/

open Finite3Plus1BrillouinAudit

/-- Origin carries the intended Dirac zero mode. -/
theorem split_step_origin_alias : ZeroQuasienergyAlias (masslessWalk 0 0 0) :=
  alias_of_eq_one zero_quasienergy_corner_values.1

/-- `(π, π, 0)` is an exact zero-quasienergy alias of the origin. -/
theorem split_step_alias_pi_pi_zero :
    ZeroQuasienergyAlias (masslessWalk Real.pi Real.pi 0) :=
  alias_of_eq_one zero_quasienergy_corner_values.2.1

/-- `(π, 0, π)` is an exact zero-quasienergy alias of the origin. -/
theorem split_step_alias_pi_zero_pi :
    ZeroQuasienergyAlias (masslessWalk Real.pi 0 Real.pi) :=
  alias_of_eq_one zero_quasienergy_corner_values.2.2.1

/-- `(0, π, π)` is an exact zero-quasienergy alias of the origin. -/
theorem split_step_alias_zero_pi_pi :
    ZeroQuasienergyAlias (masslessWalk 0 Real.pi Real.pi) :=
  alias_of_eq_one zero_quasienergy_corner_values.2.2.2

/-- **Determinant-level corner doubling of the live walk.**  The massless
successive-axis walk carries exact zero-quasienergy modes at four *distinct*
Brillouin momenta: the origin and the three even nonzero corners. -/
theorem split_step_zero_mode_doubling :
    ZeroQuasienergyAlias (masslessWalk 0 0 0) ∧
      ZeroQuasienergyAlias (masslessWalk Real.pi Real.pi 0) ∧
      ZeroQuasienergyAlias (masslessWalk Real.pi 0 Real.pi) ∧
      ZeroQuasienergyAlias (masslessWalk 0 Real.pi Real.pi) ∧
      cornerMomentum false false false ≠ cornerMomentum true true false ∧
      cornerMomentum false false false ≠ cornerMomentum true false true ∧
      cornerMomentum false false false ≠ cornerMomentum false true true :=
  ⟨split_step_origin_alias, split_step_alias_pi_pi_zero,
    split_step_alias_pi_zero_pi, split_step_alias_zero_pi_pi,
    origin_alias_pi_pi_zero.1, origin_alias_pi_zero_pi.1,
    origin_alias_zero_pi_pi.1⟩

/-- **The mass coin cannot gap the body center.**  At `(π/2, π/2, π/2)` the
complete massive step has both an exact quasienergy-`0` mode and an exact
quasienergy-`π` mode for every mass angle `θ`, at the determinant level. -/
theorem body_center_persistent_crossings (theta : Real) :
    Matrix.det (bodyCenterWalk theta - 1) = 0 ∧
      Matrix.det (bodyCenterWalk theta + 1) = 0 := by
  refine ⟨?_, ?_⟩
  · rw [← FloquetDeterminantCriterion.exists_plus_mode_iff_det_sub_one_eq_zero]
    exact ⟨bodyCenterPlusMode theta, body_center_plus_mode_ne_zero theta,
      body_center_plus_mode_eigen theta⟩
  · rw [← FloquetDeterminantCriterion.exists_minus_mode_iff_det_add_one_eq_zero]
    exact ⟨bodyCenterMinusMode theta, body_center_minus_mode_ne_zero theta,
      body_center_minus_mode_eigen theta⟩

/-! ## 3. The sharply scoped (architecture-scoped) no-go -/

open StrictQCAMinimalArchitecture StationaryAmplitudeNoGo Compact3Plus1DiracRate

/-- **Scoped no-go, determinant level.**  In the range-one, single-factor-per-axis,
four-channel factorized class with the three exact Dirac tangents and the physical
normalization `U(0) = 1`, the three even nonzero Brillouin corners are *forced* to
satisfy `det(U - 1) = 0` for any momentum-independent onsite coin `Q`.  Thus no
onsite/mass coin removes the corner aliases inside this architecture. -/
theorem factorized_degree_one_forced_corner_aliases
    (Ax Bx Cx Ay By Cy Az Bz Cz Q : Mat4)
    (hUx : UnitaryAllMomenta (laurentStep Ax Bx Cx))
    (hTx : HasRegulatedTangent (laurentStep Ax Bx Cx) alpha1)
    (hUy : UnitaryAllMomenta (laurentStep Ay By Cy))
    (hTy : HasRegulatedTangent (laurentStep Ay By Cy) alpha2)
    (hUz : UnitaryAllMomenta (laurentStep Az Bz Cz))
    (hTz : HasRegulatedTangent (laurentStep Az Bz Cz) alpha3)
    (hnorm : factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 0 0 = 1) :
    ZeroQuasienergyAlias
        (factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q Real.pi Real.pi 0) ∧
      ZeroQuasienergyAlias
        (factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q Real.pi 0 Real.pi) ∧
      ZeroQuasienergyAlias
        (factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 Real.pi Real.pi) := by
  obtain ⟨_, _, _, e1, e2, e3⟩ :=
    live_degree_one_factorized_lower_bound Ax Bx Cx Ay By Cy Az Bz Cz Q
      hUx hTx hUy hTy hUz hTz
  refine ⟨alias_of_eq_one ?_, alias_of_eq_one ?_, alias_of_eq_one ?_⟩
  · rw [← e1]; exact hnorm
  · rw [← e2]; exact hnorm
  · rw [← e3]; exact hnorm

/-- **Nonvacuity control** for the scoped no-go: the canonical directed-hop
factors (`B = 0`) with unit onsite coin populate the hypotheses. -/
theorem factorized_no_go_nonvacuous :
    ∃ Ax Bx Cx Ay By Cy Az Bz Cz Q : Mat4,
      UnitaryAllMomenta (laurentStep Ax Bx Cx) ∧
        HasRegulatedTangent (laurentStep Ax Bx Cx) alpha1 ∧
        UnitaryAllMomenta (laurentStep Ay By Cy) ∧
        HasRegulatedTangent (laurentStep Ay By Cy) alpha2 ∧
        UnitaryAllMomenta (laurentStep Az Bz Cz) ∧
        HasRegulatedTangent (laurentStep Az Bz Cz) alpha3 ∧
        factorizedStep Ax Bx Cx Ay By Cy Az Bz Cz Q 0 0 0 = 1 := by
  obtain ⟨u1, t1, u2, t2, u3, t3⟩ := live_three_axis_zero_stationary_witness
  refine ⟨positiveHop alpha1, 0, negativeHop alpha1,
    positiveHop alpha2, 0, negativeHop alpha2,
    positiveHop alpha3, 0, negativeHop alpha3, 1,
    u1, t1, u2, t2, u3, t3, ?_⟩
  simp [factorizedStep, t1.1, t2.1, t3.1]

/-- **Escape architecture** (nonvacuity of the scope): dropping tangent
involutivity permits a nonzero stationary channel and separates the zone edge,
so the scoped no-go is not vacuous — a nearby architecture escapes it. -/
theorem escape_architecture :
    ∃ A B C M : Mat4,
      Mᴴ = M ∧ M * M ≠ 1 ∧
        UnitaryAllMomenta (laurentStep A B C) ∧
        HasRegulatedTangent (laurentStep A B C) M ∧
        HasStationaryAmplitude B ∧ SeparatesPi (laurentStep A B C) :=
  noninvolutory_tangent_escape_witness

/-! ## 4. The abstract Nielsen–Ninomiya doubling gate -/

/-- A Brillouin symbol on the 3-torus: internal `4`-channel matrix at each
momentum. -/
abbrev Sym := (Fin 3 → ℝ) → Mat4

/-- Exact unitarity at every Brillouin-zone momentum. -/
def UnitaryBZ (U : Sym) : Prop :=
  ∀ q, U q ∈ Matrix.unitaryGroup (Fin 4) ℂ

/-- The three live Dirac velocity generators indexed by axis. -/
def diracAlpha : Fin 3 → Mat4
  | 0 => Compact3Plus1DiracRate.alpha1
  | 1 => Compact3Plus1DiracRate.alpha2
  | 2 => Compact3Plus1DiracRate.alpha3

/-- Ray through the origin along Brillouin axis `j`. -/
def axisRay (j : Fin 3) (t : ℝ) : Fin 3 → ℝ := Pi.single j t

/-- **Abstract Nielsen–Ninomiya balance gate (proved).**  If every element of a
finite momentum set `S` is a zero-quasienergy mode, a chirality functional `χ`
is supported on `S` and totals zero over `S`, and the origin `q0 ∈ S` carries
nonzero charge, then some *other* momentum in `S` is also a zero-quasienergy
mode.  The two external inputs isolated by this gate are the balance law `hbal`
(the ported Brillouin-zone degree theorem) and the origin charge `hχ0`. -/
theorem doubling_from_balance
    (U : Sym) (S : Finset (Fin 3 → ℝ)) (χ : (Fin 3 → ℝ) → ℤ)
    (hS : ∀ q ∈ S, Matrix.det (U q - 1) = 0)
    (hbal : ∑ q ∈ S, χ q = 0)
    (q0 : Fin 3 → ℝ) (hq0 : q0 ∈ S) (hχ0 : χ q0 ≠ 0) :
    ∃ q ∈ S, q ≠ q0 ∧ Matrix.det (U q - 1) = 0 := by
  by_contra hcon
  push_neg at hcon
  have hsub : ∀ q ∈ S, q = q0 := by
    intro q hq
    by_contra hne
    exact hcon q hq hne (hS q hq)
  have hsum : ∑ q ∈ S, χ q = χ q0 := by
    refine Finset.sum_eq_single_of_mem q0 hq0 ?_
    intro b hb hbne
    exact absurd (hsub b hb) hbne
  rw [hsum] at hbal
  exact hχ0 hbal

/-! ## 5. The admissible-walk interface and the single frontier hole -/

/-- A strict local admissible walk: an exactly unitary, `2π`-periodic, continuous
Brillouin symbol with a Dirac point at the origin (`U 0 = 1`) whose axiswise
first derivatives realize the three massless Dirac velocity generators. -/
structure AdmissibleWalk where
  U : Sym
  unitary : UnitaryBZ U
  periodic : ∀ (q : Fin 3 → ℝ) (i : Fin 3),
    U (fun k => q k + if k = i then 2 * Real.pi else 0) = U q
  continuous : Continuous U
  origin : U (fun _ => 0) = 1
  dirac : ∀ j : Fin 3,
    HasDerivAt (fun t : ℝ => U (axisRay j t)) ((-Complex.I) • diracAlpha j) 0

/-- The origin is always a zero-quasienergy mode of an admissible walk: `U 0 = 1`
puts the physical Dirac point there.  (Proved; it is the mode the frontier must
show is *doubled*.) -/
theorem admissible_origin_alias (W : AdmissibleWalk) :
    Matrix.det (W.U (fun _ => 0) - 1) = 0 := by
  rw [W.origin, sub_self]
  exact Matrix.det_zero (Fin.pos_iff_nonempty.mp (by norm_num))

/-- **FRONTIER HOLE (open).**  The universal Nielsen–Ninomiya doubling gate: every
admissible strict local walk has a *second*, nonzero Brillouin momentum carrying a
zero-quasienergy mode (`det (U q - 1) = 0`).

This is the genuine mathematical frontier.  Its intended discharge is exactly the
reusable, already-proved tool `doubling_from_balance`: supply the canonical chiral
charge `χ : (Fin 3 → ℝ) → ℤ` on the zero-mode set, the Brillouin-zone balance law
`∑ χ = 0` (the ported degree theorem — the external input), and the nonzero origin
charge `χ 0 ≠ 0` (a finite computation on the massless `α`-tangent).  Because `χ`
is unconstrained here, this existence statement is logically equivalent to the
conclusion of the ported theorem; the two isolated sub-facts (canonical `χ` with
balance, and origin charge) are the real content and are listed as the follow-up
targets.  The statement is nonvacuous: `splitStepWalk` inhabits `AdmissibleWalk`,
and `split_step_zero_mode_doubling` exhibits the doubling for it explicitly. -/
theorem admissible_doubling (W : AdmissibleWalk) :
    ∃ q : Fin 3 → ℝ, q ≠ (fun _ => 0) ∧ Matrix.det (W.U q - 1) = 0 := by
  sorry

/-! ### Nonvacuity of `AdmissibleWalk`: the live successive-axis walk -/

/-- The live massless successive-axis walk as a Brillouin symbol. -/
def splitU : Sym := fun q => masslessWalk (q 0) (q 1) (q 2)

theorem splitU_unitary : UnitaryBZ splitU := by
  intro q
  exact Compact3Plus1DiracRate.splitStep_mem_unitary (q 0) (q 1) (q 2) 0 1

theorem splitU_origin : splitU (fun _ => 0) = 1 := by
  simpa [splitU] using zero_quasienergy_corner_values.1

/-- Axis reduction: along the first axis the successive-axis walk collapses to a
single Dirac factor. -/
theorem masslessWalk_axis0 (t : ℝ) :
    masslessWalk t 0 0 = Compact3Plus1DiracRate.factor t Compact3Plus1DiracRate.alpha1 := by
  simp [masslessWalk, Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor]

theorem masslessWalk_axis1 (t : ℝ) :
    masslessWalk 0 t 0 = Compact3Plus1DiracRate.factor t Compact3Plus1DiracRate.alpha2 := by
  simp [masslessWalk, Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor]

theorem masslessWalk_axis2 (t : ℝ) :
    masslessWalk 0 0 t = Compact3Plus1DiracRate.factor t Compact3Plus1DiracRate.alpha3 := by
  simp [masslessWalk, Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor]

/-
The Dirac factor has the exact first-order tangent `-i g` at the origin.
-/
theorem factor_hasDerivAt (g : Mat4) :
    HasDerivAt (fun t : ℝ => Compact3Plus1DiracRate.factor t g) ((-Complex.I) • g) 0 := by
  unfold factor;
  rw [ hasDerivAt_pi ] ; norm_num [ Real.differentiableAt_sin, Real.differentiableAt_cos ];
  intro i; simp +decide [ hasDerivAt_pi ] ;
  intro j; convert HasDerivAt.sub ( HasDerivAt.mul ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) ( hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ) ( hasDerivAt_const _ _ ) ) using 1 ; norm_num;

theorem splitU_continuous : Continuous splitU := by
  unfold splitU;
  unfold masslessWalk Compact3Plus1DiracRate.splitStep Compact3Plus1DiracRate.factor Compact3Plus1DiracRate.alpha1 Compact3Plus1DiracRate.alpha2 Compact3Plus1DiracRate.alpha3 Compact3Plus1DiracRate.beta;
  fun_prop

theorem splitU_periodic (q : Fin 3 → ℝ) (i : Fin 3) :
    splitU (fun k => q k + if k = i then 2 * Real.pi else 0) = splitU q := by
  fin_cases i <;> simp +decide [ splitU, masslessWalk, Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor, Real.cos_add_two_pi, Real.sin_add_two_pi ] ;

theorem splitU_dirac (j : Fin 3) :
    HasDerivAt (fun t : ℝ => splitU (axisRay j t)) ((-Complex.I) • diracAlpha j) 0 := by
  convert factor_hasDerivAt ( diracAlpha j ) using 1;
  fin_cases j <;> ext t <;> simp +decide [ splitU, axisRay, masslessWalk_axis0, masslessWalk_axis1, masslessWalk_axis2 ]; all_goals rfl

/-- The live successive-axis walk is an inhabitant of `AdmissibleWalk`, so the
frontier hole `admissible_chiral_data` is nonvacuous. -/
def splitStepWalk : AdmissibleWalk where
  U := splitU
  unitary := splitU_unitary
  periodic := splitU_periodic
  continuous := splitU_continuous
  origin := splitU_origin
  dirac := splitU_dirac

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.split_step_zero_mode_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms split_step_zero_mode_doubling

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.body_center_persistent_crossings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_persistent_crossings

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.factorized_degree_one_forced_corner_aliases' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms factorized_degree_one_forced_corner_aliases

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.doubling_from_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubling_from_balance

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
