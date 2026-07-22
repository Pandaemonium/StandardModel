import Mathlib

/-!
# Constant rank for continuous finite projector paths

This module supplies the finite-dimensional topology bridge used by the HNU
Cayley-band program.  An idempotent complex matrix has trace equal to its
natural-number rank.  Consequently, a continuous real-parameter path of
four-by-four idempotents has constant rank, and rank two at one base point
forces rank two everywhere along the path.

The result is intentionally generic.  It does not construct a continuous HNU
projector, prove that a selected band is physical, establish quasi-locality, or
remove companion sectors.  Those are separate successor gates.

Provenance: the proof was completed in focused Aristotle project
`bc2ac81f-4551-4b7e-8fa3-5af08f080d54`, using
`LinearMap.IsProj.trace`, matrix/linear-map trace correspondence, continuity of
matrix trace, and connectedness of the real line.  It was reviewed and rebuilt
locally under the pinned project toolchain.

Draft-trust status: every theorem is kernel-checked.  The dedicated axiom guard
pins the dependency footprint.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ContinuousProjectorRank

/-- The concrete matrix size needed by the HNU four-spinor band projector. -/
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- An idempotent complex matrix has trace equal to its finite rank. -/
theorem trace_eq_rank_of_idempotent (P : Mat4) (hP : P * P = P) :
    Matrix.trace P = ((Matrix.rank P : Nat) : Complex) := by
  have h_trace_eq_rank :
      forall (f : Module.End Complex (Fin 4 -> Complex)), f.comp f = f ->
        (LinearMap.trace Complex (Fin 4 -> Complex)) f =
          Module.finrank Complex (LinearMap.range f) := by
    have htrace := @LinearMap.IsProj.trace
    intro f hf
    specialize htrace
      (show LinearMap.IsProj (LinearMap.range f) f from by
        constructor
        · exact fun x => LinearMap.mem_range_self f x
        · rintro _ ⟨x, rfl⟩
          simpa [LinearMap.comp_apply] using LinearMap.congr_fun hf x)
    simp_all +decide [funext_iff, LinearMap.ext_iff]
  convert h_trace_eq_rank (Matrix.toLin' P) _
  · convert rfl
    convert Matrix.trace_toLin'_eq _
  · rw [← Matrix.toLin'_mul, hP]

/-- A continuous real-parameter family of idempotent four-by-four complex
matrices has constant rank.  No Hermitian hypothesis is required. -/
theorem continuous_idempotent_rank_constant
    (P : Real -> Mat4)
    (hcont : Continuous P)
    (hidem : forall t, P t * P t = P t) :
    forall t, Matrix.rank (P t) = Matrix.rank (P 0) := by
  have h_cont_rank : Continuous (fun t => rank (P t)) := by
    have h_rank_eq_trace :
        forall t, rank (P t) = Complex.re (Matrix.trace (P t)) := by
      intro t
      rw [← Complex.ofReal_inj]
      norm_num [trace_eq_rank_of_idempotent _ (hidem t)]
    have h_cont_trace :
        Continuous (fun t => Complex.re (Matrix.trace (P t))) := by
      exact Complex.continuous_re.comp
        (continuous_finset_sum _ fun i _ =>
          continuous_apply i |> Continuous.comp <|
            continuous_apply i |> Continuous.comp <| hcont)
    convert h_cont_trace using 1
    norm_num [← h_rank_eq_trace, continuous_iff_continuousAt]
    norm_num [Metric.continuousAt_iff]
  have h_const : IsConnected (Set.range (fun t => rank (P t))) := by
    exact isConnected_range h_cont_rank
  have hrange := h_const.isPreconnected.subsingleton
  exact fun t => hrange (Set.mem_range_self t) (Set.mem_range_self 0)

/-- Rank two at the rest point forces rank two everywhere on a continuous
real-parameter path of projectors. -/
theorem continuous_rank_two_of_rest
    (P : Real -> Mat4)
    (hcont : Continuous P)
    (hidem : forall t, P t * P t = P t)
    (hrest : Matrix.rank (P 0) = 2) :
    forall t, Matrix.rank (P t) = 2 := by
  exact fun t => by
    rw [continuous_idempotent_rank_constant P hcont hidem t, hrest]

end PhysicsSM.Draft.NullEdge.ContinuousProjectorRank
