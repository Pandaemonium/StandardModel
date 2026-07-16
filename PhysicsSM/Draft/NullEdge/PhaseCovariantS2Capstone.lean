import PhysicsSM.Draft.NullEdge.DYNModularMaxEntCapstone
import PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection

/-!
# Arbitrary-phase qubit max-entropy and modular-selection capstone

This focused draft transports the accepted `z = 1` noncommuting qubit
max-entropy theorem to every nonzero complex Pluecker coupling.  The transported
state is defined by the same explicit diagonal unitary that removes the phase
from `Bz z`.  The target keeps the modulus rescaling and all supplied inputs
visible.

The result is finite `2 x 2` algebra.  It does not claim that a constant
single-site phase is observable, that a spatial connection has been built, or
that the state has been derived from continuum dynamics.

Provenance: theorem statements were prepared in the Autonomous Fundamental
Physics Lab and proved by Aristotle project
`65c69022-89c5-4356-af6e-1a8be96e2655`. The returned source was replayed
locally under Lean 4.28 before cross-family semantic review.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone

open Matrix
open QubitFixedEnergyMaxEntropy
open PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection

/-- Pull a canonical Bloch state back through the phase-removing unitary. -/
def gaugedBloch (z : Complex) (e u v : Real) : Matrix (Fin 2) (Fin 2) Complex :=
  (phaseGauge z)ᴴ * pairBloch e u v * phaseGauge z

/-- The inverse temperature whose product with `norm z` is the canonical
`-artanh e` inverse temperature. -/
def betaZ (z : Complex) (e : Real) : Real := -Real.artanh e / ‖z‖

/-- Conjugation by the phase gauge preserves Hermiticity of the Bloch family. -/
theorem gaugedBloch_isHermitian (z : Complex) (e u v : Real) :
    (gaugedBloch z e u v).IsHermitian := by
  unfold gaugedBloch; rw [ Matrix.IsHermitian, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul ] ; simp +decide [ Matrix.conjTranspose_conjTranspose ] ;
  rw [ Matrix.mul_assoc, pairBloch_isHermitian e u v ]

/-- For `2 x 2` Hermitian matrices the spectral von Neumann entropy depends only
on the trace and determinant (equivalently, only on the unordered eigenvalue
pair), since in dimension two those two symmetric functions determine the
eigenvalues. -/
theorem vonNeumannEntropy_eq_of_trace_det_eq
    (A B : Matrix (Fin 2) (Fin 2) Complex) (hA : A.IsHermitian) (hB : B.IsHermitian)
    (htr : A.trace = B.trace) (hdet : A.det = B.det) :
    VNEntropyPurity.vonNeumannEntropy A hA = VNEntropyPurity.vonNeumannEntropy B hB := by
  have h_trace_det : hA.eigenvalues 0 + hA.eigenvalues 1 = hB.eigenvalues 0 + hB.eigenvalues 1 ∧ hA.eigenvalues 0 * hA.eigenvalues 1 = hB.eigenvalues 0 * hB.eigenvalues 1 := by
    have h_trace_det : Matrix.trace A = hA.eigenvalues 0 + hA.eigenvalues 1 ∧ Matrix.trace B = hB.eigenvalues 0 + hB.eigenvalues 1 ∧ Matrix.det A = hA.eigenvalues 0 * hA.eigenvalues 1 ∧ Matrix.det B = hB.eigenvalues 0 * hB.eigenvalues 1 := by
      have := Matrix.IsHermitian.trace_eq_sum_eigenvalues hA; have := Matrix.IsHermitian.trace_eq_sum_eigenvalues hB; have := Matrix.IsHermitian.det_eq_prod_eigenvalues hA; have := Matrix.IsHermitian.det_eq_prod_eigenvalues hB; simp_all +decide [ Fin.sum_univ_two, Fin.prod_univ_two ] ;
    norm_num [ Complex.ext_iff ] at * ; aesop;
  by_cases h_cases : hA.eigenvalues 0 = hB.eigenvalues 0 ∨ hA.eigenvalues 0 = hB.eigenvalues 1;
  · cases h_cases <;> simp_all +decide [ VNEntropyPurity.vonNeumannEntropy ];
    rw [ show hA.eigenvalues 1 = hB.eigenvalues 0 by linarith ] ; ring;
  · grind

