import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
import PhysicsSM.Spinor.PluckerMass

/-!
# A phase-sensitive Pluecker quartic interaction

This module defines a finite four-mode conjugate-oriented pair-transfer
operator.  The
forward two-particle transition amplitude is the primitive spinor wedge `z`,
while the reverse amplitude is `conj z`.  Thus the interacting observable
retains the orientation phase that a free scalar gap depending only on `|z|`
forgets.

This is a finite interacting witness, not a derivation of a Standard Model
vertex, a bound state, or a continuum quantum field theory.

Provenance: clean-room occupation-basis construction using the generic CAR
algebra in `FiniteCARFockBasic` and the trusted spinor wedge in
`PhysicsSM.Spinor.PluckerMass`.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Spinor.PluckerMass
open scoped BigOperators

/-- Occupation-basis vector for four fermionic modes. -/
def basisVec (S : Finset (Fin 4)) : Fock (Fin 4) := fun T =>
  if T = S then 1 else 0

/-- Quartic transfer from the occupied pair `{2,3}` to `{0,1}`. -/
def pairForward (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  create 0 (create 1 (annihilate 3 (annihilate 2 psi)))

/-- Reverse quartic transfer from `{0,1}` to `{2,3}`. -/
def pairBackward (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  create 2 (create 3 (annihilate 1 (annihilate 0 psi)))

/-- Pair transfer with conjugate reverse coefficient. -/
def quarticPairTransfer (z : Complex) (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  z • pairForward psi + (starRingEnd Complex) z • pairBackward psi

/-- The forward two-particle matrix element is exactly `z`. -/
theorem quarticPairTransfer_forward_amplitude (z : Complex) :
    quarticPairTransfer z (basisVec {2, 3}) {0, 1} = z := by
  simp +decide [quarticPairTransfer, pairForward, pairBackward, basisVec, create,
    annihilate, opSign, belowCount]

/-- The reverse two-particle matrix element is exactly the conjugate of `z`. -/
theorem quarticPairTransfer_backward_amplitude (z : Complex) :
    quarticPairTransfer z (basisVec {0, 1}) {2, 3} =
      (starRingEnd Complex) z := by
  simp +decide [quarticPairTransfer, pairForward, pairBackward, basisVec, create,
    annihilate, opSign, belowCount]

/-- The interaction coefficient derived from two primitive null spinors. -/
def plueckerQuartic (psi phi : CSpinor) : Fock (Fin 4) -> Fock (Fin 4) :=
  quarticPairTransfer (spinorWedge psi phi)

/-- The phase-sensitive two-particle observable is the primitive wedge itself. -/
theorem plueckerQuartic_forward_amplitude (psi phi : CSpinor) :
    plueckerQuartic psi phi (basisVec {2, 3}) {0, 1} =
      spinorWedge psi phi := by
  exact quarticPairTransfer_forward_amplitude _

/-- Nondegenerate primitive-spinor fixture with wedge `3+4i`. -/
def witnessPsi : CSpinor := fun i => if i = 0 then 1 else 0

def witnessPhi : CSpinor := fun i => if i = 1 then 3 + 4 * Complex.I else 0

theorem witness_spinorWedge :
    spinorWedge witnessPsi witnessPhi = 3 + 4 * Complex.I := by
  simp [spinorWedge, witnessPsi, witnessPhi]

/-- At the `3+4i` witness, forward and reverse pair-transfer amplitudes differ;
the observable therefore detects orientation phase, not only the norm `5`. -/
theorem witness_pair_orientation_sensitive :
    plueckerQuartic witnessPsi witnessPhi (basisVec {2, 3}) {0, 1} ≠
      plueckerQuartic witnessPsi witnessPhi (basisVec {0, 1}) {2, 3} := by
  rw [plueckerQuartic_forward_amplitude]
  change spinorWedge witnessPsi witnessPhi ≠
    quarticPairTransfer (spinorWedge witnessPsi witnessPhi)
      (basisVec {0, 1}) {2, 3}
  rw [quarticPairTransfer_backward_amplitude, witness_spinorWedge]
  intro h
  have him := congrArg Complex.im h
  norm_num at him

/-! ## An exactly reversible phase-sensitive interaction kick -/

def lowPair : Finset (Fin 4) := {0, 1}

def highPair : Finset (Fin 4) := {2, 3}

theorem lowPair_ne_highPair : lowPair ≠ highPair := by decide

theorem highPair_ne_lowPair : highPair ≠ lowPair := lowPair_ne_highPair.symm

/-- Swap the two distinguished pair amplitudes with conjugate phase weights,
leaving all other occupation amplitudes unchanged. -/
def pairKick (u : Complex) (psi : Fock (Fin 4)) : Fock (Fin 4) := fun S =>
  if S = lowPair then u * psi highPair
  else if S = highPair then (starRingEnd Complex) u * psi lowPair
  else psi S

/-- Standard conjugate-linear-in-the-first-slot occupation-basis form. -/
def fockInner (psi phi : Fock (Fin 4)) : Complex :=
  ∑ S : Finset (Fin 4), (starRingEnd Complex) (psi S) * phi S

theorem fockInner_conj_symm (psi phi : Fock (Fin 4)) :
    (starRingEnd Complex) (fockInner psi phi) = fockInner phi psi := by
  simp [fockInner, map_sum, map_mul]
  apply Finset.sum_congr rfl
  intro S _
  ring

/-- The forward quartic word has exactly one nonzero occupation transition. -/
theorem pairForward_apply (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    pairForward psi S = if S = lowPair then psi highPair else 0 := by
  classical
  fin_cases S <;>
    simp +decide [pairForward, highPair, create, annihilate, opSign, belowCount]
  all_goals congr 1

/-- The backward quartic word is the reverse occupation transition. -/
theorem pairBackward_apply (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    pairBackward psi S = if S = highPair then psi lowPair else 0 := by
  classical
  fin_cases S <;>
    simp +decide [pairBackward, lowPair, create, annihilate, opSign, belowCount]
  all_goals congr 1

theorem fockInner_quartic_right (z : Complex)
    (psi phi : Fock (Fin 4)) :
    fockInner psi (quarticPairTransfer z phi) =
      (starRingEnd Complex) (psi lowPair) * z * phi highPair +
        (starRingEnd Complex) (psi highPair) *
          (starRingEnd Complex) z * phi lowPair := by
  classical
  simp only [fockInner, quarticPairTransfer, Pi.add_apply, Pi.smul_apply,
    smul_eq_mul, pairForward_apply, pairBackward_apply, mul_add,
    Finset.sum_add_distrib]
  simp only [mul_ite, mul_zero]
  rw [Fintype.sum_ite_eq', Fintype.sum_ite_eq']
  ring

/-- The conjugate-oriented quartic pair-transfer operator is Hermitian on the
full finite occupation-basis Fock space. -/
theorem quarticPairTransfer_isHermitian (z : Complex)
    (psi phi : Fock (Fin 4)) :
    fockInner psi (quarticPairTransfer z phi) =
      fockInner (quarticPairTransfer z psi) phi := by
  rw [<- fockInner_conj_symm phi (quarticPairTransfer z psi)]
  rw [fockInner_quartic_right, fockInner_quartic_right]
  simp only [map_add, map_mul, Complex.conj_conj]
  ring

/-- Orthogonal coordinate projection onto the distinguished pair sector. -/
def pairSectorProject (psi : Fock (Fin 4)) : Fock (Fin 4) := fun S =>
  if S = lowPair ∨ S = highPair then psi S else 0

/-- The pair kick is exactly the quartic transfer on the pair sector and the
identity on its coordinate complement. -/
theorem pairKick_eq_quartic_add_offPair (u : Complex)
    (psi : Fock (Fin 4)) :
    pairKick u psi =
      quarticPairTransfer u psi + (psi - pairSectorProject psi) := by
  funext S
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick, quarticPairTransfer, pairSectorProject, pairForward_apply,
      pairBackward_apply, lowPair_ne_highPair]
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, quarticPairTransfer, pairSectorProject, pairForward_apply,
        pairBackward_apply, highPair_ne_lowPair]
    · simp [pairKick, quarticPairTransfer, pairSectorProject, pairForward_apply,
        pairBackward_apply, hlo, hhi]

/-- For unit phase, the Hermitian quartic squares to the projector onto its
two-particle support. -/
theorem quarticPairTransfer_sq_eq_project (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock (Fin 4)) :
    quarticPairTransfer u (quarticPairTransfer u psi) =
      pairSectorProject psi := by
  have hstar : (starRingEnd Complex) u * u = 1 := by
    simpa [mul_comm] using hu
  funext S
  by_cases hlo : S = lowPair
  · subst S
    simp [quarticPairTransfer, pairForward_apply, pairBackward_apply,
      pairSectorProject, lowPair_ne_highPair, highPair_ne_lowPair]
    calc
      u * ((starRingEnd Complex) u * psi lowPair) =
          (u * (starRingEnd Complex) u) * psi lowPair := by ring
      _ = psi lowPair := by rw [hu, one_mul]
  · by_cases hhi : S = highPair
    · subst S
      simp [quarticPairTransfer, pairForward_apply, pairBackward_apply,
        pairSectorProject, lowPair_ne_highPair, highPair_ne_lowPair]
      calc
        (starRingEnd Complex) u * (u * psi highPair) =
            ((starRingEnd Complex) u * u) * psi highPair := by ring
        _ = psi highPair := by rw [hstar, one_mul]
    · simp [quarticPairTransfer, pairForward_apply, pairBackward_apply,
        pairSectorProject, hlo, hhi]

/-- A unit-modulus pair kick is its own exact inverse. -/
theorem pairKick_involutive (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock (Fin 4)) :
    pairKick u (pairKick u psi) = psi := by
  funext S
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick, highPair_ne_lowPair]
    calc
      u * ((starRingEnd Complex) u * psi lowPair) =
          (u * (starRingEnd Complex) u) * psi lowPair := by ring
      _ = psi lowPair := by rw [hu, one_mul]
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, highPair_ne_lowPair]
      calc
        (starRingEnd Complex) u * (u * psi highPair) =
            (u * (starRingEnd Complex) u) * psi highPair := by ring
        _ = psi highPair := by rw [hu, one_mul]
    · simp [pairKick, hlo, hhi]

/-- Occupation-label swap underlying `pairKick`. -/
def pairSwapOccupation (S : Finset (Fin 4)) : Finset (Fin 4) :=
  if S = lowPair then highPair else if S = highPair then lowPair else S

theorem pairSwapOccupation_involutive : Function.Involutive pairSwapOccupation := by
  intro S
  by_cases hlo : S = lowPair
  · subst S
    simp [pairSwapOccupation, highPair_ne_lowPair]
  · by_cases hhi : S = highPair
    · subst S
      simp [pairSwapOccupation, highPair_ne_lowPair]
    · simp [pairSwapOccupation, hlo, hhi]

def pairSwapEquiv : Finset (Fin 4) ≃ Finset (Fin 4) where
  toFun := pairSwapOccupation
  invFun := pairSwapOccupation
  left_inv := pairSwapOccupation_involutive
  right_inv := pairSwapOccupation_involutive

/-- Squared Fock norm in the finite occupation basis. -/
def fockNormSq (psi : Fock (Fin 4)) : Real :=
  ∑ S : Finset (Fin 4), Complex.normSq (psi S)

theorem normSq_pairKick (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock (Fin 4))
    (S : Finset (Fin 4)) :
    Complex.normSq (pairKick u psi S) =
      Complex.normSq (psi (pairSwapOccupation S)) := by
  have hnorm : Complex.normSq u = 1 := by
    have hnormComplex := complexAbsSq_eq_ofReal_normSq u
    rw [complexAbsSq, hu] at hnormComplex
    exact_mod_cast hnormComplex.symm
  have hnormStar : Complex.normSq ((starRingEnd Complex) u) = 1 := by
    rw [Complex.normSq_conj, hnorm]
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick, pairSwapOccupation, Complex.normSq_mul, hnorm]
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, pairSwapOccupation, highPair_ne_lowPair,
        Complex.normSq_mul, hnormStar]
    · simp [pairKick, pairSwapOccupation, hlo, hhi]

