import Mathlib
import PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore

/-!
# NullStrand.ZigZag.QuantumWalk

Finite null-step quantum-walk bridge exposing the draft quasienergy
relation under `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`.

This file is intentionally conservative:
- no new analytic claims,
- no refactor of the original draft conventions,
- only lightweight aliases and wrapper lemmas with trusted kernel checks.
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

open Complex Matrix Filter
open scoped Topology

/-- One-step null-step walk operator in the NullStrand namespace. -/
def quantumWalkOperator (a k μ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Ua a k μ

/-- One-step walk trace identity in terms of lattice data. -/
theorem quantumWalk_trace (a k μ : ℝ) :
    (quantumWalkOperator a k μ).trace =
      2 * Complex.cos (k * a) * Complex.cos (μ * a) := by
  simpa [quantumWalkOperator] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.trace_Ua a k μ

/-- Walk operator is determinant-one (special-unitary trace class). -/
theorem quantumWalk_det_one (a k μ : ℝ) :
    (quantumWalkOperator a k μ).det = 1 := by
  simpa [quantumWalkOperator] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.det_Ua a k μ

/-- Quasienergy predicate used by the roadmap in the NullStrand layer. -/
abbrev IsQuasienergy (a k μ ω : ℝ) : Prop :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.IsQuasienergy a k μ ω

/-- Quasienergy relation for the conserved walk trace. -/
theorem quantumWalk_quasienergy_relation (a k μ ω : ℝ) :
    IsQuasienergy a k μ ω ↔
      (quantumWalkOperator a k μ).trace = (2 * Real.cos (ω * a) : ℂ) := by
  simpa [IsQuasienergy, quantumWalkOperator] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.isQuasienergy_iff_trace a k μ ω

/-- Alias for the walk coherence scale used by the roadmap. -/
def quantumWalk_coherenceSq (a k μ : ℝ) : ℝ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.coherenceSq a k μ

/-- Alias for `sin²(ωa)` decomposition from the draft walk core. -/
def quantumWalk_sinOmegaSq (a k μ : ℝ) : ℝ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.sinOmegaSq a k μ

/-- Coherence identity as a direct rewrite of the draft definition. -/
theorem quantumWalk_coherenceSq_eq
    (a k μ : ℝ) :
    quantumWalk_coherenceSq a k μ =
      Real.sin (μ * a) ^ 2 / quantumWalk_sinOmegaSq a k μ := by
  rfl

/-- Coherence denominator identity from the draft kernel. -/
theorem quantumWalk_sinOmegaSq_eq (a k μ : ℝ) :
    quantumWalk_sinOmegaSq a k μ = 1 - (Real.cos (k * a) * Real.cos (μ * a)) ^ 2 := by
  simpa [quantumWalk_sinOmegaSq] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.sinOmegaSq_eq a k μ

/-- Continuum limit of the squared coherence ratio under a nondegenerate mass-momentum pair. -/
theorem quantumWalk_coherenceSq_continuum (a k μ : ℝ) (hkμ : k ^ 2 + μ ^ 2 ≠ 0) :
    Tendsto (fun a' : ℝ => quantumWalk_coherenceSq a' k μ) (𝓝[≠] 0)
      (𝓝 (μ ^ 2 / (k ^ 2 + μ ^ 2))) := by
  simpa [quantumWalk_coherenceSq] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.coherenceSq_continuum k μ hkμ

/-- `m/E` form of the coherence continuum limit. -/
theorem quantumWalk_coherenceSq_continuum_mE (k m : ℝ) (hkm : k ^ 2 + m ^ 2 ≠ 0) :
    Tendsto (fun a' : ℝ => quantumWalk_coherenceSq a' k m) (𝓝[≠] 0)
      (𝓝 ((m / Real.sqrt (k ^ 2 + m ^ 2)) ^ 2)) := by
  simpa [quantumWalk_coherenceSq] using
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.coherenceSq_continuum_mE k m hkm

/-- Alias for determinant-one claim in a shorter name. -/
theorem quantumWalk_det_eq_one (a k μ : ℝ) : (quantumWalkOperator a k μ).det = 1 :=
  quantumWalk_det_one a k μ

end PhysicsSM.NullStrand.ZigZag
