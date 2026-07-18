# Claude semantic audit: Lorentz-atlas spin-lift boundary

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-142536-3c3c4fe4. Source audited at sha256
6bc68475... (MATCH); task note read. Kernel check EXIT 0 independently;
three in-file guards pin the standard three axioms; all imported
support lemmas verified to exist at their stated homes
(`timeCharacter_sl2ToEtaLorentz`, `minusIdentity_mem_kernel`,
`centralSignData`, `centralSign_centralDefect`).
Date: 2026-07-16.

## Verdict: APPROVE (one non-blocking observation)

## The hidden-assumption hunt - nothing hidden

The requested hunt for hidden orientation/reverse-edge assumptions
comes back clean because the imported `IsCechTransition` DISPLAYS all
three conditions as structure fields: `normalized` (diagonal),
`inverse` (T_ij * T_ji = 1 - the reverse-edge law, explicit), and the
`cocycle` (T_ij * T_jk = T_ik). Every downstream theorem carries `S :
IsCechTransition ...` plus an explicit `triple_implies_pairs` function
covering all four ordered pairs the triangle argument consumes
((i,j), (j,k), (k,i), and (i,k) for the holonomy lemma). Equally
important on the spin side: `IsSpinLiftOn` deliberately does NOT
impose the inverse law on the lifts - which is correct, since the
central sign freedom on reversed edges is exactly where the defect
theory must live.

## Semantic shape - all six requested items check

- **Cech triangle product:** `lift i j * lift j k * lift k i`, matching
  the imported `triangleProduct`; the Lorentz-level triviality follows
  from cocycle + inverse, so the bridge theorem
  (`triangleLiftProduct_mem_kernel`) is genuinely UNCONDITIONAL given
  the displayed Cech and lift data. Verified against the imported
  proof.
- **Local lift assumptions:** chosen lifts projecting on occupied
  ordered pairs - displayed, not derived; the module assumes lifts are
  chosen and says so.
- **Kernel conclusion and the {+I,-I} gate:** the exact-kernel
  statement is a DISPLAYED hypothesis (`HasExactCentralKernel`), and
  the reduction lemma honestly shows only the containment direction
  remains owed (both central signs' membership already proved). The
  conditional conversion to a unique central sign and the exact
  defect-bit reconstruction (`centralSign_triangleSpinDefect` via the
  landed `centralSign_centralDefect`) are correct.
- **Central re-signing:** multiplication by either central sign leaves
  the projected Lorentz transition unchanged - proved, and it is the
  right gauge freedom for the downstream cochain theory.
- **Distinction from connection holonomy:** inherited verbatim from
  the imported lemma's docstring (nontrivial triangle holonomy must
  live in separate connection data, not the bundle-gluing cocycle);
  this module's spin content is therefore purely the central defect of
  the CHOSEN lifts - the finite Cech-w2 story - while the w2
  identification, vanishing, atlas/lift derivation, and refinement
  compatibility are all explicitly disclaimed.
- **Bonus corollary checked:** local liftability forces orthochronous
  transitions (`timeCharacter_eq_one_of_spinLift`) - correct and
  unconditional.

## Prose versus kernel

The task note's claims map one-to-one onto the theorems, including the
precise statement that the exact-kernel gate is one of the two owed
covering statements (surjectivity the other). `M [orig/comp]` for
finite group and Cech algebra is right. No overclaim found.

## Non-blocking observation

This module carries no in-file nonvacuity witness (the trivial atlas
T = 1 with identity lifts satisfies every hypothesis; the imported
obstruction modules carry their own witnesses). A five-line trivial
witness - or one docstring pointer to an imported witness - would
complete the vacuity-audit pattern used elsewhere today. Optional.
