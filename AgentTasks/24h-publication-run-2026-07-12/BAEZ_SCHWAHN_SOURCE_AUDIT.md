# Baez-Schwahn 2026 primary-source audit (Fable, 24h run startup)

Source: J. C. Baez and P. Schwahn, "The Standard Model Gauge Group from
the Exceptional Jordan Algebra", arXiv:2606.15235 (math-ph), submitted
2026-06-13. Verified via arXiv abstract page and the arXiv HTML full
text on 2026-07-11 (two targeted extraction passes). Zotero/Neo4j
ingest queued. Grade: external `T` statements; nothing below is a
repository (`M`) result unless explicitly marked.

## Exact statements (as extracted from the HTML full text)

- **Theorem 1.** If X, B are Jordan subalgebras of h3(O) with
  X ~= h2(C), B ~= h3(C), X subset B, then
  `Stab(X) cap Stab(B)_0 ~= S(U(2) x U(3))`.
- **Theorem 2.** If A, B are Jordan subalgebras with A ~= h2(O),
  B ~= h3(C), A cap B ~= h2(C), then
  `Stab(A) cap Stab(B)_0 ~= S(U(2) x U(3))`.
- **Lemma 4.** For the concrete Equation-(1) pair (below),
  `Stab(A) cap Stab(B)_0 = S(U(2) x U(3))`; this REPROVES the
  Dubois-Violette--Todorov special case. Also established there:
  `Stab(B)_0 ~= (SU(3) x SU(3))/Z3`, and Stab(B) is NOT connected -
  the second component acts by antiunitary maps `X -> U X U^{-1}`
  (complex conjugation type). Yokota is cited for Stab(B)_0 not being
  maximal in F4.
- **Lemma 5.** F4 acts transitively on Jordan frames of h3(O);
  the frame stabilizer is Spin(8).
- **Lemma 6.** F4 acts transitively on subalgebras B ~= h3(C).
- **Lemma 11.** F4 acts transitively on pairs (A, B) with A ~= h2(O),
  B ~= h3(C), A cap B ~= h2(C).
- **Equation (1) concrete pair:** A = upper-left 2x2 octonionic block
  (h2(O) in the 3x3 matrix, third row/column zero); B = h3(C) embedded
  entrywise via the chosen C subset O.
- **Proof shape of Theorem 1:** inside
  Stab(B)_0 = (SU(3) x SU(3))/Z3, acting on
  h3(O) = h3(C) (+) M3(C) (complement identified with 3x3 complex
  matrices), the X-stabilizer selects S(U(2) x U(1)) inside the FIRST
  SU(3) (conjugation action on the ordinary qutrit B), while the SECOND
  SU(3) (octonionic automorphisms preserving C subset O) is unimpeded:
  `(S(U(2) x U(1)) x SU(3))/Z3 ~= S(U(2) x U(3))`.
- **Attribution/novelty (their own framing):** the choice-INDEPENDENCE
  is the new content ("every other choice can be mapped to this
  standard choice using the action of F4... not an artifact of a
  specific choice"); Theorems 1-2 are presented as new, with Lemma 4
  the DVT special case.

## Convention gaps to carry into any use

1. **Identity component subscript is load-bearing**: the theorem
   intersects with `Stab(B)_0`, not `Stab(B)`. Dropping the subscript
   adds the antiunitary component and BREAKS the statement. Any
   manuscript sentence must preserve it.
2. The acting group is the COMPACT F4 = Aut(h3(O)) (automorphism group
   of the Albert algebra); no noncompact form appears.
3. No basis/orientation convention is fixed; everything is intrinsic
   with Jordan frames/Peirce decompositions as reference. Mapping to
   the project's XOR octonion convention is OUR obligation (via
   ConventionBridge) whenever coordinates are used.

## Exact mapping to repository formalizations (the audit's payoff)

- Our `Jordan.DVTFullStabilizerCharacterization` +
  `DVTTwoSidedActionKernelZ3Iff` + `DVTTwoSidedStabilizerMoonshot`
  (kernel-checked): the two-sided `(SU(3) x SU(3)^op)/Z3` action on the
  complement of h3(C), faithful, with image exactly
  {X -> AXB : det A = det B = 1}. This is a COORDINATE MODEL of the
  restriction of their `Stab(B)_0` to the complement (their
  "SU(3) acts on the off-diagonal block structure" step), including
  the exact Z3 arithmetic. NOT formalized: that this group is all of
  Stab(B)_0 as a subgroup of F4 (needs F4 itself).
- Our `Octonion.G2AutomorphismSU3Exactness` (kernel-checked): the
  algebraic `Aut_{e111}(O) ~=* SU(3)` equivalence. This is their SECOND
  SU(3) factor (automorphisms preserving C subset O), verified at the
  octonion-automorphism level.
- Consequence for the Jordan-Clifford bridge manuscript: both factors
  in the Baez-Schwahn proof of Theorem 1 have kernel-checked coordinate
  avatars in the repository; the EXTERNAL (`T`) content we rely on is
  exactly (i) Stab(B)_0 = that group inside F4, (ii) the F4
  transitivity lemmas (5, 6, 11), (iii) the intersection computation of
  Theorem 1. This is the precise, honest sentence structure for the
  manuscript recast: coordinate layers `M`, flag/stabilizer layer `T`
  with theorem numbers, master composition open.
- The S(U(2) x U(1))-inside-first-SU(3) step is a small, plausibly
  kernel-checkable coordinate statement (stabilizer of the h2(C) block
  under conjugation) - candidate first NEW rung for JC1 item 4.

## Manuscript consequences (to execute in the recast)

1. Cite as: J. C. Baez, P. Schwahn, arXiv:2606.15235 (2026), Theorems
   1-2, Lemmas 4-6, 11 - with the identity-component subscript stated.
2. Replace the manuscript's current "does not prove the full DVT
   stabilizer-intersection theorem" boundary with the sharper
   three-part boundary above (what is M, what is T, what is open).
3. The "shared bridge" section upgrades from analogy to architecture:
   one flag, two kernel-checked coordinate factors, one external
   glue theorem with numbers.
