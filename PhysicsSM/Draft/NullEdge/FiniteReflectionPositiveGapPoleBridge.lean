import PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveKL
import PhysicsSM.Draft.NullEdge.FMSPoleTransfer

/-!
# Finite reflection-positive gap-to-pole bridge

This module composes two previously separate finite rungs. A positive transfer
spectrum and observable overlaps generate a reflected Euclidean Hankel kernel;
the same overlap data generate a diagonal resolvent. If a selected transfer
energy is simple and the observable has nonzero overlap with it, then the
reflected kernel is positive and the resolvent has a nonzero residue at exactly
that energy.

The result is deliberately finite. It does not derive reflection positivity
from a lattice gauge action, reconstruct an infinite-volume Hilbert space,
prove persistence of an atom under a continuum limit, or establish LSZ.

Provenance: clean-room composition of the finite spectral consequences in
`FiniteReflectionPositiveKL` and `FMSPoleTransfer`, informed by the
Osterwalder-Seiler/Luscher transfer-matrix architecture and Usui's lattice
Kallen-Lehmann theorem (arXiv:1201.3415).
-/

open scoped BigOperators
open Filter Set

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge

noncomputable section

/-- Euclidean transfer energy reconstructed from a positive transfer
eigenvalue. -/
def transferEnergy {m : Nat} (lambda : Fin m -> Real) (a : Fin m) : Real :=
  -Real.log (lambda a)

/-- Positive spectral weight supplied by the observable overlap. -/
def spectralWeight {m : Nat} (v : Fin m -> Complex) (a : Fin m) : Real :=
  FMSPoleTransfer.weight v a

/-- Finite Euclidean correlation built from transfer eigenvalues and the same
observable overlaps used by the resolvent. -/
def euclideanCorrelation {m : Nat} (lambda : Fin m -> Real)
    (v : Fin m -> Complex) (n : Nat) : Real :=
  FiniteReflectionPositiveKL.correlation lambda (spectralWeight v) n

/-- Finite energy resolvent built from reconstructed transfer energies. -/
def transferResolvent {m : Nat} (lambda : Fin m -> Real)
    (v : Fin m -> Complex) (z : Complex) : Complex :=
  FMSPoleTransfer.klSum (transferEnergy lambda) v z

/-- Observable norm squares are nonnegative spectral weights, so the associated
reflected two-point kernel is positive semidefinite. -/
theorem reflectedKernel_nonneg {m n : Nat} (lambda : Fin m -> Real)
    (v : Fin m -> Complex) (c : Fin n -> Real) :
    0 <= ∑ t, ∑ s,
      c t * FiniteReflectionPositiveKL.reflectedKernel lambda
        (spectralWeight v) t.val s.val * c s := by
  apply FiniteReflectionPositiveKL.reflectedKernel_nonneg
  intro a
  exact Complex.normSq_nonneg (v a)

/-- A simple visible transfer channel has nonnegative reconstructed energy and
a nonzero resolvent residue equal to its positive overlap weight. -/
theorem selected_atom_has_visible_pole {m : Nat} (lambda : Fin m -> Real)
    (v : Fin m -> Complex) (k : Fin m)
    (hlambda : ∀ a, 0 < lambda a ∧ lambda a <= 1)
    (hSimple : ∀ i, i ≠ k -> transferEnergy lambda i ≠ transferEnergy lambda k)
    (hVisible : v k ≠ 0) :
    0 <= transferEnergy lambda k ∧
      0 < spectralWeight v k ∧
      Tendsto
        (fun z : Complex =>
          (z - (transferEnergy lambda k : Complex)) *
            transferResolvent lambda v z)
        (nhdsWithin (transferEnergy lambda k : Complex)
          ({(transferEnergy lambda k : Complex)} : Set Complex)ᶜ)
        (nhds (spectralWeight v k : Complex)) := by
  refine ⟨FiniteReflectionPositiveKL.transferEnergy_nonneg lambda hlambda k,
    Complex.normSq_pos.mpr hVisible, ?_⟩
  simpa [transferResolvent] using
    FMSPoleTransfer.tendsto_residue_eq_weight
      (transferEnergy lambda) v k hSimple

