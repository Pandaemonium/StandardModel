# Q10 — Verdict first

**V1 (signature): OUTPUT, theorem grade.** Euclidean signature dies at the first kernel axiom (`c(alpha)^2 = 0` forces alpha null; definite forms have no nonzero nulls). Multi-time signatures die at a *finite frustration lemma*: there is an explicit integer triple of null vectors in R^{2,2} admitting no consistent retarded/advanced coloring. Both are one-page Lean targets today. Lorentzian is the unique signature class with an orientable null cone; equivalently (Vinberg) the unique one with an invariant convex cone. Your candidate principle 1(a) is correct and can be made finite.

**V2 (a correction to the naive form of V1 — flag this loudly):** retardation on a *fixed* finite complex does **not** certify Lorentzian signature. I exhibit below four integer null vectors *spanning* R^{2,2} with all pairwise products strictly positive — a perfectly "retarded-looking" sky in a two-time world. The true theorem is a **stability** statement: Lorentzian ⟺ *every extension of the sky by null edges remains orientable*. Signature is a theorem about stable order, not about order at one complex. This matters for how Q3's equivalence must be phrased, and it is a small-dimension counterexample of exactly the kind your protocol requests.

**V3 (dimension): RECONSTRUCTION, not output, not free parameter.** Pure consistency of the carrier's soldering axiom gives exactly the Hurwitz ladder d ∈ {3,4,6,10} (Kugo–Townsend identity). The cut to 4 is done by two axioms, each with a finite algebraic formulation and an empirical anchor, neither a pure consistency requirement: **(A) chirality exists** (kills d = 3: no Γ on an irreducible odd-dimensional Clifford module), and **(B) the mass amplitude is a scalar** — a singlet exists in S ⊗ S for the minimal spinor S. Finite rep-theoretic fact: that singlet exists on the ladder **iff d ∈ {3,4}** (it is ε_{AB}); for d = 6, 4⊗4 = 6 ⊕ 10 and for d = 10, 16⊗16 = 10 ⊕ 120 ⊕ 126 — *no singlet in either*. So (A) ∧ (B) ⇒ d = 4, uniquely. Two independent confirming cuts land on the same point: Kramers parity (quaternionic structure forces ind ∈ 2Z, so your kernel's own (2,1), ind = 1 exhibit is impossible in d = 6) and the Alvarez-Gaumé–Witten cut (pure gravitational anomalies live only in d = 4k+2 = 2, 6, 10 and vanish identically in d = 4 — the H and O corners open an anomaly ledger the C corner never has to). Neither confirming cut is load-bearing; both are cheap kernel lemmas. Details in §2.

**V4 (skies): YES, there is a finite avatar, and it is the *same* axiom as V3's cut (M).** The sky of a vertex closes the aperture identity iff it embeds in P(K²) with an invariant pairwise amplitude; invariance of the amplitude forces K = C (Schur argument below), hence sky ⊂ CP¹. Questions 2 and 4 converge on one selecting requirement. Continuum guard: S^{d−2} is a complex curve iff d = 4; the one loophole (S⁶, d = 8 — off-ladder anyway) is closed by LeBrun's theorem that S⁶ carries no orthogonal complex structure.

**V5 (retardedness ⟺ signature): holds, but only in the stable form forced by V2.** Lorentzian ⟺ no frustrated triple of null rays ⟺ positive-pairing is transitive on null rays ⟺ null-orthogonality implies proportionality. Per the Malament split: this is entirely in the **free half** (order pays for signature and time-orientation). Dimension is *not* in the algebraic free half — pure order detects d only statistically (Myrheim–Meyer) — so in this program dimension is **owed**, and is paid by the fiber algebra via (M).

**V6 (deflation): partial, and the honest boundary is sharp.** The kernel layer does not derive d = 4; it verifies the C-corner of a rigid four-point ladder. The selection theorems are conditional — but the conditions are the program's two founding theses (a chirality grading exists; mass is a scalar pairwise amplitude), stated finitely. So: **not a free parameter (Hurwitz rigidity), not a pure output (two physical axioms do the cutting) — a two-axiom reconstruction.**

No section-5 verdict is overturned below. One dependency to log: 5c's dispersion polynomial and 5e's circulant-DFT coordinates are C-corner-specific objects (see §1b) — not errors, but ladder-nonportable assets.

