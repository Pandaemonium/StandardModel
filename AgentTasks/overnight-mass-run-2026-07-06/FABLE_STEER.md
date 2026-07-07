# Steering: operationalizing Fable-5's synthesis into the program

Fable-5's full response is in `FABLE_HELP.md`. This document turns it into the
program's marching orders. Grading follows Fable's bar: **[ESTABLISHED]** (standard
math or our kernel-checked results), **[CONJECTURAL]** (believed, sketchable),
**[CRUX]** (the genuinely hard step, flagged not hidden).

## 0. The decisive reframe (adopt program-wide)

**Unification is decomposition, not identification.** The central tension - we proved
three *distinct* mass modes (T/C/A) AND proved `no_common_carrier_via_turn` - dissolves
because T, C, A were never candidate *definitions* of mass that might coincide. They are
three **summands of one canonically-graded quadratic form**, exactly as the Chern
character and the A-hat genus are distinct, non-interconvertible *components of one index
density of one operator*. `no_common_carrier` is the analogue of "Chern character is not
the A-hat genus": true, important, and NOT an obstruction to unification - because
unification was always going to be decomposition, never identification.

**The carrier** (the object the whole program was reaching for): the **Krein square
`D^#D`** (`#` = J-adjoint) of the null-soldered transport operator

>   **D = sum_e c(alpha_e) nabla_e + Phi**

on a finite **2-complex K** (vertices, oriented edges, plaquettes) - NOT a graph. Here
`alpha_e` is a *null* covector soldered to edge `e`, `c` is Clifford multiplication into
a Krein module `S` with chirality `gamma` and J-pairing, `nabla_e` is the gauge-covariant
difference along `e`, and `Phi` is a gamma-even (Yukawa/Higgs) potential. The `#`/Krein
structure is exactly the J-self-adjointness we already built for the NSBB super-Dirac
operator - **the two programs meet at the carrier.**

**The keystone - discrete Weitzenbock/Lichnerowicz identity** [CONJECTURAL as a discrete
theorem; ESTABLISHED in continuum]: because null covectors are *nilpotent* Clifford
elements (`c(alpha_e)^2 = g(alpha_e,alpha_e) = 0`), the edge-diagonal of `D^#D` vanishes
and

>   **D^#D = Q_A + Q_C + Q_T + E**

- **Q_A** (aperture) = `sum_{e!=f} g(alpha_e,alpha_f) sym(nabla_e^# nabla_f)` - the Gram
  form of the null soldering; symbol `|sum_e k_e alpha_e|^2`, kernel = collinear locus.
  This IS our aperture functional: `nbody_aperture_massless_iff_collinear` is exactly
  "Q_A's symbol kernel = collinear locus"; `compositeMassSq_eq_sin_half` is Q_A on a
  two-edge state.
- **Q_C** (closure) = `sum_plaquettes c(alpha_e ^ alpha_f) (Hol_dP - 1) (dressing)` - the
  bivector parts pick up `[nabla_e,nabla_f]` = holonomy defects on 2-cells; zero iff flat.
- **Q_T** (turn) = `Phi^# Phi`; `turnAmplitude_eq_zero_iff` says exactly this vanishes iff
  the mass matrix does. Cross-terms `{c nabla, Phi}` cancel at vacuum (covariantly const Phi).
- **E** = the terms that survive only when the soldering *varies* / the complex is
  irregular. **E is the gravity slot** - rigorously prefigured by Witten's spinor proof of
  the positive-energy theorem (ADM mass = boundary term of a Dirac Weitzenbock identity),
  and the discrete shadow of NSBB's tick-counting time-dilation.

Three payoffs: (1) "a lone lightlike excitation is massless" becomes the one-line theorem
`c(alpha)^2 = 0`; (2) "mass is relational" becomes literal matrix structure - `D^#D` has
zero edge-diagonal, every mass term is a pairwise relation `g(alpha_e,alpha_f)`;
(3) `GrandMassCapstone` upgrades from an honest *conjunction* (AND) of four obstructions to
an *identity* (the AND becomes a +).

