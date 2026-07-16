import Mathlib

/-!
Prove the schedule-level algebra behind the spin-blind 3+1 obstruction.
Each momentum-dependent primitive shift is a scalar phase times the identity;
each coin is fixed and momentum-independent. Show that any finite alternating
schedule collapses to one scalar phase times one fixed internal matrix. This is
the missing bridge from an actual schedule to scalar logarithmic derivatives.

Provenance: clean-room formalization returned by Aristotle job
`4edbc70c-620c-424d-8895-0a83581753c3`, then adapted to the live namespace and
audited against the spin-blind obstruction's intended schedule semantics.
-/

namespace PhysicsSM.Draft.NullEdge.SpinBlindScheduleCollapse

open Matrix

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

noncomputable def stage (s : Complex) (C : M2) : M2 := (s • (1 : M2)) * C

/-- A spin-blind scalar shift commutes through an arbitrary fixed coin. -/
theorem stage_eq_scalar_coin (s : Complex) (C : M2) : stage s C = s • C := by
  rw [stage, smul_mul_assoc, one_mul]

/-- Two spin-blind shift/coin stages collapse to one scalar and one fixed coin. -/
theorem two_stage_collapse (s t : Complex) (C D : M2) :
    stage s C * stage t D = (s * t) • (C * D) := by
  rw [stage_eq_scalar_coin, stage_eq_scalar_coin, smul_mul_assoc, mul_smul_comm, smul_smul]

/-- Left-multiplication factors out of a monoid `foldl`: folding a list of fixed
coins from a left accumulator `a` equals `a` times the fold started from `1`. -/
theorem foldl_mul_assoc (l : List M2) (a : M2) :
    l.foldl (· * ·) a = a * l.foldl (· * ·) 1 := by
  induction l generalizing a with
  | nil => simp
  | cons x xs ih =>
    simp only [List.foldl_cons]
    rw [ih (a * x), ih (1 * x), one_mul, mul_assoc]

/-- Generalized fold: pushing an arbitrary left accumulator `U` through the
schedule fold factors the accumulated scalars out front and leaves `U` on the
left of the accumulated fixed coins. This is the induction workhorse. -/
theorem foldl_collapse_aux (xs : List (Complex × M2)) (U : M2) :
    xs.foldl (fun U x => U * stage x.1 x.2) U =
      (xs.map Prod.fst).prod • (U * (xs.map Prod.snd).foldl (· * ·) 1) := by
  induction xs generalizing U with
  | nil => simp
  | cons x xs ih =>
    simp only [List.foldl_cons, List.map_cons, List.prod_cons, one_mul]
    rw [ih (U * stage x.1 x.2), stage_eq_scalar_coin, mul_smul_comm,
        foldl_mul_assoc (xs.map Prod.snd) x.2, smul_mul_assoc, smul_smul,
        mul_comm (xs.map Prod.fst).prod x.1, ← mul_assoc U x.2]

/-- Finite schedules collapse: any finite alternating schedule of scalar
spin-blind shifts and fixed coins equals the product of the scalars times the
ordered product of the fixed coins. -/
theorem finite_schedule_collapse :
    ∀ (xs : List (Complex × M2)),
      xs.foldl (fun U x => U * stage x.1 x.2) 1 =
        (xs.map Prod.fst).prod • (xs.map Prod.snd).foldl (· * ·) 1 := by
  intro xs
  rw [foldl_collapse_aux xs 1, one_mul]

/-! ### Explicit nonidentity two-stage control witness

A concrete nonempty two-stage schedule whose collapse is a nontrivial scalar
multiple of a fixed coin, and which is manifestly not the identity. This certifies
that the collapse theorems are not vacuous. -/

/-- The first Pauli matrix, used as a concrete fixed coin. -/
noncomputable def pauliX : M2 := !![0, 1; 1, 0]

/-- The two-stage witness collapses exactly as predicted by `two_stage_collapse`. -/
theorem witness_collapse :
    stage 2 (1 : M2) * stage 3 pauliX = (6 : Complex) • pauliX := by
  rw [two_stage_collapse, one_mul]; norm_num

/-- The two-stage witness is genuinely not the identity: the schedule performs
nontrivial internal mixing. -/
theorem witness_ne_one :
    stage 2 (1 : M2) * stage 3 pauliX ≠ 1 := by
  rw [witness_collapse]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  simp [pauliX] at h00

/-! ### Derivative bridge

The collapse theorems reduce any schedule to `scalar • Cfixed`, where `Cfixed`
is momentum-independent (constant). To pass from this collapsed form to a scalar
*logarithmic derivative* one needs a differentiable family of scalars. We record
precisely which further hypotheses are required.

`scalar_logDeriv_algebraic` is the algebraic logarithmic derivative
`logDeriv scalar k = deriv scalar k / scalar k`; it holds unconditionally (it is
Mathlib's definition of `logDeriv`), but is only *meaningful/finite* when `scalar`
is differentiable at `k` with `scalar k ≠ 0`. Those are precisely the further
hypotheses one must supply to make the scalar logarithmic derivative usable.

`scalar_logDeriv_bridge` is the analytic statement: the logarithmic derivative
is the honest derivative of `Complex.log ∘ scalar`. Beyond differentiability of
the scalar family this requires exactly one extra hypothesis, namely
`scalar k ∈ Complex.slitPlane` (i.e. `scalar k` is off the branch cut, so `log`
is differentiable there). No differentiability of the fixed coin is needed, since
it is constant. -/

/-- Algebraic logarithmic derivative of the collapsed scalar. This identity is
unconditional; the differentiability of `scalar` at `k` and `scalar k ≠ 0` are
exactly the further hypotheses needed to make the right-hand side finite and
meaningful (see `scalar_logDeriv_bridge` for the analytic content). -/
theorem scalar_logDeriv_algebraic (scalar : ℝ → Complex) (k : ℝ) :
    logDeriv scalar k = deriv scalar k / scalar k :=
  logDeriv_apply scalar k

/-- Analytic derivative bridge. Under differentiability of the scalar family at
`k` and the branch-cut condition `scalar k ∈ Complex.slitPlane`, the scalar
logarithmic derivative `deriv scalar k / scalar k` is realized as the honest
derivative of `Complex.log ∘ scalar`. These are exactly the further hypotheses
required to infer scalar logarithmic derivatives from a collapsed schedule. -/
theorem scalar_logDeriv_bridge
    (scalar : ℝ → Complex) (k : ℝ)
    (hdiff : DifferentiableAt ℝ scalar k) (hslit : scalar k ∈ Complex.slitPlane) :
    HasDerivAt (fun x => Complex.log (scalar x)) (deriv scalar k / scalar k) k := by
  have := (Complex.hasDerivAt_log hslit).comp k hdiff.hasDerivAt
  simpa [div_eq_inv_mul] using this

/-! ### Build-enforced standard-axiom reports -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindScheduleCollapse.finite_schedule_collapse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_schedule_collapse

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindScheduleCollapse.witness_ne_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_ne_one

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindScheduleCollapse.scalar_logDeriv_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_logDeriv_bridge

end PhysicsSM.Draft.NullEdge.SpinBlindScheduleCollapse