---

## §1. Requirement-by-(d, signature) verdicts

| Requirement | (0,d) Eucl. | (1,2), K=R | **(1,3), K=C** | (2,2) split | (1,5), K=H | (1,9), K=O | (2,d−2) generic |
|---|---|---|---|---|---|---|---|
| (N) null covectors span | **✗** (no nulls) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| (R) retardation coherence | — | ✓ | ✓ | **✗** (frustrated triple) | ✓ | ✓ | **✗** (contains (2,2)) |
| (S) rank-one soldering | — | ✓ H₂(R) | ✓ H₂(C) | ✓ M₂(R) | ✓ H₂(H) | ✓ H₂(O) | ✗ (no 2×2 model) |
| (W) wedge identity | — | ✓ real | ✓ | ✓ but as (l-wedge)(r-wedge) | norm-only | norm-only | — |
| mass form ≥ 0 | — | ✓ Σ(wedge)² | ✓ Σ\|wedge\|² | **✗** (det P = −1 witness) | ✓ (Σ 2pᵢ·pⱼ) | ✓ (Σ 2pᵢ·pⱼ) | ✗ |
| (Γ) chirality on irred. module | ✓/✗ by parity | **✗** (d odd) | ✓ | ✓ | ✓ | ✓ | parity |
| (M) invariant scalar amplitude | — | ✓ (ε on R²) | ✓ (ε on C²) | per-factor only | **✗** (Schur) | **✗** (Schur) | — |
| Z-index, odd witnesses | — | ✗ (no Γ) | ✓ | ✓ | **✗** (Kramers: ind ∈ 2Z) | mod-2 flavored (KO) | — |
| sky = complex curve | — | RP¹ (real) | **CP¹** | RP¹ × RP¹ | S⁴ = HP¹ | S⁸ = OP¹ | — |
| 5a-positive quotient | — | plausible | target (open item 1) | conjectured ✗ (real-split kill) | machinery fine; state-count degrades | same + associativity care | conjectured ✗ |

**§1a. The finite algebraic reason multi-time kills positivity (question 1a): three one-line witnesses plus one structural sentence.**

- *Frustrated triple* (kills retardation coherence). In Z^{2,2} with form x₁²+x₂²−y₁²−y₂²: a = (1,0,1,0), b = (3,4,0,5), c = (0,1,1,0). All null (1=1, 25=25, 1=1); ⟨a,b⟩ = 3 > 0, ⟨b,c⟩ = 4 > 0, ⟨a,c⟩ = −1 < 0. No 2-coloring of {a,b,c} into ret/adv is sign-consistent. In Lorentzian signature this configuration is *impossible* (positive pairing is transitive on null rays — Cauchy–Schwarz on spatial parts).
- *Rigidity failure*. (1,0,1,0) ⊥ (0,1,0,1): non-proportional orthogonal nulls. In (1, d−1), null u ⊥ null v ⟹ u ∥ v. This rigidity is what makes the kernel identity's "= 0 iff projectively collinear" clause work.
- *Tachyonic null pair* (kills mass-form positivity). In split signature, soldering is ψχ^T ∈ M₂(R) (momenta are *not* Hermitian — no conjugation links the two chiralities). Take ψ₁ = (1,0), χ₁ = (0,1), ψ₂ = (0,1), χ₂ = (1,0): P = [[0,1],[1,0]], det P = −1 < 0. The identity survives as det P = Σ_{i<j} (ψᵢ∧ψⱼ)(χᵢ∧χⱼ) — a product of two *independent* real wedges, sign-indefinite. Two massless constituents, tachyonic bundle.

Structural sentence: **Lorentzian signature is exactly the reality condition under which the two spinor chiralities are complex-conjugate (SL(2,C)), so that momenta are Hermitian squares ψψ† and the mass form is a sum of Hermitian squares Σ|wedge|². In (2,2) the chiralities decouple (SL(2,R) × SL(2,R)) and the mass form factors into independent left/right wedges.** The split-signature sky RP¹ × RP¹ is this decoupling made visible. At the 5a level, I register (grade C) the bridge conjecture: in multi-time, any globally imposed retarded assignment forces at least one constraint plane into the real-split class — firing 5a's registered kill. The frustrated triple is the seed; I have not proven the implication in your exact constraint formalism.

