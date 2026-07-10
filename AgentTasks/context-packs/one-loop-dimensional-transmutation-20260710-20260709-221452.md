# Aristotle semantic context pack

Generated: 2026-07-09T22:14:58
Query: `one-loop RG invariant dimensional transmutation running coupling generated absolute scale`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP11ReadoutRescale.lean`

Score: `0.706`

```text
import Mathlib

/-!
# P11 readout rescaling core

The calibrated readout must carry scale: normalization forgets nonzero scalar
rescalings, while determinant mass scales quadratically.
-/
```

### 2. `AgentTasks/null-edge-yukawa-mass-operator-aristotle-2026-06-22.md` [Aristotle task: finite Yukawa mass-operator bridge]

Score: `0.702`

```text
# Aristotle task: finite Yukawa mass-operator bridge
```

### 3. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean` [standardModelOneGeneration]

Score: `0.702`

```text
def standardModelOneGeneration : List ChiralMultiplet :=
  [ { label := "Q_L", color := ColorRep.triplet,
      weak := WeakRep.doublet, hypercharge := 1 / 3 },
    { label := "L_L", color := ColorRep.singlet,
      weak := WeakRep.doublet, hypercharge := -1 },
    { label := "u_R^c", color := ColorRep.antiTriplet,
      weak := WeakRep.singlet, hypercharge := -4 / 3 },
    { label := "d_R^c", color := ColorRep.antiTriplet,
      weak := WeakRep.singlet, hypercharge := 2 / 3 },
    { label := "e_R^c", color := ColorRep.singlet,
      weak := WeakRep.singlet, hypercharge := 2 } ]

/--
Draft target: the conventional one-generation table is locally anomaly free.

This should be easy for Aristotle or a coding agent: unfold the definitions and
close the rational and integer equalities by exact arithmetic.
-/
```

### 4. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` [Layer 5 - Values: the actual spectrum. OPEN, with exact boundaries.]

Score: `0.702`

```text
nvariant potential has a
  repeated eigenvalue, and the three charged-lepton masses are distinct. The
  null is filed
  (`AgentTasks/nerd-gate-f2-koide-preregistration-2026-07-03.md`); the
  surviving formulations - F2.1, potentials invariant only under the
  stabilizer of the democratic direction (spurion class), and F2.0',
  directional extremality - remain grade `C` pending their own pre-registered
  freeze, still under the audit-mandated scheme/scale clause (pole vs running
  masses; an IR-fixed-point survival mechanism must be named). The Brannen
  phase observation stays in the recorded-coincidence file, unleaned-on.
- **Counting (Tier 2)**: three generations as the Jordan-tower cap
  (`J_3(O)` is the last rung) plus the Kobayashi-Maskawa/CP pincer - grade
  `C` with one soft jaw, on probation (Gate F1 requires a pre-registered
  canonical construction before any numerics are admissible).
- **Hierarchies (Tier 2/3)**: Froggatt-Nielsen-style suppression-by-distance
  is the named mechanism class (Gate F3), mechanism-only, no numbers claimed.
- **Out of reach, binned (Tier 3)**: the absolute Yukawa scale, the electron
  mass value, the electroweak/Planck hierarchy, theta_QCD - currently bedrock
  (`B`) or substrate-statistical (`S`), all waiting on the growth measure,
  which is the program's declared central open problem. The program's
  distinctive deliverable here is the *bin classification itself*: for every
  mass parameter it states whether it is derived, protected, statistical, or
  bedrock - which no competing framework currently does.

Bottom line for layer 5: **no mass value is computed, and this paper claims
none.** The value problem is not evaded; it is partitioned, with one live
gated relation, one owned scale postdiction, and named bedrock.
```

### 5. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Moduli-count gate]

Score: `0.699`

```text
#### Moduli-count gate

Before phenomenology, define the continuous finite knobs:

```text
edge weights, frame choices, holonomy normalizations, Phi, spectral function f,
cutoff Lambda, internal algebra moduli, hidden-sector couplings, graph ensemble.
```

Compare with target EFT parameters. If the finite moduli have enough local
freedom to fit all Standard Model parameters, the program is a reconstruction or
reparametrization, not a prediction. A rigidity theorem should show that the
rank of the finite-to-EFT parameter map is deficient.
```

### 6. `Sources/nrqg-round7-parameters.md` [4. Tier 3 — Honestly out of reach, with bin assignments]

Score: `0.699`

```text
## 4. Tier 3 — Honestly out of reach, with bin assignments

- **The value of α** (equivalently $g_U$): in the spectral picture, set by moments of the cutoff function — i.e., by the graph measure. Bin: **S or B** (substrate datum, like Λ's sign history), pending the growth measure. Not derivable today; *classifiable* today — which is more than any other framework offers for α.
- **The absolute Yukawa scale / $v/M_{\rm Pl}$** (hierarchy): 2/10, SOC direction only (Round 6 §7).
- **$\theta_{\rm QCD}$**: still 2/10; no native mechanism.
- **Individual CKM/PMNS angles beyond texture**: waits on F2/F3.
- **Absolute $m_e$**: the fully general case of the above; bin B today.
```

### 7. `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md` [2026-06-24 - Constrained loop round 004 model calls]

Score: `0.698`

```text
### 2026-06-24 - Constrained loop round 004 model calls

```text
[2026-06-24] [P1-F] [Gemini/Claude] [next-job selection] [useful] [quality pending]
```

Input scope: Newly integrated P1 scalar bridge, P1 `SU(2)` stabilizer, and P9
screen quotient bound.

What worked:
- Gemini suggested the extremal bound `det rho <= 1/4`, equality iff `a=b`,
which is scientifically useful as a maintenance target.
- Claude correctly identified that the extremal bound is too easy for Aristotle
and that the higher-risk bridge is invariance of the observer scalar under the
residual unitary spin-frame action.

What worried:
- The new invariance target uses explicit unitary assumptions rather than
Mathlib's `specialUnitaryGroup` subtype directly. This is intentional for a
small proof job, but a later polished module should bridge it back to the
subtype theorem.

Follow-up:
- Submitted the P1 `SU(2)` normalized determinant invariance job: project
  `cecaf26c-ab7d-4484-b901-01e12c077659`, task
  `275f0354-b046-4867-8bfa-9a13b01fd67c`.
```

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h6-dvt-jordan-yukawa-constraint-audit/fur-h6-dvt-jordan-yukawa-constraint-audit_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.13 Referee-facing response posture]

Score: `0.698`

```text
### 15.13 Referee-facing response posture

Likely objection:

```text
This is a poetic restatement of standard facts: two null particles can have
invariant mass, Higgs/Yukawa couplings give fermion masses, the Higgs mechanism
gives W/Z mass, and QCD gives proton mass.
```

Response:

```text
Correct that the ingredients are standard. The contribution is a finite,
machine-checkable null-edge theorem spine and a single operator architecture in
which primitive spacetime transport remains null while the known mass mechanisms
appear as distinct finite obstruction forms.
```

Likely objection:

```text
The Pluecker theorem does not derive proton mass or the Yukawa spectrum.
```

Response:

```text
Correct. P1 proves the kinematic invariant. QCD and Yukawa dynamics are later
layers. Numerical mass prediction requires a moduli-rank/codimension constraint.
```

Likely objection:

```text
Gauge symmetry is redundancy, so breaking language is misleading.
```

Response:

```text
Use gauge-invariant link language: holonomies that fail to preserve a Higgs
section acquire quadratic edge cost. The usual W/Z mass terms appear only after a
vacuum/trivialization expansion.
```
```

## Scoped paper hits

No paper hits returned.
