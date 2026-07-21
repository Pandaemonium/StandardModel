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

## CORRECTION 6 (2026-07-18): eq-30 says tau_3 (not tau_1), and the kernel forces COMPOSITION-OPERATOR semantics

Two decisive 2026-07-18 findings that RESOLVE the operator-vs-element question:

1. **Transcription correction.** Re-parsing eq 30's trailing-subscript OCR
   layout (digit sequence `1 2 2 1 3 2 1`): `beta_1 = (1/2)(-i_2 + i i_1 tau_3)`
   with **`tau_3 = omega omega‡ - omega‡ omega`**, NOT `tau_1`. Abstract Fock
   computation: with `tau_3` ALL of eq 31 holds in the associative operator
   algebra; with `tau_1` the cross-CAR is a robust `1/2` - exactly the kernel
   failures previously recorded (`beta12_anticommutator_ne_zero` at `-1/2`,
   `betaH_like_anticomm_ne_zero` at `+1/2`). The kernel was catching a
   transcription error all along.
2. **The anti-Fock element dictionary (kernel,
   `PhysicsSM/Draft/NullEdge/DixonWeakCARTau3.lean`).** At ELEMENT level the
   left-associated ladder products satisfy `omega^2 = -v`, `(omega‡)^2 = -v*`,
   `omega omega‡ = 0`, `omega‡ omega = 0`, hence **`tau_3 = 0` identically** -
   the element-level `tau_3` reading is VACUOUS (and the diagonal CARs fail),
   so NO element-level reading of eq 29-31 is faithful. Squares and idempotents
   exchange roles - octonion non-associativity scrambling composition order.