**§1b. What survives on the ladder (question 1b).** Survives on all of {R, C, H, O}: rank-one soldering (Manogue–Dray for O), det P = Σ_{i<j} 2pᵢ·pⱼ ≥ 0 via the polarized determinant (this is future-cone convexity, dimension-blind), the decomposition-gauge/little-group story, chirality for even d, and pairwise wedge *norms* (any two octonions associate — Artin — so pairwise terms are well-defined; compose left-multiplication operators, per your standing caution). **C-only:** the wedge as an *invariant scalar amplitude* (hence: the 1+1 chirality-flip bridge, interference, the celestial complex curve), the Z-valued index calculus with odd witnesses (your (2,1)/ind = 1 exhibit is impossible over H: quaternionic structure ⟹ Kramers ⟹ ind ∈ 2Z), 5c's dispersion polynomial det σ(k) = Σ z_e z_f |ψ_e ∧ ψ_f|² in that form, and 5e's circulant/DFT mass coordinates (cube roots of unity live in the scalars). Note this means the program has *already spent* several C-only assets; the ladder is not merely disfavored, it is incompatible with adjudicated round-1 structure.

---

## §2. The selection theorem (question 2)

**Theorem candidate (Dimension–Signature Selection; grade T|H — assembly of classically proved pieces, each finitely checkable; kernel-transcribable modulo L6 below).** Let (V*, g) be a real quadratic space, dim d ≥ 3, and suppose:

- **(N)** the null covectors of g span V*;
- **(R)** the null rays admit a global 2-coloring {ret, adv} with same-color pairings ≥ 0, cross-color ≤ 0, and zero pairing only for proportional rays;
- **(S)** there is a real division algebra K and an identification of one color class with the rank-one elements ψψ† of the Hermitian 2×2 algebra H₂(K), with g the polarized determinant;
- **(W)** det(Σᵢ ψᵢψᵢ†) = Σ_{i<j} |ψᵢ ∧ ψⱼ|², the pairwise K-valued wedge with the composition norm;
- **(Γ)** the irreducible Clifford module of (V*, g) carries a grading anticommuting with every c(α);
- **(M)** the wedge (ψ, χ) ↦ ψ ∧ χ is Spin(g)-invariant valued in the trivial representation (a genuine scalar amplitude).

Then: (N) ⟺ g indefinite; (N)∧(R) ⟺ signature (1, d−1) up to overall sign; (S)∧(W) ⟹ K ∈ {R, C, H, O} and d ∈ {3, 4, 6, 10} (Hurwitz composition + the sl(2,K) ≅ so(1, dim K + 2) identities); (Γ) eliminates d = 3 (odd-d volume element is central; any grading forces a doubled module, and doubled d = 3 chirality is vectorlike — the index calculus dies); (M) eliminates d = 6 and d = 10. **Unique survivor: (R^{1,3}, K = C, S = C²).**

**Which requirement does the selecting.** (R) selects signature. (W) selects the ladder — and note honestly: (W) is not neutral bookkeeping; demanding that mass decompose into pairwise spinor amplitudes *is* the ladder-cutting axiom (see §5). (M) does the heavy lifting on the ladder, killing two of three rivals; (Γ) kills the third. The proof of the (M)-cut is one Schur line: an invariant scalar in S ⊗ S exists iff the minimal Weyl module is **self-dual**. For d = 4, S* ≅ S via ε (the wedge *is* the duality). For d = 6, the dual of the 4 of SL(2,H) is the opposite-chirality 4′ — inequivalent irreps, Hom = 0. For d = 10, 16* ≅ 16′, same story. Crucial precision (this is where a careless version of the theorem would be wrong, so I flag it): **Dirac masses — opposite-chirality pairings S ⊗ S̄′ ⊃ 1 — exist in every even d.** What is C-only is the *same-chirality* invariant, and Layer K is built from same-chirality pairs: one Weyl spinor per edge, mass from pairwise wedges. "A single chiral edge-pair carries a scalar disagreement amplitude" is the sharp condition. Physical reading of the cut: in d = 6, 10 mass still exists as a norm (Σ 2pᵢ·pⱼ) but admits **no scalar square root** — no interference-capable amplitude, no "mass = rate of chirality exchange." Those are exactly the dimensions where a lone Weyl fermion cannot be massed and where superstrings live: the ladder's far corners are the *masslessness-natural* worlds; C is the unique corner where mass-as-amplitude and chirality coexist.

