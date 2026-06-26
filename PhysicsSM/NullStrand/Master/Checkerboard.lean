import Mathlib
import PhysicsSM.NullStrand.ZigZag.LatticeBeable
import PhysicsSM.NullStrand.Probability.Trajectory
import PhysicsSM.Spinor.CheckerboardDynamics

/-!
# NullStrand.Master.Checkerboard

Real finite checkerboard Bohm–Bell master theorem.

Unlike `PhysicsSM.NullStrand.Master.FiniteModel` and
`PhysicsSM.NullStrand.Master.FoliatedManyParticle`, this module does **not**
package its conclusions as abstract `Prop` fields with bundled witnesses.  Every
conjunct of `checkerboardBohmBell_master` is a concrete mathematical statement
about explicit model data, and each is discharged by an already-proved
checkerboard equivariance / null-step lemma together with the trajectory-measure
infrastructure:

* null-step kinematics —
  `PhysicsSM.NullStrand.ZigZag.actualShift_speed_eq_c`;
* one-step Born equivariance (total Born mass conserved) —
  `PhysicsSM.NullStrand.ZigZag.latticeBeable_oneStep_equivariant`;
* finite-trajectory ( `n`-step ) Born equivariance —
  `PhysicsSM.NullStrand.ZigZag.latticeBeable_nStep_equivariant`;
* stochasticity (nonnegativity + local-mass preservation) of the one-step coin
  transport — `PhysicsSM.NullStrand.ZigZag.coinBornTransport_isStochastic`;
* the actual pathwise checkerboard dynamics is a genuine `n`-step local
  evolution of a delta history —
  `PhysicsSM.Spinor.Checkerboard.pathSum_eq_iterate_evolve`;
* the actual history is a bona-fide random variable: the i.i.d. product of the
  per-step configuration law is a probability measure on the trajectory space
  `ℕ → Chiral × L` —
  `PhysicsSM.NullStrand.Probability.iidTrajMeasure_isProbability`.

The result is finite and explicit; no continuum limit is asserted.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Master

open scoped BigOperators
open MeasureTheory
open PhysicsSM.NullStrand.ZigZag
open PhysicsSM.NullStrand.Probability
open PhysicsSM.Spinor.Checkerboard

/-- Data of a finite checkerboard Bohm–Bell model.

This bundles the *data* of the model only (a finite lattice beable, a
nonnegative Born density, and a `1+1` Feynman-checkerboard corner weight).  None
of the master conclusions are recorded here; they are proved in
`checkerboardBohmBell_master`. -/
structure CheckerboardBohmBellModel (L : Type*) [Fintype L] where
  /-- The finite lattice beable carrying the coin kernel and the null shift. -/
  beable : LatticeBeable L
  /-- The current Born density over positions and chirality. -/
  density : LatticeDensity L
  /-- Born densities are nonnegative. -/
  density_nonneg : ∀ x c, 0 ≤ density x c
  /-- The complex corner/chirality-flip weight of the `1+1` Feynman checkerboard
  (physically `μ = i ε m`). -/
  cornerWeight : ℂ

/-- **Finite checkerboard Bohm–Bell master theorem.**

For any finite checkerboard Bohm–Bell model on a finite lattice `L`, and any
per-step configuration law `stepLaw` on the configuration space `Chiral × L`,
the following all hold simultaneously:

1. **Null steps (Minkowski nullity + time-component normalization).** Each
   chirality branch advances with time-component equal to the common light speed
   (`actualShift_speed_eq_c`) **and** along a genuinely Minkowski-null 4-vector
   (`actualShift_isNull`): `minkowskiSq (step c) = 0` in the `(+---)` convention,
   i.e. the squared time component equals the squared spatial norm.
   *Audit closure (2026-06-25):* the wave-4 caveat is resolved. The finite
   `NullShift` record now stores genuine Minkowski nullity as the field
   `NullShift.null`, so this conjunct is the full nullity statement, not merely a
   time-component normalization. The same nullity content is also carried, for
   the i.i.d. increment process, by the capstone `finiteIIDNullStrand_master`
   (fields `resolution.null` and `step_null`).
2. **One-step Born equivariance.** The total Born mass is invariant under one
   coin step (`latticeBeable_oneStep_equivariant`).
3. **Finite-trajectory Born equivariance.** The total Born mass is invariant
   under every finite iterate of the one-step map
   (`latticeBeable_nStep_equivariant`).
4. **Stochasticity.** The one-step coin transport preserves nonnegativity and
   the local per-site chirality mass (`coinBornTransport_isStochastic`).
