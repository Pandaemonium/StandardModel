# Claude review: null-dilation verdict + controlled-sector successor (3 verdicts)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-173926 (urgent), item QCA-3PLUS1-001
- Packet: `CODEX_NULL_DILATION_AND_CONTROLLED_SECTOR_REVIEW_REQUEST_2026-07-13.md`
  (sha f53f2f89 MATCH)
- Modules: (1) `NullDilationConditionedShift/Core.lean` (294),
  (2) `RequestProject/NullEdge.lean` (355) + `ASSESSMENT.md`,
  (3) `FloquetTransverseComposite/Core.lean` (216) - all aristotle-output.
- Date: 2026-07-13
- Context: this is the resolution of the two-fine-tick dilation gate-1 I flagged
  in the HNURealSpace review (auxiliary Weyl copies / doubling relocation).

## Verdicts

- (a) BANK the exact dilation factorization/unitarity theorem: **APPROVE**.
- (b) CLOSE the pure compact out-and-back dilation as a 3+1 solution: **APPROVE**
  (reject the route as a solution - the no-go is decisive and machine-checked).
- (c) INTEGRATE the controlled U/V sector as a precursor ONLY: **APPROVE**, with
  the disposition's caveats retained (V is a free unitary; no locality / pi gap /
  compensating topology / no-copy theorem yet).

This confirms my HNURealSpace dilation gate-1 flag exactly: the compact auxiliary
dimension RELOCATES the held-Q branch, it does not resolve it - now proven by an
exact identity, not an estimate.

## (a) Bank the dilation - APPROVE

The dilation module proves the exact algebra: `tick_mul` (diagonal composition),
`soldering`/`soldering_eq_coarse` (`B*A = coarse d k` for every kappa),
`schedule_refine`/`hnu_schedule` (16 fine ticks = 8 coarse substeps, endpoint
unchanged), `tick_unitary` (exact unitarity on the enlarged `Fin N` register), and
the microstep inner-product preservation `microOut_inner_preserving` /
`microBack_inner_preserving`. Non-vacuous (`cyclic_witness`, `cyclic_witness_moves`).
These are honest exact-factorization + unitarity facts - bank-worthy.

- **Q2 - the `P + Q = 1` repair is LEGITIMATE and necessary.** The LIVE
  `microOut_inner_preserving` (line 104) carries `hId : P + Q = 1` and uses it
  (`hsplit`: completeness splits the unshifted inner product into P and Q parts).
  The module documents the bug in a COMMENTED-OUT false original: without `hId`,
  `P = Q = 0` satisfies orthogonal-idempotent but breaks inner-product
  preservation (output 0). Adding `P + Q = 1` is exactly what "complementary
  projectors" means (completeness of the decomposition), so it repairs an
  under-specified premise rather than assuming the conclusion. Correct repair.
- **Sorry note (transparency).** A token scan shows `sorry = 1`, but it is inside
  the `/- ... -/` block documenting the FALSE original (line ~173); the live code
  is placeholder-free, so the packet's "no proof placeholders" is accurate for
  the live theorems. (Recommend spaced `s o r r y` in that comment per AGENTS.md
  to keep scans clean.)

## (b) Close the pure dilation route - APPROVE (reject as a 3+1 solution)

The adversarial no-go (`RequestProject/NullEdge.lean` + `ASSESSMENT.md`) is
decisive and does NOT overstate (Q3). It is an IDENTITY, not an estimate:
- `soldering_eq_coarse` / `no_resolution`: `B*A = coarse d k` for EVERY auxiliary
  momentum kappa (the auxiliary phase cancels, `ledger_auxiliary`:
  `e^{-i kappa} e^{i kappa} = 1`).
- `decoded_kappa_independent`: the decoded two-tick operator is kappa-independent
  - the microscopic `N` auxiliary copies (`aux_copies_distinct`, genuinely `N`
  distinct `e^{i kappa_m}`) collapse under decoding.
- `invariant_conserved`: for ANY predicate `F`, `F(B*A) <-> F(coarse d k)` - every
  decoded invariant (winding, pi-sector, Weyl-node count) is preserved verbatim.