**Slogan form:** R has mass but no chirality; H and O have chirality but no mass amplitude; **C alone has both — and "both" is verbatim the kernel's 1+1 bridge** ("the chirality-flip amplitude IS the wedge"), which presupposes (Γ) and (M) simultaneously. The program's founding identity is satisfiable precisely at K = C. The selection principle is not an add-on; it is the program.

**If (Γ) and (M) are dropped:** the theorem degrades to the ladder theorem — (S)∧(W) ⟺ K Hurwitz ⟺ d ∈ {3,4,6,10} — and the available cutting principles rank as follows. Primary: (M), (Γ), as above. Confirming (soft, cheap kernel lemmas): Kramers parity (kills H against your existing ind = 1 exhibits); Alvarez-Gaumé–Witten (d = 6, 10 owe a pure-gravitational anomaly ledger; d = 4 owes none); the KO-decoration of index protection from 5d applied to the *base* (only the C corner gives the Z-valued protection your index theorems use — quaternionic gives mod-2-flavored constraints, real gives KO mod-2). **Not available as cuts:** three generations (5e's triality is a *fiber* mechanism — G2 and the order-3 outer automorphism act on internal Λ(C³), not on base spinors); the 5a positivity quotient (it selects signature, not dimension — Theorem A is signature-blind Witt geometry). Indeed the right way to read your repo's octonion formalization: **the division-algebra ladder is spent twice, C on the base and O on the fiber** (5d: C⊗O = Λ(C³); C⊗H⊗O = Λ(C⁵) = the 32). The d = 10 corner is realized internally, where 5d/5e already put it. (SPECULATIVE one-liner for open item 8: base (1,3) plus internal KO-dimension 6 totals 2 mod 8 — the Majorana–Weyl class — which is exactly the coherence the C8 seam has to certify.)

---

## §3. Retardedness ⟺ signature: the finite equivalence (question 3)

**Theorem candidate (finite Malament; grade T for (i)–(iii), each with elementary proof; kernel-ready).** Let A be a finite spanning set of null vectors in (V, g), d ≥ 3. A *retardation structure* on A is a 2-coloring as in axiom (R).

(i) **Soundness.** If g is Lorentzian, *every* finite A admits exactly two retardation structures, both induced by the global cone split (the two time orientations).

(ii) **Per-complex insufficiency (the V2 counterexample — flag: this falsifies the naive equivalence).** In Z^{2,2} the family {(1,0,1,0), (5,0,4,3), (5,0,3,4), (5,1,1,5)} is null, **spans R⁴**, and has all pairwise products strictly positive (values 1, 2, 4, 1, 6, 2) — a coherently "retarded," spanning sky in a two-time world. Existence of a retardation structure on one finite complex certifies nothing about signature.

(iii) **Stable equivalence.** TFAE: (a) g has signature (1, d−1) up to sign; (b) every finite spanning A admits a retardation structure; (c) no frustrated triple exists; (d) positive pairing is transitive on null rays; (e) null-orthogonality implies proportionality. The multi-time kill for (b)–(e) is the integer triple of §1a, which embeds in every (p, q) with p, q ≥ 2.

(iv) **Decidability remark.** On a fixed complex, admissibility of a retardation structure is bipartiteness of the negative-pairing graph after contracting positive-pairing components — a linear-time 2-coloring check; a natural per-complex certificate to log next to each model's (H*) audit.

**Malament-split tagging (per the addendum).** (i)–(iii) are pure incidence data on null rays — the **free half**: order pays for signature and time-orientation, discretizing Malament/Hawking–King–McCarthy exactly as hoped, and dovetailing with 5a's "retardedness = the orientation choosing one null ray per oscillatory plane": frustration is precisely the obstruction to *gluing* the per-plane choices, and Lorentzian signature is precisely global gluability. But **dimension is not in the algebraic free half.** Pure order determines d only statistically (Myrheim–Meyer ordering fractions in Alexandrov intervals) — nothing finite and algebraic forces d from order. In this program dimension is **owed** and is paid by the decorations: axiom (M) on the fiber algebra. Clean division of labor: **order → signature (theorem); decorations → dimension (theorem-conditional-on-(M)); decorations → scale (Sorkin's number).**

---

## §4. Skies (question 4)

