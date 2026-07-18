# Design note: S2b - derive weak isospin W±/T3 from the octonion alpha_i ladder

Author: claude. Date: 2026-07-17. Work item: SM-branch foundation (Furey
electroweak). Status: DESIGN / scoping only - no theorem claimed. This
isolates the single precise remaining electroweak gap identified by the
derivation map (`Sources/Null_Edge_Derivation_Map_SM_GR_2026-07-17.md`, node
S2b) and by the repo's own claim boundaries, and gives a concrete,
uniqueness-anchored path to closing it.

> **Convention reference (READ FIRST):**
> `Sources/Dixon_CxHxO_Convention_Reference.md` is the authoritative doc for the
> `C(x)H(x)O` conventions this note relies on - the `H`-units vs octonion units
> (a separate triple, the most costly error source), the left/right/bar actions,
> the XOR octonion basis, and the operator-vs-element CAR distinction. Consult it
> before touching the weak sector.

## The gap (repo-flagged, verbatim)

- `ElectroweakBridge`: "the weak-isospin values `targetT3` ... are not derived
  here from the Furey ladder algebra."
- `ElectroweakCompletePackage` claim boundary: "does not derive the SU(2)_L
  algebra from the octonionic ladder operators - the W± operators are defined
  by explicit permutation maps on the basis states, not constructed from
  `alpha_i` ladder operators."
- `WeakIsospinLadderDerived` re-derives W± by ket-bra spectral decomposition
  on the abstract `JbarWavefunction` basis and proves UNIQUENESS, but still
  not from the octonion `alpha_i`.

So one generation's electroweak quantum numbers (Q, T3, Y, Gell-Mann-Nishijima,
W± su(2) relations, SU(2)^2-U(1)_Y anomaly cancellation) are DERIVED as
operators, but the ORIGIN of W±/T3 in the octonion ladder is supplied. Closing
S2b turns the last supplied electroweak tables into theorems, leaving only the
octonion algebra itself supplied on the SM branch.

## The uniqueness handle (why this is now tractable)

`WeakIsospinLadderDerived.TPlusEnd_unique` (and `TMinusEnd_unique`): any
continuous-linear endomorphism `T` of `JbarWavefunction` satisfying

1. `[T3End, T] = T`  (weak-isospin raising),
2. `[YEnd, T] = 0`   (hypercharge-neutral),
3. the correct action on the four `T3 = -1/2` basis states,

MUST equal `TPlusEnd`. Therefore S2b does NOT require rebuilding W± from
scratch. It requires:

- (a) define a candidate `TPlusLadder` as an explicit combination of the
  octonion `alpha_i` ladder operators (`Furey.LadderOperators`) acting through
  the `ComplexOctonion <-> JbarWavefunction` identification
  (`Furey.MinimalLeftIdeal` / `JbarActionTable`);
- (b) prove `TPlusLadder` satisfies hypotheses 1-3;
- (c) conclude `TPlusLadder = TPlusEnd` by `TPlusEnd_unique`.

Then T3's eigenvalues follow: T3 = (1/2)[T+, T-]-normalized Cartan, so once W±
are ladder-derived, `T3End`'s supplied table becomes a computed commutator
eigenvalue - S2b closes both flagged gaps at once.

## CORRECTION (2026-07-17): su(2)_L is beyond Cl(6) - the target is a NEW sector

An earlier draft of this note proposed building W± from `alpha_i^dagger alpha_j`
combinations WITHIN the `C(x)O` (Cl(6)) algebra. That is WRONG, and the repo
says so explicitly (`AnomalyBridge` open task 2): "weak isospin requires SU(2)_L
structure BEYOND Cl(6) ... the SU(2)_L doublet/singlet assignments need
additional algebraic input." Within Cl(6) the `alpha_i` ladder generates only
`su(3)_c (+) u(1)_em`; the `alpha_i^dagger alpha_j` products live in that
algebra and cannot produce a NEW su(2). So S2b is NOT a re-expression of
existing operators - it requires building the additional algebraic input that
Furey supplies from the QUATERNIONIC factor `C(x)H` (her `R(x)C(x)H(x)O`
program: `C(x)H` gives the Lorentz reps and, in the combined leptonic subspace,
su(2)_L acting only on left-handed states).