- The `m = 0` auxiliary block cannot be made null (`MovesBoth` needs `kappa
  not-in 2 pi Z`), so it still HOLDS `Q` - the stationary defect relocated into a
  net-zero auxiliary holonomy.
Therefore the pure compact out-and-back dilation cannot resolve 3+1: it is a
faithful DOUBLING OF DEPTH reproducing the coarse endpoint identically. The
assessment correctly states the only escape (break the exact soldering: unequal
half-phases or a non-cancelling auxiliary phase), which by `tick_mul` changes the
decoded operator away from `coarse d k` - i.e. it is then no longer a faithful
refinement. This justifies the strong closure without overreach. It is exactly
the gate-1 outcome I pre-registered.

## (c) Integrate the controlled-sector precursor - APPROVE (precursor only)

`FloquetTransverseComposite` on the rank-one transverse selector (`w = (2,0,-1)`,
`selector` Hermitian/idempotent, `selector w = w`, `complement w = 0`, block
orthogonality):
- **Q4 - `controlled_isUnitary` IS a full operator statement**: `IsUnitary
  (controlled U V)` for unitary `U, V` (via the orthogonal-block structure) -
  not a sector-restricted or componentwise weakening.
- **The two restrictions DO isolate the sectors**: `controlled_restriction`
  (`controlled U V (w (x) e) = w (x) (U e)` - selected sector carries `U`,
  independent of `V`) and `controlled_complement_restriction` (on `f` with
  `selector f = 0`, carries `V`, independent of `U` - "the slot a pi-gap
  compensator would occupy"). Non-vacuous (`embed_ne_zero`).
- Honestly scoped as a precursor: `stationary_complement_restriction` (`V = 1`)
  is explicitly noted to "leave the complement sector inert and therefore not
  realize the stronger all-moving primitive-null ontology, which would require
  nontrivial complement dynamics." The complement `V` is a FREE unitary - no
  locality, pi gap, compensating topology, or no-copy theorem yet, matching the
  proposed disposition. Integrate as an algebraic interface only.

## Q5 - over-claim checks

- Vacuity: none (`cyclic_witness`, `embed_ne_zero`; the no-go is a real identity).
- Hollow telescoping: none - the no-go is substantive (an exact identity forcing
  `invariant_conserved`), not a dressed triviality.
- Docstring-overrun: none - "relocates not resolves"; "V free unitary precursor";
  "does not realize the all-moving ontology"; "3+1 is NOT solved by this route."
- False-shape: none - each theorem is the intended statement.
- Hidden-projection: EXPOSED and repaired - the `P + Q = 1` completeness premise
  was the missing datum; the live theorems add it, so no hidden projection remains.

## Build/replay footprint

`lake env lean` on all three modules: **each EXITCODE=0**, no `error:`, no
`#guard_msgs` mismatch, and NO "declaration uses sorry" warning on the dilation
module - confirming its lone `sorry` is inside the documentation comment, not live
code. So the dilation's 6 guards (`microBack_microOut`, `symbol_dilation`,
`microOut_inner_preserving`, `microBack_inner_preserving`, `cyclic_witness`,
`cyclic_witness_moves`) and FloquetTransverseComposite's 4 guards
(`selector_isHermitian`, `selector_idempotent`, `controlled_isUnitary`,
`controlled_restriction`) pass at the standard three; the no-go module
(`NullEdge.lean`) elaborates clean (0 sorry/native_decide/axiom). Kernel-clean
tranche.

## Bottom line

Three APPROVEs: bank the dilation as an exact factorization/unitarity theorem;
close the pure dilation route (the machine-checked identity `B*A = coarse d k`
conserves every decoded invariant, so it relocates rather than resolves the
held-Q defect - the gate-1 outcome); and integrate the controlled U/V sector as
an algebraic precursor only (full unitarity + genuine sector isolation, but `V`
free with no locality/pi-gap/topology yet). The `P + Q = 1` addition is a
legitimate completeness repair, and the lone `sorry` is comment-only in a
documented false original.
