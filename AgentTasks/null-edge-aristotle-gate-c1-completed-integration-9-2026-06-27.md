# Null-edge Aristotle Gate C1 completed integration 9

Date: 2026-06-27

Integrated jobs:

```text
C157: Furey/Hughes/SM J-not-gauged audit
Project: b01927c3-3629-40e6-b186-d9326ee1b09c
Task: 1752bd20-18b1-4c33-8bbe-df6c6fe7dcc0

C158: C145 finite-seed promotion package
Project: 0bb1d7de-5236-430c-9b1a-0968ed7b2dc7
Task: 3c9cb6c5-e90b-4e10-bb79-8cd5a2ec2de9
```

## Executive result

C157 and C158 move two key Gate C1 support pieces from informal status into
explicit repo artifacts.

C157 reduces the SM gauge-safety question to a concrete assumption:

```text
SMActsInternally:
  every SM gauge generator has form id_B tensor g_i.
```

Under that assumption, branch `J = J_b tensor id` is not gauged and the C144
native-mode safety condition applies. If a gauge generator mixes the branch
factor, native mode is unsafe.

C158 supplied and we copied a draft Lean module:

```text
PhysicsSM/Draft/NullEdgeGateC1FiniteSeed.lean
```

This module formalizes the finite overlap/Ginsparg-Wilson algebra for the C145
seed without promoting physical claims.

## C157 integration

The audit artifact was copied to:

```text
AgentTasks/null-edge-c157-furey-hughes-sm-j-not-gauged-audit-integration-2026-06-27.md
```

Important output:

```text
internal gauge action:
  g = id_B tensor g_i

branch operator:
  J = J_b tensor id

then:
  gJ = Jg
```

The resulting project assumption stack is:

```text
A1: branch factor is disjoint from SM gauge action;
A2: null-edge branch grading is not weak-isospin/hypercharge chirality;
A3: Furey/Hughes internal action and octonion conventions are fixed;
A4: flavor/generation operators preserve the branch grading.
```

This is a genuine narrowing of the gauge blocker, but it is not yet a
generator-by-generator SM proof.

## C158 integration

The finite seed module copied into the draft tree contains:

```text
Trusted.overlapOp
Trusted.ginsparg_wilson
ginsparg_wilson_scaled
Trusted.kronecker_involution
Seed.Gamma_K
Seed.T_br
Seed.D_ov_ne
Seed.seed_ginsparg_wilson
Draft.null_edge_seed_has_exact_chiral_symmetry
```

Interpretation:

```text
Gamma_K^2 = 1
T_br^2 = 1
D_ov,ne = 1 + Gamma_K T_br
  -> Gamma_K D + D Gamma_K = D Gamma_K D
```

This confirms that once the sign kernel is supplied as an involution, the finite
seed has exact GW algebra by pure ring/matrix reasoning.

## Claim boundary

C157 does not prove that the intended physical SM embedding satisfies
`SMActsInternally`; it gives the exact assumption and no-go condition.

C158 does not prove the physical null-edge release. In particular, it does not
prove:

```text
T_br = sign(H_ne) from a gapped Hermitian kernel;
mass-window/sign-straddling for actual H_ne;
branch-line lift;
SM embedding;
bad-sector physical inverse gap;
anomaly/index import;
non-ultralocal control or locality.
```

## Follow-up

The new draft Lean module should be locally checked and then either left as a
draft finite algebra witness or split later into a trusted finite-algebra file
plus a draft physical-dictionary file.

C157 should later be converted into a project-facing Lean API under
`PhysicsSM.Draft`, preferably with names like `SMActsInternally`,
`JNotGauged`, and `sm_native_gauge_safe`, after we decide the exact branch and
Furey/Hughes internal representation conventions.