## 1. The goal, now precisely defined

"Deliver a model that explains all mass from null edges" = deliver, kernel-checked:
1. the carrier `D` and its Krein module on a finite 2-complex;
2. the **discrete Weitzenbock decomposition** `D^#D = Q_A + Q_C + Q_T + E`;
3. the **four component-identification lemmas** tying each term to the pre-existing lane
   functionals (Q_A = aperture, Q_T = turn, Q_C <-> closure/Z2-gap, E <-> NSBB gravity);
4. the **graded-slot irreducibility theorem** (the upgraded `no_common_carrier`);
5. the **relative exhaustiveness theorem** (see 3 below);
6. one honest solved instance per slot (A done; T at algebra level; C = Z2 done; G imported).

**What the model does NOT contain, at our bar:** derivation of mass *values* (Yukawa
numbers, the SU(N) gap magnitude, ADM masses) - those need dynamics/measures and stay
OPEN. The unification is of the *taxonomy and its carrier* - exactly the thing that was to
be *derived* rather than assembled.

**The surviving hard cruxes (do not let anyone paper over these):**
- **[CRUX] statistical positivity of the closure slot.** The decomposition says *where* the
  closure mass sits; it does NOT prove the gap. `Q_C = c(F)` is generally *indefinite*
  (Lichnerowicz needs curvature positivity). Honest C-identification target: the
  strong-coupling leading order of the Z2 transfer gap (`-log tanh beta`, which we have)
  equals the leading behavior of `<Q_C>` in the character expansion. Positivity-in-
  expectation beyond leading order is the hard problem it always was - localized, not solved.
- **[CRUX] Krein positivity domain.** `D^#D` is a form on an indefinite space, so
  `M^2 = inf spec` needs the physical-sector positivity that in NSBB comes from the
  `<lambda, lambda-tilde>` pairing. Prior infrastructure exists in NSBB.

## 2. Irreducibility = the upgraded `no_common_carrier`

Bigrade by **(operator order in nabla, Clifford degree)**, refined by gamma-parity. The
slots occupy distinct positions: Q_A (order 2, degree 0, even); Q_C (order <=1, degree 2,
even); Q_T (order 0, degree 0, even). No natural transformation moves content between them
- you cannot inject a Clifford-bivector holonomy term into a scalar potential slot. This is
the mechanism behind `MassTaxonomySeparation`, and it is why routing all masses "via turn"
had to fail. **Reprove `no_common_carrier` as this graded-slot argument** - that turns our
central negative into the second half of the unification theorem. `no_common_carrier` is
**shallow as a no-go** (its quantifier misses the one-level-up carrier) but **deep as
irreducibility** (the graded-slot form).

## 3. Exhaustiveness - RELATIVE, not absolute (a hard honesty point)

"These three and no others" is FALSE without hypotheses. The honest theorem is *relative*:

> On a translation-regular, boundaryless null-edge 2-complex with covariantly constant
> soldering and vacuum Phi, `D^#D` decomposes into exactly three obstruction forms
> (aperture, closure, turn) in distinct bigraded slots, and vanishes on a sector iff the
> sector is collinear, flat, and Phi-free simultaneously.

Each *dropped* hypothesis admits exactly one known extra term - and each lands on real
physics: drop covariant-constancy -> soldering-gradient = **G/gravity** (Witten); add a
boundary -> **ADM mass**; Higgs-gradient `|nabla Phi|^2` -> the **Higgs mechanism**
(a T-origin C-mass). The relativized statement is *stronger* evidence than an unconditional
trichotomy, because the "extra" modes are predicted and land on known phenomena.

**Non-vacuity flag:** "`D^#D` decomposes into its own terms" is a tautology; the content is
the *identification lemmas* - that the three terms equal the four independently-defined lane
functionals we built *before* this decomposition existed. Q_A = aperture and Q_T = turn look
mechanical; **Q_C-identification is the crux** (see 1).

