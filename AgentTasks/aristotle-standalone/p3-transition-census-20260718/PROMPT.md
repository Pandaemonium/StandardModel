# Task: the eq-39 single-excitation transition census (proton-decay directions)

Lean 4 (v4.28.0) + Mathlib. The package is a working slice of a physics
formalization project (division-algebra Standard Model, Furey 1806.00612).
Everything compiles except the target file
`PhysicsSM/Draft/NullEdge/CompositionTransitionCensus.lean`, whose module
docstring carries the full physics context, the task list, and the honesty
rules. Summary:

- The landed modules realize the Cl(10) ladder operators as composition
  operators on a 4-slot "Dixon" carrier (`CompositionCl10Probe` and its
  `Ext`: colour ladders `A1`/`A1dag`, weak-colour composites `B1a`/`B1aDag`,
  `B2a`/`B2aDag`, and the eq-40 mixing generators `Mix11`, `MixT11` with
  kernel-checked nonzero witnesses).
- The target defines the five single-excitation slot states of the eq-39
  minimal ideal (three quark slots `A_i-dag vt`, two lepton slots
  `B_j-dag vt`, with `vt = ofColour vIdem`).
- CENSUS QUESTIONS (the three `sorry` targets - you may and SHOULD replace
  the placeholder statements with the strongest TRUE statements the kernel
  supports, per the docstring's license):
  1. `slotVL_ne_zero` - the lepton slot is a nonzero state.
  2. `mix11_slotVL_census` - compute `Mix11 slotVL`; ideally exhibit it as
     an explicit C-linear combination of the three quark slots
     (the quark <-> lepton CROSSING claim), or state the honest residual.
  3. `mix11_slotDbar1_census` - same for `Mix11 slotDbar1` against the
     lepton-family span.

Proof style guidance: the landed files show working closers - coordinatewise
`ext`/`simp` with the definitional lemma lists and
`simp (maxSteps := 10000000)`, plus `ring_nf` for arithmetic verdicts.
Compute single coordinates first to discover values, then state full
equalities. IMPORTANT: do not elaborate many heavy witnesses in parallel in
one file - keep the heavy proofs few and sequential (memory).

Constraints: no new axioms, no n a t i v e _ d e c i d e, standard axiom set
[propext, Classical.choice, Quot.sound]. A negative or partial census
(zero images, wrong family, residuals) is an acceptable HONEST outcome if
stated as the true kernel theorems with a prominent report.
