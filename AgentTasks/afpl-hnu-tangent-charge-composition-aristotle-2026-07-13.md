# Aristotle successor: HNU infrared tangent to Weyl charge

```yaml
aristotle:
  project_id: c626cb61-f1db-49ff-aa41-a9d96e9152ad
  task_id: 10a6436c-e878-4d00-bd06-7b5a655ec316
  target_file: HNUInfraredWeylCharge.lean
  expected_module: HNUInfraredWeylCharge
  status: integrated and independently reviewed
```

## Prompt

Compose the exact HNU endpoint and the completed `HNUInfraredTangent` result
into the strongest honest local-Weyl theorem available. The tangent is
expected to be `-i (q0 sigma1 + q1 sigma2 + q2 sigma3)`. Formalize the
associated real coefficient map/Jacobian, prove its determinant and
orientation sign exactly, and connect it to the existing finite Weyl
orientation/degree architecture where the uploaded API permits.

Preferred theorem ladder:

1. exact derivative/Jacobian coefficients and nonzero determinant;
2. isolated linearized node and explicit nonzero axis/rational witness;
3. local chirality/orientation `+1` with every sign convention displayed;
4. if definitions align, a clean bridge into the enclosing-sphere
   degree/Chern theorem shape, without pretending the derivative alone proves
   a global Brillouin-zone charge.

If a full degree bridge is blocked by incompatible definitions, prove the
exact Jacobian-orientation theorem and report the minimal adapter required.
Do not infer a copy-free lattice, anomaly cancellation, bulk-edge theorem,
primitive-null support, or continuum PDE from this local result. Add
standard-three guards and a semantic completion report. Do not weaken a
statement silently.

## Harvest and review status

Aristotle completed task `10a6436c-e878-4d00-bd06-7b5a655ec316`. The candidate
is stored at:

`AgentTasks/aristotle-output/c626cb61-f1db-49ff-aa41-a9d96e9152ad/charge/extracted/output-final_aristotle/HNUInfraredWeylCharge.lean`

The unconditional local ladder derives the identity coefficient map, nonzero
Jacobian determinant, isolated linearized node, and local orientation `+1`.
The degree and Chern endpoints remain conditional reductions through explicitly
named hypotheses. Message `msg-20260713-193035-1ce912c0` requests an independent
Claude semantic review of the exact integration subset before any live-tree
landing.

Claude returned `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_HNUInfraredWeylCharge_2026-07-13.md`.
The review independently confirmed the Pauli convention bridge, the isolated
linearized node, the real Jacobian orientation `+1`, and the fact that the
separate `-i` evolution prefactor does not reverse that orientation. It also
classified the degree/Chern endpoints as valid but assumption-heavy `T|H`
reductions rather than unconditional global charges.

The reviewed module is integrated at
`PhysicsSM/Draft/NullEdge/HNUInfraredWeylCharge.lean`. The central guard imports
it and pins only the unconditional local headlines; the conditional
degree/Chern wrappers remain guarded inside the module but are not promoted to
the headline guard surface.

Verification completed:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUInfraredWeylCharge.lean
lake build PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge
```

Declaration-level `lean_verify` checks for the tangent, isolated-node,
chirality, sign-convention, and Bloch-map theorems report only `propext`,
`Classical.choice`, and `Quot.sound`, with no source warnings. The aggregate
`OvernightTheoryAxiomGuard` build was attempted but timed out after four minutes
without diagnostics; no aggregate-guard success is claimed from that attempt.