/-- Finite gap-to-pole capstone. The same overlap weights simultaneously give
reflection positivity for every finite positive-time test and a visible simple
pole at the selected transfer energy. -/
theorem finite_reflection_positive_gap_to_pole {m : Nat}
    (lambda : Fin m -> Real) (v : Fin m -> Complex) (k : Fin m)
    (hlambda : ∀ a, 0 < lambda a ∧ lambda a <= 1)
    (hSimple : ∀ i, i ≠ k -> transferEnergy lambda i ≠ transferEnergy lambda k)
    (hVisible : v k ≠ 0) :
    (∀ (n : Nat) (c : Fin n -> Real),
      0 <= ∑ t, ∑ s,
        c t * FiniteReflectionPositiveKL.reflectedKernel lambda
          (spectralWeight v) t.val s.val * c s) ∧
      0 <= transferEnergy lambda k ∧
      0 < spectralWeight v k ∧
      Tendsto
        (fun z : Complex =>
          (z - (transferEnergy lambda k : Complex)) *
            transferResolvent lambda v z)
        (nhdsWithin (transferEnergy lambda k : Complex)
          ({(transferEnergy lambda k : Complex)} : Set Complex)ᶜ)
        (nhds (spectralWeight v k : Complex)) := by
  refine ⟨fun n c => reflectedKernel_nonneg lambda v c, ?_⟩
  exact selected_atom_has_visible_pole lambda v k hlambda hSimple hVisible

/-- Exact nondegenerate fixture: a visible transfer eigenvalue `1/2` produces
positive mass `log 2`, a positive reflected kernel, and unit resolvent residue.
The unit transfer channel is present but invisible to the observable. -/
theorem two_level_visible_gap_pole_control :
    let lambda : Fin 2 -> Real := ![1, (1 / 2 : Real)]
    let v : Fin 2 -> Complex := ![0, 1]
    let k : Fin 2 := 1
    (∀ (n : Nat) (c : Fin n -> Real),
      0 <= ∑ t, ∑ s,
        c t * FiniteReflectionPositiveKL.reflectedKernel lambda
          (spectralWeight v) t.val s.val * c s) ∧
      transferEnergy lambda k = Real.log 2 ∧
      0 < transferEnergy lambda k ∧
      spectralWeight v k = 1 ∧
      Tendsto
        (fun z : Complex =>
          (z - (transferEnergy lambda k : Complex)) *
            transferResolvent lambda v z)
        (nhdsWithin (transferEnergy lambda k : Complex)
          ({(transferEnergy lambda k : Complex)} : Set Complex)ᶜ)
        (nhds (1 : Complex)) := by
  dsimp
  have hcontrol :=
    FiniteReflectionPositiveKL.two_level_reflection_positive_mass_control
  dsimp at hcontrol
  have hlog : 0 < -Real.log (1 / 2 : Real) := hcontrol.2.2.1
  have henergy : -Real.log (1 / 2 : Real) = Real.log 2 :=
    hcontrol.2.2.2.1
  have hlog2 : 0 < Real.log 2 := henergy ▸ hlog
  have hSimple : ∀ i : Fin 2, i ≠ 1 ->
      transferEnergy ![1, (1 / 2 : Real)] i ≠
        transferEnergy ![1, (1 / 2 : Real)] 1 := by
    intro i hi
    fin_cases i
    · simp [transferEnergy]
      exact ne_of_lt hlog2
    · exact (hi rfl).elim
  have hcap := finite_reflection_positive_gap_to_pole
    ![1, (1 / 2 : Real)] ![(0 : Complex), 1] (1 : Fin 2)
    (by intro a; fin_cases a <;> norm_num) hSimple (by norm_num)
  refine ⟨hcap.1, ?_, hlog, by norm_num [spectralWeight, FMSPoleTransfer.weight], ?_⟩
  · rw [show transferEnergy ![1, (1 / 2 : Real)] (1 : Fin 2) =
        -Real.log (1 / 2 : Real) by rfl]
    exact henergy
  · simpa [spectralWeight, FMSPoleTransfer.weight] using hcap.2.2.2

end

end PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge.finite_reflection_positive_gap_to_pole' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge.finite_reflection_positive_gap_to_pole

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge.two_level_visible_gap_pole_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteReflectionPositiveGapPoleBridge.two_level_visible_gap_pole_control
