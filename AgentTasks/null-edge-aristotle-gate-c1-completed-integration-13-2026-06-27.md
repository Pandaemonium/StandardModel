# Null-edge Gate C1 Aristotle completed integration 13

Date: 2026-06-27

Integrated jobs:

```text
C171R: anomaly/index and locality/control import certificates
C172: abstract block-reference GateC1_NU instantiation model
```

Aristotle project/task IDs:

```text
C171R project: d1eaf438-4271-4e4f-80fb-8a2fed32d5ec
C171R task:    30b06e43-9a18-4d21-b724-23db7e9f05ec

C172 project:  bf4f69b0-c077-4ad9-8d8f-dca7719ad23a
C172 task:     615e5f9c-cbda-41f7-9e2e-63d37fc9ae3b
```

Copied reports:

```text
AgentTasks/null-edge-c171r-anomaly-locality-import-certificates-integration-2026-06-27.md
AgentTasks/null-edge-c172-abstract-block-reference-integration-2026-06-27.md
```

Downloaded archives:

```text
AgentTasks/aristotle-output/d1eaf438-4271-4e4f-80fb-8a2fed32d5ec/project.zip
AgentTasks/aristotle-output/bf4f69b0-c077-4ad9-8d8f-dca7719ad23a/project.zip
```

## C171R result

C171R supplies the explicit import-certificate stack for C159.

The returned package organizes reference import around:

```text
ReferenceImportContract
  RefKind: directFlavoredOverlap | abstractBlock | domainWall
  AnomalyIndexCertificate
  LocalityControlCertificate
  DetGhostControlCertificate
  SubgapCertificate
```

The key theorem boundary is that `reference_import_valid` discharges only the
GateC1_NU import-precondition bundle. It does not claim full gauge dynamics,
determinant-line measure construction, Standard Model internality, or a closed
physical C1 theorem.

Two important shortcuts are explicitly rejected:

```text
Ginsparg-Wilson algebra alone does not imply anomaly cancellation.
A sign kernel alone does not imply summable locality/control.
```

This is now the right audit posture for the CKM/reference-kernel route.

## C172 result

C172 supplies the finite abstract block-reference scaffold.

The model uses:

```text
one finite sector set;
one designated light sector;
one real inverse-propagator mass per sector;
one positive gap for the heavy complement;
straight-line homotopy between reference masses and null-edge masses.
```

Its transfer theorem proves:

```text
sector-signature match
  + null-edge bad-sector inverse gap
  + null-edge light-sector lightness
  -> one-light-sector content
  -> true bad-sector inverse-propagator gap
  -> uniformly gapped homotopy.
```

This is useful because the abstract block reference can instantiate the
spectral part of C159 immediately, while physical certificates remain external
until a direct CKM/flavored-overlap or domain-wall reference is supplied.

## Documentation updates made

Updated:

```text
Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md
AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md
AgentTasks/null-edge-c171r-anomaly-locality-import-certificates-aristotle-2026-06-27.md
AgentTasks/null-edge-c172-abstract-block-reference-aristotle-2026-06-27.md
```

## Claim boundary

These jobs do not close Gate C1.

They do close a documentation/architecture gap:

```text
The finite spectral transfer and the physical import certificates now have a
clean interface.
```

Remaining blockers:

```text
CKM one-sector mass table;
shifted CKM mass window;
C170R sub-gap norm bound;
direct reference-sector match;
SM internality;
anomaly/index source theorem;
determinant-line control;
ghost-zero exclusion;
non-ultralocal locality/control.
```

## Lean artifact status

The returned Lean files are preserved in the Aristotle archives and reports but
were not promoted into the live trusted Lean tree in this integration pass.

No local Lean verification was run.
