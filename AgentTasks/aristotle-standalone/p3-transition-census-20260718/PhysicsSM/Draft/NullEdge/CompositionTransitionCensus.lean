import PhysicsSM.Draft.NullEdge.CompositionCl10ProbeExt

/-!
# P3 step 3: the eq-39 single-excitation transition census

**Goal.** Furey 1806.00612 eq 38-39: the minimal left ideal `S = Cl(10) vt`
decomposes into sixteen labelled particle slots. The single-excitation layer:

  `vt`               - the vacuum (right-handed neutrino `V_R` slot);
  `A_i‡ vt`          - the `Dbar^i_L` anti-down-quark slots (i = 1, 2, 3);
  `B_1‡ vt`          - the `V_L` neutrino slot;
  `B_2‡ vt`          - the `E-_L` electron slot.

On this package's Dixon carrier: `vt = ofColour vIdem` (the mode-plane state
of all landed CAR probes), `A_i‡ = co (alpha_i_dag * .)` (the landed `A1dag`
pattern), `B_j‡ = B1aDag`/`B2aDag` (landed, ordering (a)).

The eq-40 mixing generator `Mix11 = A_1‡ B_1 + B_1‡ A_1` (landed, with a
nonzero colour-supported witness) is CLAIMED by the paper to generate
quark <-> lepton (baryon-number-violating) transitions: applied to a LEPTON
slot (`B_1‡ vt`) it should produce a QUARK-family state (`A_i‡`-string), and
applied to a QUARK slot (`A_1‡ vt`) a lepton-family state. This module asks
for that census, kernel-checked.

## Tasks

1. Define the five single-excitation states as `Dixon` elements:
   `slotDbar1 = A1dag (ofColour vIdem)` etc. (define `A2dag`, `A3dag` by the
   `A1dag` pattern with `alpha2_dag`, `alpha3_dag`), `slotVL = B1aDag
   (ofColour vIdem)`, `slotEL = B2aDag (ofColour vIdem)`.
2. Kernel-verify which slots are NONZERO states (a zero slot means the
   vacuum identification is wrong - REPORT, do not force; the mode-plane
   `vt` candidate is a pinned hypothesis of this census).
3. THE CENSUS: compute `Mix11 slotVL` and `Mix11 slotDbar1` (and, if budget
   allows, `MixT11` on the same two). For each, determine and STATE as
   kernel theorems:
   - is it zero or nonzero (nonzero expected)?
   - which slot family does it lie in? Concretely: exhibit coefficients
     `c_i : C` with `Mix11 slotVL = c_1 • slotDbar1 + c_2 • slotDbar2 +
     c_3 • slotDbar3` (the CROSSING claim: a lepton slot maps into the
     quark family), or - if it does NOT lie in that span - display the
     residual component honestly and state what it is.
4. Same question for `Mix11 slotDbar1` against the lepton-family span
   `{slotVL, slotEL, ofColour vIdem}`.

## Style and constraints

- Follow the landed probe style: coordinatewise `simp` with the definitional
  lemma lists (see `CompositionCl10Probe`/`Ext` for working closers);
  single-coordinate probes are cheap, full-element only where needed.
- Heavy witnesses: elaborate FEW per file section (parallel elaboration of
  many 10M-step simps thrashes memory).
- No new axioms; no n a t i v e _ d e c i d e; standard axiom set.
- A negative census result (no crossing / zero image / wrong family) is an
  HONEST outcome: state the true theorem and report the discrepancy against
  the paper's claim prominently.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionTransitionCensus

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionCl10Probe
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- The colour ladder `A_2‡` (the `A1dag` pattern). -/
def A2dag (d : Dixon) : Dixon := co (fun z => alpha2_dag * z) d

/-- The colour ladder `A_3‡`. -/
def A3dag (d : Dixon) : Dixon := co (fun z => alpha3_dag * z) d

/-- Single-excitation quark slot `Dbar^1_L = A_1‡ vt`. -/
def slotDbar1 : Dixon := A1dag (ofColour vIdem)

/-- Single-excitation quark slot `Dbar^2_L = A_2‡ vt`. -/
def slotDbar2 : Dixon := A2dag (ofColour vIdem)

/-- Single-excitation quark slot `Dbar^3_L = A_3‡ vt`. -/
def slotDbar3 : Dixon := A3dag (ofColour vIdem)

/-- Single-excitation lepton slot `V_L = B_1‡ vt`. -/
def slotVL : Dixon := B1aDag (ofColour vIdem)

/-- Single-excitation lepton slot `E-_L = B_2‡ vt`. -/
def slotEL : Dixon := B2aDag (ofColour vIdem)

/-- Census task 2: the lepton slot is a nonzero state. PROVE or refute;
if zero, the vacuum identification fails - report. -/
theorem slotVL_ne_zero : slotVL ≠ 0 := by
  sorry

/-- Census task 3 (THE crossing question): determine `Mix11 slotVL` and
state the strongest true theorem of the form
`Mix11 slotVL = c_1 • slotDbar1 + c_2 • slotDbar2 + c_3 • slotDbar3`
(with explicit complex literals `c_i`), or the honest residual version. The
`sorry` below is a PLACEHOLDER for whatever the kernel census finds - replace
the statement itself as licensed by the module docstring. -/
theorem mix11_slotVL_census : Mix11 slotVL ≠ 0 := by
  sorry

/-- Census task 4: `Mix11 slotDbar1` against the lepton family span -
same instructions. -/
theorem mix11_slotDbar1_census : Mix11 slotDbar1 ≠ 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CompositionTransitionCensus