/-- A unit-modulus pair kick preserves the exact finite Fock norm. -/
theorem pairKick_preserves_fockNormSq (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock (Fin 4)) :
    fockNormSq (pairKick u psi) = fockNormSq psi := by
  unfold fockNormSq
  calc
    (∑ S : Finset (Fin 4), Complex.normSq (pairKick u psi S)) =
        ∑ S : Finset (Fin 4), Complex.normSq
          (psi (pairSwapEquiv S)) := by
      apply Finset.sum_congr rfl
      intro S _
      exact normSq_pairKick u hu psi S
    _ = ∑ S : Finset (Fin 4), Complex.normSq (psi S) :=
      Equiv.sum_comp pairSwapEquiv (fun S => Complex.normSq (psi S))

/-- The pair kick is additive. -/
theorem pairKick_add (u : Complex) (psi phi : Fock (Fin 4)) :
    pairKick u (psi + phi) = pairKick u psi + pairKick u phi := by
  funext S
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick]
    ring
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, highPair_ne_lowPair]
      ring
    · simp [pairKick, hlo, hhi]

/-- The pair kick commutes with complex scalar multiplication. -/
theorem pairKick_smul (u c : Complex) (psi : Fock (Fin 4)) :
    pairKick u (c • psi) = c • pairKick u psi := by
  funext S
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick]
    ring
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, highPair_ne_lowPair]
      ring
    · simp [pairKick, hlo, hhi]