## CORRECTION 2 (2026-07-17, from the ACTUAL 1806.00612 PDF via WebFetch+pdfplumber)

The earlier "EXACT construction" section below CONFLATED 1806.00612 (the
SU(3)xSU(2)xU(1) paper) with the SU(5)/Cl(10) construction (Furey-Hughes
2409.17948). The garbled Neo4j OCR caused the error. The clean PDF gives the
FAITHFUL 1806.00612 Section 5 construction (verbatim, eqs 29-36):

- The WEAK sector is `Cl(4) = Cl(2) (x)_C Cl(2)` from the RIGHT actions: one
  Cl(2) is CHIRALITY (transitions L<->R on Psi_L+Psi_R), the other is ISOSPIN
  (up<->down on Su+Sd). NOT `B_j = i e_7 | beta_j` (that was the wrong SU(5) form).
- Cl(4) generators (eq 29): `{tau_1 i_2, tau_2 i_2, tau_3 i_2, i_2}` with
  `tau_1 = omega + omega_dag, tau_2 = i*omega - i*omega_dag,
  tau_3 = omega*omega_dag - omega_dag*omega` (omega = a_1 a_2 a_3 from Cl(6)).
- beta ladders (eq 30): `beta_1 = (1/2)(-e_2 + i e_1 tau_1)`, `beta_2 = omega_dag i e_1`;
  the dagger `‡` maps `i->-i, e_j->-e_j (j=1,2,3), e_k->-e_k (k=1..7)` and reverses
  multiplication order. CAR (eq 31): `{beta_i, beta_j‡} = delta_ij`, i,j=1,2 - a
  genuine TWO-mode Cl(4).
- Leptonic minimal right ideal (eq 32): `L = v_w Cl(4)`, vacuum
  `v_w = beta_1‡ beta_2‡ beta_2 beta_1`, and
  `L = V_R v_w + V_L v_w beta_1‡ + E-_L v_w beta_2‡ + E-_R v_w beta_1‡ beta_2‡`.
  So the four leptonic states are `V_R (vacuum), V_L (beta_1‡), E-_L (beta_2‡),
  E-_R (beta_1‡ beta_2‡)`.
- su(2)_L (eq 35): `T_j = tau_j (1/2)(1 + i_3)` - the `(1/2)(1+i_3)` is a CHIRALITY
  PROJECTOR (i_3 squares to +1), which is WHY su(2)_L acts on left-handed states
  only "without imposing a chiral projector by hand" (Fig 4).
- Decomposition (eq 36): `L ~ 1 (+) 2 (+) 1` under su(2)_L.

KEY CONSEQUENCE: eq 32/36 EXACTLY matches the landed
`PhysicsSM/Draft/NullEdge/WeakIsospinRepContent.lean` `1(+)2(+)1`. The state
map is `V_R=|00>, V_L=|10>, E-_L=|01>, E-_R=|11>`, so the DOUBLET `(V_L,E-_L)` is
LEFT-handed and the SINGLETS `(V_R,E-_R)` are RIGHT-handed. This is the faithful
identification that CLOSES item 1's open remainder ("RH fermions are su(2)_L
singlets"): the landed singlet states ARE V_R, E-_R (right-handed), the doublet
IS V_L, E-_L (left-handed). And `Cl(6)(x)_C Cl(4) = Cl(10)` (Section 6) is where
the SU(5)-shaped combination lives - reconciling the two papers.

Faithful next build (brick 2/3, now correctly grounded): the CHIRALITY PROJECTOR
`P = (1/2)(1+i_3)` and `T_j = tau_j P`, showing su(2)_L annihilates the
right-handed (`1-P`) states - the "no projector by hand" mechanism, connecting to
the landed `ChiralityFromActionSplit` (left action = chirality, right = isospin).