## 4. Honesty corrections to apply NOW (Fable's stress tests - real over-claim risks)

- **[H1] Taxonomy classifies TERMS, not PARTICLES.** The Higgs mechanism (C-sector boson mass
  from the potential slot via `|nabla Phi|^2`) and the Schwinger-model photon mass
  (`e^2/pi`, from the axial anomaly = T-slot index density feeding the gauge sector) are
  genuine cross-slot phenomena. They do NOT break the decomposition (both are cross-terms /
  expectation effects it can host), but they falsify any "every particle's mass belongs to
  one mode" claim. **State exhaustiveness at the operator-term level, never the particle-
  spectrum level.** Audit all mass-taxonomy docstrings/capstone prose for this.
- **[H2] `OctonionMassCoupling` reframed as a CONSTRAINT theorem.** A physical mass operator
  must *commute* with color (color is exact). Our theorem that the split mass matrix fails to
  commute with the su(3) ladder ops is, read as physics, evidence the split matrix is NOT a
  physical mass operator. Correct reading: a constraint. Follow-up = compute the **color
  commutant on End(minimal left ideal)** (Schur: `(+) End(multiplicity spaces)`) - that is
  exactly where flavor/Yukawa structure is allowed to live, and it feeds Phi's shape into the
  T-slot. Finite, formalizable, near-term.
- **[H3] Scope note on baryonic mass.** Most real-world baryonic mass is the trace anomaly /
  dimensional transmutation - a C-mode phenomenon whose quantitative content lives in the
  *continuum* limit, outside our fixed-spacing scope. Say so in the freeze document; it
  preempts the obvious external objection.

## 5. Re-scoped gates and routes

### 5.1 Lane C (nonabelian gap) - STOP over-investing; re-scope
The unification (0-3) needs from C only (a) the Q_C slot (algebra, cheap) and (b) one honest
solved instance, which we HAVE (Z2 chain + Q8 string tension). Split the SU(N) gate:
- **Strong coupling (`beta < beta_0` explicit): known since Osterwalder-Seiler 1978** (Ann.
  Phys. 110; Seiler LNP 159). Re-scope the C-gate to **"formalize Osterwalder-Seiler for
  SU(2) with explicit `beta_0`"** - known-true, finite, honest; the first machine-checked
  confinement gap for a genuinely nonabelian continuous group is a landmark on its own.
- **All `beta` at fixed spacing:** believed true, continuum-hard, Clay-adjacent. **Mark OPEN,
  out of scope, stop gating the program on it.**
- Routes ranked: (i) **Shen-Zhu-Zhu stochastic route** (arXiv:2204.12737 - Langevin dynamics,
  log-Sobolev/Poincare, explicit `|beta| < 1/(16(d-1))` mass gap for SU(N)); (ii) polymer /
  character-expansion route via our `CharacterExpansion` dominance; (iii) vortex free energy -
  **prefer the rigorous 1985 Tomboulis-Yaffe RP inequalities (CMP 100, 313)** over the later
  disputed decimation-based confinement claims; **audit whether our arXiv:0808.3442 route
  descends from the decimation program.** Feed the pipeline: Chatterjee "YM for probabilists",
  Cao-Park-Sheffield random-surface Wilson loops.
- **Null-edge reading:** a center twist is a class in `H^2(K, Z(G))` - closure is measured by
  2-cohomology with center coefficients, parallel to NSBB's P9 localizing Lambda-risk in
  harmonic cohomology. Uniform pattern across both programs: **T = index/degree (K-theory),
  C = holonomy/twist (H^1,H^2 with gauge coeffs), A = symbol positivity (Clifford), G =
  harmonic/boundary.** Obstruction theory on one complex.

### 5.2 KP crux (`pairSum_le_expBound`) - stop fighting the tree-graph inequality
- **[recommended] Penrose partition scheme** (O. Penrose 1967): explicit map connected-graphs
  -> spanning-trees with Boolean-interval fibers; alternating sums telescope to an *exact*
  identity - pure finite combinatorics, respecting the third-order cancellation our naive
  root-count violated. Survey: **Scott-Sokal 2005** (J. Stat. Phys. 118); companion Faris
  2010 (Probability Surveys); Friedli-Velenik Ch. 5 for a KP-inductive proof.