lemma pairKick_inner_term (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1)
    (psi phi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    (starRingEnd Complex) (pairKick u psi S) * pairKick u phi S =
      (starRingEnd Complex) (psi (pairSwapOccupation S)) *
        phi (pairSwapOccupation S) := by
  have hstar : (starRingEnd Complex) u * u = 1 := by
    simpa [mul_comm] using hu
  by_cases hlo : S = lowPair
  · subst S
    simp [pairKick, pairSwapOccupation, map_mul]
    calc
      (starRingEnd Complex) u * (starRingEnd Complex) (psi highPair) *
          (u * phi highPair) =
        ((starRingEnd Complex) u * u) *
          ((starRingEnd Complex) (psi highPair) * phi highPair) := by ring
      _ = (starRingEnd Complex) (psi highPair) * phi highPair := by
        rw [hstar, one_mul]
  · by_cases hhi : S = highPair
    · subst S
      simp [pairKick, pairSwapOccupation, highPair_ne_lowPair, map_mul]
      calc
        u * (starRingEnd Complex) (psi lowPair) *
            ((starRingEnd Complex) u * phi lowPair) =
          (u * (starRingEnd Complex) u) *
            ((starRingEnd Complex) (psi lowPair) * phi lowPair) := by ring
        _ = (starRingEnd Complex) (psi lowPair) * phi lowPair := by
          rw [hu, one_mul]
    · simp [pairKick, pairSwapOccupation, hlo, hhi]

/-- A unit-modulus pair kick preserves the full occupation-basis inner product. -/
theorem pairKick_preserves_fockInner (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1)
    (psi phi : Fock (Fin 4)) :
    fockInner (pairKick u psi) (pairKick u phi) = fockInner psi phi := by
  unfold fockInner
  calc
    (∑ S : Finset (Fin 4),
        (starRingEnd Complex) (pairKick u psi S) * pairKick u phi S) =
      ∑ S : Finset (Fin 4),
        (starRingEnd Complex) (psi (pairSwapEquiv S)) *
          phi (pairSwapEquiv S) := by
        apply Finset.sum_congr rfl
        intro S _
        exact pairKick_inner_term u hu psi phi S
    _ = ∑ S : Finset (Fin 4), (starRingEnd Complex) (psi S) * phi S :=
      Equiv.sum_comp pairSwapEquiv
        (fun S => (starRingEnd Complex) (psi S) * phi S)

/-- The unit-modulus pair kick as a complex-linear equivalence. -/
def pairKickLinearEquiv (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) :
    Fock (Fin 4) ≃ₗ[Complex] Fock (Fin 4) where
  toFun := pairKick u
  invFun := pairKick u
  map_add' := pairKick_add u
  map_smul' := pairKick_smul u
  left_inv := pairKick_involutive u hu
  right_inv := pairKick_involutive u hu

@[simp] theorem pairKickLinearEquiv_apply (u : Complex)
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock (Fin 4)) :
    pairKickLinearEquiv u hu psi = pairKick u psi := rfl

