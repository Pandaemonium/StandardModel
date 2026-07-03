
## 2026-07-03 origin-of-mass five-problem push (claude, daytime session)
- [claude] SUBMITTED Aristotle f983a254 (p1-bridge-coherence-20260703): the
  no-double-counting bridge suite - 11 targets: on-shell two-null wedge = coin
  amplitude mu (geometric mass = coupling mass), Dirac eigenvector chirality
  coherence = mu/E exactly, walk trace dispersion cos(wa)=cos(ka)cos(mua),
  explicit walk eigenvector + exact finite-a coherence |sin mua|/sin(wa).
  Statements typecheck; hand-verified proof notes in module docstring.
  (Problems 1+3 of the origin-of-mass push.)
- [claude] SUBMITTED Aristotle 2b9ab4ce (gate-c2-index-vanishing-20260703):
  the vanishing theorem - IsUnit(Dov) => overlapIndex = 0 and nonzero index
  => exact zero mode (topological protection of masslessness), via finite
  Avron-Seiler-Simon pair-of-projections index. Statements typecheck; full
  sketch in docstring. (Problem 2.)
- [claude] Gate F2 round 1 EXECUTED same-day: pre-registration written
  (AgentTasks/nerd-gate-f2-koide-preregistration-2026-07-03.md) and the
  cheapest falsification PROVED in-repo - new module
  PhysicsSM/Draft/NullEdge/GateF2/InvariantPotentialNogo.lean (builds, 8026
  jobs, axiom-clean): no conjugation-invariant potential has a critical point
  with three distinct eigenvalues => naive F2.0 (Koide point as critical
  point of an invariant potential) is DEAD; kill-condition fired by proof.
  Null filed; surviving rescope = F2.1 democratic-spurion class (freeze
  pending) + F2.0' directional reading. No Aristotle job needed. (Problem 4.)
- [claude] Problem 5 (Measure Problem / absolute mass scales): no job
  appropriate - nothing Lean-ready; layers 1-4 work above is
  measure-independent by design, and F2 is the only value-layer probe
  available. Revisit after growth-sector numerics (M1/G2') give the measure
  candidate a shape.
- NOTE: Aristotle 635b44ae (hermitian-sylvester, for the 2D flux witness) is
  COMPLETE and awaiting harvest - separate thread from this push.

## 2026-07-03 harvest integration (claude)
- [claude] HARVESTED f983a254 -> PhysicsSM/Draft/NullEdge/GateI1/MassCoinBridge.lean
  (all 12 bridge/walk statements proved, NO statement changed; builds 8026 green;
  key theorems axiom-clean). Layer 2 of the origin-of-mass map closed at 1+1D:
  coin amplitude = Pluecker wedge; Dirac + walk coherence = m/E exact.
- [claude] HARVESTED 2b9ab4ce -> PhysicsSM/Draft/NullEdge/GateC2/OverlapIndexVanishing.lean
  (both vanishing theorems proved; Aristotle's algebraic route needs NO
  Hermiticity, so ported statements are strictly more general; rewired onto repo
  Dov/overlapIndex via overlapIndex_eq; added flux_witness_has_zero_mode
  corollary: the pi-flux triangle's index -1 pins an exact zero mode). Added to
  GateC2 aggregator; aggregate build 8065 green (20 modules); axiom-clean.
- [claude] 635b44ae (Hermitian Sylvester) was already integrated by codex as
  GateC2/HermitianSylvester.lean (commit c9365e2) - my duplicate port deleted,
  codex's stands. Cross-checked: in aggregator, in write-up, in flux plan.
- [claude] Docs updated: C2 write-up section 2(g) (vanishing + zero-mode-at-witness)
  + file map (20 modules); P1 manuscript v2.1 (abstract, sections 11/14/16, change
  log): layer 2 closed at 1+1D, layer 3 protection proved, layer 4 keystone proved
  in minimal instance, layer 5 Koide gate rescoped after the F2.0 kill.
- [claude] NEW: Sources/Null_Edge_Measure_Problem.md - first dedicated status +
  strategy document for the program's central open problem. Consolidates Rounds
  4-8 + Gate D routes; 11-row entrance checklist (null-Markov fingerprint as the
  sharpest necessary condition); breakthrough ladder B-2..B+1 + negative tiers;
  candidate classes ranked; near-term queue: MP1 fingerprint test (new), G2' A_s
  freeze-then-scan, MP2 classical no-go (new, Lean-able), D4/D6 decorated-growth
  toy as the B0 vehicle, MP3 uniqueness squeeze (new); kill list; verification-
  debt register. Free-sector acceptance tests now machine-checked (MassCoinBridge
  1+1D; Gates C1-C2 tetra) - noted as the measure search's boundary conditions.

## 2026-07-03 SCG integration + follow-ups (claude)
- [claude] Reviewed + verified the external SCG measure-candidate analysis:
  Gram/positivity lemma checked by hand; mixture-CMI dichotomy reproduced
  independently (scratchpad/cmi_mixture_check.py: components exactly Markov,
  mixture 0.500 bits at full routing swap, quadratic vanishing).
- [claude] SUBMITTED Aristotle 970e20fe (measure-scg-gram-positivity-20260703):
  4 targets - gramDecoherence_posSemidef (+event level), deformed
  _posSemidef_of_posSemidef, deformed_posSemidef_iff (the back-reaction
  PSD-kernel criterion). Statements typecheck; harvest to a new GateMP module.
- [claude] MP1' v0 EXECUTED: Scripts/mp1_concentration.py (two-curve protocol;
  region-local JW Gaussian reconstruction, fermionically clean middle blocks;
  paired common-random-number estimates). Self-checks 1e-15/1e-12; excess = 0
  exactly at zero spread; superlinear growth (eff. exponent ~2.6); findings:
  kill criterion must target the mixture curve (excess not sign-constrained),
  v1 needs sprinkled 2D orders + SJ state + null cuts + stencil clause.
- [claude] Sources/Null_Edge_Measure_Problem.md updated (458 lines): SCG as
  candidate class 4(e) with grading table + pre-registered R7 kill test;
  MP1->MP1' (v0 results in-doc); MP2 rescoped; NEW gate MP4 (BC-Q freeze);
  kill list + bottom line + debt register updated (B-1 tier now has its first
  entrant, one definition gate short of complete grading).

## 2026-07-03 SCG Gram harvest (claude)
- [claude] HARVESTED 970e20fe -> PhysicsSM/Draft/NullEdge/GateMP/SCGGramPositivity.lean
  (all 4 theorems proved, NO statement changed; builds 8027 green, axiom-clean).
  Verified the necessity-direction mechanism by hand: deformed(deformed W A)(A^-1)
  = W exactly under full support (A^-1*A and conj(A)*conj(A)^-1 cancel), so
  necessity reuses the sufficiency lemma twice - cleaner than the quadratic-form
  route originally sketched. New GateMP/ area + GateMP.lean aggregator (first
  Lean content for the Measure Problem sector). Also fixed a gap: MassCoinBridge
  (harvested earlier today) was never wired into the GateI1.lean aggregator -
  added; GateI1 aggregate now 8028 jobs green.
- [claude] Sources/Null_Edge_Measure_Problem.md updated (476 lines): R4 in the
  SCG grading table upgraded T-once-landed -> T-done; strong positivity and the
  back-reaction criterion now cited as kernel-checked theorems throughout
  (candidate 4(e), the D4/D6 queue item, the bottom line).
