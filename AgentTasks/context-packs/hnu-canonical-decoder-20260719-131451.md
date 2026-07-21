# Aristotle semantic context pack

Generated: 2026-07-19T13:15:00
Query: `HNU selected transverse sector canonical orthogonal decoder onsite local update projector`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUTransversePiComposite.lean`

Score: `0.809`

```text
import PhysicsSM.Draft.NullEdge.FloquetTransverseComposite
import PhysicsSM.Draft.NullEdge.HNUSU2FixedVectorCensus

/-!
# HNU selected sector with an explicit quasienergy-pi complement

This module instantiates `FloquetTransverseComposite.controlled` with the exact
HNU endpoint on the selected transverse line and `Vpi = -1` on its orthogonal
complement. It proves full finite-matrix unitarity and a state-level spectral
census: the selected sector has a nonzero `+1` eigenvector only at the origin,
while the complement supplies an explicit `-1` eigensector and no nonzero
`+1` eigenvector.

Provenance: clean-room integration of Aristotle project
`d82ea36b-490a-4e78-bc17-29e1aa3c96e9`, independently reviewed by
interactive Claude/Opus. The SU(2) rigidity step is reused from
`HNUSU2FixedVectorCensus` rather than duplicated.

Hard boundary: `Vpi = -1` is a momentum-space spectral control. It is not an
all-moving local update and does not prove primitive-null support, winding,
bulk-edge correspondence, anomaly inflow, or a physical domain wall.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/ProjectorConditionedStep.lean`

Score: `0.808`

```text
import Mathlib

/-!
# Generic projector-conditioned unitary step

This standalone draft isolates the algebra behind one HNU substep. A selected
internal sector receives a unit-modulus translation phase while the
complementary sector is held on site. The theorem says exactly what is moved
and what is held; it does not call the held sector a null translation.
-/
```

### 3. `AgentTasks/afpl-floquet-transverse-composite-aristotle-2026-07-13.md` [Objective]

Score: `0.806`

```text
## Objective

Formalize the exact finite composition that the lateral 3+1 strategy now needs.
A rank-one transverse projector selects one two-component sector.  A unitary
`U` acts on that sector and an independently chosen unitary `V` acts on the
orthogonal complement.  Prove the combined update is unitary and restricts
exactly to `U` on the selected sector.

This is intended to accept the exact HNU anomalous-Floquet endpoint as `U` in a
successor module, while `V` records the compensating pi-gap, bulk, or mirror
dynamics.  Do not claim that compensation has been constructed merely because
`V` is a parameter.
```

### 4. `AgentTasks/aristotle-downloads/d82ea36b-extract/output-final_aristotle/AgentTasks/afpl-floquet-transverse-composite-aristotle-2026-07-13.md` [Objective]

Score: `0.806`

```text
## Objective

Formalize the exact finite composition that the lateral 3+1 strategy now needs.
A rank-one transverse projector selects one two-component sector.  A unitary
`U` acts on that sector and an independently chosen unitary `V` acts on the
orthogonal complement.  Prove the combined update is unitary and restricts
exactly to `U` on the selected sector.

This is intended to accept the exact HNU anomalous-Floquet endpoint as `U` in a
successor module, while `V` records the compensating pi-gap, bulk, or mirror
dynamics.  Do not claim that compensation has been constructed merely because
`V` is a parameter.
```

### 5. `AutonomousLab/reviews/CLAUDE_REVIEW_HNUExactCore_RelativeFlow_TargetMirror_2026-07-13.md` [(1) HNU endpoint/census faithful? - YES (HNUExactCore)]

Score: `0.792`

```text
### (1) HNU endpoint/census faithful? - YES (HNUExactCore)

Faithful to my HNU adversarial audit's L1-L8 and to the exact reconstruction:
- **Corrected symbols** recorded prominently: `Uplus s θ = e^{-iθ}.Pplus s + Pminus s`,
  `Uminus s θ = e^{+iθ}.Pminus s + Pplus s` (exponent tied to the ± label) - exactly
  the audit's corrected `U_j^±(k) = P_j^± e^{∓ik} + P_j^∓`.
- Projector algebra (`Pplus/Pminus` idempotent, orthogonal, Hermitian, sum `= 1`);
  `Uplus_unitary`/`Uminus_unitary`; `endpoint_unitary`, `endpoint_det = 1` (SU(2)).
- **Exact trace identity** `trace_endpoint`:
  `Tr = 2(2 cos²(k0/2) cos²(k1/2) cos²(k2/2) - 1)` - matches the paper / my
  `verify9.py` (symbolic `= 0`).
- **Complete census over `[-π,π]³`** (genuine `<->`, not sampled): `zero_census`
  `endpoint k = 1 <-> forall i, k i = 0` (single `eps=0` node at origin);
  `pi_census` `endpoint k = -1 <-> exists i, k i = ±π` (`eps=π` = the boundary);
  `endpoint_pi` boundary pinning; `witness_zero`/`witness_pi`/`witness_zero_unique`
  (nonvacuity). 24 build-enforced `#guard_msgs`.
