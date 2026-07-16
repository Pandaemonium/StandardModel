# Claude review: GammaTransverseControl/PairedChiralityGap (refill harvest)

- Reviewer: interactive Claude (claude family), Skeptic, solo mode
- Source: Aristotle job `87e8d4f4`, `GammaTransverseControl/PairedChiralityGap.lean`
  (202) + `ChiralitySelectorNoGo.lean` + `Core.lean`. Date: 2026-07-14

## Verdict: APPROVE (draft-trust)

Independently built (Core + PairedChiralityGap + ChiralitySelectorNoGo, retargeted
imports): `lake build` EXITCODE=0 (8028 jobs). 0 real sorry/native/axiom; 7 guards;
build confirms standard-three `[propext, Classical.choice, Quot.sound]`.

## What it proves

`paired_chirality_no_full_gap` (6-way conjunction): the anticommuting transverse
gamma coupling does NOT open a full gap and the surviving cone is net-zero paired:
1. kernel sector `H^2 = (kx^2+ky^2+kz^2) . embed e` (massless cone, no mass);
2. complement (`v _|_ w`) `H^2 = (5 + k^2) .(...)` (gapped, `>= 5`);
3. `chir^2 = 1`; 4. `[chir, tangent] = 0`; 5. `trace chir = 0` (equal-dim Weyl
sectors => net-zero chirality); 6. `JacPlus.det + JacMinus.det = 0` (opposite Weyl
signs). Plus `no_full_gap_zero_mode` (explicit nonzero zero mode at k=0, control)
and the `chirality_selector_no_go` ladder. Semantically sound.

## Over-claim audit

- Vacuity: none - explicit zero-mode witness, `embed_ne_zero` injectivity.
- False shape: none - the H^2 sector identities and the trace/det chirality
  statements are exactly as read.
- Docstring-outruns-kernel: none - explicit "What is NOT claimed": single fixed
  finite matrix; no discrete-time/primitive-null/Brillouin/bulk-edge/continuum/
  physical/anomaly-inflow/SM; "no full gap" = exact H^2 on fixed sectors, not a
  spectral diagonalisation.

## Program fit

A clean finite NO-GO refinement: the balanced transverse gamma coupling leaves a
massless cone with net-zero (paired) chirality - it cannot isolate a single
chirality. Complements the domain-wall result (9eb52ec3): sublattice IMBALANCE ->
single species; BALANCED transverse coupling -> paired net-zero. Together they map
the finite single-vs-paired boundary. Consistent with the relocate/pair-not-escape
pattern.

## Bottom line

APPROVE (draft-trust). Independently rebuilt, standard-three, exemplary scope. The
transverse gamma coupling gives a massless paired-chirality cone with no full gap -
a finite no-go against single-chirality isolation by this mechanism. Distinct from
the HNU Floquet Gate-1 (running). Landing: reconcile the Core submodule.
