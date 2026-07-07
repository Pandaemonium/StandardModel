# Q9 memo: horizons, entropy, and the boundary of the E-slot

## 0. Verdicts first

**V0 (section-5 audit).** I found no section-5 verdict that Q9 forces me to overturn. I do demolish one presupposition of the *question itself* (the Borchers–Wiesbrock half of the addendum, V6) and one of its suggested definitions (V1).

**V1 (area).** The suggested definition — "edge counting weighted by |alpha_e|-type data" — is **ill-posed**, by your own kernel lemma: a lone null edge is massless and scaleless; a null covector has no invariant norm. There is no invariant single-edge weight. The repair is exact and kernel-ready today: **area is relational, exactly as mass is** — it is the *polarization of the aperture form against the cut's screen direction*, A_N(S) = tr(adj(P_S) N), which for a null screen chi is the wedge-weighted pierced-edge count Sum_e |chi ^ psi_e|^2. It is *not* Q_A restricted to the cut; the restriction det P_S is a different (shear/expansion-type) scalar. This is the first theorem of the family and I state it as Theorem A9.1 below.

**V2 (entropy).** Theorem-shaped, but only on the physical sector: **the domain of definition of cut entropy is exactly 5a's positivity domain** — ghosts (real-split planes) make entropy undefined, not merely wrong. Two tracks: an *exact finite theorem* (edge-mode/holonomy decomposition, Donnelly–Casini-Huerta-Rosabal combinatorialized) and a *Gaussian/Sorkin-Johnston track* whose area law is a conjecture with a loud, program-specific kill: the causal-set precedent (Sorkin–Yazdi) shows discrete SJ entropy generically goes **volume-law** through nonlocal near-zero modes, and your doubler lines (5c) are precisely the analog. "Universal coefficient" as posed is false (species problem); what can be universal is the ratio (V3).