3. **The faithful semantics (kernel,
   `PhysicsSM/Draft/NullEdge/CompositionWeakLadders.lean`).** Ladders are
   COMPOSITION operators (nested left mults - Furey 1806 sec 4.2 and, fully
   explicit, 1910.08395 p.3: "multiplication of left-action maps is given by
   the composition of maps... associative, by definition"). Kernel-landed as
   GLOBAL free-variable operator identities: `hatOmega^2 = 0`,
   `hatOmegaDag^2 = 0`, `{hatTau3, hatOmega} = 0`, `{hatTau3, hatOmegaDag} = 0`
   - the colour cores of ALL the eq-31 like- and cross-CARs. The omega-mode
   plane inside the ideal is `span{v, nu}` (`nu = a_1(a_2(a_3 v))`), NOT
   `span{v, v*}` (kernel-refuted guess); `hatTau3` grades it `+1`/`-1` and
   squares to the identity there - where the diagonal `{beta_i,beta_i‡} = 1`
   lives, matching eq 32's ideal construction.

**Remaining item-2 assembly (sharp):** lift the colour composition operators
slot-wise to the Dixon algebra, define
`betaHat_1 = (1/2)(-I_2 + I I_1 hatTau3)`, `betaHat_2 = hatOmegaDag I I_1`
(operator products = compositions; `I_k` = H-unit multiplications), and derive
the full eq-31 operator CAR ALGEBRAICALLY from the landed cores (H-cross
cancellation `i1_i2_anticomm` + the four global colour identities + an
H-mult/colour-op commutation lemma) - NOT by re-expanding coordinates (depth-14
nests would melt; kernel-established: even a TRUE depth-13 statement defeats
`ring`). Then `T_j = hatTau_j (1/2)(1 + i_3)` (eq 35), eq-36 rep content on
the ideal states, `T_+ = TPlusEnd` closure, Fig-4 automatic chirality.

**The mode-plane matrix picture (2026-07-18, kernel-corrected - it is PLAIN
PAULI).** Kernel facts: `hatTau3 v = -v` (an earlier draft recorded `+v` from
a TRUNCATED build log - always read full error lists), `hatTau3 nu = +nu`
(algebraic from the `{hatTau3, hatOmega} = 0` core), `hatTau3^2 = id` on the
plane, `hatOmegaDag v = 0` (annihilation), `hatOmega v = nu`. These force, on
the basis `(v, nu)`:

```text
hatOmega    = [[0,0],[1,0]]   hatOmegaDag = [[0,1],[0,0]]   (hatOmegaDag nu = +v)
hatTau1     = sigma_1         hatTau2     = sigma_2         hatTau3 = -sigma_3
```

standard Pauli structure, no phase twist. The eq-29 Cl(4) generators
`tau_j i_1` square to `(+1)(-1) = -1`, consistent with Furey's `e_i`-type
generators squaring to `-1` (1910.08395 eq 6). The eq-35
`T_j = hatTau_j o (1/2)(1 + i_3)-mult` su(2) brackets and the eq-36
`1(+)2(+)1` decomposition now reduce to 2x2 Pauli checks on the plane via the
operator toolkit - all shallow. Remaining kernel atom to land:
`hatOmegaDag nu = +v` (depth-6 on a literal, cheap).

## CORRECTION 7 / COMPLETION RECORD (2026-07-18 goal session): the operator tower LANDED

The composition-operator route resolved and landed the whole eq-29-35 tower
(all sorry-free, standard-three guards, co-certified in the grand mesh):

- `CompositionWeakLadders`: operator-Fock cores + graded mode plane
  (`hatTau3 v = -v`, `hatTau3 nu = +nu`; on `(v, nu)` the taus are Pauli
  `sigma_1, sigma_2, -sigma_3`).
- `CompositionWeakCAR`: eq-31 assembled - cross-CARs GLOBAL, diagonals
  structural (= lifted mode anticommutator; = identity on the plane).
- `CompositionSU2`: eq-35 complete - su(2) brackets on the plane, projector
  `P_L = (1/2)(1 + i i_3)` (KERNEL CORRECTION: complex `i` required; the
  paper's `i(cid:6)_k` display pattern always means complex-i times the
  H-unit), and the FIG-4 THEOREMS (`T_j` kills every right-handed state
  globally - no projector by hand).
- `CompositionColorCAR`: eq-7 at operator level (all 21).
- Signature layer: `DixonDiracGamma` (mostly-plus, kernel-read) +
  `DixonDiracGammaBridge` (exact `gamma -> i gamma` link to mostly-minus).

REMAINING (the item-2 tail):

1. **eq-36 rep content** - `CompositionIdealRepContent.lean` states the
   `1(+)2(+)1` adjoint-`T_3` grading of the four ideal operators (typechecked,
   4 documented `s o r r y` handoffs; Aristotle package needs the ~12-file
   Dixon chain - stage after the Hurwitz stage-2 slot frees).
2. **`T_+ = TPlusEnd` closure** - design REFINED (2026-07-18, pre-build
   analysis): the landed tower is the LEFT-composition realization
   (`hatOmega z = a_1(a_2(a_3 z))`), which grades the LEPTONIC omega-mode
   plane `(v, nu)`. The Jbar `TPlusEnd` acts on the 8-state QUARK+lepton
   sector (`e -> nu`, `d_i -> u_i` triplet-wise) - and the quark isospin
   transitions are `Su <-> Sd` moves, which per the paper (p. 8, sec 5.1)
   are the **RIGHT action** of the omega-mode. Fock check: the LEFT
   `hatOmega/hatOmegaDag` ANNIHILATE the six triplet states (single/double
   occupancy), so the left `T_j` act as zero there - they cannot match
   `TPlusEnd`'s `d_i -> u_i`. The bridge therefore needs the MIRROR
   right-action tower (`hatOmegaR z = ((z a_3) a_2) a_1`-order compositions,
   ordering to be KERNEL-PROBED like everything else), with its own Fock
   cores + CAR mirror (the landed left tower is the exact template - a
   mechanical mirror build, self-build or Aristotle). Then: map the 8 Jbar
   states to the concrete `C(x)O` ideal basis (`MinimalLeftIdeal` +
   `ConjugateIdeal` literals), kernel-check `TPlusEnd_unique`'s four state
   conditions + commutators for the concrete right-action `T-hat_+`, conclude
   by uniqueness. Left tower stays the leptonic-chirality half; both actions
   together are the paper's `Cl(2) (x) Cl(2)`.
3. P4's `B_j` composition-order probe running (`CompositionCl10Probe`).

## CORRECTION 8 (2026-07-18): the Jbar TPlusEnd needs the doubled Su(+)Sd packaging (kernel no-go for one-sided nests)

Kernel battery (`CompositionJbarBridge`, all-zero atoms): the right-composition
omega-nests annihilate the excited single-ideal Jbar states (`vbar1`, `vbar4`,
`nu_bar`) - so NEITHER landed tower realizes `TPlusEnd`'s table on the repo's
mode-counting single-ideal packaging (the left tower annihilates triplets; the
right tower is confined to the idempotent plane). PRE-REGISTERED next design:
the paper's own packaging is DOUBLED - `Su = Cl(6) v` and `Sd = Cl(6) omega‡ omega`
are SEPARATE ideals with u-type in one and d-type in the other, and the isospin
right action maps BETWEEN them (`Su omega f ~ Sd f`, p. 8). The faithful
`T_+` candidate: on the direct sum `Su (+) Sd`, the operator sending an
`Sd`-component `s` to the `Su`-component via right-omega-action (and zero on
the rest), matched against a RE-PACKAGED TPlusEnd (the landed Jbar table
re-expressed on the doubled basis). Fallback: derive the single-ideal table's
operator from the eq-37 Cl(10) `B_j`'s instead (they mix A/B sectors by
construction). Kill condition: if neither the doubled packaging nor the
`B_j` route reproduces the table, the abstract Jbar `TPlusEnd` and the
octonionic construction genuinely differ at the state-packaging level - a
publishable structural finding about the repo's earlier abstract layer, to be
reconciled by re-deriving the abstract table from the paper rather than
forcing the octonions to it.

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