- **[shortcut] LLL equivalence** - Scott-Sokal: cluster convergence <=> Shearer's region;
  and the Lovasz Local Lemma is **already formalized** (Chelsea Edmonds, Isabelle/HOL AFP
  2023, w/ Paulson). Port/transpile the combinatorial skeleton instead of rebuilding it.
- **[oracle-friendly] Dobrushin-Shlosman** finite-volume mixing criterion, verify by explicit
  kernel-checkable computation in gauge-invariant polymer variables.

### 5.3 Higher-d Nielsen-Ninomiya - it's the Euler class of a trivial bundle (= 0)
The Brillouin symbol is a section of a *trivial* bundle; Poincare-Hopf gives
`sum(local indices) = Euler number = 0`. Finite formulation = **discrete Stokes theorem for
degree**, the d-dim copy of our 1D proof: genericity on the (d-1)-skeleton; `w(c) =
deg(sigma|_dc)` by sign-of-determinant on facets; `sum_c w(c) = 0` because every facet is
shared by two cells with opposite orientation (our up/down-crossings-balance argument, one
dimension up). Crux = only the (L2) well-definedness bookkeeping. Prior art: Friedan CMP 85
(1982), Banchoff (1967); **formalizability gold mine: Loring's finite-dimensional almost-
commuting-matrices K-theory** (and Prodan-Schulz-Baldes) - may hand the d-dim index half of
`NNIndexExact` nearly pre-packaged. Tie-back confirmed: "a single chiral crossing cannot
exist" = "a null edge cannot turn without a partner" = vanishing of the trivial bundle's
Euler class (the zig needs the zag).