**V3 (coefficient).** The 1/4 splits cleanly: **the 2pi is a finite theorem candidate (modular), the 1/(4G) is a convention** (the same normalization freedom as Newton's constant in Q2, equivalently the chi-scale of the screen). The entire content is one identity, which is also where Q4 and the addendum land: **discrete Bisognano–Wichmann at a cut (BW_cut)**. Species independence = Lemma-0 redecoration invariance; the pre-registered failure channels are edge modes (finite Kabat contact term) and the sign characteristic at the cut.

**V4 (first law / Jacobson).** delta S = delta<K> is a *free, unconditional finite theorem* (Klein's identity). The Jacobson upgrade decomposes into four rungs, of which two are kernel-ready, one is BW_cut, and one is a per-complex rank computation. Honest assessment: **yes, finite Jacobson can be a theorem family**, easier than the continuum in that "all cuts" is a finite family and no local-equilibrium idealization is needed, harder in that BW is a theorem for continuum wedges but a conjecture here. Registered structural prediction: the derivation determines field equations **only modulo the harmonic cohomology of the bookkeeping cochain — Lambda is the entanglement blind spot**, converging exactly with your P9 Hodge branch.

**V5 (Wilson bridge).** Real but narrow: the string tension and the strong-coupling cut entropy are **two different functionals (free energy vs. Shannon entropy) of one local plaquette measure** — common origin, no identity, and the Wilson loop lives in the Q_C block while horizon entropy lives in the soldering/boundary sector; Lemma 0 formally forbids transporting the result across slots. Use it as the exactly solved testbed for the Track-1 entropy theorem, never as evidence. The sentence "our kernel area law is a horizon-entropy result" must not be written.

**V6 (addendum, flagged loudly).** The Tomita–Takesaki half of the modular route is fully available and explicit in finite dimensions; BW_cut is well-posed and decidable on your 2+1 torus witness. But the Borchers–Wiesbrock half is **provably vacuous at finite dimension**: any finite-dimensional realization of the half-sided modular commutation relation with positive translation generator forces the generator to vanish (one-line trace argument, Theorem A9.4). Null-translation generation from modular flow is strictly a continuum phenomenon; the discrete ANEC survives anyway, riding on Lindblad monotonicity (a finite theorem) + BW_cut + a decidable discrete Markov property, with no inclusions needed.

---

## 1. The area operator (Q9.1)

Work in the soldered picture: pierced edges e in S carry rank-one positive Hermitian bispinors P_e = psi_e psi_e^dagger; P_S = Sum_{e in S} P_e. A **screen** is a positive semidefinite Hermitian 2x2 matrix N (the soldered cut normal); null screens N = chi chi^dagger are the extreme rays of the screen cone, and every screen is a convex combination of null ones (A_N below is linear in N, so null screens suffice).

**Theorem A9.1 (area = screen polarization of the aperture form). [kernel-ready; 2x2 linear algebra throughout]** Define

  A_N(S) := tr( adj(P_S) N ),  adj(X) := (tr X) I - X.

Then:
(i) *(additivity)* A_N(S) = Sum_{e in S} [ tr P_e tr N - tr(P_e N) ] — a sum of per-edge, screen-relative weights;
(ii) *(first variation of mass)* A_N(S) = d/dt det(P_S + t N) |_{t=0}; in fact exactly, by 2x2 speciality, A_N(S) = det(P_S + N) - det(P_S) - det(N);
(iii) *(wedge form)* for N = chi chi^dagger: A_N(S) = Sum_e |chi ^ psi_e|^2, and A_N(S) = det(P_S + chi chi^dagger) - det(P_S);
(iv) *(positivity and degeneracy)* A_N(S) >= 0; for a null screen, A_N(S) = 0 iff every pierced psi_e is projectively collinear with chi — **a cut tangent to the generators has zero area**;
(v) *(invariance)* A_N(S) is invariant under simultaneous SL(2,C) on screen and edges, additive over disjoint pierced sets, and invariant under redecorations supported off the cut.

Physical reading, in your house style: **a null congruence has no area of its own; the area of a cut is the mass the pierced bundle would acquire, to first order, from one quantum of the screen's null direction.** Area is relational for the same reason mass is — it is the *mixed* term of the same quadratic form det.

This answers the sub-question exactly: "area of a cut" is **not** Q_A restricted to the cut's edges. The restriction, det P_S = Sum_{e<f in S} |psi_e ^ psi_f|^2, is the *internal* disagreement of the pierced generators — a discrete expansion/shear scalar, i.e. Raychaudhuri fodder, not area. Both live in one form: restriction = diagonal value; area = polarization against the screen. This division of labor is itself the theorem's virtue: the discrete Raychaudhuri identity (needed for Q4) should be the statement that the step-derivative of A_chi along the generator flow equals a bilinear in the wedges controlled by det P_S plus the 5b telescoping density Phi (torsion + drift). **[STRATEGY; kernel target: "discrete Raychaudhuri = d(A9.1)/d(step), source = 5b's Phi."]**

Two honesty notes. (a) Dimension: wedge-squares carry mass^2; A_chi is geometric area only *in the emergent metric*, which by 5b/5c is itself the wedge Gram — metric and area come from one object, with one common scale ambiguity (chi-rescaling: A_{c chi} = |c|^2 A_chi). This is the Newton's-constant slot, not a defect; see Q3. (b) Redecorations *at* the cut act jointly on (chi, {psi_e}) and are the finite corner/edge-mode ambiguity — pre-register it; it is the same ambiguity Donnelly–Wall resolved in the continuum, and it resurfaces in Q3 as a failure channel. Prior art for the shape of A9.1(iii): Dou–Sorkin's "entropy = number of causal links crossing the horizon" — your functional is the decorated (wedge-weighted, screen-relative) refinement of their link counting.

## 2. Entropy across a cut (Q9.2)

**Domain statement first (this is a theorem-grade constraint, not hygiene):** entanglement entropy requires a state on a positive-definite physical sector. By 5a, that sector exists iff the Witt condition b + r = q holds; a real-split plane anywhere in the cut's constraint span makes the Sorkin eigenvalues complex and entropy *undefined*. So **the entropy functional's domain is exactly 5a's positivity domain — the ghost problem and the entropy problem are one wall.** Every theorem below carries (H0): 5a hypotheses hold on X, A, B; the finite Ward identity holds so D descends.

**Track 1 (exact finite theorem; gauge/flat sector).**

**Theorem shape A9.2|H (cut decomposition).** Hypotheses: (H0); (H1) the cut algebra is defined in the extended-Hilbert-space / electric-boundary convention; (H2) the global state Omega lies in the flat sector, parametrized by holonomy data. Conclusion: the reduced state on A decomposes over cut-holonomy superselection sectors r, and

  S(A) = H(mu) + Sum_r mu(r) log d_r + Sum_r mu(r) S_bulk(r),

with mu the induced distribution on cut sectors — a functional of the cut alone. **Corollary (counting area law, exact):** if mu is a product measure over pierced edges — precisely the strong-coupling regime of your kernel Wilson-loop machinery — then S(A) = s_0 x #{pierced edges} *exactly*, s_0 the per-edge Shannon-plus-log-dimension entropy. This is Donnelly / Casini–Huerta–Rosabal combinatorialized; it is finite, provable, and the cheapest kernel entry of the whole memo. Note the coefficient multiplies **counting measure, not the wedge measure of A9.1** — that mismatch is not a bug; it is the species-problem data that Q3 must metabolize.

**Track 2 (Gaussian / Sorkin–Johnston).** Definitions, all finite: Pauli–Jordan form Delta = retarded minus advanced inverse of the carrier (exists per 5c's retarded regulator); SJ two-point form W = positive part of i·Delta *in the physical inner product* (needs H0); cut entropy by Sorkin's spectral formula

  S(A) = Sum lambda ln lambda over solutions of W|_A v = i lambda Delta|_A v on Im(Delta|_A),

eigenvalues pairing lambda <-> 1 - lambda. Kernel-ready lemmas: well-definedness under H0; S(A) = S(B) for a globally pure SJ state. Then:

**Conjecture C-A9.3 (wedge area law).** Under (H0) + (h1) the carrier gapped on the physical sector except index-protected modes + (h2) doubler modes removed by the quotient (GW descent; open item 6) + (h3) the cut is null-generic (no pierced edge has vanishing wedge with the screen — see the finite Reeh–Schlieder lemma in section 6): S(A) = s_1 A_chi(S) + lower order, with s_1 a function of local cut-decoration statistics (NOT universal across complexes — the species problem is real; universality lives only in the Q3 ratio).

**Registered kill (the sharpest in Q9):** Sorkin–Yazdi found that naive SJ entropy on a causal set is **volume-law**, driven by a swath of nonlocal near-zero modes of i·Delta, with area law recovered only after truncation. Your carrier is local where the causal-set d'Alembertian is not — but your doubling partners (5c: *lines* of gapless modes on the Brillouin torus) are the structural analog of that swath. If the physical quotient does not delete the doublers from the (W, Delta) generalized eigenproblem, cut entropy goes volume-law and this branch of the horizon program dies. This welds Q9 to open item 6 ("doubler relocation vs. the quotient") as a single gate.

**Registered prediction (index-log term):** index-protected massless modes are the discrete analog of gapless fermions, which produce log-enhanced area laws (Gioev–Klich, Wolf). Prediction: balanced complexes (ind = 0) show a pure area law; unbalanced complexes show S = s_1 A + c·ind(D)·log A + ..., the log coefficient a central-charge shadow of the index. Decidable numerically on small complexes; a clean, cheap falsifier linking the index machinery to entropy.

## 3. The coefficient (Q9.3)

Decompose the 1/4 honestly:

1. **2pi is kinematics.** Once BW_cut holds (section 6), the modular temperature is 2pi by definition of modular flow — in finite dimensions Delta is an explicit matrix and nothing is asymptotic.
2. **1/(4G) is a convention.** G is *defined* by the normalization of the telescoped boundary functional (5b), and the chi-rescaling covariance |c|^2 is common to both the entropy density and the boundary-action density, so it cancels in the ratio. There is no independent coefficient to derive.
3. **The content is one identity.** The lock is:

  **BW_cut (Conjecture, the load-bearing square):** log Delta_{omega, M_A}, restricted to the one-particle physical space, equals 2pi K_S, where K_S is the J-self-adjoint boost generator of the cut soldering (the polar-boost part of the cut transports, wedge-weighted).

Given BW_cut, delta S = delta<K> (Q4, unconditional) turns entropy variation into 2pi x (wedge-weighted aperture flux through the cut), and the ratio to the boundary functional is fixed *for every complex simultaneously*. Species independence is then exactly **Lemma 0**: both sides are functionals of the same redecoration-invariant total-trace data; a decoration species shifts entropy and boundary action identically — the finite avatar of the Susskind–Uglum / Cooperman–Luty renormalization resolution.

Sharpest finite identity (schematic, as licensed): let Z(theta) be the invariant total trace with a Krein-unitary conical defect U_S(theta) inserted along the cut. Then (a) the boundary gravitational density is the response d^2/dtheta^2 log Z at 0, and (b) S = (1 - theta d/dtheta) log Z at theta = 2pi (Callan–Wilczek). One family, both coefficients; Lemma 0 makes Z decoration-covariant; the ratio is calculus. **Where analysis smuggles in:** the replica continuation in theta/n — avoidable on the entropy side (Sorkin/Peschel formulas are direct), so I recommend the modular route as primary and the defect family only as a cross-check.

**Failure channels (pre-register all three):** (f1) *edge modes* — Track 1's Shannon term has no counterpart in a naive boundary functional (the finite Kabat contact term); the repair is to extend the discrete Gibbons–Hawking functional by the cut-holonomy measure, i.e. a finite Donnelly–Wall; (f2) *sign characteristic* — if U_S(theta) is not implementable as a vertex-local Krein unitary (the 2pi rotation can hit the mod-2 KO wall for pseudoreal fibers, 5d), block-trace non-invariance leaks decoration dependence and the species problem returns *as sign-characteristic dependence* — this would be a genuinely new form of the species problem, worth a paper either way; (f3) doubler volume law (kills the ratio wholesale, see Q2).

**Immirzi contrast:** in LQG the area spectrum carries a free parameter gamma fixed a posteriori by entropy counting. Here there is no analogous free parameter *if* the emergent metric is the wedge Gram: metric, area, and entropy all draw on one Gram with one scale, already spent on G. "No independent Immirzi" is a claimable structural advantage — conditional, and only after (f1)–(f3) are cleared.

## 4. First law and the Jacobson upgrade (Q9.4)

**R1 (theorem, unconditional, kernel-transcribable in a weekend).** For any differentiable family of full-rank finite-dimensional states, delta S = tr(delta rho · K), K = -log rho (Klein's identity; tr delta rho = 0). Applied to reductions of a pure state: the finite first law of entanglement, delta S(A) = delta<K_A>. Free.

**R2 (the square).** BW_cut: K_A one-particle part = 2pi K_S, localizing K on the cut. All the physics is here. Continuum calibration of optimism: exact locality of modular Hamiltonians holds for wedges (Bisognano–Wichmann) and — crucially for you — for **null cuts**, where modular Hamiltonians are local integrals of T_{++} and the vacuum is Markov (Wall; Casini–Testé–Torroba). Your cuts are natively null. The conjecture is placed exactly where continuum theory says exact locality lives. Its finite kill is a matrix computation on the 2+1 torus witness: if log Delta has one-particle matrix elements far from the cut that no redecoration removes, the exact form dies and only a gap-rate-decay version survives.

**R3 (discrete Raychaudhuri; kernel target).** The step-derivative of A_chi along the generator flow = -(quadratic in internal wedges, controlled by det P_S) + Phi-flux (5b's corrected telescoping density). This is the slot Jacobson's continuum argument fills with the Raychaudhuri equation; 5b's telescoping ladder is literally the Bianchi/Raychaudhuri sector of this derivation.

**R4 (rank condition; decidable per complex).** Demanding delta(A_chi/4G) = delta S for a family of cuts imposes linear conditions on decoration variations. Statement shape: if the cut-flux map (variations -> first-law defects over the cut family) has cokernel spanned by the variational equations of the telescoped functional, then those field equations follow. Whether the finite cut family *spans* is a rank computation — per complex, decidable, and honestly the place where finite Jacobson could be true-but-weak (too few cuts, too little forced).

**Assembled verdict:** finite Jacobson = R1 (T) + R2 (C) + R3 (kernel target) + R4 (decidable), conclusion T|H shaped. It is *more* theorem-apt than the continuum version in two respects (no local-equilibrium idealization; "for all cuts" is finite) and *less* in one (BW is a wedge theorem in the continuum, a conjecture here). **Structural prediction to pre-register now:** the cut-flux map cannot see the harmonic sector of the bookkeeping cochain, so the derivation fixes field equations only modulo harmonic cohomology — the discrete Lambda ambiguity, exactly your P9 Hodge branch arriving from an independent direction. "Lambda is the entanglement blind spot" is a named, checkable convergence: verify on a small complex that the kernel of the cut-flux map contains, and ideally equals, the harmonic piece.

**Surface gravity [STRATEGY]:** kappa_S := log of the positive eigenvalue of the polar (boost) part of the cut's generator transport, taken in the physical inner product; T = kappa/2pi via BW_cut. Operationally, kappa is the conversion rate between modular parameter and the global tick clock — directly measurable in your tick-counting time-dilation experiment, which thereby becomes a *surface gravity meter*.

## 5. The area law we already have (Q9.5)

Precise verdict: **common origin, different functionals, wrong block — a testbed, not a bridge to gravity.** In the strong-coupling expansion, one local object (the single-plaquette character measure) generates both: the string tension as its log-partition (free energy per tiled plaquette: sigma = -log of the leading character coefficient) and the strong-coupling cut entropy as the Shannon entropy of the boundary flux distribution it induces (exact prior art: Velytsky's strong-coupling expansion of lattice EE; Buividovich–Polikarpov numerically; Klebanov–Kutasov–Murugan for the continuum shadow). Free energy and entropy of one measure are related by thermodynamic identities order-by-order, never equal; no coefficient lock exists or should be sought. And the Wilson loop is a Q_C-sector statistic while the horizon functional lives in the boundary/soldering sector — Lemma 0 (block traces not separately invariant) formally blocks reading one as the other. Legitimate uses: (i) the strong-coupling product measure is the cleanest sandbox in which to kernel-check Theorem A9.2's corollary first (i.i.d. cut distribution, exact counting area law); (ii) the confinement-transition-in-EE literature as the continuum control. The resemblance to Ryu–Takayanagi minimal surfaces is superficial here (no holographic bulk); do not anchor on it.

## 6. The modular route (addendum): the first rung, and a no-go

Finite Tomita–Takesaki is explicit: for M_A = B(H_A) tensor 1 and pure full-rank Omega, Delta = rho_A tensor rho_B^{-1}, J = (modular conjugation), sigma_t = conjugation by rho_A^{it} tensor rho_B^{-it}. So the addendum's first rung is genuinely decidable-shaped:

**Rung 1 (decidable on the 2+1 torus witness).** Construct V'/N (5a), the SJ Gaussian state, the cut algebra M_A; compute Delta as a matrix; test BW_cut. Two necessary conditions are kernel-ready lemmas *now*:
- **Finite Reeh–Schlieder:** Omega is cyclic-separating for M_A iff the restricted covariance avoids eigenvalues {0,1} iff no pierced edge wedge-decouples from the cut. *Reeh–Schlieder = nonvanishing cut wedges* — a pleasing finite equivalence, and hypothesis (h3) of C-A9.3.
- **Ward compatibility:** modular flow preserves the Krein form on the one-particle space iff the 5a finite Ward identity holds at the cut — the same object again; everything in Q9 lands on V'/N and BW_cut, mirroring the round-1 pattern.

**Theorem A9.4 (T; finite vacuity of half-sided modular structure).** Suppose on a finite-dimensional space Delta^{it} e^{iaP} Delta^{-it} = e^{i e^{-2pi t} a P} with P self-adjoint and P >= 0. Differentiating gives [log Delta, P] = 2pi i P (Borchers' commutation relation); taking the trace, 0 = tr[log Delta, P] = 2pi i · tr P... hence tr P = 0, and P >= 0 forces **P = 0**. (Same skeleton as the Wintner–Wielandt no-finite-CCR argument.) Algebra version: the modular group of a finite-dimensional algebra is almost periodic, so any inclusion N with sigma_t(N) ⊂ N for t >= 0 is sigma-invariant by recurrence — no strict half-sidedness exists.

Consequences, stated bluntly: **null-translation generation via half-sided modular inclusions is strictly a continuum phenomenon.** The finite program may not claim it, and the addendum's second half is demolished as a finite target — which is a success per your own success criterion. It converts into an *emergence criterion* for open item 6: under refinement, the rescaled modular-difference generators (log Delta_{S'} - log Delta_S)/2pi must approach the affine (positive-generator) relation; the failure of A9.4's trace obstruction in the limit is quantifiable (the trace escapes to infinity), giving a numerical diagnostic of "how continuum" a refinement stage is.

**Discrete ANEC without inclusions.** The chain that survives is: (i) Lindblad's monotonicity of relative entropy under restriction — a *finite-dimensional theorem*; (ii) BW_cut for two nested null cuts S ⊂ S', defining the flux F := (K_{S'} - K_S)/2pi; (iii) then, exactly, 2pi<F>_omega >= [S_omega(A) - S_omega(A')] - [S_Omega(A) - S_Omega(A')] — an unconditional finite inequality given (i)+(ii). Pure positivity <F> >= 0 needs the entropy-difference terms controlled, which is the **discrete Markov property**: saturation of strong subadditivity for nested null cuts of the SJ state (the finite shadow of Casini–Testé–Torroba; also the engine inside Wall's GSL proof). That is decidable on small complexes and is the natural E-numbered target after BW_cut.

## 7. Formalization ladder (statement-first)

L1 [kernel-ready]. Theorem A9.1 (i)–(v): the area functional. Pure 2x2 algebra over the existing Layer-K assets.
L2 [kernel-ready]. Finite Reeh–Schlieder lemma: cyclic-separating <=> restricted covariance avoids {0,1} <=> nonvanishing cut wedges.
L3 [kernel-ready]. Theorem A9.4: finite vacuity of the Borchers relation with positive generator (trace argument) + the recurrence corollary for inclusions.
L4 [kernel-ready]. Sorkin-formula bookkeeping: well-definedness of S(A) under H0; lambda <-> 1-lambda pairing; S(A) = S(B) for pure global SJ states. Klein identity delta S = tr(delta rho K).
L5 [finite theorem, medium effort]. Theorem A9.2|H: cut-holonomy decomposition of flat-sector entropy; corollary: exact counting area law for product cut measures (strong-coupling sandbox).
L6 [kernel target]. Discrete Raychaudhuri: step-derivative of A_chi along the flow = -(wedge bilinear) + Phi-flux, in the 5b telescoping normalization.
L7 [decidable computation, gates everything]. BW_cut on the 2+1 torus witness: compute log Delta, compare to 2pi K_S; record locality defects; test redecoration removability.
L8 [decidable]. Discrete Markov property for nested null cuts; then the discrete ANEC chain (Lindblad + L7 + L8).
L9 [numerical falsifiers]. (a) Doubler volume-law scan: does the quotient delete the gapless lines from the (W, Delta) problem? (b) Index-log prediction: S = s_1 A + c·ind·log A on unbalanced complexes, pure area law on balanced ones. (c) Lambda blind spot: kernel of the cut-flux map vs. harmonic cohomology. (d) Species audit: add a decoupled decoration species; verify the Q3 ratio is invariant iff edge modes are included on the action side.

The "first such theorem" the question asks for is L1; the first thermodynamic theorem is L4's Klein identity, which becomes *contentful* exactly when L7 lands; the first no-go is L3.

## 8. Literature anchors

Entanglement origin of horizon entropy: R. Sorkin, "On the entropy of the vacuum outside a horizon," GR10 proceedings 1983 (posted arXiv:1402.3589); Bombelli–Koul–Lee–Sorkin, PRD 34 (1986) 373; M. Srednicki, "Entropy and area," PRL 71 (1993) 666, hep-th/9303048. Jacobson: "Thermodynamics of spacetime," PRL 75 (1995) 1260, gr-qc/9504004; "Entanglement equilibrium and the Einstein equation," arXiv:1505.04753. Entanglement first law / gravity from it: Blanco–Casini–Hung–Myers arXiv:1305.3182; Faulkner–Guica–Hartman–Myers–Van Raamsdonk arXiv:1312.7856. Species/renormalization: Susskind–Uglum hep-th/9401070; Demers–Lafrance–Myers gr-qc/9503003; Kabat, Nucl. Phys. B453 (1995) 281 (hep-th/9503016, unverified number); Cooperman–Luty arXiv:1302.1878. Edge modes: Donnelly arXiv:1109.0036; Casini–Huerta–Rosabal arXiv:1312.1183; Donnelly–Wall arXiv:1412.1895 and 1506.05792. Causal sets: Dou–Sorkin, "Black hole entropy as causal links," gr-qc/0302009; Barton–Counsell–Dowker–Gould–Jubb–Taylor, "Horizon molecules," arXiv:1909.08620 (author list unverified); SJ state: Afshordi–Aslanbeigi–Sorkin arXiv:1205.1296; Sorkin entropy formula arXiv:1205.2953; Saravani–Sorkin–Yazdi arXiv:1311.7146; **volume-law warning:** Sorkin–Yazdi, CQG 35 (2018) 074004, arXiv:1611.10281. Modular: Bisognano–Wichmann, J. Math. Phys. 16 (1975) 985; Borchers, CMP 143 (1992) 315; Wiesbrock, CMP 157 (1993) 83 (with later erratum); null cuts and Markov: Casini–Testé–Torroba arXiv:1703.10656; Wall's GSL arXiv:1105.3445; ANEC from modular theory: Faulkner–Leigh–Parrikar–Wang arXiv:1605.08072; Ceyhan–Faulkner arXiv:1812.04683; monotonicity: Lindblad, CMP 40 (1975) 147. Gapless-fermion log terms: Gioev–Klich quant-ph/0504151; Wolf quant-ph/0503219. Replica/conical: Callan–Wilczek hep-th/9401072; Holzhey–Larsen–Wilczek hep-th/9403108. Lattice gauge EE: Velytsky arXiv:0801.4111; Buividovich–Polikarpov arXiv:0802.4247; Klebanov–Kutasov–Murugan arXiv:0709.2140. LQG contrast: Ashtekar–Baez–Corichi–Krasnov gr-qc/9710007. Coefficient universality: Bianchi–Myers arXiv:1212.5183; Bianchi arXiv:1211.0522. No-finite-CCR skeleton: Wintner, Phys. Rev. 71 (1947) 738; Wielandt, Math. Ann. 121 (1949) 21.

---

Summary in one line: the first horizon theorem is that **area, like mass, is relational** — the screen polarization of the aperture form (L1, kernel-ready today); the entire thermodynamic superstructure then hangs on a single decidable square, BW_cut on the torus witness (L7), with the doubler volume-law scan (L9a) as the kill that must be run before any entropy claim is written down.