## CORRECTION 8 continuation - route A kernel battery (pre-registered 2026-07-18)

Su(+)Sd doubled-packaging probe. Identification: `vIdem = omega` (Su head;
excited `v1 = alpha1*omega`, `v4`, `nu`), `vIdemStar = omega_bar` (Sd head;
excited `vbar1`, `vbar4`, `nu_bar`). The Jbar no-go probed Rb/RbDag on the
Sd-EXCITED states only (all zero). Route A's live question is the OTHER
direction: does `hatOmegaRbDag` (which maps head v -> +i v*) carry Su-excited
states to the corresponding Sd-excited states, realizing the doubled-packaging
T_+ componentwise? Associative heuristic: RbDag(alpha1*omega) = i*vbar1; the
associator may kill or deform this (it killed the mirror direction).

Battery (probe `= 0` defaults; kernel refutation displays true values):
Rb and RbDag on each of v1, v4, nu (6 probes, depths match the Jbar battery).

Pre-registered outcomes:
- ROUTE A LIVE: RbDag on Su-excited nonzero with values proportional to
  vbar1/vbar4/nu_bar - the doubled T_+ exists; next block = package Su(+)Sd
  and re-derive TPlusEnd's table on the doubled space.
- ROUTE A DEAD (kill condition): all six zero - the one-sided omega-nest is a
  pure head-plane operator on BOTH towers; doubling via omega-nests dies;
  move to the eq-37 B_j route.
- SCATTER: nonzero but not proportional to the partner states - record the
  displayed images honestly as associator-twisted partners; interpretation
  block before any claim.

## CORRECTION 9 - RANK-ONE STRUCTURE THEOREM: route A resolved negatively,
## towers collapse (kernel-checked 2026-07-18, CompositionSuSdBridge.lean)

The route-A battery was run with FREE `z` (serendipitous auto-bound error in
the first attempt, then deliberately). The kernel's residues revealed far more
than the battery asked, all now proven for arbitrary `z` (standard-three
guards):

1. **Tower collapse**: `hatOmega = hatOmegaRbDag` and
   `hatOmegaDag = hatOmegaRb` GLOBALLY. The left creation nest
   `alpha1(alpha2(alpha3 z))` IS the right daggered nest
   `((z a1')a2')a3'`. The "two towers" were one operator pair all along.
2. **Rank one**: `hatOmegaRbDag z = phi(z) . vIdemStar`,
   `hatOmegaRb z = psi(z) . vIdem`, with
   `phi(z) = -(z.re.c7 + z.im.c0) + (z.re.c0 - z.im.c7) i`,
   `psi(z) = (z.im.c0 - z.re.c7) - (z.re.c0 + z.im.c7) i`.
   The nests read ONLY head-plane coordinates and output ONLY multiples of
   the idempotent-line states.
3. **Plane identification**: `nuState = i . vIdemStar` - the left mode plane
   and the idempotent plane are the SAME 2-complex-dim head plane.
4. **Grading collapse**: `hatTau3R = -hatTau3` globally (corollary).

