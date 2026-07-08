# Memo: seven challenges, responses and one outright solve

Date: 2026-07-08. Format per brief section 7: numbered findings, labels
THEOREM / HEURISTIC / REFERENCE / CONJECTURE, kill conditions attached to
every proposed mechanism, references precise enough to locate the lemma.
Companion artifact: `probe_c3_stacked_current.py` (oracle for finding
3.1; residuals at 1e-15, counterexample check included).

Summary of value density, highest first: C3 is solved (two-line proof +
oracle). C1 gets a structural repair that explains the five prover
failures and routes around them. C2 gets the classical name for its
question (plus-operators), three construction routes, and a sharpened
conjecture that converts the positivity question into a background
stratification. C4 gets a reframing (Bargmann-flatness) with a
pre-registered kill test. C5–C7 get honest scoping plus the specific
literature that exists.

---

## C1 — the forest-counting injection

**1.1 Diagnosis of the five failures. [HEURISTIC, from the failure
pattern]** The intended proof injects into flat words (orderings of n
objects) and recovers the data by parsing. Injectivity of a
concatenation map is a prefix-code property: block boundaries in a flat
word are not locally recoverable, so the parse needs global
well-founded recursion whose correctness interleaves with the
tie-breaks. That is the single worst proof shape for current provers —
the case analysis explodes exactly where the canonical-least-root and
increasing-children rules interact. The repair is: do not parse.

