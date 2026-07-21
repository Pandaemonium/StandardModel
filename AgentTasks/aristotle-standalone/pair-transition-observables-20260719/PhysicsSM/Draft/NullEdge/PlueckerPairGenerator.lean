/-
Provenance: Aristotle job cef7aab7 (fable-24h-pairgen), harvested
2026-07-11 ~12:15 PDT; memo at
`AgentTasks/aristotle-results/pairgen-cef7aab7/.../MEMO_PlueckerPairGenerator.md`.
Statements integrated UNCHANGED except this header and the import
rewire. KERNEL-ONLY (standard three axioms; in-file guards).
KILL-CONDITION RECORD: the submitted headline "Uop 0 1 z m =
pairKick (-i z/m)" was FALSE (my oracle hand-coded the anti-Hermitian
matrix and mislabeled it as pairKick); the prover proved
naive_halfpulse_false instead of silently repairing. Corrected, proved:
pairKick (z/m) - a Hermitian unit-modulus reflection - equals i times
the quarter-period exponential half-pulse of the Hermitian quartic
generator Kop z on the pair sector, both fixing the complement
(halfpulse_low/high/off). Boundary: Kop remains a supplied coupling.
-/
import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

/-!
# The pair kick as the (phase-corrected) half-pulse of a Hermitian quartic generator

This file upgrades the "supplied interaction" of the E lane: the conjugate-oriented
pair-transfer word `pairForward`/`pairBackward` assembles into a finite **Hermitian**
quartic CAR generator `Kop z`, and the exact one-parameter unitary group it generates
(`Uop c s z m`, the closed form of `exp (-i α Kop)` at `cos = c`, `sin = s`, `|z| = m`)
contains the module's `pairKick` as its quarter-period member — **up to the expected
global phase `i`**.

## Boundary (stated plainly for the memo)

This does **not** derive the generator `Kop` from the free walk.  `Kop` remains a supplied
coupling.  What is established here is purely the algebraic fact that the pair kick is not
an arbitrary gate: it is (a global phase times) the exact exponential half-pulse of a finite
Hermitian even quartic CAR generator.

## Kill condition (triggered): pairKick phase convention

The naive claim `Uop 0 1 z m = pairKick (-i z / m)` is **false**: `pairKick` fixes the reverse
(high → low) amplitude to be the *conjugate* of the forward (low → high) amplitude
(a Hermitian, self-adjoint reflection), whereas the true quarter pulse `Uop 0 1 z m = -i·Kop z / m`
is *anti*-Hermitian, so its reverse amplitude is the *negative conjugate* of its forward amplitude.
Concretely the reverse amplitudes differ by a sign (`+i·conj z/m` for `pairKick (-i z/m)` versus
`-i·conj z/m` for `Uop 0 1 z m`).  The corrected identification, proved below, is

  `Uop 0 1 z m` restricted to the pair sector `= (-i) • pairKick (z / m)`,

with `z / m` a **unit** phase (`|z/m| = 1`), which for the `3+4i`, `m=5` witness is exactly the
module's own `witnessUnitPhase = (3+4i)/5`.  See `naive_halfpulse_false` for the exhibited
mismatch and `halfpulse_low` / `halfpulse_high` for the corrected identity.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PlueckerPairGenerator

open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open scoped BigOperators