5. **Pathwise checkerboard dynamics.** The exact finite checkerboard path sum is
   the `n`-fold iterate of the local two-component evolution applied to a delta
   history (`pathSum_eq_iterate_evolve`); this is a genuine trajectory recursion,
   not a one-step identity.
6. **Actual history is a random variable.** The i.i.d. product of the per-step
   configuration law is a probability measure on the trajectory space
   `ℕ → Chiral × L` (`iidTrajMeasure_isProbability`).

Every conjunct is an explicit statement about the model data and the trajectory
space; no conclusion is assumed as a `Prop` field. -/
theorem checkerboardBohmBell_master
    {L : Type*} [Fintype L] [MeasurableSpace L] (model : CheckerboardBohmBellModel L)
    (stepLaw : Measure (Chiral × L)) [IsProbabilityMeasure stepLaw] :
    -- (1) null steps: genuine Minkowski nullity and time-component normalization
    (∀ c : Chiral,
        PhysicsSM.NullStrand.minkowskiSq (model.beable.shift.step c) = 0
      ∧ model.beable.shift.step c 0 = model.beable.shift.lightSpeed) ∧
    -- (2) one-step Born equivariance
    (latticeBornMass (oneStep model.beable model.density)
      = latticeBornMass model.density) ∧
    -- (3) finite-trajectory Born equivariance
    (∀ n : ℕ, latticeBornMass ((oneStep model.beable)^[n] model.density)
      = latticeBornMass model.density) ∧
    -- (4) stochasticity of the one-step coin transport
    ((∀ x c', 0 ≤ coinBornTransport model.beable model.density x c') ∧
      (∀ x, ∑ c' : Chiral, coinBornTransport model.beable model.density x c'
        = ∑ c : Chiral, model.density x c)) ∧
    -- (5) pathwise checkerboard dynamics is an n-step local evolution
    (∀ (x : Int) (d : Direction) (n : Nat) (y : Int) (e : Direction),
      pathSum model.cornerWeight x d n y e
        = (evolve model.cornerWeight)^[n] (deltaInit x d) y e) ∧
    -- (6) the actual history is a genuine random variable
    IsProbabilityMeasure (Measure.infinitePi (fun _ : ℕ => stepLaw)) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro c
    exact ⟨actualShift_isNull model.beable c, actualShift_speed_eq_c model.beable c⟩
  · exact latticeBeable_oneStep_equivariant model.beable model.density
  · intro n
    exact latticeBeable_nStep_equivariant model.beable model.density n
  · exact coinBornTransport_isStochastic model.beable model.density model.density_nonneg
  · intro x d n y e
    exact pathSum_eq_iterate_evolve model.cornerWeight x d n y e
  · exact iidTrajMeasure_isProbability stepLaw

/-- Concrete non-vacuity witness for the strengthened checkerboard model: a
single lattice site, the identity coin kernel, the zero Born density, an
arbitrary corner weight, and a genuine **null** zig-zag shift whose two
chirality branches move at the speed of light along `±x`
(`step c = ![1, ±1, 0, 0]`, each Minkowski-null in the `(+---)` convention). This
exhibits `CheckerboardBohmBellModel` as inhabited *with the Minkowski-nullity
constraint `NullShift.null` active*, so the strengthened conjunct (1) of
`checkerboardBohmBell_master` is non-vacuous. -/
def checkerboardWitnessModel : CheckerboardBohmBellModel (Fin 1) where
  beable :=
    { coin :=
        { kernel := 1
          nonneg := by intro c c'; by_cases h : c = c' <;> simp [Matrix.one_apply, h]
          rowSum := by intro c; simp [Matrix.one_apply] }
      shift :=
        { step := fun c => if c then ![1, 1, 0, 0] else ![1, -1, 0, 0]
          lightSpeed := 1
          timeComponent := by intro c; cases c <;> rfl
          null := by
            intro c
            cases c <;>
              simp [PhysicsSM.NullStrand.minkowskiSq,
                PhysicsSM.NullStrand.minkowskiInner] <;> norm_num } }
  density := fun _ _ => 0
  density_nonneg := by intro x c; rfl
  cornerWeight := 0

/-- The strengthened checkerboard model is non-vacuous. -/
theorem checkerboardBohmBellModel_nonempty : Nonempty (CheckerboardBohmBellModel (Fin 1)) :=
  ⟨checkerboardWitnessModel⟩

end PhysicsSM.NullStrand.Master