## The EXACT construction (extracted from Furey 1806.00612 full text, 2026-07-17)
### [SUPERSEDED by CORRECTION 2 above - this section conflated the SU(5) paper]

Full-text study done (PDF extracted, EPJC 78 (2018) 375). The construction is
SU(5)-GUT-shaped: ten Cl(10) ladder operators generate SU(5), and one
generation is `1 (+) 5* (+) 10` of SU(5), with `SU(3)_C x SU(2)_L x U(1)_Y / Z6
subset SU(5)`. The ten ladders (her eq. 37) split into COLOUR (octonionic) and
WEAK (quaternionic):

```text
colour:  A_i = a_i | I        (i=1,2,3; a_i the C(x)O octonion ladders)  [in repo]
weak:    B_1 = i e_7 | beta_1,  B_2 = i e_7 | beta_2                      [MISSING]
         (beta_j the C(x)H QUATERNIONIC ladder operators; e_7 the octonion twist)
plus the six/four adjoints A_i^dagger, B_j^dagger.
```

The su(2)_L generators (her eq. 42), acting on the minimal left ideal:

```text
T_1 = B_1^dagger B_2 + B_2^dagger B_1
T_2 = i (B_2^dagger B_1 - B_1^dagger B_2)
T_3 = B_1^dagger B_1 - B_2^dagger B_2
```

(standard two-mode Cartan-Weyl; T_3 the Cartan, T_1 +- i T_2 the raising/
lowering). These "generate SU(2)_L when applied to the ideal." Weak
hypercharge Y is the remaining U(1) number-operator combination (her sec. 6.3;
the `(x U(1)_X)` is the extra SU(5) charge if U(2) is taken instead of SU(2)).

CHIRALITY (why SU(2)_L is left-handed, her sec. 5.3 + 6): the beta-ladders
build a pair of minimal ideals `L` and `gamma^0 Lbar`; the su(2)_L acts on the
LEFT ideal only, and the algebra "blocks certain transitions under the
assumption that conceptually distinct algebraic actions do not mix" (left
action = chirality, right action = isospin). No chiral projector is imposed by
hand - the left-handedness is structural.

## Consequence for the repo: S2b needs the C(x)H beta-ladder sector

The repo has the octonion `a_i` (= A_i) but NOT the quaternionic `beta_j`
ladders or the `B_j = i e_7 | beta_j` weak ladders. So S2b's concrete build is:

1. Build the `C(x)H` quaternionic ladder sector: `beta_1, beta_2` with their
   CAR relations (Mathlib `Quaternion R` tensored with C, `~ M(2,C)` - the SAME
   `M(2,C)` as the soldering / SL(2,C) module, a unification; the spin
   idempotent `v_s = alpha_s alpha_s^dagger` of Cl(2) gives the Weyl/Lorentz
   rep, matching the landed `SL2CLorentzAction`).
2. Define `B_j = i e_7 | beta_j` (the octonionic twist linking the C(x)H and
   C(x)O sectors) as operators on the combined `C(x)O` state space.
3. Define `T_1, T_2, T_3` per eq. 42, prove the su(2) commutators, and prove
   the `T_3` eigenvalues on the Jbar/leptonic states equal the supplied
   `targetT3` table - then close via the `WeakIsospinLadderDerived` uniqueness
   handle (`TPlusEnd_unique`) to identify `T_+ = T_1 + i T_2` with `TPlusEnd`.
4. Formalize the left-ideal chirality blocking (sec. 5.3) for the L/R
   asymmetry, or scope it as a separate follow-up.