/-- The Hermitian quartic pair-transfer generator: forward amplitude `z`, reverse `conj z`. -/
def Kop (z : Complex) (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  z • pairForward psi + (starRingEnd Complex) z • pairBackward psi

theorem Kop_eq_quartic (z : Complex) (psi : Fock (Fin 4)) :
    Kop z psi = quarticPairTransfer z psi := rfl

/-
The three nonzero occupation actions of the generator.
-/
theorem Kop_apply (z : Complex) (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    Kop z psi S =
      if S = lowPair then z * psi highPair
      else if S = highPair then (starRingEnd Complex) z * psi lowPair
      else 0 := by
  unfold Kop;
  split_ifs <;> simp_all +decide [ pairForward_apply, pairBackward_apply ]

/-- The closed form of `exp (-i α Kop z)` at `cos = c`, `sin = s`, `|z| = m`. -/
def Uop (c s : Real) (z : Complex) (m : Real) (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  fun S =>
    if S = lowPair then
      (c : Complex) * psi lowPair - Complex.I * (s : Complex) * (z / (m : Complex)) * psi highPair
    else if S = highPair then
      (c : Complex) * psi highPair
        - Complex.I * (s : Complex) * ((starRingEnd Complex) z / (m : Complex)) * psi lowPair
    else psi S

@[simp] theorem Uop_low (c s : Real) (z : Complex) (m : Real) (psi : Fock (Fin 4)) :
    Uop c s z m psi lowPair =
      (c : Complex) * psi lowPair
        - Complex.I * (s : Complex) * (z / (m : Complex)) * psi highPair := by
  simp [Uop]

@[simp] theorem Uop_high (c s : Real) (z : Complex) (m : Real) (psi : Fock (Fin 4)) :
    Uop c s z m psi highPair =
      (c : Complex) * psi highPair
        - Complex.I * (s : Complex) * ((starRingEnd Complex) z / (m : Complex)) * psi lowPair := by
  simp [Uop, highPair_ne_lowPair]

theorem Uop_off (c s : Real) (z : Complex) (m : Real) (psi : Fock (Fin 4))
    (S : Finset (Fin 4)) (hlo : S ≠ lowPair) (hhi : S ≠ highPair) :
    Uop c s z m psi S = psi S := by
  simp [Uop, hlo, hhi]

/-! ## T1 — the generator is Hermitian -/

theorem generator_hermitian (z : Complex) (psi phi : Fock (Fin 4)) :
    fockInner (Kop z psi) phi = fockInner psi (Kop z phi) := by
  convert quarticPairTransfer_isHermitian z psi phi |> Eq.symm using 1

/-! ## T2 — finite closure `K^3 = |z|^2 K` -/

theorem generator_cubed (z : Complex) (psi : Fock (Fin 4)) :
    Kop z (Kop z (Kop z psi)) = (z * (starRingEnd Complex) z) • Kop z psi := by
  ext S; simp +decide [ Kop_apply ]; ring_nf

/-! ## unit coefficient of the normalized phase -/

/-
The normalized forward phase `z / m` has unit modulus.
-/
theorem unit_coefficient (z : Complex) (m : Real)
    (hm : (m : Complex) ^ 2 = z * (starRingEnd Complex) z) (hm_pos : 0 < m) :
    (z / (m : Complex)) * (starRingEnd Complex) (z / (m : Complex)) = 1 := by
  norm_num [ Complex.ext_iff, sq ] at *;
  grind

/-
The naive coefficient `-i z / m` also has unit modulus (the `|u| = 1` sub-claim of T5).
-/
theorem unit_coefficient_naive (z : Complex) (m : Real)
    (hm : (m : Complex) ^ 2 = z * (starRingEnd Complex) z) (hm_pos : 0 < m) :
    (-Complex.I * z / (m : Complex)) * (starRingEnd Complex) (-Complex.I * z / (m : Complex)) = 1 := by
  simp +zetaDelta at *;
  rw [ div_mul_div_comm, div_eq_iff ] <;> ring_nf at * <;> norm_num [ Complex.ext_iff, sq, hm_pos.ne' ] at * ; aesop

/-! ## T3 — group law (angle addition at coefficient level) -/

theorem group_law (c1 s1 c2 s2 : Real) (z : Complex) (m : Real)
    (hm : (m : Complex) ^ 2 = z * (starRingEnd Complex) z) (hm_pos : 0 < m)
    (psi : Fock (Fin 4)) :
    Uop c1 s1 z m (Uop c2 s2 z m psi) =
      Uop (c1 * c2 - s1 * s2) (s1 * c2 + c1 * s2) z m psi := by
  funext S; simp [Uop];
  split_ifs <;> simp_all +decide [ Complex.ext_iff, sq ]; all_goals grind

/-! ## T4 — unitarity on the full occupation-basis inner product -/

theorem unitary (c s : Real) (z : Complex) (m : Real)
    (hm : (m : Complex) ^ 2 = z * (starRingEnd Complex) z) (hm_pos : 0 < m)
    (hcs : c ^ 2 + s ^ 2 = 1) (psi phi : Fock (Fin 4)) :
    fockInner (Uop c s z m psi) (Uop c s z m phi) = fockInner psi phi := by
  have h_unit_coeff : (z / (m : Complex)) * (starRingEnd Complex) (z / (m : Complex)) = 1 := by
    convert unit_coefficient z m hm hm_pos using 1;
  unfold fockInner Uop; simp_all +decide [ Finset.sum_ite ] ;
  simp_all +decide [ Finset.filter_ne', Finset.filter_eq', mul_left_comm, mul_comm ];
  norm_num [ Complex.ext_iff ] at *;
  grobner

/-! ## T5 (corrected) — the quarter pulse is `pairKick` up to the global phase `i`

`halfpulse_low`/`halfpulse_high` give the exact identification on the two pair-sector
components; `halfpulse_off` records that both fix all other occupation amplitudes;
`naive_halfpulse_false` exhibits the sign mismatch that kills the uncorrected claim. -/

theorem halfpulse_low (z : Complex) (m : Real) (psi : Fock (Fin 4)) :
    Uop 0 1 z m psi lowPair = -Complex.I * pairKick (z / (m : Complex)) psi lowPair := by
  unfold Uop; unfold pairKick; norm_num; ring

theorem halfpulse_high (z : Complex) (m : Real) (psi : Fock (Fin 4)) :
    Uop 0 1 z m psi highPair = -Complex.I * pairKick (z / (m : Complex)) psi highPair := by
  unfold pairKick; simp +decide [ mul_comm, mul_left_comm, div_eq_mul_inv ]

theorem halfpulse_off (z : Complex) (m : Real) (psi : Fock (Fin 4))
    (S : Finset (Fin 4)) (hlo : S ≠ lowPair) (hhi : S ≠ highPair) :
    Uop 0 1 z m psi S = psi S :=
  Uop_off 0 1 z m psi S hlo hhi

/-
The uncorrected claim `Uop 0 1 z m = pairKick (-i z/m)` is false: on `highPair` the
reverse amplitudes differ by a sign.  Exhibited on `psi = basisVec lowPair`, where the
values are `-i·conj z/m` and `+i·conj z/m` respectively.
-/
theorem naive_halfpulse_false (z : Complex) (m : Real)
    (hm_pos : 0 < m) (hz : z ≠ 0) :
    Uop 0 1 z m (basisVec lowPair) ≠ pairKick (-Complex.I * z / (m : Complex)) (basisVec lowPair) := by
  contrapose! hz; have := congrFun ‹_› highPair; simp_all +decide [ Uop_high, pairKick ] ;
  simp_all +decide [ Complex.ext_iff, div_eq_mul_inv ];
  simp_all +decide [ basisVec, lowPair ];
  grind

/-! ## T6 — the all-rational `3+4i`, `m = 5` witness -/

/-
The witness normalized phase equals the module's `witnessUnitPhase = (3+4i)/5`.
-/
theorem witness_phase_eq :
    ((3 + 4 * Complex.I) / (5 : Complex)) = witnessUnitPhase := by
  rfl

/-
Unitarity at the concrete rational instance `(c,s) = (4/5, 3/5)`, `z = 3+4i`, `m = 5`.
-/
theorem witness_unitary (psi phi : Fock (Fin 4)) :
    fockInner (Uop (4/5) (3/5) (3 + 4 * Complex.I) 5 psi)
      (Uop (4/5) (3/5) (3 + 4 * Complex.I) 5 phi) = fockInner psi phi := by
  convert unitary _ _ _ _ _ _ _ _ _ using 1;
  · norm_num [ Complex.ext_iff, sq ];
  · norm_num;
  · norm_num

/-
Corrected concrete quarter-pulse identification at the witness (pair-sector components).
-/
theorem witness_halfpulse_low (psi : Fock (Fin 4)) :
    Uop 0 1 (3 + 4 * Complex.I) 5 psi lowPair
      = -Complex.I * pairKick witnessUnitPhase psi lowPair := by
  convert halfpulse_low ( 3 + 4 * Complex.I ) 5 psi using 1

theorem witness_halfpulse_high (psi : Fock (Fin 4)) :
    Uop 0 1 (3 + 4 * Complex.I) 5 psi highPair
      = -Complex.I * pairKick witnessUnitPhase psi highPair := by
  convert halfpulse_high ( 3 + 4 * Complex.I ) 5 psi using 1

/-! ## T7 — negative control: `c^2 + s^2 ≠ 1` breaks unitarity -/

/-
On `psi = basisVec lowPair`, the non-circle instance `(c,s) = (1,1)`, `z = 3+4i`, `m = 5`
inflates the norm: the output inner product is `2`, not the input `1`.
-/
theorem negative_control_value :
    fockInner (Uop 1 1 (3 + 4 * Complex.I) 5 (basisVec lowPair))
      (Uop 1 1 (3 + 4 * Complex.I) 5 (basisVec lowPair)) = 2 := by
  unfold fockInner Uop basisVec;
  rw [ Finset.sum_eq_add ( lowPair ) ( highPair ) ] <;> simp +decide;
  · norm_num [ Complex.ext_iff, div_eq_mul_inv ];
  · aesop

theorem negative_control_input :
    fockInner (basisVec lowPair) (basisVec lowPair) = 1 := by
  unfold fockInner; simp +decide [ basisVec ] ;

theorem negative_control_not_unitary :
    fockInner (Uop 1 1 (3 + 4 * Complex.I) 5 (basisVec lowPair))
      (Uop 1 1 (3 + 4 * Complex.I) 5 (basisVec lowPair))
      ≠ fockInner (basisVec lowPair) (basisVec lowPair) := by
  rw [negative_control_value, negative_control_input]
  norm_num

/-! ## Build-enforced assumption-footprint guards (standard three axioms only) -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.generator_hermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms generator_hermitian

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.generator_cubed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms generator_cubed

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.group_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms group_law

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitary

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.halfpulse_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms halfpulse_low

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.halfpulse_high' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms halfpulse_high

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.naive_halfpulse_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms naive_halfpulse_false

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.witness_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.witness_halfpulse_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_halfpulse_low

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.witness_halfpulse_high' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_halfpulse_high

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairGenerator.negative_control_not_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms negative_control_not_unitary

end PhysicsSM.Draft.NullEdge.PlueckerPairGenerator
