# Wave 6 job: Furey/internal-spectrum bridge for the null-edge mass program

You are Aristotle. This is a no-build strategy/formal-interface job. Use the files in `materials/` as context, and rely on the repo paths mentioned there.

## Core request

The repo has substantial Furey/division-algebra Standard Model work: one-generation anomaly cancellation, Furey-to-one-generation bridge packages, electroweak anomaly bridge, anomaly decomposition, and draft null-edge Yukawa flip/mass-operator files. The null-edge mass program needs to know whether this can become a formal internal-spectrum layer for `Phi_H` and chiral/anomaly consistency.

## Tasks

1. Propose a clean interface `NullEdgeInternalSpectrum` whose `toChiralMultipletList` can be proved equal to `standardModelOneGeneration`.
2. Explain how existing Furey bridge theorems could instantiate this interface, without claiming that Furey explains mass by itself.
3. Connect the interface to the null-edge zero-order block `Phi_H`: what data should `Phi_H` act on, what chirality/handedness conventions are needed, and which existing Yukawa flip proofs can be reused?
4. State the anomaly inheritance theorem: if the null-edge internal spectrum maps to `standardModelOneGeneration`, then local and Witten anomaly freedom follow from existing theorems.
5. Identify the missing theorem needed to say the null-edge model realizes the chiral SM rather than merely reusing the SM anomaly table.
6. Recommend whether Furey should be treated as optional internal realization, preferred internal realization, or core axiom of the null-edge program.
7. Produce 3-5 ambitious follow-up Aristotle jobs, including at least one Lean proof target.

## Guardrails

- Furey supplies internal spectrum and anomaly consistency, not mass by itself.
- Do not collapse anomaly cancellation into a mass theorem.
- Preserve all-left anomaly convention and hypercharge sign flips for conjugate right-handed fields.
- Keep QCD/confinement out of this bridge except as a boundary note.

## Deliverable

Write `AgentTasks/null-edge-furey-internal-spectrum-bridge.md` with formal interfaces, theorem statements, caveats, and follow-up jobs.