/-- The phase transport does not change the spectral von Neumann entropy. -/
theorem gaugedBloch_entropy_eq (z : Complex) (hz : z ≠ 0) (e u v : Real) :
    VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) =
      VNEntropyPurity.vonNeumannEntropy
        (pairBloch e u v) (pairBloch_isHermitian e u v) := by
  convert vonNeumannEntropy_eq_of_trace_det_eq ( gaugedBloch z e u v ) ( pairBloch e u v ) ( gaugedBloch_isHermitian z e u v ) ( pairBloch_isHermitian e u v ) _ _ using 1;
  · unfold gaugedBloch;
    rw [ Matrix.trace_mul_comm ];
    rw [ ← Matrix.mul_assoc, phaseGauge_unitary z hz, Matrix.one_mul ];
  · unfold gaugedBloch;
    simp +decide [ Matrix.det_fin_two, phaseGauge ];
    unfold pairBloch; norm_num [ Complex.ext_iff ] ; ring;
    field_simp;
    norm_num [ Complex.normSq, Complex.sq_norm ] ; ring

/-- Conjunct 3 helper: the transported zero-transverse state is the Gibbs state
of `Bz z` at the rescaled inverse temperature `betaZ z e`. -/
theorem gaugedBloch_zero_eq_gibbsState (z : Complex) (hz : z ≠ 0) (e : Real)
    (he : |e| < 1) :
    gaugedBloch z e 0 0 =
      ModularSelection.gibbsState (PairModularSelection.Bz z) (betaZ z e) := by
  unfold gaugedBloch;
  have hconj : phaseGauge z * ModularSelection.gibbsState (PairModularSelection.Bz z) (betaZ z e) * (phaseGauge z)ᴴ = pairBloch e 0 0 := by
    convert gibbsState_conj z hz ( betaZ z e ) using 1;
    unfold betaZ; ring_nf; norm_num [ hz ] ;
    exact QubitGibbsBridge.pairBloch_zero_eq_gibbsState e he
  rw [ ← hconj, Matrix.mul_assoc ];
  have hPP : (phaseGauge z)ᴴ * phaseGauge z = 1 := by
    convert mul_eq_one_comm.mp ( phaseGauge_unitary z hz ) using 1
  rw [ Matrix.mul_assoc ] ;
  simp +decide [ ← Matrix.mul_assoc, hPP ]

/-- Conjunct 4 helper: normalized-energy identity for the transported family. -/
theorem gaugedBloch_normalized_energy (z : Complex) (hz : z ≠ 0) (e u v : Real) :
    (((gaugedBloch z e u v) *
        ((‖z‖ : Complex)⁻¹ • PairModularSelection.Bz z)).trace.re = e) := by
  unfold gaugedBloch;
  simp +decide [ Matrix.trace_smul ];
  convert congr_arg Complex.re ( congr_arg ( fun x : ℂ => ‖z‖⁻¹ * x ) ( show ( Matrix.trace ( pairBloch e u v * ( phaseGauge z * PairModularSelection.Bz z * ( phaseGauge z ) ᴴ ) ) ) = e * ‖z‖ from ?_ ) ) using 1;
  · simp +decide [ Matrix.mul_assoc, Matrix.trace_mul_comm ( ( phaseGauge z ) ᴴ ) ];
  · norm_num [ mul_assoc, mul_comm, mul_left_comm, hz ];
  · rw [ show phaseGauge z * PairModularSelection.Bz z * ( phaseGauge z ) ᴴ = ( ‖z‖ : ℂ ) • PairModularSelection.Bz 1 from ?_ ];
    · unfold pairBloch PairModularSelection.Bz; norm_num [ Matrix.trace ] ; ring;
    · convert phaseGauge_conj z hz using 1

