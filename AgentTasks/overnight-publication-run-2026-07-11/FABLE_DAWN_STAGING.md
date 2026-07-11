# Fable dawn staging (facts landed so far; verdicts belong to the 07:00 co-audit)

Maintained by Fable through the night so MORNING_REPORT and HONEST_SCORECARD
fill fast at dawn. Facts only; every line has a ledger timestamp.

## Fable-lane landings (kernel-checked, guarded, manuscript-synced)

| Result | Module / location | Ledger time |
| --- | --- | --- |
| Derived link winding: arg-ratio increments, 2*pi*Int integrality, chiral covariance, winding-one spinor-generated witness, derived no-go bridge (6 thms) | PhysicsSM/Draft/NullEdge/PlueckerWindingDerived.lean | 21:38 |
| Chiral flip-mode engine: charpoly conj-closure, unimodular roots, det = (-1)^mult(-1), det=-1 forces exact -1 mode (+1 partner even dim), witness+control (6 thms) | PhysicsSM/Draft/NullEdge/ChiralFlipMode.lean | ~20:20 real |
| Operational phase witness: conjugate rest operators for 3+4i vs 5, two-kick return amplitude u2*conj(u1), vacuum reference, interference amplitude, survival probability 4/5 vs 1 (7 thms + compat lemmas) | PhysicsSM/Draft/NullEdge/PlueckerPhaseObservable.lean | 21:58 |

| Route-B protection theorem + Route-A det kill (composed; abstract witness, no native_decide in the new parts) | PhysicsSM/Draft/NullEdge/SignWallDefectRouteB.lean | ~20:50 real |
| Mass-mixedness package: purity bridge, Lagrange/trace-distance, ensemble pairwise, Pauli corollary, witness+control (6 thms; Sol sec 1; companion-paper core) | PhysicsSM/Draft/NullEdge/MassMixedness.lean | ~21:25 real |

## Fable manuscript work (Paper A)

- Abstract: five-part rewrite (18:42); full-Bloch criterion (19:36);
  classification upgrade (22:50); QCA-referee rescopes (23:22); rank-language
  collinearity fix (22:30).
- Intro: seven-contribution restructure (18:42); two-pillar framing (23:45).
- Nearest work: WvdW/AHH confrontation + Dittmaier (18:58); Pavia
  informational-principles acknowledgment (23:22); Mlodinow-Brun attribution
  sentence + comparison-table row (23:22).
- Gupta-Short: positioning paragraph + involution corollary (20:56), M3
  rescope + Appendix-F characterization (23:22/23:35); DOI Crossref-verified
  (23:35).
- Discussion: assigned-mass mimicry paragraph (22:30); verb-table updates.
- Conclusion: fragment repair (18:42); winding + interference + complete
  crossing classification synced (23:50).
- Citations added: DittmaierWvdW, DouglasQFTLean, Mlodinow-Brun table row.
- Integrity: full structural check clean (00:05) after repairing one
  backspace and two tab corruption artifacts.

## Referee state

- 85cbba5e (math-phys): no fatal/vacuous; MAJOR-1 artifact completeness
  (Codex lane, scorecard release gate); MAJOR-2 novelty margin (C race is
  the counter); MINORs fixed.
- 382a2b2c (QCA): no fatals; verdict "major revision, wording only"; ALL
  demanded fixes applied same night (M1 rescope, M2 attribution, M3
  corollary scope, m1-m5); m7 = MAJOR-1 duplicate.

## In flight at last update

- ecbe0d8b chiral-flip-mode engine (C pillar 2)
- b407e2d5 sign-wall defect design (C pillar 3)
- 85a80ef1 strategy refresh 2
- Codex: f90d69c7 CAR functorial, 144a848d strict-QCA integer-range kill,
  4f21ae6e grand strategy (check their ledger entries for landings)

## Late-night landings (post ~20:30 real; see ledger for full detail)

