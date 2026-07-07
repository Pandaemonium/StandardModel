# Q12 verdict

**DEFUSAL: CONFIRMED FOR THE COMPOSED MODEL, but boundary-corrected.** The conclusion stands; the argument as written does not. Two things in your analysis are wrong or incomplete, flagged loudly first per charter:

**F1 (a registered expectation is FALSE as stated).** "θ₂₃ − π/4 = O(eps²)" is wrong for a *generic* equivariance-breaking probe. Generic breaking shifts θ₂₃ at **O(eps)**. The quadratic law holds only for probes preserving the antilinear μ–τ-reflection that pins the angle (the same symmetry 5e's variant uses to pin δ_CP). First-order degenerate perturbation theory: nothing forbids the linear term unless a residual (anti)symmetry does, and Z/3-equivariance alone is already spent. Register two probe classes (reflection-preserving → O(eps²); generic → O(eps)); if the toy ever shows O(eps²) for a *generic* probe, that is a hidden protection and should be escalated, not celebrated.

**F2 (the defusal argument is incomplete, though its conclusion is true).** Factor-separation ("τ lives on C[Z/3], (−1)^F lives on the strand factor") does **not** survive the octonionic upgrade, because in the V_O = O³ realization the triality identification maps act on spaces that carry parity, and J_R provably must act on the family factor (see 1b). The composed model is still safe — but by a *stronger and different* finite fact (the G₂-parity lemma below), not by disjointness. Additionally your defusal omits one hypothesis: **constraint equivariance** (τΓ′ = Γ′). Commutation of τ with Γ and D upstairs does not give a per-sector count on the physical sector V′/N without it; this is the same square everything lands on (cross-memo (ii)).

---

## 1. Adversarial confirmation

### 1a. The octonionic seed: interaction exists, and is safe by a G₂ lemma

The hunt finds a real channel: once V_O = O³ with τ = cyclic shift composed with triality intertwiners T_v→s, T_s→c, T_c→v, the family monodromy acts on 8-dimensional spaces on which internal parity acts nontrivially. Factor-separation is dead. What saves the model is:

**LEMMA G₂-PARITY (grade T; kernel-ready, 8×8).** In the XOR-Fano convention e_a e_b = σ(a,b) e_{a⊕b}, a,b ∈ F₂³, the strand parity φ: e_a ↦ (−1)^{pc(a)} e_a is an algebra automorphism of O — hence φ ∈ G₂ — for **every** sign convention σ. Proof: pc(a⊕b) ≡ pc(a)+pc(b) mod 2, so (−1)^{pc} is a character of (F₂³, ⊕); the character identity commutes with any XOR-graded product. More generally every character χ_c(a) = (−1)^{a·c} is a diagonal automorphism (this is the known rank-3 elementary abelian 2-subgroup of G₂ attached to the Fano basis); parity is χ_{(1,1,1)}. Its fixed subalgebra is span{e₀, e₃, e₅, e₆} = Λ⁰ ⊕ Λ² — the even strand sector is literally the fixed quaternion subalgebra of the parity involution.

Consequences, in order:

1. Since Fix(order-3 triality) = G₂ **pointwise** as a subgroup of Spin(8) (G₂ is simply connected, so it embeds in Spin(8) covering its SO(8) copy isomorphically — no lift ambiguity), and since 8v|_{G₂} ≅ 8s|_{G₂} ≅ 8c|_{G₂} = 7 ⊕ 1 (multiplicity-free), the triality intertwiners can be chosen G₂-equivariantly, uniquely up to one scalar per isotypic. Then the diagonal parity P = φ ⊕ φ̃_s ⊕ φ̃_c **commutes with τ exactly**. The character check confirms coherence: tr(φ) = 0 in 8v forces tr_7(φ) = −1, hence signature (4,4) in all three slots — parity is balanced in every family copy, matching dim Λ^even = dim Λ^odd = 4.
2. The L4c multiplication identity is parity-coherent rather than parity-breaking: (φ, φ̃, φ̃) is itself a triality triple, i.e. φ̃_c(x·ψ) = φ(x)·φ̃_s(ψ). Corollary: a family-slot-shifting Yukawa turn L_x is chirality-odd iff φ(x) = −x, i.e. x ∈ span{e₁,e₂,e₄,e₇} — the 4-dimensional complement of the fixed quaternion subalgebra. (SPECULATIVE aside worth one line in the ledger: the carrier axiom "turns are chirality-odd" thus canonically selects a 4-real-dimensional turn slot in the octonionic delivery — a Higgs-doublet-sized space, dovetailing with the V_H ⊗ V_O factorization.)
3. **Convention risk (the one genuine residual danger in 1a).** The lemma is basis-sensitive in exactly the way your convention bridge handles: it proves *the XOR-diagonal parity* is in G₂. If the executor's Λ(C³) is a ladder-mixed basis (Furey-style α_k built with the extra complex unit), (−1)^{F_c} is diagonal there, not in the XOR basis, and the two parities differ by the bridge unitary. The kernel check must therefore be: (i) φ is an automorphism (64 sign identities); (ii) T_i intertwines the slotwise parities; (iii) **bridge**: the repo's (−1)^{F_c} conjugates onto φ under the existing convention-bridge unitary. If (iii) fails, do not patch silently — that mismatch is a C8-seam symptom (open item 8) and should be escalated as such, because it would mean the strand grading and the octonionic grading are inequivalent G₂-conjugacy data.

### 1b. Krein/J_R: the coupling is real, forced, and index-safe

Break attempt succeeds at the level of the *claim of disjointness*: **J_R cannot act as identity on the family factor.** This needs no model input — it is antilinearity alone. If τv = ωv and J_R commutes *or* inverts τ, then τ(J_R v) = ω̄(J_R v). So J_R swaps family sectors ω ↔ ω̄ in every realization. The same holds for the linear # slot: the canonical antiautomorphism of C[Z/3] is group inversion, so τ^# = τ⁻¹; Krein-self-adjoint family turns are Hermitian circulants (DFT values real or conjugate-paired) — your mass coordinates already assume this. And there is a base-level reason both reflections must invert the cycle: the monodromy is delivered by base transports, and edge-orientation reversal inverts holonomy. So family-cycle inversion is the **fourth role** of the one operation in cross-memo (v) (GW grading, OS reflection, J_R ingredient, monodromy inversion). The coupling is the base geometry showing through, not a new solder.

Index-safety: J_R anticommutes with Γ on Λ(C⁵) (degree reversal on odd total degree; the KO-dim-6 sign), so J_R maps ker D₊ ↔ ker D₋ while swapping (ρ, ω) ↔ (ρ̄, ω̄). Hence the constraint it imposes is ind(ρ̄, ω̄) = −ind(ρ, ω) **across conjugate charge sectors**, never within one — for complex ρ (all charged SM irreps) this is the standard particle/antiparticle chirality flip. Two consequences you should adopt: (i) the *naive total* index over the full fiber vanishes identically (dim Λ^even = dim Λ^odd = 16; the NCG fermion-doubling phenomenon in finite form) — so the counting object was never the plain index; it is the **equivariant, charge-resolved** index in R(Z/3 × G). This is cross-memo (i) again, now with teeth: the solder audit *cannot even be stated* without L0. (ii) If the C8 top-form pairing forces a fiber J-component anticommuting with Γ, the kernel McKean-Singer rank-symmetry lemma's hypothesis set changes (J then maps M₊ → M₋, forcing balance — consistent with 16+16, and again pushing everything to the equivariant refinement). Check which commutation the current kernel proof assumes; if it assumes [J, Γ] = 0, the composed model needs the isotypic-resolved restatement before the fiber is attached.

### 1c. The quotient: no forced coupling, one missing hypothesis

U1/U3 force no cross-factor coupling, but they add hypothesis **E4: τΓ′ = Γ′** (and τ-covariance of the finite Ward identity DΓ′ ⊆ Γ′). Without it τ does not descend to V′/N and "per-sector" is meaningless downstairs regardless of upstairs commutation. For gauge-generated constraints with family-blind gauge transports, E4 is automatic; it fails exactly when gauge-fixing or IR-selection decorations are family-dependent. Note the converse possibility for completeness: upstairs failure can *heal* on the quotient (the non-commuting part of [τ, Γ] can lie in N); the audit must therefore be run on (V′/N, descended Γ, descended τ), with upstairs checks as the cheap sufficient condition.

---

## 2. The anomaly route made concrete

The sharp modern form of the solder danger exists, and the composed model passes it while the pure-internal variant fails it. Three finite conditions (collectively **PSA**, per-sector admissibility), formulated as properties of the equivariant GW measure — a τ-equivariant choice of chiral basis over decoration space:

**PSA-1 (per-sector supertrace identity).** For each ω-sector, str restricted to the sector of g ∈ G must satisfy the one-line identity str_{Λ(Cⁿ)}(g) = det(1−g) with its order-n vanishing. Composed model: each DFT sector is a *full* Λ(C⁵) as a graded G-module (τ acts only on C[Z/3]), so PSA-1 is three identical copies of the 5d identity — passes trivially. Any delivery splitting one generation's content across sectors can fail PSA-1 per sector while the total passes.

**PSA-2 (per-sector mod-2, with the CP-paired failure pattern).** For every pseudoreal isotypic ρ: ind₂(D; ρ, ω) = 0 for **each** ω separately. This is strictly stronger than total bookkeeping, and the dangerous pattern is precisely the one J_R's ω ↔ ω̄ swap makes self-consistent: sectors ω and ω̄ each carrying Witten anomaly 1, sector 1 clean — total ≡ 0, theory family-sick. Total bookkeeping is provably blind to it. Composed model per sector = one generation = four SU(2) doublets (3 colors of Q, plus L) — even; passes by the classic color-saves-the-lepton-doublet count, now per family sector.

**PSA-3 (the τ 't Hooft phase).** τ acts on the determinant line of D₊ restricted to the physical sector by a scalar λ_τ with λ_τ³ = 1. λ_τ ≠ 1 is the discrete 't Hooft anomaly of the family symmetry: monodromy delivery (background holonomy) remains legal, but family cannot be gauged, and — the solder-relevant part — no τ-equivariant GW measure exists, so "three *identical* families" fails at the quantum level even though ind = 3: the family label is anomalously broken by the measure. This is your 5f HS-implementability gate specialized to Z/3, and it is a finite computation (a phase on a finite exterior power).

PSA is the answer to your question 2: yes, there are per-sector conditions the total can mask; PSA-1–3 are their finite statements; the composed model passes all three structurally (each sector = full generation); the Spin(8) variant fails PSA-1 (each of 8v, 8s, 8c alone is not anomaly-complete).

---

## 3. The boundary: criterion and decision procedure

**CRITERION (the requested iff).** The per-sector index degrades iff Ad(τ)Γ_phys ≠ Γ_phys on V′/N — equivalently iff Γ_phys has a nonzero component in a nontrivial Ad(τ)-isotypic of the operator algebra — equivalently, structurally: **iff the family delivery places the three triality-related copies in distinct internal-chirality classes.** Safe deliveries are exactly those whose grading is built from Ad(τ)-fixed data; for octonionic delivery this means G₂-data, and the composed model qualifies because base chirality is τ-blind and strand parity is a G₂ element (Lemma G₂-PARITY). The Spin(8) variant fails because the grading that distinguishes 8s from 8c is the Spin(8) chirality element, which triality moves by construction. Its failure is a clean dichotomy: either (a) keep the spinor grading — then Ad(τ)-averaging of Γ = (+,+,−) gives (1/3)·1, not an involution, so per-sector grading is *undefined*; or (b) regrade fiber-blind — then [τ,Γ] = 0 is restored but the τ-orbit charge content is self-conjugate and the Distler-Garibaldi index lemma gives per-sector ind = 0; the mechanism survives at most as "ind = 3 without identifiable families" (your question-5 fallback, which applies only to this variant).

**Decision procedure (executor-runnable on any proposal):**

1. **Normalize:** certify τ³ = 1 exactly (Schur: the composite T₃T₂T₁ is a scalar per irreducible slot; rescale to +1 — over C always possible; if a proposal cannot normalize, the residual sign solders family to fermion parity and is an instant fail). Certify τ is J-unitary.
2. **Outerness rail (5e):** certify Ad(τ) outer on the charge algebra. Inner → vacuous, stop.
3. **Grading solder:** compute [τ, Γ]. If ≠ 0: compute the Ad(τ)-average of Γ; not an involution → grading undefined → run the (a)/(b) dichotomy above → not a three-identifiable-family mechanism. If = 0: proceed.
4. **Dynamics:** τDτ⁻¹ = D on the equivariant reference decorations; record which decorations are permitted to break it (these define flavor).
5. **Constraints (E4, the new hypothesis):** τΓ′ = Γ′ and τ-covariance of DΓ′ ⊆ Γ′; if upstairs checks fail, re-run 3–4 on V′/N before declaring failure.
6. **Reality/KO:** record J_Rτ J_R⁻¹ ∈ {τ, τ⁻¹} (sector swap ω ↔ ω̄ is automatic either way); tabulate per-sector KO types; run PSA-1, PSA-2 (including the CP-paired pattern), PSA-3.
7. **Breaking probe:** perturb by eps·V with V chirality-odd and Krein-self-adjoint; verify exact index constancy, commutant collapse, and angle orders per the corrected registration below.

---

## 4. Toy certification (dims: C³ ⊗ C² ⊗ C³², total 192)

Kernel lemma list, in dependency order:

- **L-A:** τ³ = 1 after intertwiner rescaling; τ^#τ = 1. (3×3 ⊗ trivial; then 24×24 in the octonionic upgrade.)
- **L-B:** [Γ_total, 1 ⊗ τ] = 0, Γ_total = γ_base ⊗ (−1)^F ⊗ 1. (Trivial; the TOY-A floor.)
- **L-C (G₂-parity, three parts):** (i) φ ∈ Aut(O): 64 sign identities in the repo σ; (ii) T_i φ_{(i)} = φ_{(i+1)} T_i for the chosen G₂-equivariant intertwiners (8×8, three checks); (iii) bridge: repo (−1)^{F_c} = B φ B⁻¹ under the convention-bridge unitary. **(iii) failing is a C8-seam escalation, not a patch.**
- **L-D:** for circulant/equivariant decorations, [D, τ] = 0, hence [Γ(1 − aD), τ] = 0.
- **L-E (the gate; = L0 specialized to Z/3):** equivariant McKean-Singer — under L-B/L-D and per-isotypic rank symmetry, ind_ω = dim M₊^ω − dim M₋^ω and Σ_ω ind_ω = ind. Without this lemma no claim in this memo is a statement in your calculus; it gates 5d and 5e identically.
- **L-F:** τΓ′ = Γ′ for the toy's Gauss covectors; descended commutation on V′/N.
- **L-G (reality):** the ω ↔ ω̄ swap; per-sector table ind(ρ̄, ω̄) = −ind(ρ, ω); check against the KO decorations.
- **L-H (anomaly pair):** PSA-1/2 verified per sector on the composed toy; the pure-Spin(8) toy (fiber 24 = 8v⊕8s⊕8c) exhibited failing PSA-1 per sector while passing totals — the worked counterexample pair. PSA-3: λ_τ computed on the physical determinant line.
- **L-I (probe), with corrected registrations:**
  - Total ind: **confirmed, and strengthened — it is exactly constant at all eps**, not merely rigid perturbatively, by your existing index theorem, *provided* V stays chirality-odd and Krein-self-adjoint; a chirality-even component voids the theorem, and a Γ′-breaking component changes the physical-sector statement even at fixed total ind. State the hypothesis class in the probe spec.
  - Commutant 3 → 1: **confirmed** at generic eps, drop at first order; genericity is Zariski-open, so the kernel certificate is a single nonvanishing determinant at one exhibited eps.
  - θ₂₃ − π/4: **corrected per F1** — O(eps) generic; O(eps²) only for μ–τ-reflection-preserving probes. Run both classes.

## 5. Not applicable

The composed model is SAFE, conditional on: E4 added to the hypothesis list; L-A normalization certified; L-C(iii) bridge certified; and the counting object upgraded to the charge-resolved equivariant index (L-E), since the plain fiber index is identically 0 by the J_R balance — a fact your defusal never needed to confront but the octonionic upgrade forces into view.

## Literature anchors

Adams, *Lectures on Exceptional Lie Groups* (1996) — Fix(triality) = G₂, 7⊕1 branching. Baez, "The Octonions," Bull. AMS 39 (2002), arXiv:math/0105155 — triality triples. Griess, "Elementary abelian p-subgroups of algebraic groups," Geom. Dedicata 39 (1991) — the rank-3 2-group in G₂ (the sign-flip automorphisms). Yokota, "Exceptional Lie groups," arXiv:0902.0431 — explicit involutions of G₂ with SO(4)-type fixed groups. Lizzi–Mangano–Miele–Sparano, Phys. Rev. D 55 (1997), hep-th/9610035 — fermion doubling/quadrupling in NCG (the finite ind = 0 balance). Lüscher, Nucl. Phys. B549 (1999), hep-lat/9811032 — GW chiral measure existence. Witten, "An SU(2) anomaly," Phys. Lett. B 117 (1982). 't Hooft, Cargèse lectures (1980) — anomaly matching. Ibáñez–Ross, Phys. Lett. B 260 (1991) — discrete anomaly bookkeeping (unverified page numbers). Distler–Garibaldi, Commun. Math. Phys. 298 (2010), arXiv:0905.2658. Harrison–Scott, Phys. Lett. B 547 (2002); Grimus–Lavoura, hep-ph/0305309 — μ–τ reflection pinning θ₂₃ (the F1 protection mechanism). Furey, Eur. Phys. J. C 78 (2018), arXiv:1806.00612 — ladder-basis conventions relevant to L-C(iii) (identifier from memory; verify).
