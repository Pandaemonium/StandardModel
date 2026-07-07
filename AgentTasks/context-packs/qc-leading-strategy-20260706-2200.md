# Aristotle focused strategy job: QC-leading bridge after finite Z2 normalization

You are Aristotle acting as a mathematical strategist, not as a code patcher.

## Thread

Two-day carrier run, Codex lane QC: identify the closure/curvature slot `Q_C`
with the strong-coupling leading closure-flux scalar, honestly scoped to leading
order only.

Codex has just added a small kernel-checked finite `Z2` normalization bridge in
`PhysicsSM/Draft/NullEdge/GateYM/QCLeading.lean`.  Claude has separately landed
the carrier-side torus curvature identity in
`PhysicsSM/Draft/NullEdge/Carrier/WeitzenbockQC_Torus.lean`.  The next question
is not "prove this small normalization lemma" but "what is the next honest bridge
statement that should connect the GateYM scalar to the carrier torus curvature
slot without overclaiming an expectation theorem or beyond-leading positivity?"

## Current landed/checked facts

Focused checks already run locally:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/QCLeading.lean
lake env lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
```

The build has only pre-existing warnings in unrelated draft/imported files.

## Exact current GateYM QC-leading source

```lean
import PhysicsSM.Draft.NullEdge.GateYM.SlabGapAssembly
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCLeading

def leadingClosureFluxCoeff (beta : ℝ) : ℝ :=
  TYAreaLaw.partitionRatio beta

theorem leadingClosureFluxCoeff_eq_partitionRatio (beta : ℝ) :
    leadingClosureFluxCoeff beta = TYAreaLaw.partitionRatio beta := rfl

theorem leadingClosureFluxCoeff_eq_tanh (beta : ℝ) :
    leadingClosureFluxCoeff beta = Real.tanh beta := by
  rw [leadingClosureFluxCoeff, TYAreaLaw.partitionRatio_eq_tanh]

theorem leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap {beta : ℝ}
    (hbeta : 0 < beta) :
    leadingClosureFluxCoeff beta =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta) := by
  rw [leadingClosureFluxCoeff, TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap hbeta]

theorem exp_neg_osSpectralGap_eq_leadingClosureFluxCoeff {beta : ℝ}
    (hbeta : 0 < beta) :
    Real.exp (-OSReconstruction.osSpectralGap beta hbeta) =
      leadingClosureFluxCoeff beta :=
  (leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap hbeta).symm

structure Z2LeadingQCReadout (beta : ℝ) (hbeta : 0 < beta) : Prop where
  coeff_eq_tanh : leadingClosureFluxCoeff beta = Real.tanh beta
  coeff_eq_exp_neg_osGap :
    leadingClosureFluxCoeff beta =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta)
  os_gap_value :
    OSReconstruction.osSpectralGap beta hbeta = -Real.log (Real.tanh beta)
  slab_chain : SlabGapAssembly.SlabGapChain beta hbeta

theorem z2LeadingQCReadout (beta : ℝ) (hbeta : 0 < beta) :
    Z2LeadingQCReadout beta hbeta where
  coeff_eq_tanh := leadingClosureFluxCoeff_eq_tanh beta
  coeff_eq_exp_neg_osGap := leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap hbeta
  os_gap_value := OSReconstruction.osSpectralGap_eq_neg_log_tanh beta hbeta
  slab_chain := SlabGapAssembly.slabGapAssembly beta hbeta

end QCLeading
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
```

## Exact current carrier torus source shape

Key proved identity:

```lean
namespace PhysicsSM.Draft.NullEdge.Carrier.Torus

abbrev Site : Type := ZMod 2 × ZMod 2

def shiftLM (a : Fin 2) : (Site → W) →ₗ[R] (Site → W) := ...
def gaugeLM (U : Site → (W →ₗ[R] W)) : (Site → W) →ₗ[R] (Site → W) := ...
def nabla (U : Fin 2 → Site → (W →ₗ[R] W)) (a : Fin 2) :
    (Site → W) →ₗ[R] (Site → W) := ...
def plaquetteCurvature (U : Fin 2 → Site → (W →ₗ[R] W)) (a b : Fin 2) :
    Site → (W →ₗ[R] W) := ...

theorem nabla_commutator_path_difference
    (U : Fin 2 → Site → (W →ₗ[R] W)) (a b : Fin 2) :
    (nabla U a).comp (nabla U b) - (nabla U b).comp (nabla U a)
      = (gaugeLM (plaquetteCurvature U a b)).comp
          ((shiftLM a).comp (shiftLM b)) := by
  ...

end PhysicsSM.Draft.NullEdge.Carrier.Torus
```

There is also a draft handoff theorem `mZero_iff_commute` in that module, still
with a documented executable placeholder.  A separate Aristotle proof job is
already running on that target; do not duplicate it.

## Honest constraints

Do not recommend a statement that claims:

- a nonabelian `SU(2)` result,
- a physical or continuum mass gap,
- positivity of `<Q_C>` beyond leading order,
- equality between a Wilson/TY partition ratio and a transfer-Hamiltonian gap in
  general,
- or a carrier `Q_C` expectation theorem before an explicit observable/measure
  bridge exists.

The next bridge should probably be one of:

1. a pure GateYM statement packaging the leading coefficient more sharply,
2. a Carrier/GateYM bridge statement after the torus curvature identity,
3. a statement-level design file with a documented handoff if a real expectation
   bridge needs new infrastructure,
4. or a decision to wait for Fable call 03 before spending proof effort.

## Requested output

Produce a Markdown strategy memo with:

1. Can the current decomposition succeed as stated, or is it already mis-scoped?
2. The sharpest honest next decomposition from finite `Z2` coefficient to carrier
   torus curvature.
3. Counterexample/vacuity/overclaim risks in the current `QCLeading` surface.
4. The three highest-value next Lean statements, with exact theorem names,
   namespaces, and statement sketches precise enough for Codex to implement.
5. Which statement, if any, should be sent to Fable call 03 for ratification
   before proof spend.

Do not patch code.  Be skeptical and decision-forcing.
