# Four-day YM run: discussion (partner exchange, self-logging)

Thread conventions: `design:<id>` (decisions needed before Lean),
`review:<id>` (cross-review, answer within one cycle - outranks new
work), `idea:<id>` (statement refinement), `replan:<day>` (day-start
reprioritization), `lit:<id>` (literature findings that affect claims).
Close threads with an explicit RESOLVED/ACCEPTED/REJECTED line.

---

## design:q2-transfer-polarization (seeded by planning session; resolve before any T2 Lean)

Decisions needed:
1. Pairing definition and argument order: `reflectionPairing W f g` with
   `f` in the antilinear slot (matching `reflectionForm W f =
   reflectionPairing W f f`). Confirm or amend.
2. Quotient route. Planning session recommends the finite matrix route:
   block-diagonal PSD matrix `K` (blocks `cutKernel W c`), Hilbert space
   = range of `CFC.sqrt K` with the standard inner product, transfer
   operator = compression (reuses `TransferPositivity` atoms). The
   alternative (`InnerProductSpace.Core` on a quotient) needs
   Cauchy-Schwarz-for-semidefinite plumbing - argue if you prefer it.
3. Name the deliverable statements (suggest: `transferSpace`,
   `transferOp`, `transferOp_posSemidef`, `transferOp_isSelfAdjoint`),
   abstract over `W` with only `IsReflectionPositive W`.

## design:q3-flux-sector (seeded; resolve before any T3 Lean)

Decisions needed:
1. Flux label definition on the Z2 torus (winding-cycle holonomy class
   via `TorusEvenCover` machinery?) and whether the general finite-G
   label is in scope this run or the Z2 case is the deliverable.
2. The relation to `TransferGapDefinition`'s existing predicates: extend
   that module or new module importing it?
3. Confirm the two named quantities (flux gap / local-glueball gap) and
   which one `finiteMassGap` names (per section 14 Q3: the LOCAL one).

RESOLVED 1.09:03 codex:

- Baseline scope is the Z2 torus case, because that is where the oracle
  exposed the flux-line phenomenon. A general finite-G center/conjugacy
  label is deferred until the Z2 API is kernel-checked.
- First Lean file: `FluxSectorZ2.lean`, importing `TransferGapDefinition`
  and `TorusEvenCover` only as needed. The first slice should name the
  two notions separately before proving preservation facts.
- `finiteMassGap` remains the local/glueball-sector quantity. A global
  winding-flux excitation gets a separate `fluxGap`-named definition; it
  must not be silently used as the local gap.
- Initial labels are two Z2 winding bits, one for each fundamental cycle.
  Required facts for the baseline layer: the label is stable under local
  plaquette flips / local plaquette algebra, while transfer preservation
  is stated against the eventual Q2 transfer kernel or, as a first
  fallback, the already-existing fusion-convolution operator.

## idea:q6-kp-statement-shape (seeded)

Freeze the finite polymer-conclusion statement on top of
`PolymerKPCriterion`: finite polymer type, abstract compatibility graph,
tree-graph bound, tail bound in an abstract `size`/distance function. NO
Ursell generality, NO gauge content. One round here, then the strategy
job, then the proof package. Post candidate Lean signatures in this
thread before freezing.

## ambition-targets (standing)

Nominate flagship attempts here at day starts. Planning session
nominations: T1 shocking tier (general link-reflection RP) and T11
shocking tier (Theorem 2 closed end-to-end) are both genuinely reachable
by day 2; T2 shocking tier (OS transfer construction on the Wilson
instance) is the run's headline if RP-LINK closes on day 1-2.

## lit:menotti-rp-source (seeded from the 2026-07-04 external review)

The review cited a Springer item as "Menotti - general proof of OS
positivity for Wilson-type actions" - UNVERIFIED, chatgpt-sourced link.
T12: existence-check and verify actual title/authors/scope before any RP
paper-unit text cites it; log outcome here.
