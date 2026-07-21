# P5 grounding: Furey 1910.08395 three-generation construction (verbatim extract)

Date: 2026-07-18. Plan: P5 route (b)
(`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`). Source: the
ACTUAL PDF (arXiv:1910.08395, "Three generations, two unbroken gauge
symmetries, and one eight-dimensional algebra", N. Furey, saved locally via
WebFetch + pdfplumber 2026-07-18; 10 pages). Design/scoping only - no theorem
claimed here.

## The construction (verbatim-grounded)

1. **Composition-operator semantics confirmed at source** (p. 3): "multiplication
   of left-action maps is given by the composition of maps. Of course, the
   composition of maps is associative, by definition." Eq (6):
   `e_i(e_j f) = -e_j(e_i f)` for `i != j`, `= -f` for `i = j`, for all
   `f in C(x)O`, `i,j = 1..6` - the Cl(6) Clifford relations AS MAPS. This is
   exactly the composition-operator resolution the kernel forced on item 2
   (`DixonWeakCARTau3` anti-Fock dictionary; `CompositionWeakLadders`). One
   infrastructure serves P1 AND P5.
2. **e7 redundancy** (eq 4): `e_7 f = e_1(e_2(e_3(e_4(e_5(e_6 f)))))` - the
   seventh unit is a DERIVED left-action map. Right multiplication is also
   expressible in left-action chains (eq 5):
   `f e_7 = (1/2)(e_1(e_3 f) + e_2(e_6 f) + e_4(e_5 f) - e_7 f)`.
3. **The 64-dim algebra**: left-action maps (3) = full `End_C(C(x)O)` = 64C-dim;
   Cl(6) realized inside it.
4. **Ladders** (eq 8-9, THIS paper's convention - differs from the repo's
   1806-lineage `LadderOperators`, bridge required):
   `alpha_1 = (-e_5 + i e_4)/2`, `alpha_2 = (-e_3 + i e_1)/2`,
   `alpha_3 = (-e_6 + i e_2)/2`, daggers with `i -> -i`, `e_j -> -e_j`, order
   reversed. CAR (7) holds AS MAPS.
5. **SU(3) + U(1)**: the g2 derivation generators (eq 2, via the associator
   `{a,b,c} = a(bc) - (ab)c`); the first eight Lambda_j generate the SU(3)
   holding `e_7` constant. `Q = (1/3) sum alpha_i-dag alpha_i` (eq 10) = number
   operator / 3.
6. **The two idempotent PAIRS** (the generation mechanism, sec V-VI):
   - `s = (1/2)(1 + i e_7)`: LEFT-multiplication idempotent; `s s* = s* s = 0`.
   - `S f = f (1/2)(1 + i e_7)`: the RIGHT-multiplication analogue, re-expressed
     as a left-action map (eq 15-16): `S = 1/2 + (1/4)(-i e_7 + i e_13 + i e_26
     + i e_45)` where `e_ab f = e_a(e_b f)`. `S S* = S* S = 0`, `[s, S] =
     [s, S*] = 0`.
   - Cl(6) splits into four sectors by (s|s*) x (S|S*).
7. **Rep content** (eq 12-13): `Cl(6)s -> 8 + 3 + (5 x 3*) + (6 x 1)` under
   `[i Lambda_j s, .]`; conjugate for `Cl(6)s*`.
8. **The 48 states** (eq 21): three generations x (u RGB, d RGB, nu, e-) as
   EXPLICIT elements, e.g.
   `u1_R = s S* (-i e_12 - e_16 + e_23 + i e_36) s S`,
   `nu_1 = s S (1 + i e_13 + i e_26 + i e_45) s S`,
   `e1- = s S* (i e_1 - e_3 + e_126 + e_145) s* S*`, etc. (full table in the
   PDF; generation index carried by the s/S sector pattern, NOT by replicating
   `C(x)O`: "we did not simply replicate copies").
9. **Charge operator** (eq 22): `Q = (1/3) s* S + (2/3) s S* + s* S*`
   (decomposition), acting via the commutator action (eq 19); eq 23 checks
   `Q u1_R = (2/3) u1_R`.

## Convention bridges REQUIRED before any Lean

- Octonion basis: this paper uses `e_1 e_2 = e_4` + index-doubling/cycling
  rules (eq 1), NOT the repo XOR convention. Every `e_a`, `e_ab`, `e_abc` in
  the state table must pass through `ConventionBridge`-style relabeling + sign
  correction. Do NOT transcribe raw.
- The alphas differ from repo `LadderOperators` (1806 lineage): repo alpha_1
  uses different units. Either bridge or define paper-local ladders.
- `dagger` here: `i -> -i`, `e_j -> -e_j`, order-reversing - same shape as the
  repo coStar + reversal; on composition operators reversal is composition
  reversal.

## Formalization plan (P5, staged)