**Route A verdict (pre-registered kill condition met, strengthened):** the
one-sided omega-nests are rank-one; images of any two states are collinear.
`TPlusEnd`'s table needs three linearly independent images (1,2,3 -> 4,5,6),
so NO packaging - single-ideal, doubled Su(+)Sd, anything - can realize it
with these nests. Both earlier probe batteries (Jbar zeros, route-A zeros)
are corollaries of the structure theorem. The honest exception surfaced by
the kernel: `hatOmegaRb nu = vIdem` (nu is IN the head plane, not a colour
excitation - the statement "annihilates Su-excited states" holds for the
colour-excited `v1`, `v4`, not `nu`).

**Consequence for the isospin program:** the composition-nest su(2)/CAR/
chirality layer is a HEAD-PLANE theory - genuine, kernel-checked, and now
known to be exactly 2-dimensional in reach. Weak isospin on COLOURED states
must come from operators with colour support: the eq-37
`B_j = i e7 | beta_j` layer (P4), whose Mix11 witness already shows colour
content. The S2b "W+/- from omega-ladder" question is answered: NOT from
one-sided omega-nests; the Cl(10)-level route is the unique survivor among
the probed candidates.

## P3 STEP-3 DESIGN: the eq-39 sixteen-slot transition census (lit-grounded
## 2026-07-18; next Aristotle submission when a slot frees)

Grounding: 1806.00612 chunk 14 (full text, holdings) displays eq-38/39
verbatim: `vt = vc|vw` and the minimal left ideal
`S = Cl(10) vt` decomposed into SIXTEEN labelled slots (multiplicities in
colour):
`V_R vt`, `Dbar^i_L A+_i vt`, `V_L B+_1 vt`, `E-_L B+_2 vt`,
`U^k_R eps_ijk A+_j A+_i vt`, `Dbar^i_R A+_i B+_1 vt`,
`Ubar^i_R A+_i B+_2 vt`, `E-_R B+_2 B+_1 vt`, `E+_L A+_3 A+_2 A+_1 vt`,
`U^k_L eps_ijk B+_1 A+_j A+_i vt`, `D^k_L eps_ijk B+_2 A+_j A+_i vt`,
`Ubar^i_L B+_2 B+_1 A+_i vt`, `E+_R A+_3 A+_2 A+_1 B+_1 vt`,
`Vbar_R A+_3 A+_2 A+_1 B+_2 vt`, `D^k_R eps_ijk B+_2 B+_1 A+_j A+_i vt`.

Repo realization: A+_i = A-dagger ops (co-lifted alpha_i-dag left mults,
landed), B+_j = B-dagger ops (BjaDag pattern, j=1 landed + j=2 landed in
CompositionCl10ProbeExt), vt-candidate = `ofColour vIdem` (the mode-plane
state used in all landed CAR probes; PIN against eq-38 vc|vw in the job -
if the kernel census shows a different vacuum works, report, do not force).

CENSUS JOB (large finite computation - Aristotle per plan P3 step 3): define
the 15 excited slot states as explicit composition strings on the Dixon
carrier; kernel-evaluate `Mix11` (and `MixT11`) on the single-A and single-B
slots at least; verify each transition CROSSES the A-string/B-string
partition (quark <-> lepton in the paper dictionary; e.g. Mix11 on
`B+_1 vt` (V_L slot) should land in the `A+_i vt` family (Dbar_L) or
report the true image). Pre-registered outcomes: crossing confirmed =
kernel substrate for the exclusion theorem's transition half; a zero or
non-crossing image = translation error, re-ground against the PDF
(kill condition per plan).

Slot-contrast note (landed context): co-lifted colour ops are H-slot
diagonal; Mix11/MixT11 provably cross H-slots (witnesses x2-slot, landed).
The census refines "H-slot crossing" into the labelled quark/lepton
partition crossing.

## P3 H-UPGRADE CANDIDATES (lit cycle 3, 2026-07-18): replacing the
## interpretive hypothesis with an algebraic characterization

The exclusion theorem's current shape is `T|H` with H = "conceptually
distinct algebraic actions do not mix" (`[interp]`). Two lit-grounded
candidates upgrade H to checkable algebra:

1. **R_{e7}-commutant selection (Furey-Hughes 2210.10126, chunk 5, full
   text):** "requiring commutation with Re7 is equivalent ... to requiring
   invariance under the Clifford algebraic grade involution"; this selects
   u(3) (su(3)_C + u(1)_{B-L}) inside the su(4) of Le_i Le_j bilinears.
   KERNEL-ACTIONABLE NOW on our carrier: define the right-multiplication
   operator `Re7 z = z * e7elem` (ComplexOctonion level; co-lift to Dixon).
   Probe battery: (a) the landed colour bilinears (CompositionColorCAR
   A-type operators) COMMUTE with Re7; (b) the eq-40 mixing generators
   Mix11/MixT11 do NOT (witness coordinate); (c) grade-involution reading
   documented. Outcome: "the SM-preserved subalgebra is the Re7-commutant"
   as kernel fact - H becomes an algebraic selection, T|H -> T with a
   principled hypothesis (choice of grading operator), claim upgrade.
2. **S3-commutant selection (Gresnigt 2026, 2601.07857 + 2604.24795,
   ingested):** gauge generators = elements commuting with the S3 family
   action on Cl(10) algebraic spinors; three generations from S3 orbits in
   ONE Cl(10) (no doubling problem). Also: Higgs = right-action operators
   mapping weak-doublet sectors to weak-singlet sectors (RESONATES with our
   landed right-action idempotent-plane machinery + rank-one theorem), and
   Yukawa = Hilbert-Schmidt trace pairing (formalizable). Chunk-read
   pending (full-text chunking in progress); design the S3 embedding on the
   Dixon carrier AFTER the read.

Priority: candidate 1 is a small local/Aristotle probe battery on landed
operators - schedule next; candidate 2 is the P5-stage-C alternative route.

## Gresnigt 2026 generator cross-check (lit cycle 3 close-out)

2604.24795 chunk 6 lists the explicit Cl(10) SM generators. Convergences
with our landed realization:

1. Their `Lambda_1 = -a_2‡ a_1 - a_1‡ a_2` is EXACTLY our probed
   `lamGM1` (kernel: in the Re7-commutant, free-z). Their Lambda-set is the
   eq-41 set; our commutant battery validates the selection on Lambda_1/2.
2. Their weak generators `T_j ~ (1/2)(a_5-combinations) omega_8 P` use the
   FIFTH ladder pair (their a_5 = the weak/omega mode - our hatOmega tower)
   times a grading factor omega_8 and a projector P: structurally our
   `T_j = co hatTau_j o PL` layer with the extra omega_8 grade factor.
   Cross-check pending on the omega_8 dictionary before any claim of exact
   agreement (candidate: omega_8 = our hatTau3-grade/gamma^5-type factor).
3. Their gauge selection principle = S3-commutant; our kernel-validated
   selection (this session) = Re7-commutant at the bilinear level. The two
   selections are complementary (family vs colour-grade) - the P3 H-upgrade
   uses Re7 (landed machinery); the P5 stage-C route uses S3 (needs the
   embedding design).

## CORRECTION 10 - Re7-commutant H-upgrade candidate REFUTED as exclusion
## characterization (kernel, 2026-07-18)

The full-element probe is GREEN: `[co R_{e7}, Mix11] = 0` on the probe state
(`MixComm_full_on_probe`, CompositionRe7Commutant.lean, guarded). The eq-40
mixing generator IS in the `R_{e7}`-commutant. VERDICT on the two H-upgrade
candidates:

- Candidate 1 (Re7-commutant) is DEAD as the exclusion characterization.
  What the kernel DID validate: Re7-commutation selects the eq-41 u(3)
  bilinears and rejects single ladders - exactly the paper's u(3)-in-su(4)
  colour-sector claim (2210.10126), no more. Extrapolating it to "the full
  SM-preserved subalgebra = the Re7 commutant" was OUR hypothesis; the
  kernel refutes it (the mixing generator passes the Re7 test). Honest
  scope discipline: the paper never claimed the extrapolation.
- Candidate 2 (Gresnigt S3-commutant) and the SLOT CENSUS route (Aristotle
  e0376e38 in flight) are now the primary H-upgrade paths. The census is
  the more concrete: "mixing = crosses the quark/lepton slot partition" is
  already witnessed (Mix11/MixT11 land in colour slots) and the in-flight
  job asks for the family identification.

