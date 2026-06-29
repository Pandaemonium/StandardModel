# Null-edge Gate C1 Aristotle completed integration 14

Date: 2026-06-27

Integrated jobs:

```text
C170R: sub-gap norm bound for reference homotopy
C175: pure product/parity no-go in dimension four
C177: CKM branch-mass gauge safety
C178: CKM strategy and index-import architecture
```

Aristotle project/task IDs:

```text
C170R project: 47a820f0-3195-4553-bdfc-5ce10f6b4b8f
C170R task:    b3f2a899-7b82-4265-81df-afc2677f1a8d

C175 project:  0fa06ae5-be0b-4e7a-b217-9e1b85c307a0
C175 task:     926435ae-1416-48df-ba8c-283476cedd9d

C177 project:  903b5288-98ed-4386-ab60-43de812e4797
C177 task:     d8c49785-cd99-4cc4-87c4-82789bb91546

C178 project:  793ce443-8e11-4d49-8ba0-9692d4737dba
C178 task:     2f29e7f4-07a7-400d-9791-e5389545ea77
```

Copied summaries:

```text
AgentTasks/null-edge-c170r-subgap-homotopy-bound-integration-2026-06-27.md
AgentTasks/null-edge-c175-pure-parity-no-go-integration-2026-06-27.md
AgentTasks/null-edge-c177-ckm-gauge-safety-integration-2026-06-27.md
AgentTasks/null-edge-c178-ckm-strategy-index-import-integration-2026-06-27.md
AgentTasks/null-edge-c178-strategy-gatec1-index-import-2026-06-27.md
```

Downloaded archives:

```text
AgentTasks/aristotle-output/47a820f0-3195-4553-bdfc-5ce10f6b4b8f/project.zip
AgentTasks/aristotle-output/0fa06ae5-be0b-4e7a-b217-9e1b85c307a0/project.zip
AgentTasks/aristotle-output/903b5288-98ed-4386-ab60-43de812e4797/project.zip
AgentTasks/aristotle-output/793ce443-8e11-4d49-8ba0-9692d4737dba/project.zip
```

## C170R result

C170R supplies the quantitative sub-gap certificate for reference homotopy.

It decomposes:

```text
H_ne - H_ref
```

into:

```text
kinetic mismatch;
W_branch mismatch;
R/m0 mismatch;
gauge/admissibility perturbation;
branch-frame mismatch.
```

It proves:

```text
||H_ne - H_ref|| <= kappa + omega + rho + alpha + beta.
```

If the right-hand side is below the reference gap, then the straight-line
homotopy is uniformly gapped. This supplies the C164/C159 sub-gap interface but
does not compute the actual null-edge constants.

## C175 result

C175 proves that pure product/parity mass in four dimensions gives:

```text
8 positive sectors;
8 negative sectors.
```

Therefore a selector depending only on pure product parity cannot isolate the
unique level-zero corner. This confirms that pure parity is a diagnostic seed
or no-go object, not a one-sector release.

It also records the level-linear Wilson comparison:

```text
W = 2r level
```

with level multiplicities:

```text
1, 4, 6, 4, 1.
```

## C177 result

C177 proves CKM branch-mass gauge safety under the `SMActsInternally`
assumption.

If:

```text
SM generators act as id_Branch tensor g_i;
W_branch acts as branch_operator tensor id_Internal,
```

then the branch mass commutes with the SM generators. If a generator mixes the
branch factor and fails to commute with the branch mass, native gauge safety
fails unless a gauge dressing is supplied.

## C178 result

C178 gives the index-import theorem architecture and strategy update.

It separates:

```text
HomotopyTransferred:
  overlap/GW algebra, projector rank, index/spectral flow, Krein sign.

IndependentCertificates:
  anomaly/index-weight matching, SM gauge representation, non-ultralocal
  control, locality, determinant line, no ghost zero.
```

It also defines the seven-slot sector-signature checklist:

```text
rank;
chirality;
branch parity;
gauge representation;
shifted mass sign;
Krein sign;
anomaly/index weight.
```

Important warning:

```text
CKM is appropriate as a flavor-texture/mass-table reference.
A literal naive product flavored-overlap operator is not the final reference
unless it is proven doubler-resolved.
```

The safer operator-side target is a doubler-resolved Neuberger-overlap, tuned
flavored-overlap, or domain-wall reference with matching sector signature.

## Documentation updates made

Updated:

```text
Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md
AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md
AgentTasks/null-edge-c170r-subgap-homotopy-bound-aristotle-2026-06-27.md
AgentTasks/null-edge-c175-pure-parity-no-go-aristotle-2026-06-27.md
AgentTasks/null-edge-c177-ckm-gauge-safety-aristotle-2026-06-27.md
AgentTasks/null-edge-c178-ckm-strategy-index-import-aristotle-2026-06-27.md
```

## Lean artifact status

Returned Lean files are preserved in Aristotle archives and summaries. They
were not promoted into the live trusted Lean tree during this integration pass.

No local Lean verification was run.