/-- Conjunct 5 helper: modular-flow covariance of the transported family. -/
theorem gaugedBloch_modFlow_covariant (z : Complex) (hz : z ≠ 0) (e : Real)
    (t : Real) (X : Matrix (Fin 2) (Fin 2) Complex) :
    phaseGauge z *
          ModularSelection.modFlow
            (PairModularSelection.Bz z) (betaZ z e) t X *
        (phaseGauge z)ᴴ =
      ModularSelection.modFlow
        (PairModularSelection.Bz 1) (-Real.artanh e) t
        (phaseGauge z * X * (phaseGauge z)ᴴ) := by
  by_cases h : ‖z‖ = 0 <;> simp_all +decide [ betaZ ];
  -- Apply the modFlow_conj theorem with β = -Real.artanh e / ‖z‖.
  have := @PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.modFlow_conj;
  specialize this z hz (-Real.artanh e / ‖z‖) t X;
  field_simp [hz] at this ⊢;
  exact this;

/-- **Arbitrary-phase operator S2 capstone.**  For every nonzero complex
coupling and every interior fixed normalized energy, the transported full
Bloch family has the same strict entropy maximizer as the canonical real
family.  The maximizer is exactly the Gibbs state of `Bz z` at the displayed
rescaled inverse temperature.  The normalized energy and modular-flow
covariance are included to prevent a merely decorative phase wrapper. -/
theorem phase_covariant_operator_S2_capstone (z : Complex) (hz : z ≠ 0)
    (e u v : Real) (he : |e| < 1)
    (hball : e ^ 2 + u ^ 2 + v ^ 2 ≤ 1) :
    VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) ≤
      VNEntropyPurity.vonNeumannEntropy
        (gaugedBloch z e 0 0) (gaugedBloch_isHermitian z e 0 0)
      ∧ (VNEntropyPurity.vonNeumannEntropy
            (gaugedBloch z e u v) (gaugedBloch_isHermitian z e u v) =
          VNEntropyPurity.vonNeumannEntropy
            (gaugedBloch z e 0 0) (gaugedBloch_isHermitian z e 0 0)
          ↔ u = 0 ∧ v = 0)
      ∧ gaugedBloch z e 0 0 =
          ModularSelection.gibbsState
            (PairModularSelection.Bz z) (betaZ z e)
      ∧ (((gaugedBloch z e u v) *
            ((‖z‖ : Complex)⁻¹ • PairModularSelection.Bz z)).trace.re = e)
      ∧ (∀ (t : Real) (X : Matrix (Fin 2) (Fin 2) Complex),
          phaseGauge z *
                ModularSelection.modFlow
                  (PairModularSelection.Bz z) (betaZ z e) t X *
              (phaseGauge z)ᴴ =
            ModularSelection.modFlow
              (PairModularSelection.Bz 1) (-Real.artanh e) t
              (phaseGauge z * X * (phaseGauge z)ᴴ)) := by
  obtain ⟨dyn1, dyn2, _, _, _⟩ :=
    DYNModularMaxEntCapstone.dyn_modular_operator_S2_capstone e u v he hball
  refine ⟨?_, ?_, gaugedBloch_zero_eq_gibbsState z hz e he,
      gaugedBloch_normalized_energy z hz e u v,
      fun t X => gaugedBloch_modFlow_covariant z hz e t X⟩
  · rw [gaugedBloch_entropy_eq z hz e u v, gaugedBloch_entropy_eq z hz e 0 0]
    exact dyn1
  · rw [gaugedBloch_entropy_eq z hz e u v, gaugedBloch_entropy_eq z hz e 0 0]
    exact dyn2

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone.gaugedBloch_entropy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gaugedBloch_entropy_eq

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone.gaugedBloch_zero_eq_gibbsState' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gaugedBloch_zero_eq_gibbsState

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone.gaugedBloch_modFlow_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gaugedBloch_modFlow_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone.phase_covariant_operator_S2_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phase_covariant_operator_S2_capstone

end PhysicsSM.Draft.NullEdge.PhaseCovariantS2Capstone