/-- Unit phase of the nondegenerate `3+4i` Pluecker fixture. -/
def witnessUnitPhase : Complex := (3 + 4 * Complex.I) / 5

theorem witnessUnitPhase_unitary :
    witnessUnitPhase * (starRingEnd Complex) witnessUnitPhase = 1 := by
  rw [mul_comm, <- Complex.normSq_eq_conj_mul_self]
  norm_num [witnessUnitPhase, Complex.normSq_div, Complex.normSq_apply]

/-- The explicit Pluecker-phase kick is exactly reversible. -/
theorem witnessPairKick_involutive (psi : Fock (Fin 4)) :
    pairKick witnessUnitPhase (pairKick witnessUnitPhase psi) = psi := by
  exact pairKick_involutive witnessUnitPhase witnessUnitPhase_unitary psi

theorem witnessPairKick_preserves_fockNormSq (psi : Fock (Fin 4)) :
    fockNormSq (pairKick witnessUnitPhase psi) = fockNormSq psi := by
  exact pairKick_preserves_fockNormSq witnessUnitPhase
    witnessUnitPhase_unitary psi

theorem witnessPairKick_preserves_fockInner (psi phi : Fock (Fin 4)) :
    fockInner (pairKick witnessUnitPhase psi)
      (pairKick witnessUnitPhase phi) = fockInner psi phi := by
  exact pairKick_preserves_fockInner witnessUnitPhase
    witnessUnitPhase_unitary psi phi

