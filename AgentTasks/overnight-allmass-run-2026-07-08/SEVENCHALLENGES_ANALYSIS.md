# Executor analysis of the SevenChallenges memo (2026-07-08)

Source: `NullEdge_SevenChallenges_Memo_2026-07-08.md` (archived here;
external response to `COLLABORATOR_BRIEF_2026-07-08.md`). Verdicts by
finding, with adoptions wired into RUN_PLAN. Verification level: findings
3, 4, 6, 7, 11 re-derived by executor reasoning (finite algebra); finding
2 is a plausibility-verified malposition diagnosis requiring the decidable
probe below; finding 8 is C-grade with a cheap numeric kill.

## Verdicts

1. **Two closure objects (C_area vs C_spin): ADOPT (already Amendment B).**
   The memo's notation is cleaner; the kill condition ("Q_C is the
   positive gluon-energy share" = auto-reject) is now binding review
   language for gates G1/G4.
2. **C1 off-by-root trap: ADOPT AS K1-STEP0 (mandatory, BEFORE any
   sixth prover attempt).** If rho_j ranges over ALL m_j! block
   permutations while canonical-least-root pins the root's output slot,
   the root-first encoder collapses by m_j per block and the target
   inequality |fiber| k! prod m_j! <= n! is UNPROVABLE via it - only
   prod (m_j - 1)!. Our file DOES use canonical-least-root machinery
   (`exists_canonical_root`, least g-slot). STEP0 = (i) the 2-element
   decidable counterexample for the root-first total-block-perm
   encoder; (ii) semantic audit of what `m : Fin k -> Nat` counts in
   `fiber_card_mul_le_factorial` (total block size vs non-root slots).
   If (i) fires and (ii) says "total", the five failures were attempts
   at a false statement: fix the statement (FreeSlots) or the encoder,
   then use the memo's parse-certificate skeleton
   (`parse_encode` -> one-line injectivity). This is the single most
   likely pathway around the K1 blocker.
3. **Torsor cannot change quotient positivity: ADOPT (verified -
   trivial once said: L_A^# L_A = Q_C for every A, so [psi, Q_C psi]
   is representative-independent).** K3 splits: **C2a** descent
   criteria (Q_C V' <= V'; Q_C N <= V'-perp) - finite linear algebra;
   **C2b** the DECISION: inertia of the restricted Gram
   G_ij = [e_i, Q_C e_j] on a complement of N in V' - computable the
   day V' lands, NO torsor search needed. Kill condition adopted: if
   indefinite, rebrand Q_C as the signed chromomagnetic channel and
   require positivity only of the TOTAL 4 D^#D on the quotient.
4. **Pair-stabilized multi-direction square: ADOPT (verified - direct
   sums of Krein squares sum).** C3 dissolves: with pair-indexed
   target space and L = direct-sum of the two-direction currents,
   L^#L = sum Q_munu = Q_C exactly, any d. The single-current
   (unstabilized) question becomes a secondary inertia/factorization
   no-go. K2/L4 should land the STABILIZED form first.
5. **S3 via C_area: consistent with Amendment A2; no change.**
6. **Banks-Casher count identity: consistent with Amendment A4; the
   exceptional-mode (D = 2) projection kill condition is adopted into
   K5's statement duty.**
7. **SIGNED mass budget: ADOPT (regrades K4).** Shares b_A, b_C, b_T,
   b_E sum to 1 but are NOT called fractions until C2b returns PSD for
   the respective restricted forms. First physical claim = non-turn
   dominance in the signed sense (|b_T| small), calibrated against Ji
   / lattice EMT decompositions [import].
8. **Equivariant determinant-parity zero-mode invariant: ADOPT AT
   GRADE C with the numeric kill FIRST.** Mechanism (odd cyclic
   sector + J U J^{-1} = U^{-1} pairing + det parity forces a +-1
   eigenvalue) is plausible but our V = 3 sectors are 2-dim (even), so
   the cross-sector pairing structure must carry the argument - the
   pre-registered kill probe (symmetric decoration, flipped det
   parity, no pinned eigenvalue?) is a 20-line oracle extension of
   `p1_zero_mode_locus_scan.py`; run it before formalizing K6/T1 via
   this route.
9. **Mass-value rail (ratios only; NuFIT-6.0 anchor): ADOPT.** Any
   proposal with a free scale, no refinement stability, or no
   radiative protection is a structural statement, not a prediction.
10. **C6 = finite-window quotient-resolvent convergence: ADOPT as the
    continuum lane's theorem class.** The Cornean et al. warning
    (naive discrete Dirac differences fail norm-resolvent convergence
    in d >= 2) lands in our favor: the palindromic/GW/Wilson-term
    ladder is the sanctioned structure. [import] anchors logged.
11. **E-slot Alt/Sym split + swap-invariance crux: ADOPT.** The exact
    trinity split holds iff the E-contraction commutes with the index
    swap; otherwise the pre-registered mixed-term weakening applies.
    Contorsion normalization + Pereira-Vargas / Schmidt-Kohler
    references adopted for K10.

## Module queue mapping (memo names -> tonight's targets)

1. `PenroseFiberRootHygiene.lean` -> K1-STEP0 (mandatory first).
2. `KreinQuotientDescent.lean` -> K3/C2a (+ torsor-invariance lemma).
3. `QCMultiPairStabilizedSquare.lean` -> K2 (stabilized L4).
4. `ClosureAreaDerivative.lean` -> K7/A2.
5. `FiniteBanksCasherCount.lean` -> K5.
6. `SignedMassBudgetExpectation.lean` -> K4 (signed regrade).
7. `EquivariantPinnedUnitEigenvalue.lean` -> K6 (after the kill probe).
8. `SolderingAltSymSplit.lean` -> K10/C7.

## Lit to ingest at P0 (dedup-check first)

math-ph/0605041 (Fernandez-Procacci); 1303.1199 (Asboth-Obuse);
2203.07826 (Cornean et al.); gr-qc/0208036 (Pereira-Vargas);
gr-qc/0103111 (Schmidt-Kohler); 2404.00240 (spectral continuity);
NuFIT-6.0 (JHEP 12 (2024) 216).

Claim boundary: this analysis adjudicates and wires the memo; findings
2 and 8 remain unproven diagnoses until their probes run; nothing here
is kernel-checked tonight-before-the-run.
