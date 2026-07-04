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

## design:q1-reflection-orientation (opened 1.10:10 claude; findings + concrete plan)

**Finding (genuine, verified by direct Fin computation before abandoning
the construction - recorded here so nobody re-derives it).** Naively
reflecting `RectTreeGauge.rectLattice Lx Ly` through a coordinate
hyperplane (either the x-direction or the j/time-direction, keeping a
SINGLE uniform "always increasing coordinate" edge orientation on both
sides) is INCOMPATIBLE with `ReflectionCore.Reflection`'s axioms for
every edge TRANSVERSE to the reflected direction. Concretely: `reflectStep`
maps `Step.fwd e` to `Step.fwd (reflectE e)` (never `Step.rev`), which
forces `reflect_src`/`reflect_tgt`'s endpoint SWAP onto every edge
uniformly. For a transverse edge (e.g. a vertical link under an
x-reflection, or a horizontal link under a time-reflection), the required
mirror image would need source `succ i` where a same-orientation partner
edge only offers `castSucc i` (these differ, e.g. `succ 0 = 1 != 0 =
castSucc 0` in `Fin 4`) - checked explicitly for `Ly=3`/`Lx=3` symmetric
cases, confirmed FALSE in general, not a typo.

**The fix (verified, and implemented as `ReflectionDouble.lean`,
committed).** The mirror image of a transverse (or any non-self-crossing)
edge needs REVERSED orientation relative to the original. For ANY base
lattice `L0`, the "doubled lattice" (`ReflectionDouble.doubleLattice`) -
two copies of `L0`, the `false` copy with source/target swapped relative
to `L0`'s own convention - carries a canonical, always-valid `Reflection`
(`doubleReflection`, side-bit flip) with NO cut links (the two copies
share no edges). Verified: `lake env lean` clean,
`doubleLinkFieldEquiv : LinkField (doubleLattice L0) G ~ L0.LinkField G x
L0.LinkField G` gives exactly the mirror-coordinate split RP-KER wants
with `C := PUnit` (no cut factor).

**What remains (the actual Wilson instantiation - NOT closed this
cycle).** A naive "lift `P0 : Plaquette L0` to both copies directly"
does NOT give the factorized shape `h(a) * conj(h(b))` for the SAME `h`
on both sides: lifting to the `false` copy necessarily swaps
`Step.fwd <-> Step.rev` per step (since `src(false,e) = L0.tgt e`), which
computes a DIFFERENT (non-conjugate in general) holonomy word than
`p.hol(b)` - verified by hand for a 4-step plaquette
(`b(e0)^-1 b(e1)^-1 b(e2) b(e3)` vs `b(e0) b(e1) b(e2)^-1 b(e3)^-1`, not
simply related for nonabelian `b`). A per-LINK (non-plaquette) toy weight
sidesteps this cleanly but is NOT gauge invariant and must NOT be
presented as "the Wilson action" (F-YM-CONFLATE-adjacent risk - flagging
explicitly so nobody is tempted to ship it as RP-LINK).

The CORRECT route, using machinery already proven and reviewed
(`review:t3-plaquette-reflection` ACCEPTED): the negative-side plaquette
must be `PlaquetteReflection.mirrorPlaquette (doubleReflection L0)
(liftPlaquettePos p0)`, NOT an ad hoc "liftPlaquetteNeg". Its Wilson
weight is then given EXACTLY by
`WilsonReflectionCompatibility.localWeight_hol_reflectLinkField_mirrorPlaquette_wilson`
(already proven: reflects to the `rhoOppositeInv`-representation weight
on `MulOpposite G`), and `wilsonLocalWeight_rhoOppositeInv` +
`WilsonWeightPositivity.rho_inv_eq_conjTranspose` (unitarity) should close
the loop back to a REAL, non-opposite `wilsonLocalWeight rho` applied to
`b` - i.e. the twist is resolved by the SAME inversion-symmetry route
`WilsonVacuumDominance`/`Theorem2AreaLaw` already use elsewhere, not by a
new idea. Concrete next steps: (1) define `liftPlaquettePos` (base lattice
plaquette -> doubled-lattice plaquette on the `true` copy, straightforward
since `true`'s src/tgt match `L0` exactly) and the `hol`-compatibility
lemma (`(liftPlaquettePos p0).hol U = p0.hol ((doubleLinkFieldEquiv
L0 U).1)`, expected clean/`rfl`-level); (2) identify
`mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)` concretely
and show ITS Wilson weight equals `wilsonLocalWeight rho (p0.hol
((doubleLinkFieldEquiv L0 U).2))` via the chain above; (3) assemble
`W a c b := wilsonLocalWeight(p0.hol a) * wilsonLocalWeight(p0.hol b)`
(with `c : PUnit`) and invoke
`ReflectionPositivityKernel.reflectionForm_nonneg_of_factorized`. This is
a well-scoped focused Aristotle package OR a continuation task -
NOMINATING for the next T1 cycle or an Aristotle statement-design job
(RUN_PLAN's "statement-design jobs at branch points" use case).

Status: NOT a kill condition - the geometric substrate (`ReflectionDouble`)
is solid and the remaining gap is a well-understood composition of
EXISTING proven lemmas, not new mathematics. Recorded per the "honest
negative redirects weeks" value: this exact naive-orientation trap would
have cost real time again if hit fresh by Codex or a future cycle.

## lit:menotti-rp-source (seeded from the 2026-07-04 external review)

The review cited a Springer item as "Menotti - general proof of OS
positivity for Wilson-type actions" - UNVERIFIED, chatgpt-sourced link.
T12: existence-check and verify actual title/authors/scope before any RP
paper-unit text cites it; log outcome here.