- **Scope correct**: "The momentum-space winding, continuum Weyl tangent, real-space
  locality, and primitive-null realization are separate gates and are not
  consequences of this module." `W=1`/tangent/locality/null NOT claimed.
```

### 6. `AgentTasks/afpl-transported-projector-holonomy-aristotle-2026-07-13.md` [Requested result]

Score: `0.792`

```text
## Requested result

Read the exact HNU schedule and the completed `AntiperiodicHNU.lean`. Design the
smallest finite matrix API for:

1. a sequence of orthogonal projectors `P_j`;
2. inter-step unitary frame transports `G_j` satisfying an explicit relation
   such as `P_(j+1) = G_j P_j G_j^*`;
3. selected and complement substep updates in their co-moving frames;
4. an exact telescoping theorem for the selected endpoint;
5. an exact formula for the complement holonomy, including the accumulated
   center element.

Then instantiate as much as possible on the HNU axis schedule. Determine
whether the central `-1` found by the antiperiodic audit is invariant under
schedule-local frame changes, removable only by adding a mirror/bulk sector,
or removable by a concrete nontrivial transported frame.

Return a theorem, a finite counterexample, or a sharpened missing hypothesis.
Do not claim a universal no-go from one phase assignment. Preserve full
zero/pi sectors; projection is not cancellation.
```

### 7. `AgentTasks/afpl-antiperiodic-hnu-strategy-aristotle-2026-07-13.md` [Required audit]

Score: `0.792`

```text
## Required audit

1. Write the exact finite schedule architecture. Track the changing HNU spin
   projectors separately from the global transverse selector and auxiliary
   register; do not pretend they commute unless proved.
2. Determine whether applying the same two-tick twist to all eight HNU
   substeps cancels by even parity. If so, identify the smallest asymmetric or
   global-period placement that retains one pi complement while preserving the
   selected HNU endpoint.
3. Prove or refute exact full-step unitarity and real-space finite locality for
   the proposed placement.
4. Census all auxiliary/twist bands and both zero and pi eigenspaces. An
   antiperiodic boundary condition must not be described as removing copies
   without a full finite census.
5. Track the HNU zero-sector Weyl charge and the compensating pi/bulk charge in
   one explicit ledger. State exactly what remains an imported topological
   identification rather than a finite theorem.
6. Test whether the same auxiliary register can also implement the rank-one
   transverse selector, or prove a dimension/commutation obstruction.
7. Return a Lean-ready theorem ladder for the strongest surviving architecture,
   or a scoped no-go with a finite nontrivial witness.
```

### 8. `AutonomousLab/work/NE-3PLUS1/CODEX_NULL_DILATION_AND_CONTROLLED_SECTOR_REVIEW_REQUEST_2026-07-13.md` [Proposed scientific disposition]

Score: `0.791`

```text
## Proposed scientific disposition

- **Bank** the two-fine-tick null dilation as an exact finite factorization and
  unitarity theorem.
- **Reject** the pure compact out-and-back dilation as a solution to 3+1. The
  cyclic zero-momentum auxiliary block still holds the complementary branch,
  and the decoded two-tick operator is identically the original coarse HNU
  update, so every decoded invariant is unchanged.
- **Advance** the controlled transverse-sector interface, but only as an
  algebraic precursor. Its complement update `V` is a free unitary and does not
  yet supply locality, a pi gap, compensating topology, or a full-spectrum
  no-copy theorem.
```

## Scoped paper hits

### 1. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.722`
Zotero key: `B68T629C`
arXiv: `1605.08072`
DOI: `10.1007/JHEP09(2016)038`
URL: http://arxiv.org/abs/1605.08072

Abstract:

Derives a modular Hamiltonian term for deformed half-spaces and uses relative-entropy monotonicity to prove ANEC.

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.716`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. Recovering the QNEC from the ANEC

Score: `0.710`
Zotero key: `TFGTQQTU`
arXiv: `1812.04683`
URL: http://arxiv.org/abs/1812.04683

Abstract:

Uses relative modular flow and half-sided modular inclusion structure to recover QNEC from ANEC.

### 4. HepLean: Digitalising high energy physics

Score: `0.707`
Zotero key: `4CVWW854`
arXiv: `2405.08863`
URL: http://arxiv.org/abs/2405.08863

Abstract:

We introduce HepLean, an open-source project to digitalise definitions, theorems, proofs, and calculations in high energy physics using the interactive theorem prover Lean 4. HepLean has the potential to benefit the high energy physics community in four ways: making it easier to find existing results, allowing the creation of new results using artificial intelligence and automated methods, allowing easy review of papers for mathematical correctness, and providing new ways to teach high energy physics. We will discuss these in detail. We will also demonstrate the digitalisation of three areas of high energy physics in HepLean: Cabibbo-Kobayashi-Maskawa matrices in flavour physics, local anomaly cancellation, and Higgs physics.

### 5. Dirac quantum walk on tetrahedra

Score: `0.703`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840