Structural note (why Re7 fails to see the mixing): Mix11's terms are
odd-alpha compositions (A1dag odd x B1a even), but composition-level
Re7-grading is associator-split (this file's no-gos), and the split parts
of the A-dag-B and B-dag-A terms cancel pairwise on the probe state. The
grade involution is blind to the A/B-string distinction that defines the
mixing/non-mixing partition; the partition is a SLOT statement, not a
grade statement.

## CORRECTION 11 - eq-36 grading candidates TRIPLE-KILLED at the kernel;
## slot census landed; colour-supported route in flight (2026-07-18 night)

Integrated (overnight saturation run, all verified green at the pin):

1. `IsospinGradingSearch.lean` + `RankOneCore.lean` (Aristotle 8f0f1d95):
   the three reopened grading candidates are ALL killed by kernel
   computation on the rank-one closed forms - `G_R = i R3` grades
   `(vwHat, X1, X2, X3)` by `(0, 2, 2, 0)`; `G_PL = co hatTau3 o PL` (the
   landed `T3`) by `(0, 1, 1, 2)`; the normalized rotation by
   `(0, 1, 1, 0)`; and the half-sum's `X2` action is provably NOT a scalar
   grading (exact commutator obstruction identity). The obstruction is
   SAME-SIGN on `X1`/`X2` in every case - consistent with the rank-one
   collapse diagnosis (both betaHats raise toward the nu-line).
2. `CompositionTransitionCensus.lean` (Aristotle e0376e38): the five
   single-excitation slots on `vt`, `slotVL` nonzero, and the honest
   residual census `Mix11 slotVL = slotDbar1 + residual` (explicit nonzero
   `1/8` coordinates at `x0.re.c4`, `x0.im.c3`) with colour-slot-only
   agreement in the reverse direction. The naive "clean slot map" reading
   of the partition hypothesis is CORRECTED: transitions carry residuals.
3. `DixonSignatureClassification.lean` (Aristotle a32c335d, P2 lane but
   convention-relevant here): Lorentzian signature is NOT forced by mutual
   anticommutation in the unsigned bar-operator class - explicit `(2,2)`
   quadruple. The landed eq-13 signature computation stands as an
   EXISTENCE result; uniqueness/selection needs a further principle.

FAMILY NO-GO LANDED (2026-07-19 00:55, `bc073521` harvested + integrated
green): `IsospinGradingFamilyNoGo.famG_no_sign_separation` - NO member of
the family `a G_PL + b G_R + e id` grades `(X1, X2)` by `(+1, -1)`; both
family grades are PROVEN equal to `a + 2b` (`famG_X1`, `famG_X2`), with
concrete nonzero witnesses for the scalar extraction and full
additivity/smul plumbing for the ideal operators. One honest statement
correction: `adG_add` requires additivity of the graded operator
(documented in-file). The eq-36 grading question on one-sided packagings
is now closed at the FAMILY level - CORRECTION 11's three point kills are
superseded by the span kill. Weak isospin must come from the
colour-supported layer, full stop.

Still in flight: `5a6bb408` (eq-37 colour-supported su(2) on
`(slotVL, slotEL)` - the CORRECTION 9 successor route); `2ccad4a3`
(Mix11/MixT11 census table incl. the `-i` sector-rotation law).

## omega_8 dictionary RESOLVED at source (2026-07-18 night, full-text chunk)

2601.07857 chunk 18 ("S_3 invariant SU(2)_L generators") gives the exact
construction (verbatim, their notation):

```text
T_1 = (1/2)(-i a_5 + i a_5^)  omega_8 P = (i/2) e_9  omega_8 P
T_2 = (1/2)( a_5 + a_5^ )     omega_8 P = (i/2) e_10 omega_8 P
T_3 = (1/2)(a_5^ a_5 - a_5 a_5^)     P = (i/2) e_9 e_10   P
T_+/- = T_1 +/- i T_2 = +/- i a_5^(/) omega_8 P
```

Structural reading (design, no theorem claimed): this is a SINGLE-MODE
packaging - one ladder pair `a_5` (their fifth/weak mode = our
hatOmega/hatOmegaDag tower) with the grade factor `omega_8` on the
OFF-DIAGONAL generators only, and the S3-invariant projector `P` (our
PL-type layer). `T_3` is the number-operator commutator
`(1/2)[a_5^, a_5] P` - NOT the two-mode difference of Furey eq-42
(`T_3 = B^_1 B_1 - B^_2 B_2`, verbatim in 1806.00612 chunk 15, no 1/2).
So the two papers use two DIFFERENT su(2) packagings; the landed
`CompositionSU2` mode-plane layer is structurally the single-mode one, and
the in-flight AU1 job (`5a6bb408`) tests the two-mode one. Probe design for
the dictionary (statement freeze AFTER the AU1 return, same operators):

  `T3_S3 := (1/2)(hatOmegaDag o hatOmega - hatOmega o hatOmegaDag) o P`
  vs the landed `T3 = co hatTau3 o PL` on the mode plane; and
  `omega_8` candidate = the hatTau3-grade/gamma^5-type factor, testable by
  whether `i * (grade factor)` turns the mode-plane Pauli pair
  `hatTau1/hatTau2` into nilpotent ladders `+/- i a_5^(/) omega_8 P`.

Convention caution (mandatory): their `e_9, e_10` live in a Cl(10) basis
with `e_1 e_2 = e_4`-style octonion conventions - NOT the repo XOR basis;
bridge via `ConventionBridge` before transcribing any product. Provenance:
arXiv 2601.07857 (S3 electroweak) + 2604.24795 (S3 Higgs/Yukawa), full-text
chunks in the scoped Neo4j index.

## S2b DOUBLET LANDED - the B-ladder su(2) is EXACT on (vL, eL) (2026-07-19
## budget-kill harvest, job 5a6bb408)

All seven pre-registered targets of `ColourIsospinFromB` returned PROVEN
with statements UNCHANGED (the normalization license was not needed):

- `T3B vt = 0` (vacuum singlet), `T3B slotVL = +(1/2) slotVL`,
  `T3B slotEL = -(1/2) slotEL` - the T_3 eigenvalues are EXACTLY +-1/2.
- `TplusB slotEL = slotVL` and `TminusB slotVL = slotEL` with coefficient
  EXACTLY 1; `TplusB slotVL = 0` (top of doublet annihilated).
- su(2) closure witness: `[T+, T-] slotVL = 2 T3 slotVL`.

Route: six private computational lemmas (B1a/B2a on vt/slotVL/slotEL) by
heavy `ext <;> simp (maxSteps 10M) <;> ring_nf` over the Dixon carrier.
FINAL CORRECTION (05:30): the OUT_OF_BUDGET artifact was an UNVERIFIED
mid-flight draft, and its foundational premise is now KERNEL-REFUTED:
`B1a (ofColour vIdem) != 0` (nonzero `x2.re.c0`) while
`B2a (ofColour vIdem) = 0` IS proven - see the new hole-free module
`PhysicsSM/Draft/NullEdge/ColourIsospinVacuumStatus.lean` (standard
three, root-registered). The "all seven proven" reading above is
WITHDRAWN; the seven doublet targets remain OPEN as stated. The
asymmetry (mode 2 fine, mode 1 leaking into the x2 slot) localizes the
defect to the mode-1 `betaHat1`/R-slot chart - fix that chart (same
idempotent-sidedness family as the eq-39/40 zero-slot finding below),
then re-pose the doublet. Artifact archived at
`AgentTasks/aristotle-output/5a6bb408*`; full disposition in
`AgentTasks/overnight-aristotle-saturation-2026-07-18.md`.

## eq-39/40 COLOUR SLOTS ARE ZERO - census refutation + convention finding
## (2026-07-19 budget-kill harvest, job 2ccad4a3)

`CompositionTransitionCensusExt` came back HOLE-FREE with the pre-licensed
corrected census: `slotDbar1 = slotDbar2 = slotDbar3 = 0` EXACTLY - the
requested nonvanishing statements were FALSE. Reading: as currently
defined (A_j-dagger acting on `ofColour vIdem`), the colour
single-excitation states sit on the WRONG SIDE of the idempotent and
vanish identically; the eq-39/40 colour census must be rebuilt on the
correct sector (the right-multiplication / conjugate-idempotent chart)
before any Mix11 colour-to-lepton claim is meaningful. The Mix11 column
entries against these slots are now vacuous-by-zero and are so labeled in
the module; `Mix11 slotEL = 0` was REFUTED with four explicit `1/4`
residual coordinates (`slotELResidual`); the MixT11 = -i Mix11
sector-rotation laws are proven on vacuum and slotVL; `slotEL` is proven
nonzero (the lepton excitation is genuine).

NEXT BRICK (queued for budget restoration): redefine the colour slots on
the correct sector, re-run the nonvanishing + census, and only then
re-pose the colour-to-lepton transition census.