Finite avatar, stated: the sky of a vertex is its finite set of null-edge rays together with the wedge-Gram data; the aperture identity Q_A = Q(Σα_e) closes with mass = Σ|amplitudes|² iff the sky embeds in P(S) for S a rank-2 K-module carrying (a) an invariant antisymmetric scalar pairing and (b) a compatible conjugation squaring amplitudes to pairings of momenta. (a) is axiom (M) ⟹ K ∈ {R, C}; (b) plus (Γ) ⟹ K = C ⟹ **every sky is a finite subset of CP¹**, and Lorentz = PSL(2,C) = Möbius is forced as its automorphisms. So the sky question is not an independent selector — it is (M) again, which is the good news: one axiom, three faces (mass amplitude, 1+1 bridge, complex skies). Continuum cross-check: among spheres only S² is a complex curve; the celestial S^{d−2} of the twistor/celestial-holography literature is conformal but not complex for d > 4; the S⁶ near-miss (d = 8, off-ladder) fails integrability — LeBrun proved no orthogonal complex structure on S⁶ exists, which is the conformally-compatible class relevant here. Finite skies cannot see this topology; they see the algebra, and the algebra already decided.

---

## §5. The deflationary steelman, honestly (question 5)

Where dimension enters the kernel-checked layer, exactly: (1) the very first token of Layer K, ψ : C²; (2) the dagger — Hermitian conjugation is the Lorentzian reality condition (V2/§1a); (3) Γ as the even-d volume grading. Everything downstream is the C-corner by fiat. The steelman continues: even the ladder is not assumption-free — Jordan–von Neumann–Wigner spin factors give a Lorentzian cone with quadratic determinant in *every* dimension, so "null cone + quadratic mass" selects nothing. What cuts to the ladder is demanding the **spinor square root**: momenta are ψψ† and mass decomposes into pairwise amplitudes — i.e., **Layer K's own headline identity is the ladder-cutting axiom (W)**, equivalent to the Fierz/supersymmetry identities that hold iff K is a division algebra (Baez–Huerta). So the deflationist is right that C² was an input, and right that "consistency alone" selects nothing beyond signature. The deflationist is wrong that the input is arbitrary: it is the unique solution of three finitely-stated demands — null ontology with spinor square root (W), chirality (Γ), scalar mass amplitude (M) — of which (Γ) and (M) carry the physical content and are the program's founding sentence. Final honest formula: **signature is an output (theorem grade); dimension is a reconstruction from two named axioms; neither is a free parameter.** A ladder-dweller who rejects (M) is running a different program — the massless chiral string corner — and one who rejects (Γ) is running d = 3 vectorlike physics; both rejections are coherent, neither is *this* theory.

---

## §6. Formalization ladder (statement-first; no analysis smuggled)