/-- The explicit `3+4i` phase kick as a complex-linear automorphism. -/
def witnessPairKickLinearEquiv : Fock (Fin 4) ≃ₗ[Complex] Fock (Fin 4) :=
  pairKickLinearEquiv witnessUnitPhase witnessUnitPhase_unitary

/-- Its oriented pair-transition amplitude is the normalized Pluecker phase. -/
theorem witnessPairKick_forward_amplitude :
    pairKick witnessUnitPhase (basisVec highPair) lowPair =
      witnessUnitPhase := by
  simp [pairKick, basisVec]

/-- The pair kick is invisible on every one-particle occupation basis state. -/
theorem pairKick_singleton (u : Complex) (i : Fin 4) :
    pairKick u (basisVec {i}) = basisVec {i} := by
  fin_cases i <;> funext S <;>
    by_cases hlo : S = lowPair <;> by_cases hhi : S = highPair <;>
    simp_all +decide [pairKick, basisVec, lowPair, highPair]

theorem witnessUnitPhase_ne_zero : witnessUnitPhase ≠ 0 := by
  intro hzero
  have hunit := witnessUnitPhase_unitary
  rw [hzero, zero_mul] at hunit
  norm_num at hunit

/-- The same kick is nontrivial on a two-particle state. -/
theorem witnessPairKick_two_particle_nontrivial :
    pairKick witnessUnitPhase (basisVec highPair) ≠ basisVec highPair := by
  intro heq
  have hamp := congrFun heq lowPair
  rw [witnessPairKick_forward_amplitude] at hamp
  simp [basisVec, lowPair_ne_highPair] at hamp
  exact witnessUnitPhase_ne_zero hamp

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.plueckerQuartic_forward_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plueckerQuartic_forward_amplitude

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witness_pair_orientation_sensitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_pair_orientation_sensitive

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witnessPairKick_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witnessPairKick_preserves_fockNormSq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_preserves_fockNormSq

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witnessPairKick_preserves_fockInner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_preserves_fockInner

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witnessPairKickLinearEquiv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKickLinearEquiv

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.quarticPairTransfer_isHermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quarticPairTransfer_isHermitian

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.pairKick_eq_quartic_add_offPair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairKick_eq_quartic_add_offPair

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.quarticPairTransfer_sq_eq_project' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quarticPairTransfer_sq_eq_project

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction.witnessPairKick_two_particle_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_two_particle_nontrivial

end PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
