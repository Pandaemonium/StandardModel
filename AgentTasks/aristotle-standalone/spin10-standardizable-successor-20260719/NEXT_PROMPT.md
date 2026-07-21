# Global pure-spinor chart entry and normal form

Focus on `PhysicsSM/Draft/Spin10StandardizablePairs.lean`. Prove
`exists_evenCliffordGroup_vacuum_coefficient_ne_zero`, then use the chart
reconstruction API (or prove the needed local lemma) to close
`exists_evenCliffordGroup_smul_eq_vacuum`.

The hard point is cancellation-safe chart entry: choose a minimal nonzero even
support coordinate and construct explicit signed mode flips so the transformed
vacuum coefficient is nonzero. Preserve exact Spin(10) and Fock conventions.
The pre-registered scalar license is allowed only if exact normalization truly
cannot be absorbed by the existing scalar units, and must be documented. Do
not attempt the final pair theorem. No new assumptions or compiler-trusted
procedures. Run the target and report all axioms. Read `CONTEXT.md`.