**L1** (trivial): g definite ⟹ no nonzero null covector; g indefinite ⟹ null covectors span. Kills Euclidean at axiom (N).
**L2** (one-liner): the integer frustrated triple a, b, c ∈ Z^{2,2} of §1a: three nullity checks, three inner products, and the non-2-colorability of a signed triangle.
**L3**: Lorentzian transitivity — for null u, v, w in R^{1,d−1}: ⟨u,v⟩ > 0 ∧ ⟨v,w⟩ > 0 ⟹ ⟨u,w⟩ ≥ 0, with equality iff u ∥ w. Proof content: Cauchy–Schwarz on spatial parts. With L2 this yields Theorem §3(iii)(a)⟺(c).
**L4**: rigidity — null u ⊥ null v ⟹ u ∥ v in (1, d−1); falsified in (2,2) by (1,0,1,0) ⊥ (0,1,0,1).
**L5**: split-signature mass identity — for ψᵢ, χᵢ : R², det(Σ ψᵢχᵢ^T) = Σ_{i<j}(ψᵢ∧ψⱼ)(χᵢ∧χⱼ); corollary witness P = [[0,1],[1,0]], det = −1: two nulls, tachyonic sum. (Mirror of your kernel's Layer-K theorem with C replaced by the split composition algebra — a satisfying pairing of theorems.)
**L6** (the load-bearing one): singlet census as a Schur statement — Hom_{Spin}(S ⊗ S, 1) ≅ Hom(S, S*), and S* ≅ S for d = 4 (ε), S* ≅ S′ ≇ S for d = 6, 10. Given explicit module definitions this is a finite duality computation, not character theory. Medium effort; it is the kernel form of axiom (M)'s cut.
**L7**: Kramers parity — j antilinear, j² = −1, [D, j] = 0 ⟹ dim_C ker D even ⟹ ind ∈ 2Z. Cheap; combined with your existing (2,1)/ind = 1 exhibit it is a machine-checked "this program is not quaternionic" certificate.
**L8**: per-complex retardation decision procedure (§3(iv)) as an executable check, added to the model-by-model (H*) audit list of open item 3.
**L9** (grade C, register): the multi-time → real-split-plane bridge conjecture of §1a, seeded by L2, target formalism = 5a's constraint-plane trichotomy.

---

## §7. Literature anchors

Kugo–Townsend, "Supersymmetry and the division algebras," Nucl. Phys. B221 (1983) 357 — the mod-8 bilinear tables that are L6's classical source. Baez–Huerta, "Division algebras and supersymmetry I," arXiv:0909.0551 (Proc. Symp. Pure Math. 81, 2010); II, arXiv:1003.3436. Sudbery, "Division algebras, (pseudo)orthogonal groups and spinors," J. Phys. A17 (1984) 939. Manogue–Dray: "The Geometry of the Octonions" (World Scientific, 2015); Dray–Manogue, "Octonionic Cayley spinors and E₆," Comment. Math. Univ. Carolinae 51 (2010) 193 (arXiv id unverified). Jordan–von Neumann–Wigner, Ann. Math. 35 (1934) 29 — spin factors. Malament, J. Math. Phys. 18 (1977) 1399; Hawking–King–McCarthy, J. Math. Phys. 17 (1976) 174. Bombelli–Lee–Meyer–Sorkin, PRL 59 (1987) 521; Myrheim, CERN TH-2538 (1978); Meyer, MIT PhD thesis (1988) — dimension from ordering fractions; Sorkin, "Causal sets: discrete gravity," arXiv:gr-qc/0309009 — order + number. Penrose, "Twistor algebra," J. Math. Phys. 8 (1967) 345; Penrose–Rindler, *Spinors and Space-Time* I–II — the classical d = 4 two-spinor exceptionalism. LeBrun, "Orthogonal complex structures on S⁶," Proc. AMS 101 (1987) 136. Alvarez-Gaumé–Witten, "Gravitational anomalies," Nucl. Phys. B234 (1984) 269. Tegmark, "On the dimensionality of spacetime," Class. Quantum Grav. 14 (1997) L69, arXiv:gr-qc/9702052 — PDE-stability/anthropic steelman. Mankoč Borštnik–Nielsen, "Why odd-space and odd-time...," Phys. Lett. B486 (2000) 314 (arXiv:hep-ph/0005327, unverified) — Weyl-equation well-posedness selecting (1, d−1); note their mechanism is the continuum shadow of L2/L3. Bars, "Survey of two-time physics," Class. Quantum Grav. 18 (2001) 3113, arXiv:hep-th/0008164 — the disciplined multi-time program; instructive because it *must* gauge away the frustration. Celestial holography: Strominger, arXiv:1703.05448; Raclariu, arXiv:2107.02075; Pasterski, arXiv:2108.04801. Harvey, *Spinors and Calibrations* (1990) — mod-8 structure, backup for L6.

---

## §8. Pre-registered kills for this answer

**K1**: exhibit a Spin(1,5)- or Spin(1,9)-invariant scalar bilinear on a single Weyl module — kills the (M)-cut (I claim impossible by L6; a counterexample overturns §2). **K2**: exhibit a (2,2)-complex satisfying all 5a hypotheses with nonvacuous positive V′/N — kills the physical reading of the signature theorem and L9. **K3**: if 5e's chirality-solder danger ever fires (physical grading forced to couple to internal chirality), the base/fiber double-spend of §2 collapses and the O-corner bookkeeping must be redone. **K4**: a spanning retarded integer family in (2,2) is *already* exhibited (§3(ii)) — any future paper phrasing "retardation ⟹ Lorentzian" per-complex is pre-killed; only the stable form may be claimed.

Bottom line for the paper: write "signature: theorem about order (free half); dimension: theorem about the fiber, conditional on (Γ) and (M), which are the program's founding identity" — and never write "we derive 3+1 from consistency alone."