This is now a FAITHFUL, formalization-ready spec (not a fabrication).
Convention guard: XOR-basis octonions (e_7 -> the repo's XOR label; alpha vs
Furey's a_i already bridged in `Furey.Basic`); the beta_j need their own
convention record. Provenance: Furey, EPJC 78 (2018) 375, arXiv:1806.00612,
full text extracted 2026-07-17 [comp for the construction; orig for the
formalization].

## Deeper grounding (2026-07-17 chunk search): the eq-38 ideal basis

Furey 1806.00612 eq. 38 (arXiv chunk 14) gives the ONE-GENERATION minimal left
ideal explicitly as `Cl(10)`-ladder monomials on the vacuum `v_t` (OCR, verify
against PDF; `A‡_i` = colour creation i=1,2,3, `B‡_1, B‡_2` = weak creation):

```text
S = Cl(10) v_t =
    V_R v_t                                  (nu_R, the vacuum/formal RH neutrino)
  + Dbar^L_i  A‡_i v_t
  + V_L       B‡_1 v_t                        (nu_L)
  + E-_L      B‡_2 v_t                        (e_L)   <- weak doublet (V_L,E-_L)
  + U^k_R eps_ijk A‡_j A‡_i v_t
  + Dbar^R_i  A‡_i B‡_1 v_t
  + Ubar^R_i  A‡_i B‡_2 v_t
  + E-_R      B‡_2 B‡_1 v_t
  + E+_L      A‡_3 A‡_2 A‡_1 v_t
  + U^k_L eps_ijk B‡_1 A‡_j A‡_i v_t          (u_L)   <- weak doublet with D^k_L
  + D^k_L eps_ijk B‡_2 A‡_j A‡_i v_t          (d_L)
  + Ubar^L_i  B‡_2 B‡_1 A‡_i v_t
  + E+_R      A‡_3 A‡_2 A‡_1 B‡_1 v_t
  + Vbar_R    A‡_3 A‡_2 A‡_1 B‡_2 v_t
  + D^k_R eps_ijk B‡_2 B‡_1 A‡_j A‡_i v_t ...
```

This is the EXACT state <-> ladder-monomial dictionary. The weak doublets are the
`B‡_1 <-> B‡_2` pairs at fixed `A‡` content: `(V_L, E-_L) = (B‡_1, B‡_2) v_t`;
`(u_L, d_L) = (B‡_1, B‡_2) x [A‡A‡]`. So the weak raising `T_+` swaps
`B‡_2 -> B‡_1` at fixed colour content - i.e. `T_+ ~ B‡_1 B_2` (create weak-1,
annihilate weak-2), which is exactly Furey eq. 42's `T_+ = B_1^dagger B_2`
restricted to the ideal. This is the concrete handle: the repo's Jbar carries the
`A‡` (colour) structure; adding `B‡_1, B‡_2` per eq. 38 realizes the weak sector
on the SAME states, and `T_+ = B‡_1 B_2` then acts by the doublet swap the
uniqueness handle expects (`e -> nu`, `d -> u`).

Chirality confirmation (chunk 13, verbatim gist): "the SU(2) symmetries of our
ladder operators are found to act automatically on lepton states of only a single
chirality ... without the need to impose a chiral projector by hand" - so the
left-handedness is structural (brick 3 / item 1), matching the landed
`ChiralityFromActionSplit` associativity mechanism.

Still not made explicit in the readable OCR: the `beta_j` quaternionic ladders in
terms of `C(x)H` units. But eq. 38 shows the `B‡` ACTION on the ideal directly,
which (with the repo's `JbarActionTable` for the `A‡` side) may suffice to build
`T_+` without the raw `beta_j` - a promising route for the item-2 re-submission if
Aristotle 661e5230 returns a no-go.

## Aristotle 661e5230 return (2026-07-17): NO-GO confirmed, substrate gap sharpened

Aristotle attempted the closure and returned a documented NO-GO (verbatim gist):
the current Furey substrate has `ComplexOctonion` + the three `Cl(6)` alpha
ladders + the 8-dim `Jbar'` ideal, but does NOT contain the quaternionic factor,
`beta_1, beta_2`, their dagger, or a `C(x)H(x)O` action on `Jbar'`. So `B_1^dag
B_2` cannot be stated faithfully in the present API, and substituting a ket-bra /
8x8 matrix / arbitrary `Cl(6)` polynomial would erase the quaternionic provenance
(a false-shape result). Aristotle correctly REFUSED to give false-shape defs.
This confirms the design-note analysis: item 2's positive construction is blocked
on first BUILDING the `C(x)H` (Dixon) substrate (brick 2), then `beta_j`, `B_j`,
and the restricted-ideal transport (brick 4).

Well-posed obstruction SUB-TARGET (Aristotle stated it but left it `s o r r y`;
a future focused job or hand proof): NO single `ComplexOctonion` left-multiplier
`a` realizes the four raisings on the corrected basis -

```text
¬ ∃ a : ComplexOctonion,
  a * JbarBasisState' 7 = JbarBasisState' 0 ∧ a * JbarBasisState' 1 = JbarBasisState' 4 ∧
  a * JbarBasisState' 2 = JbarBasisState' 5 ∧ a * JbarBasisState' 3 = JbarBasisState' 6
```

(This rules out the `e111`-twist shortcut and rigorously forces the quaternionic
factor. NB: the norm/composition argument does NOT give it - all basis states
share a complex-norm - so the obstruction is a genuine linear-algebra
inconsistency, non-trivial to prove.) Returned file preserved under
`AgentTasks/aristotle-downloads/weak-isospin-661e5230.tar`; NOT integrated (has a
`s o r r y`, and belongs in `Cl(6)` = trusted Furey territory).

## CORRECTION 3 (2026-07-17): the CAR needs the RIGHT/bar action, not left mult

Built the faithful eq-30 beta ladders as concrete `ComplexOctonion` elements
(`PhysicsSM/Draft/NullEdge/WeakBetaLaddersFromColor.lean`: omega, tau_j, beta_1,
beta_2 from the repo alpha_i) and submitted the CAR to Aristotle (2f3fd545).
RESULT (kernel-proven, integrated): the LEFT-multiplication CAR FAILS -
`{beta_1, beta_2}_left = -1/2 * Id != 0` (`beta12_left_action_anticommutator`).

Sharpened diagnosis: Furey's Cl(4) weak sector is the RIGHT action / the `x|y`
bar operator (`x|y . z = x z y`, eqs 13/29), NOT left multiplication (which the
repo's `JbarActionTable` and my beta defs use). This matches the landed
`ChiralityFromActionSplit` (left = chirality, right = isospin - "conceptually
distinct actions do not mix"). The `-1/2 * Id` scalar is the fingerprint that
under LEFT mult `beta_2` behaves like a dagger of `beta_1`. So the genuine next
step is to build the beta ladders as RIGHT/bar-operator actions on the ideal
(and confirm the `H`-triple units `i_1,i_2,i_3` in the XOR convention from the
soldering / SL2CLorentz C(x)H sector), then re-check the CAR and close
`T_+ = TPlusEnd`. The left-action route is kernel-proven to fail.

## CORRECTION 4 (2026-07-17): item 2 genuinely needs the C(x)H(x)O Dixon algebra

Re-read eq. 13 (the C(x)H Dirac matrices) against eq. 30 in the actual PDF. The
units written with the special glyph in eqs 29/30 are Furey's H-QUATERNION units
`i_1, i_2, i_3` of a SEPARATE tensor factor (they square to -1; the Dirac
matrices are bar operators `1|i_1, i_1|i_2, ...`), NOT octonion units `e_1=c1,
e_2=c2`. Since `tau_j = omega + omega-dag` is in `C(x)O` (colour), the ladder
`beta_1 = (1/2)(-i_2 + i i_1 tau_1)` combines an H unit with a `C(x)O` element, so
it lives in `C(x)H(x)O` (the full Dixon algebra), NOT `C(x)O`.

HONEST CORRECTION of my own earlier claim: I wrote (CORRECTION 2/3 and the ledger)
that the beta's are "`C(x)O`-constructible" and that the original Aristotle no-go
(661e5230) had the wrong premise. THAT WAS WRONG. The no-go was RIGHT: the repo
substrate (`ComplexOctonion` = C(x)O) genuinely LACKS the `C(x)H` factor. My
`WeakBetaLaddersFromColor` beta's (using octonion c1,c2 for the H units) are the
wrong algebra, which is exactly why the CAR fails as `-1/2` (kernel-proven).

So item 2's genuine missing build IS the `C(x)H(x)O` Dixon algebra: tensor the
`C(x)H` Lorentz/weak factor (biquaternions ~ M(2,C), the soldering algebra) with
the `C(x)O` colour factor, define the beta's there (H units i_1,i_2 (x) colour
tau_j), and use the LEFT/RIGHT actions (the landed `DixonLeftRightAction` framework
is the generic scaffolding, but must act on `C(x)H(x)O`, not `C(x)O`). This is a
substantial multi-session build - the "one substantial missing build" the spine
names. The chirality-projector and 1(+)2(+)1 results (landed) remain correct
(they are the abstract su(2)_L shadow); it is the CONCRETE octonionic realization
that needs the Dixon algebra.

## CORRECTION 5 (2026-07-17): the C(x)H(x)O substrate is now BUILT; the CAR is an operator-on-ideal relation

The Dixon substrate CORRECTION 4 called for is now built and kernel-checked -
`PhysicsSM/Draft/NullEdge/DixonAlgebra.lean` (sorry-free, 3 axiom guards):

- `Dixon` = `H`-valued-over-`ComplexOctonion` (a 4-tuple of `ComplexOctonion`
  `x_0 + x_1 i_1 + x_2 i_2 + x_3 i_3`), Hamilton product with `C(x)O` coefficients.
- Verified `H`-relations `i_j^2 = -1`, `i_1 i_2 = i_3` (+ cyclic).
- `ofColour_comm_i_j`: the `H`-units COMMUTE with the whole colour factor - this
  is the tensor-product structure, what makes it genuinely `C(x)H(x)O`.
- PAYOFF `i1_i2_anticomm`: `{i_j, i_k} = 0` (j != k). The `H`-units ANTICOMMUTE -
  the fermionic Clifford structure the colour factor alone could not supply.

The faithful eq-30 ladders + the `‡` are built on it -
`PhysicsSM/Draft/NullEdge/DixonWeakLadders.lean` (sorry-free, guarded):
`betaH1 = (1/2)(-i_2 + i i_1 tau_1)`, `betaH2 = omega‡ i i_1`, and
`conjH` = the element `‡` (`coStar` each colour coefficient + negate the three
`H`-slots; equals the order-reversing anti-automorphism on elements because each
`x_k i_k` term has a single `H`-unit commuting with its colour coefficient).

HONEST KERNEL FINDING (`betaH_like_anticomm_ne_zero`): the element like-CAR
`{beta_1, beta_2}` is NONZERO. Hand-analysis, kernel-checked at one coordinate:

  `{beta_1, beta_2} = (1/2)[ (I omega‡)i_3 + tau_1 omega‡
                            - (I omega‡)i_3 + omega‡ tau_1 ]  =  (1/2){tau_1, omega‡}.`

The `H`-unit `i_3` cross-terms CANCEL (the `{i_1,i_2}=0` payoff working). The
surviving `(1/2){tau_1, omega‡} = (1/2){omega, omega‡}` (`(omega‡)^2 = 0`), and in
the CONCRETE `C(x)O` realization `omega omega‡` and `omega‡ omega` are the two
COMPLEMENTARY idempotents `(1 - i e_111)/2` and `(1 + i e_111)/2` (repo
`MinimalLeftIdeal.omega`) which SUM TO 1, so `{omega,omega‡} = 1` and
`{beta_1,beta_2} = 1/2`.

**INTERPRETATION CORRECTED (self-caught over-claim; supersedes an "operator-on-
ideal" reading first written here).** Because `{omega,omega‡} = 1` (NOT a rank-2
projector - I first wrote `P_000+P_111`, wrong in this realization) AND the repo
proves the COLOUR ladder CAR at the ELEMENT level (`LadderOperators`:
`alpha_i alpha_j‡ + alpha_j‡ alpha_i = delta_ij` as `C(x)O` elements, kernel), an
element-level CAR IS achievable in this algebra. So a nonzero element
`{beta_1,beta_2}` does NOT establish "operator-on-ideal"; it establishes that these
ELEMENT `beta`'s are not Furey's intended objects. Furey's `beta`'s are
BAR/RIGHT-ACTION OPERATORS (eq. 13: the `C(x)H` Dirac matrices are bar operators
`1|i_1`, `i_1|i_2`, ...); eq-31 is an anticommutator of OPERATORS, which the Dixon
element product does not model.

**Exact operator prescription now grounded (eq. 13, PDF p.5).** Furey's Dirac
generators are BAR operators: `gamma^0 = 1|i_1`, `gamma^1 = i_1|i_2`,
`gamma^2 = i_2|i_2`, `gamma^3 = i_3|i_2`, where **the bar operator `x|y` acts on `z`
by `(x|y) z = x z y`** (`x,y,z in C(x)H`; two-sided). Semantics (p.4-5): LEFT
multiplication rotates SPIN states, RIGHT multiplication rotates CHIRALITIES; and
(p.8) the weak `Cl(4)` is two RIGHT actions (chirality on `C(x)H`, isospin on
`C(x)O`). States are minimal left ideals `Psi = Cl(2n) v` on an idempotent vacuum
`v` (eq. 8), so `z = 1` is NOT a physical state.

**Genuinely open (I flip-flopped in prose - let the kernel/Aristotle decide, do not
prose-argue it further).** The one CERTAIN fact is the kernel one: the ELEMENT
product is not the model (`{beta_1,beta_2}_element = 1/2 != 0`). Two live operator
readings remain, and eq. 13 + the ideal/state construction keep BOTH open:
  (A) RIGHT-action operators `R_{beta}(z) = z beta` restricted to the ideal STATES
      (`z=1 not in ideal`, so the `1/2` is irrelevant) - matches "right action" +
      the `Psi = Cl(2n) v` state construction;
  (B) BAR operators `(x|y) z = x z y` on all of `C(x)H(x)O` - matches eq. 13's
      explicit `x|y` Dirac generators; here `(x|y) 1 = x y != ` element product, so
      `1/2` is again not an obstruction.
An earlier version of this note wrongly ASSERTED (B) and "NOT an ideal restriction";
that was an over-correction. **Sharpened target (Aristotle):** determine which of
(A)/(B) is Furey's realization and prove the eq-31 `Cl(4)` CAR for it, then close
`T_+ = TPlusEnd` via `WeakIsospinLadderDerived.TPlusEnd_unique`. Landed scaffolding:
the Dixon substrate, the faithful eq-30 element `beta`-data, the `DixonLeftRightAction`
`Rmul`/`bar` framework, and the honest kernel finding.

(Landed tools that will help, `MinimalLeftIdeal.lean`: the colour idempotent
`omega=(1-i e_111)/2` with `omega*omega=omega`, `alpha_i_dag_kills_omega`, and the
ideal-membership `v_i*omega=v_i`. These are the colour-sector Fock structure; the
weak sector is the analogous construction one tensor slot up.)

## The S2b brick roadmap (buildable sequence)

- **Brick 1 - abstract su(2)_L algebra [SUBMITTED 2026-07-17, Aristotle
  64e5ad32].** su(2)_L from two fermionic ladder modes (Cl(4)): CAR, the su(2)
  brackets (eq. 42), the ladders, and `T_3 = diag(0,1,-1,0)` - the weak-isospin
  doublet at `+-1/2`. Standalone `weak-isospin-two-mode-su2-20260717`, all
  verified numerically. This is the reusable OPERATOR ALGEBRA.
- **Brick 2 - the C(x)H spin/chirality sector (Cl(2)).** ℂ⊗ℍ gives "spin and
  chirality" (Furey sec. 3): the Weyl/Lorentz rep + the chirality idempotent
  `v_t`. This is the SAME `M(2,C)` as the landed soldering / `SL2CLorentzAction`
  module (unification), so brick 2 largely EXISTS - it needs the `v_t`
  chirality idempotent and the `omega, omega^dagger` Cl(2) ladder wrapper.
- **Brick 3 - the chirality mechanism [the hard, distinctive part].** Furey's
  key novelty (secs. 5-6): the RIGHT action of `omega, omega^dagger` on
  `Psi_L + Psi_R` induces CHIRALITY transitions, while the right action on
  `Su + Sd` induces ISOSPIN transitions; su(2)_L (LEFT isospin action) then
  acts on left-handed states only, with NO chiral projector imposed by hand,
  because "conceptually distinct algebraic actions do not mix." Formalizing
  this needs the full C(x)O left/right-action distinction + `v_t`; it is a
  genuine multi-step target, not a quick brick.
- **Brick 4 - the SM realization + closure.** `B_j = i e_7 | beta_j` linking
  the C(x)H and C(x)O sectors; prove the `T_3` eigenvalues on the actual Jbar
  doublet states match `targetT3`; close via `WeakIsospinLadderDerived.
  TPlusEnd_unique` to identify the ladder-derived `T_+` with the landed
  `TPlusEnd`. This turns the repo's supplied `W±`/`T_3` tables into theorems.

Net: bricks 1 (submitted), 2 (mostly landed as the soldering M(2,C)), and 4
(uniqueness-anchored) are tractable; brick 3 (chirality-from-action-blocking)
is the deep remaining challenge and the true heart of "why the weak force is
left-handed." Doing all four DERIVES one generation's weak isospin from the
division-algebra ladder operators, leaving only the octonion+quaternion
algebra itself supplied.

Prerequisites to read/confirm before pinning statements: `LadderOperators`
(alpha_i, CAR relations `{alpha_i, alpha_i^dagger} = 1`, nilpotency),
`OperatorAlgebra` (the `EqOnJ` framework, `H_ij_op` color operators - the
su(3) analog to mirror), `MinimalLeftIdeal` / `JbarActionTable` (the
`ComplexOctonion -> Fin 8` state identification), `QuantumNumbers`.

## Convention guards (AGENTS.md)

- XOR-basis octonions, NOT Furey/Baez verbatim; any product formula from
  1806.00612 must pass through `Octonion.ConventionBridge`. Furey's
  `alpha_1 = (-e5 + i e4)/2` is `(+e100 + i e011)/2` here (per `Furey.Basic`);
  sign/relabel every ladder product.
- The safe object is a module / minimal left ideal for the ASSOCIATIVE
  left-action algebra generated by complex-octonion left multiplications, not
  "minimal left ideals of the complex octonions" unqualified. Compose linear
  maps; do not multiply raw octonions unparenthesized.

## Deliverable shape (next focused session or Aristotle package)

A trusted module `WeakIsospinFromLadder.lean` with:
`TPlusLadder`/`TMinusLadder` (alpha_i combinations), the three uniqueness-
hypothesis lemmas, the equalities `TPlusLadder = TPlusEnd` /
`TMinusLadder = TMinusEnd` (via the uniqueness theorems), and the derived
`T3` eigenvalue theorem. Grade `M [orig formalization; comp: Furey 1806.00612]`.
This is Aristotle-suitable once (a)'s combination is pinned by hand + numeric
check; the uniqueness handle keeps the proof obligation finite and local.

## Why S2b is the right next SM foundation

It is the single highest-leverage unbuilt SM node: algebraic, kernel-checkable,
repo-flagged, uniqueness-anchored, and it converts "one generation's
electroweak numbers are consistent" into "one generation's electroweak numbers
are DERIVED from the octonion ladder" - a genuine step of the "derive the
Standard Model" program, complementary to codex's GR-branch reconstruction.