### 5.4 Lane B - reposition as the INTERNAL spectral triple
In the Connes-Chamseddine spectral SM, the **Yukawa matrix IS the internal Dirac operator
`D_F`**. Lane B's job is to *constrain* the carrier's internal factor, not conjure dynamics.
`C(x)O`'s left-mult algebra is `Cl(6) = M8(C)` (Furey); minimal left ideal = internal Hilbert
space; su(3) inside; the allowed Yukawa space = the **color commutant on End(ideal)** (see
[H2]) - decompose the ideal into color irreps, read off multiplicity spaces = allowed shape
of Phi. Near-term B-lane theorem. Mass *values* derived by no one (Furey, Dubois-Violette-
Todorov, Boyle-Farnsworth non-associative geometry, Krasnov Spin(11,3)); adopt the NCG
*interface* (van Suijlekom's book), not a hidden mechanism.

**Spin(10) repair** [ESTABLISHED up to SU(5); CONJECTURAL for the selector]: the compact
chain is Stab(pure spinor *line*) = U(5) (pure-spinor variety = Spin(10)/U(5), Chevalley);
Stab(pure spinor *vector*) = (cover of) SU(5); and **S(U(2)xU(3)) = Stab(vector + a 2(+)3
flag** on the isotropic 5-plane). The falsified Isomorphism was one datum short: **the SM
group is the stabilizer of pure spinor + flag, and the Selector IS the flag.** Natural
conjecture: the flag comes from the division-algebra chain - `H subset O` splits `C^5 =
C^2 (+) C^3` (weak from H, color from O). Resonance with 0/1.5: **the Selector question
("which pure spinor?") and the soldering question ("which nulls coexist masslessly?") are the
same question** - a pure spinor = the Fock vacuum of a maximal null polarization.

## 6. The A=T bridge we already own (a free win to formalize)

In spinor-helicity `p_i = lambda_i lambda-tilde_i`, `(p1+p2)^2 = <12>[21]`, so our kernel-
checked `M^2 = 4E^2 sin^2(theta/2)` is *literally* `|<12>|^2`. But `<12>` is a **chirality
pairing between constituent spinors = a turn amplitude.** So on-shell, **aperture mass =
(turn amplitude)^2**, and this is exactly NSBB's `det(P) = Phi^# Phi`: the Plucker mass
identity is the A-slot, `Phi^# Phi` is the T-slot, and the on-shell identification is the
bridge. Our two programs proved two halves of one statement without noticing. [ESTABLISHED -
the spinor identity is classical; the recognition is the new content.] Prior art to stand on
explicitly: **Penrose zig-zag** (Road to Reality 25.2), **Feynman checkerboard** (Jacobson-
Schulman 1984 - promote to the program's canonical 1+1d toy where the whole Weitzenbock
story is closed-form), **massive spinor-helicity** (Arkani-Hamed-Huang-Huang 1709.04891),
**two-twistor particles** (Penrose-Perjes-Hughston, LNP 97, 1979), **celestial holography**
(Pasterski-Shao-Strominger - natural home of `ApertureEntropy` on the celestial sphere).

## 7. Marching orders - the three moves + probes

- **Move 1.** Formalize the carrier + the **discrete Weitzenbock theorem** on a finite
  2-complex, `E`'s vanishing hypotheses explicit. Finite linear algebra; the fiddly part is
  the Wilson-line dressing of plaquette terms to a common basepoint. **Use NSBB's causal
  diamonds as the 2-cells and its Krein structure as `#`** - the natural merge point of the
  two programs.
- **Move 2.** Prove the **component-identification lemmas** (Q_A = aperture, Q_T = turn;
  Q_C <-> Z2 gap at strong-coupling leading order, honestly scoped), the **graded
  irreducibility** theorem, and the **relative exhaustiveness** theorem. This package IS the
  goal in honest form.
- **Move 3.** Re-scope lane C to the **strong-coupling SU(2) gap with explicit `beta_0`**,
  citing Osterwalder-Seiler as the result being mechanized; pick the polymer (5.2) vs
  Shen-Zhu-Zhu (5.1) route after a formalizability assessment; demote all-`beta` to OPEN.
- **Park/kill:** Spin(10) Transitivity (dead, correctly); building SU(N) Haar partition
  functions *before* Move 2 (needed eventually, doesn't block unification); any route
  descending from disputed decimation-based confinement proofs.
- **Pre-registered probes (oracle-before-analysis):** (P-i) flat U, Phi=0: `inf spec D^#D`
  on the physical sector = minimal multi-edge Gram value (aperture only); (P-ii) Phi!=0,
  collinear flat: gap = min singular value^2 of Phi; (P-iii) Z2 small torus: leading
  strong-coupling transfer gap vs `<Q_C>` must recover `-log tanh beta`; (P-iv) two-edge
  sector eigenvalue = `4E^2 sin^2(theta/2) = |<12>|^2`. Any failure falsifies the
  corresponding identification lemma before analytic investment.

## 8. Reading list to ingest (Fable-surfaced)

Osterwalder-Seiler 1978 (Ann.Phys.110) + Seiler LNP 159; Tomboulis-Yaffe 1985 (CMP 100,313);
Shen-Zhu-Zhu arXiv:2204.12737; Chatterjee "YM for probabilists"; Cao-Park-Sheffield random
surfaces; Scott-Sokal 2005 (JSP 118) + Faris 2010 + Friedli-Velenik Ch.5; O.Penrose 1967;
Chelsea Edmonds LLL AFP (Isabelle 2023); Dobrushin-Shlosman; Friedan 1982 (CMP 85); Banchoff
1967; Loring finite-dim K-theory + Prodan-Schulz-Baldes; Witten 1981 (CMP 80, positive
energy); Arkani-Hamed-Huang-Huang 1709.04891; Jacobson-Schulman 1984 (checkerboard);
Penrose-Perjes-Hughston LNP 97 (1979); Pasterski-Shao-Strominger (celestial); van Suijlekom
(NCG SM); Boyle-Farnsworth (non-associative geometry); Chevalley (pure spinors).