- **Stage A (shared with item-2 infra):** composition-operator framework -
  left-mult nests, the four idempotent sector projectors `s, s*, S, S*` as
  operators, kernel checks: idempotency, orthogonality, commutation
  `[s, S] = 0`, and eq-4/5 (e_7 redundancy + right-mult re-expression - two
  crisp, surprising kernel identities).
- **Stage B:** the ladder CAR as maps (paper eq 7) - likely already close to
  the repo's landed operator lemmas modulo convention bridge.
- **Stage C:** `Q` eigenvalue checks on a FEW representative states (eq 23
  pattern): `u1_R` at `2/3`, `d1_R` at `-1/3`, `nu_1` at `0`, `e1-` at `-1` -
  one per charge class, kernel-computable as nested-literal evaluations.
- **Stage D (the P5 headline):** the generation count - the three `u`-triples
  (etc.) are linearly independent and exhaust the sector decomposition; the
  honest statement is the 48-state table with charges + the sector partition,
  NOT a claim that "three" is derived beyond this construction (the paper
  itself presents it as a demonstration).
- Kill/no-go: if the XOR-bridge signs cannot reproduce eq 21's charges, stop
  and re-derive the bridge (do not tune signs); record any failure verbatim.

## Status

Grounding note only. Zotero/Neo4j ingest of 1910.08395 pending (check
pre-add existence per MCP_SERVERS before adding). Stage A partially exists
already (`CompositionWeakLadders` - the hatOmega infrastructure).

## Lit cycle 2 addendum (2026-07-18, session lit pass)

Chunk-level pass over the successor papers (all in holdings) sharpens the
stage-B target and adds an honest-grading datum:

1. **Known doubling problem in the 1910.08395 identification.** 2209.13016
   ("One generation ... single copy of R (x) C (x) H (x) O", chunk 2) states
   explicitly that in the earlier three-generation papers (incl. 1910.08395)
   "we tend to find a seemingly unnecessary doubling of fermionic states. This
   is a problematic state of affairs." Any P5 stage-B claim built on the
   1910.08395 census MUST carry this caveat until the doubling is resolved on
   our carrier; the 2022 single-copy packaging is the fix the authors adopt.
2. **The Cl(8) left-multiplication route.** 2210.10126 (appendix, chunk 10):
   three generations + gauge + Higgs proposed to live in Cl(8) generated by
   the LEFT-MULTIPLICATION algebra of R(x)C(x)H(x)O (real slice Cl(0,8);
   16x16 hermitian Jordan subalgebra H16(C) reading). This is the natural
   successor target for our composition-operator machinery: the repo already
   kernel-realizes the Cl(6) colour sector as composition operators on the
   Dixon carrier; the Cl(8) extension (adding the H-side left-mults) is the
   formalizable stage-B brick, BEFORE any generation census.
3. Cross-check source for the C_8 generator layout: 2206.06912 chunk 10
   (2x2 hermitian L_a matrices, e_8 = 1 unit, L_beta* = -L_beta).

REVISED stage-B recommendation: formalize the Cl(8) CAR generation by the
Dixon left-multiplication operators (concrete kernel probes in the landed
composition style), and treat the three-generation census as stage C,
gated on resolving/pinning the doubling caveat against the 2022 papers.

## Stage-C design: the triality seed rho3 on the Dixon carrier
## (lit cycle 4, 2026-07-18; next Lean brick)

Gresnigt 2026 grounding (chunks, full text): the family S3 is the
sedenion-automorphism / Spin(8)-triality discrete group - order-3 rho_3 +
order-2 sigma, acting on the Cl(8) octonion basis, TRIVIALLY on the weak
Cl(2) factor, nontrivially on e9/e10 through the omega_8 pseudoscalar
(2601.07857 chunks 7, 13). Generations tie to the three canonical J2(O)
corners of J3(O) (chunk 3) - direct convergence with the landed P7
h3(O) spectral carrier.

KERNEL BRICK (design): on the XOR-basis octonions the classical order-3
automorphism candidate is INDEX DOUBLING i -> 2i mod 7
(c1->c2->c4->c1, c3->c6->c5->c3, c0,c7 fixed). Probes:
(a) `rho3 (x*y) = rho3 x * rho3 y` (automorphism; convention-sensitive on
    OUR Fano orientation - kernel decides, may need a sign-twisted variant);
(b) `rho3^3 = id`;
(c) rho3 fixes the head plane (c0/c7 fixed => vIdem/vIdemStar fixed) and
    PERMUTES the alpha-ladder colour pairs cyclically (alpha_1 -> alpha_2 ->
    alpha_3 up to phases - state the exact kernel-found phases).

PRE-REGISTERED INTERPRETATION QUESTION (do not conflate): on OUR
single-generation carrier this rho3 permutes the COLOUR ladder index;
Gresnigt's S3 permutes GENERATIONS (their Cl(8) slots carry different
assignments). Whether the two readings are related by the Cl(8)
left-multiplication re-packaging (2210.10126 appendix) is exactly the
stage-B/stage-C bridge question - record kernel facts first, interpret
second.