| Result | Module / location |
| --- | --- |
| Route-B abstract protection theorem + Route-A det kill | SignWallDefectRouteB.lean |
| Sector-det blindness (honest negative, both controls) | SignWallDefectRouteBConcrete.lean |
| Mass-mixedness package (Sol sec 1; companion core) | MassMixedness.lean |
| Gauge classification FULLY PROVED (orbit invariant; triviality iff constant; relative invariant = what 4/5 reads) | GaugeClassification.lean |
| C: involutive-compression engine (kernel-only) + explicit two-wall fixture modes (draft-trust); half-winding LAW demoted per 00:08 audit to a sharply-posed conjecture (no Lean invariant/iff/localization/stability yet; Afix0=Afix4 control failure found and REPAIRED by Codex full-walk certificates 01:12) | ModeInvariantHalfWinding.lean + Codex HalfWindingFullWalkControls |
| Pauli trace conventions (clean-room Physlib-adjacent port) | PauliTraceConventions.lean |
| Dynamics lab v1 (spec-driven, deterministic, JSON+SHA) | Scripts/sim/dynamics_lab.py |

Manuscripts: A (2 referee waves applied + all syncs); obstruction letter
(3 referee sims survived, all fixes applied incl. Nielsen-Ninomiya);
mixedness companion v1 (ratification-pending); C half-winding paper v1
(ratification-pending, positive-gate framing). GA fully synced incl. the
half-winding twist. Strategy memos 1-3 harvested and executed.

## Known dawn tasks

- HONEST_SCORECARD headline rows: canonical rest gap (M), exact dynamics
  (M), consequence beyond constant mass (M for carried-phase witness; C for
  free-theory escape), strict 3+1 verdict (M: determinants + classification
  + no-gos), continuum (M at compact-support scope), many-body (M seeds; C
  interaction), scale (C; no-go landed).
- MAJOR-1 artifact release gate; author-line release gate (title page
  comment).
- Zotero ingests deferred by rate limits: 1003.1729, 1208.2143, 1611.04439,
  2603.15770.
- Memo-1.3 appendix demotion deferred to one-week list (23:45 rationale).

## Dawn wave additions (post-waiver, 06:36-07:45; ledger timestamps)

Landed / decided this wave:

| Result | Location | Ledger time |
| --- | --- | --- |
| HalfPeriodInvariant: positional law iff (16 fields) + full-walk protection via engine + mirror ill-definedness + chiral frame structure | PhysicsSM/Draft/NullEdge/HalfPeriodInvariant.lean (+4 guard pins) | 07:19 |
| Timeframe-pair kill (advisor's pre-registered condition fired; bulk (0,-+2) windings exact) | harvest f4879a60 design memo | 07:19 |
| Full-walk census: EVERY two-wall field has modes (blind (2,2), blocks (4,4)); law = certificate boundary | ledger + C paper census remark | 07:32 |
| Axis-equivariant certificate: blind fields certified by the {0,2} chart through the SAME engine | ledger + C paper atlas remark | 07:41 |
| Blocks are exact involutions (W^2=1, W=W^T, tr 0): engine at identity | ledger + C paper taxonomy remark | 07:42 |
| H7 exact negative: marginal direction = dilatation (Euler), c+b^2 = 0 identically | ledger (Codex's FiniteHomogeneousScaleNoGo is the kernel leg) | 07:0x |
| Window half-charge -1/2 sector-resolved (exact L=8; rational Gamma; Schur lesson) | oracles + dynamics_lab v1.1; Lean cb16b747 in flight | 06:50 |
| 4x4 phase-defect spectrum (Pro), equal-moduli load-bearing | sympy-verified; Lean 497535a1 in flight | 07:17 |

## GA-ready story lines (STAGING ONLY - GA edits queued post-run, earned scope)

1. "One machine puzzle, three answers" - the 16-field taxonomy: the same
   kernel-checked engine explains every defect's modes at three
   compression levels (whole walk / one mirror axis / the other mirror
   axis), and the celebrated winding number provably cannot tell the
   charts apart. Footnote grade: law/protection = machine-verified;
   atlas/census = exact computation, formalization in flight.
2. "The phase is real" - two independent free-theory observables: a
   half-electron's worth of charge (-1/2 exactly) pinned at a mass kink
   per gap sector, and a two-site spectrum that hears the relative phase
   of equal-modulus masses. Footnote: fixture-level; in-flight Lean.
3. "Why no scale selects itself" - Euler's 200-year-old identity closes
   every homogeneous route to a mass scale; the only honest escape is a
   running-coupling family. Footnote: kernel-checked no-go.