**1.2 The repair: factor through structured data ("factor, don't
parse"). [THEOREM-shape, three reusable lemmas]** Strengthen the
codomain so injectivity is componentwise:

- **Lemma A (multinomial concatenation, data-independent).** There is a
  bijection between S_n and the sigma-type
  `Σ (B : ordered set partition of [n] with size vector m), Π_j (linear
  orders on block B_j)`, given by concatenation. Proved once, no
  program content. In Lean: an `Equiv` whose inverse is defined
  structurally (the partition IS part of the data, so no boundary
  recovery is ever needed); cardinality side is `Nat.multinomial`.
- **Lemma B (free S_k-action; kills the equal-size trap).** Ordered set
  partitions with size vector m biject with (canonically ordered
  unordered partitions) × S_k, where the canonical order is by least
  element (`Finset.min'`). The action is free because distinct blocks
  are distinct *sets* — equal sizes m_i = m_j cause no collision. I
  suspect prior attempts bled here: tie-breaking equal-size blocks
  inside a word is painful; tie-breaking sets by their minimum is one
  lemma.
- **Lemma C (the only program-specific step).** Inject the fiber into
  canonically-ordered partitions (+ whatever residual structure, e.g. a
  parent function for the forest, canonicalized by increasing-children).
  All the Penrose-specific content lands here, but now on structured
  data (finsets and functions), not words.

Composing: `Fiber × S_k × Π_j S_{m_j} ↪ Σ-type ≃ S_n`, giving
`|fiber| · k! · Π m_j! ≤ n!` with no parsing anywhere. KILL CONDITION:
if the fiber is not constant over the S_k × Π S_{m_j} orbit, Lemma C is
malposed — but the brief asserts fiber constancy, so this should be
safe; verify on two orbit representatives before investing.

**1.3 Injection-free alternatives. [REFERENCE]**
- Exact forest count: the number of linear extensions of a rooted-forest
  poset on n vertices is `n! / Π_v s_v` (s_v = size of the subtree at
  v). Knuth, TAOCP vol. 3, §5.1.4, exercise 20; q-analog in Björner &
  Wachs, "q-hook length formulas for forests," J. Combin. Theory A 52
  (1989) 165–187. If the fiber is linear-extension-shaped, the
  inequality becomes an identity plus `Π_v s_v ≥ Π_j m_j` (roots'
  subtrees), which is termwise.
- Where this bookkeeping is done carefully in the cluster-expansion
  literature: W. G. Faris, "Combinatorics and cluster expansions,"
  Probability Surveys 7 (2010) 157–206 — the most explicit
  forest/tree map bookkeeping in print; Fernández & Procacci, Comm.
  Math. Phys. 274 (2007) 123–140; Poghosyan & Ueltschi, J. Math. Phys.
  50 (2009) 053509. Check Faris first: his maps are stated at
  injection-level precision.
- Reformulation avoiding Penrose counting entirely: the
  Brydges–Kennedy–Abdesselam–Rivasseau forest interpolation formula
  (Abdesselam & Rivasseau, "Trees, forests and jungles: a botanical
  garden for cluster expansions," in Constructive Physics, Springer
  LNP 446, 1995). It is an exact algebraic identity, but it carries
  [0,1]-interpolation integrals — probably *worse* for Lean than the
  combinatorial route. Noted for completeness, not recommended.

---

## C2 — constraint-compatible representatives (the positivity crux)

**2.1 The classical name for your question. [REFERENCE]** "Operators in
an indefinite-metric space mapping the nonnegative cone into itself"
is the theory of **plus-operators** (M. G. Krein & Yu. L. Shmul'yan,
"Plus-operators in a space with indefinite metric," Amer. Math. Soc.
Transl. (2) 85 (1969) 93–113; systematic treatment in Azizov &
Iokhvidov, *Linear Operators in Spaces with an Indefinite Metric*,
Wiley 1989, ch. on plus- and B-plus-operators; background: Bognár,
*Indefinite Inner Product Spaces*, Springer 1974; Iohvidov, Krein &
Langer, Akademie-Verlag 1982). Gate S1-CC in this language: **does the
GL-torsor of representations contain a plus-operator relative to the
physical cone?** The classification of strict/focusing plus-operators
is exactly the structure theory you want to import. For spectral-side
control the keyword is **definitizable operators** (H. Langer, in
Springer Lecture Notes in Math. 948 (1982) 1–46); in a Pontryagin
space every J-s.a. operator is definitizable — your finite setting is
automatically in the good class.

**2.2 Three construction routes, ordered by fit. [HEURISTIC each, with
kill conditions]**
- **(i) BRST/cohomological descent (recommended first).** You already
  hold finite Kugo–Ojima (T-F3): H(Q) = ker Q / im Q carries a
  canonically nondegenerate form. Weaken S1-CC from "L preserves V′"
  to the chain-map condition **[Q, L] = 0 on ker Q (or [Q, L] Q-exact)**;
  then L descends to H(Q) and [ψ, Q_C ψ] = [Lψ, Lψ] descends with it.
  Chain-map conditions are linear in L and interact well with the
  torsor: on the stacked form (see C3) the constraint set
  {A†B = −K/2} is a quadric, and quadric ∩ linear-subspace is decidable
  numerically on your small models (least squares / Gröbner) the day
  the sector is transcribed. KILL: if the intersection is empty on the
  smallest nonvacuous Gupta-Bleuler witness you already have, the
  route is dead there and the stratification conjecture 2.3 takes over.
- **(ii) Group averaging / refined algebraic quantization.** For
  compact (a fortiori finite) gauge groups the rigging map
  η = ∫ dg U(g) is exact finite-dimensional machinery; the physical
  form is [ψ, ηφ], and compatibility becomes [L, η] = 0, i.e. gauge
  invariance of L. Reference: Giulini & Marolf, "On the generality of
  refined algebraic quantization," Class. Quantum Grav. 16 (1999)
  2479–2488. CAVEAT/KILL: on a *fixed* background the gauge action
  moves the links, so the honest averaging group is the background's
  stabilizer, generically trivial; this route works if your V′ is
  defined by averaging over the constraint group action on states (the
  Gauss picture), and fails if V′ is the fixed-background Witt sector.
  Decide which V′ you mean before spending here — the two readings
  give different S1-CC problems.
- **(iii) Positive deformation within the torsor.** Compatibility need
  not hold at the base point A = 1. The freedom is a GL-torsor (per
  face-pair slot after C3); pose "find A with L_A V′ ⊆ V′" as the
  linear-in-(A,B) system on the quadric. Small-model numerics first.
  KILL: torsor ∩ compatible = ∅ certified by rank computation.

**2.3 The sharpened conjecture: positivity as background
stratification. [CONJECTURE, pre-registered shape]** Your own P-CHI
physics predicts the answer is background-dependent, not uniform:
*[ψ, Q_C ψ] ≥ 0 on V′/N holds iff the physical-sector chiral index of
the background vanishes; on index-carrying backgrounds the restricted
form is necessarily indefinite* (sector Lichnerowicz: PSD closure would
rigidify ker D against the index your protection theorems force). This
converts C2 from yes/no into a stratification, makes the "no-go would
be valuable" branch precise, and *couples it to your kernel-checked
McKean–Singer family* — the trade-off statement you asked for is: the
same negative directions that obstruct positivity are the ones that
create the near-zero modes the condensate needs. KILL (cheap, one day
after V′ transcription): an index-0 background with indefinite
restricted form, or an index-carrying background with PSD restricted
form; either falsifies the stratification.

---

## C3 — multi-direction closure representation: SOLVED

**3.1 Theorem (exact square in any number of directions, no
compensator). [THEOREM; oracle-pinned 6.5e-15]** The pre-registered
compensated form is unnecessary. Let W = C^{P} ⊗ V with one slot per
transport pair p = (μ<ν) (P = #pairs), Krein structure J_W = I_P ⊗ J.
Define the **face-pair-stacked rectangular current** L : V → W with
slot components

```
L_{μν} = c(α_μ) ⊗ 1 + c(α_ν) ⊗ (−K_{μν}/2),    K_{μν} = [∇_μ, ∇_ν].
```

Then L^♯L = Σ_p L_p^♯ L_p = −Σ_{μ<ν} b_{μν} ⊗ K_{μν} = Q_C exactly.
Proof: per slot, the d = 2 computation verbatim — diagonal blocks die
by c(α)² = 0; with X = 1†·(−K_{μν}/2) skew (K_{μν}† = −K_{μν}), the
symmetric (aperture-shaped) part X + X† vanishes identically and the
antisymmetric part gives −K_{μν}; distinct slots cannot interfere
because they land in orthogonal components of W. Two lines.

**3.2 Why the worry arose, and the moral. [HEURISTIC]** Cross-pair
contamination is real but is an artifact of demanding a *square*
(single-slot) current: the oracle's naive single-slot sum misses Q_C by
‖R‖ ≈ 53 on the d = 3 test while the stacked current is exact to
1e-15. The brief's own phrase "rectangular closure current" was already
the correct notion; rectangularity is not a technical concession but
the mechanism. Physical bonus: the codomain is literally
(face-pairs) ⊗ V — one current per face, which is the shape the
program's closure intuition always wanted, now in the correct
off-diagonal (non-site-local, P1-compliant) form.

**3.3 Consequences.** (i) The C2/S1-CC question is now per-slot:
descent needs each L_{μν} compatible, and the torsor freedom is
per-slot GL plus J_W-isometries mixing slots — strictly more room for
route 2.2(iii). (ii) Retire the compensated-form conjecture as
pre-registered (killed in the good direction). (iii) Lean ladder rung:
the statement is finite algebra over your existing Clifford/Krein API;
transcribe the d = 2 lemma once, sum over slots. KILL CONDITION: none
remaining at finite level — the identity is exact; only the
transcription against pinned conventions (the ♯-normalization carrying
the 4's) can fail, and that is mechanical.

---

## C4 — the invariant behind symmetry-forced zero modes

**4.1 Reframing: the invariant is Bargmann-flatness, not a walk
topology. [CONJECTURE, with a precise kill test]** For a cycle of
edge maps t_{i,i+1} built from celestial directions n_i, decompose the
transfer by the Z_V symmetry (exact finite Bloch decomposition; sector
phases ω^m). The pinned unit eigenvalue in the aligned sector exists
iff the product of the edge couplings around the loop equals the
**Bargmann invariant** of the direction sequence,
`Δ = ⟨n_1|n_2⟩⟨n_2|n_3⟩···⟨n_V|n_1⟩`, whose argument is the
Pancharatnam/Berry phase (−Ω/2, Ω the solid angle). That is exactly a
codimension-1 relation between amplitude data and holonomy — matching
your finding that abstract decorations need a codim-1 locus — and
overlap-normalized geometric decorations satisfy it *identically*
(dividing by the full complex overlap locks modulus and phase to the
same Bargmann datum), which is why "any cone" works with no
quantization condition on Ω. The theorem class to state: *a
Z_V-equivariant Pancharatnam-flatness criterion for exact quasi-energy
pinning on closed decorated cycles*. References for the invariant:
Bargmann, J. Math. Phys. 5 (1964) 862; Mukunda & Simon, Ann. Phys. 228
(1993) 205–268; Rabei, Arvind, Mukunda & Simon, Phys. Rev. A 60 (1999)
3397 (null phase curves — the geodesic-edge case where edge phases
vanish and everything sits in the holonomy).

**4.2 Why the walk literature is adjacent but not it. [REFERENCE]**
Kitagawa–Rudner–Berg–Demler PRA 82 (2010) 033429; Asbóth PRB 86 (2012)
195414; Asbóth–Obuse PRB 88 (2013) 121406(R); Asbóth–Tarasinski–
Delplace PRB 89 (2014) 075133 classify 0- and π-quasienergy *boundary*
states via chiral/particle-hole indices; Cedzich et al., Ann. Henri
Poincaré 19 (2018) 325, is the index theory for symmetric walks. Your
phenomenon is decoration-forced pinning on a *closed* loop — a
symmetry-locked constraint, not a bulk-boundary index. The one piece
of that toolbox worth keeping: SU(2) pseudoreality gives an antiunitary
θ = iσ_y K commuting with frame transports, so spectra are closed
under conjugation (Kramers pairing) — this explains the ± pairing of
near-zero modes for generic decorations but cannot alone force
exactness, consistent with your measurements.

**4.3 Pre-registered kill test.** Compute, for your celestial
decorations, δ := (product of edge couplings) − (Bargmann invariant of
the direction sequence). Prediction: δ ≡ 0 identically on the
symmetric-cone family, and perturbing the decoration to δ ≠ 0 at fixed
geometry detaches the exact mode continuously (near-zero, not zero).
If instead the exact mode survives δ ≠ 0, finding 4.1 is wrong and the
invariant is elsewhere (then look at equivariant spectral flow /
Atiyah–Bott fixed-point structure on the cyclic group action).

---

## C5 — is any honest mass-VALUE route alive?

**5.1 Verdict: yes, exactly one sector — neutrino mass-squared
ratios. [HEURISTIC + REFERENCE]** The Sumino bar (Y. Sumino, Phys.
Lett. B 671 (2009) 174; JHEP 0905 (2009) 075) exists because charged-
lepton pole masses run electromagnetically and Koide's Q = 2/3 holds at
the per-mille level for *pole* masses — any finite mechanism must
explain why radiative corrections respect it. Neutrinos evade the bar
structurally: Δm² ratios are RG-stable below the seesaw scale (tiny
Yukawas; only quasi-degenerate spectra run appreciably), the observable
IS a ratio (absolute scale unknown), and pole-vs-running ambiguity is
absent. A finite program that produces cycle-geometry spectra should
pre-register against: r = Δm²_21/|Δm²_31| ≈ 0.030 (NuFIT global fits;
verify the current value at test time), plus mass ordering. Note the
discipline works immediately: the natural spectrum {0, 1, 2} gives
r = 1/4 — dead on arrival; sin(πk/N) families give scannable
predictions. That instant falsifiability is the *good* sign.

**5.2 What to avoid. [HEURISTIC]** Quark-sector Koide analogs are
scheme-dependent (running masses at what scale?) — dishonest at finite
level. Mixing-angle predictions from Z_V decorations land you in the
crowded discrete-flavor-symmetry field (Altarelli & Feruglio, Rev. Mod.
Phys. 82 (2010) 2701; King & Luhn, Rep. Prog. Phys. 76 (2013) 056201);
enter only with a prediction that discriminates your mechanism from
A4/S4 model space. Otherwise: structural statements (multiplicity menu
{1,3}, protection theorems) plus the single neutrino-ratio probe is the
honest portfolio. KILL for any proposed ratio mechanism: state the
predicted (r, ordering) pair before computing; a post-hoc fit counts
as killed.

---

## C6 — realistic continuum theorem classes

**6.1 The strongest available class: norm-resolvent convergence of
discretized Dirac operators, in the quasi-unitary framework.
[REFERENCE + recommendation]** Two anchors: (i) Cornean, Garde &
Jensen have proved norm-resolvent convergence of standard lattice
discretizations of Dirac operators to the continuum operator (their
program on discrete approximations and norm-resolvent convergence,
J. Fourier Anal. Appl. 27 (2021) for the multiplier machinery and the
companion Dirac paper — verify exact venue against full text per your
protocol); this is precisely "spectra, gaps, and functional calculus
converge on compact sets" with no measures and no constructive QFT.
(ii) The right abstract home for your quotient-then-limit ladder is
**quasi-unitary equivalence** between varying Hilbert spaces: O. Post,
*Spectral Analysis on Graph-Like Spaces*, Springer LNM 2039 (2012) —
identification maps J_ε with ‖J_ε ψ‖ ≈ ‖ψ‖ and resolvent intertwining
up to ε; it is built for exactly the situation "different spaces at
every refinement level," and gives spectral convergence as a package
theorem. Recommendation: define the R-ladder rungs AS quasi-unitary
equivalences; then each background-carrier convergence statement is one
verification of the Post axioms, and gap semicontinuity comes for
free. Adjacent support: Nakamura & Tadano, J. Spectral Theory 11
(2021) (discrete Schrödinger → continuum); Exner–Post graph
convergence series.

**6.2 What not to target. [HEURISTIC]** Gromov–Hausdorff-type
convergence is metric-measure technology — it forgets gauge and Krein
structure and buys nothing here. Categorical colimits of transfer data
are a fine *organizing* language but prove no spectral statement by
themselves; use them to state the ladder, not as the theorem.
Everything statistical (interacting measures in the limit) stays
behind P7, as your rules already say. KILL for 6.1 on your setting:
the Krein (non-self-adjoint in Hilbert sense) carrier may leave the
Cornean–Garde–Jensen hypotheses; the honest first rung is the
background/flat carrier where D is normal, then Kato-perturb within a
fixed refinement level. If even the flat rung fails quasi-unitarity,
the ladder needs new identification maps before any continuum sentence
is uttered.

---

## C7 — discrete torsion split of the gravity channel

**7.1 Make the split a Pythagoras theorem, not a symmetry guess.
[HEURISTIC, mirrors your own P9 move]** P4 died because "torsion" was
identified by antisymmetry alone. Define instead the split by
*orthogonal projection in the same pairing that E's contraction uses*
(exactly how the P9 branch turned four regimes into Hodge summands):
let 𝔅 be the space of soldering-difference bilinears with the
contraction inner product; T := antisymmetric projection, S := its
orthogonal complement piece. Then `2E = C(T) + C(S)` is exact *by
orthogonality* whenever the cross contraction vanishes — and the
theorem to prove is that the cross term C(T,S) vanishes under a stated
hypothesis (translation-regularity + a reflection symmetry killing
odd contractions is the natural candidate; pre-register it). If the
cross term does not vanish, report the three-term identity
`2E = C(T) + C(S) + C(T,S)` honestly — a finite trinity with an
interaction term is still a theorem; forcing two terms was P4's
mistake.

**7.2 The right discrete contorsion. [HEURISTIC + REFERENCE]** Define
the discrete Levi-Civita part of a transport by **polar
decomposition** of the soldering transfer (the nearest
metric-compatible map), and contorsion as the deviation
K_e := ∇_e ∘ (∇_e^{pol})^{-1}. Polar decomposition is finite, exact,
and Lean-tractable (Mathlib has `Matrix.polarDecomposition`-adjacent
SVD infrastructure), and it reproduces the continuum definition
(connection = LC + contorsion + disformation) in the trinity
normalization. References: Beltrán Jiménez, Heisenberg & Koivisto,
"The Geometrical Trinity of Gravity," Universe 5 (2019) 173;
Bahamonde et al., Rep. Prog. Phys. 86 (2023) 026901 (review with the
1 : 1/2 : −2 torsion-scalar coefficients you want to *derive*, not
assume). Discrete precedents are thin, which is good for you:
Caselle, D'Adda & Magnea, "Regge calculus as a local theory of the
Poincaré group," Phys. Lett. B 232 (1989) 457 (torsion on simplicial
complexes via Poincaré gauge); discrete-connection machinery: Crane,
Desbrun & Schröder, "Trivial Connections on Discrete Surfaces," Comput.
Graph. Forum 29 (2010); DEC foundations: Hirani, PhD thesis, Caltech
2003; Desbrun–Hirani–Leok–Marsden, arXiv:math/0508341. KILL for 7.1:
compute C(T,S) on your existing P-probe decoration (the Z_N×Z_N
zero-torsion, nonzero-E witness that killed P4) — if the cross term is
nonzero even under the reflection hypothesis, the two-term trinity is
dead and the three-term identity is the deliverable.

---

## One-paragraph close

The stacked-current theorem (3.1) removes the last *algebraic* obstacle
between the closure channel and its "mass is transported disagreement"
reading in any number of directions: gauge-shaped mass is now, exactly
and for any compact group, the Krein square of a face-indexed
disagreement current — with the entire remaining question being C2's
plus-operator/compatibility problem, for which the classical theory,
three construction routes, and an index-stratification conjecture are
laid out above with their kill conditions. C1's repair is a proof-
engineering claim, not mathematics: factor the injection through
ordered set partitions and the five-times-fatal parse disappears. C4,
C5, C6, C7 each get one sharp reframing (Bargmann-flatness; neutrino
ratios as the only Sumino-proof value target; quasi-unitary equivalence
as the ladder's ambient definition; Pythagoras-defined trinity) — every
one with a cheap pre-registered test that can kill it.
