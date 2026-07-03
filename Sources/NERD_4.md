# NSBB-V2.1-REVISION-AND-DEVELOPMENT.md

**Provenance.** External contribution (Claude, session of 2026-07-02), responding
to the outside review of the v2 document. Status labels are strict: THEOREM
(finite math, proof included or one-line from standard results), IMPORT (real
literature theorem whose hypotheses we have not yet reproduced), PROPOSAL
(theory development, checkable), SPECULATIVE (labeled). Nothing here is
Lean-checked yet. The review's literature spot-checks match my knowledge
(BHS gr-qc/0605006; Benincasa–Dowker 1001.2725; FLPW 1605.08072; QNEC
1509.02542; Jacobson 1505.04753; Chamseddine–Connes hep-th/9606001; Wang–You
2204.14271; hyperdiamond 0804.1145; AHH 1709.04891). The "Physlib"
consolidation claim should be re-verified at P2 submission time.

---

## 1. Disposition ledger

| Review item | Verdict | Action |
|---|---|---|
| I1 formalization order (σ-det → PSD cone → rank/null → 2×n Cauchy–Binet) | ACCEPT | Adopt verbatim as the I1 build order. |
| "Mass as concurrence" must be unnormalized (det P, not det(P/trP)) | ACCEPT | Matches our earlier FVG-anchored fix (unnormalized det P as the invariant; det ρ_vis = (m/E)² is frame-dependent). Language: "Plücker norm / unnormalized concurrence." |
| I1.7 Stiefel splitting (little group = SU(2) only for minimal splits) | ACCEPT+EXTEND | Proof in §3.2; extended in §4.4 to the U(2) = spin × clock synthesis. |
| I1.8 normalized dictionary (C = m/E, purity–mass, entropy–velocity) | ACCEPT | Centerpiece of P2; derivations checked (§3.3). |
| A1 boost–Gibbs identity | ACCEPT | Checked: P = m e^{η p̂·σ}, eigenvalue ratio e^{2η}. |
| A1 clock overreach (modular flow trivial at rest) | ACCEPT+REPAIR | The reviewer's diagnosis is correct and important. Repair completed as a theorem, not just a gate: §4 (determinant-line clock, zitterbewegung frequency 2m). |
| A2 Minkowski determinant inequality | ACCEPT | Rename "binding energy" → kinematic superadditivity gap; adopt the exact cosh χ formula. |
| Krein/γ₅ housekeeping "High" | ACCEPT+PREREQ | Gate C0 (§2) must precede: the three-J disambiguation and the grading split found in our earlier audit are prerequisites, or the "housekeeping" will formalize the wrong operator. |
| Finite Tomita; timelike ⟺ faithful ⟺ finite modular Hamiltonian | ACCEPT | Adopt as Gate I2 statement; "null edges do not age" in this precise form. |
| L0 Lorentz-ensemble viability (urgent) | ACCEPT+RESOLVE | The review is right that this is the biggest structural risk. §5 proposes a specific resolution: finite valency dies, links live. |
| Metric-as-covariance signature problem | ACCEPT+SHARPEN | §6: the invariant object is the symbol of the transport operator, not a covariance tensor; covariance works only in a matter rest frame. |
| Gravity = DPI weakening | ACCEPT | Adopt the weakened slogan verbatim. |
| Q1 finite DPI before QNEC | ACCEPT | §7: monotonicity and positivity of S_rel are EXACT finite theorems (free); the QNEC content is the second difference. This split should be stated loudly. |
| Discrete QNEC ladder | ACCEPT+METHOD | §7: Peschel Gaussian method makes every rung exact linear algebra; propose the checkerboard null-cut geometry. |
| SMG iff too strong | ACCEPT | Consistent with our earlier Gate-C1 conclusion (strict finite ultralocal chiral release impossible; SMG the native alternative, necessity-not-sufficiency). Gate S1 adopted; first instance §8. |
| Λ: Hodge yes, interpretation needs boundary discipline | ACCEPT+FIX | §9: the missing ingredient is RELATIVE cohomology. Small diamonds are absolutely trivial but relatively nontrivial: H⁴(D,∂D) ≅ ℝ is the volume mode — exactly the unimodular-gravity integration constant. This dissolves the reviewer's "topologically trivial" worry and upgrades P9. |
| Spectral action = consistency gate only | ACCEPT | Reclassify as G1′.4. |
| Publication sequencing (P2 wedge first) | ACCEPT | §11. |

Net: every correction is accepted. In four places (§4, §5, §6, §9) the
development below goes beyond the review.

---

## 2. Gate C0 — convention cleanup (prerequisite, from our earlier audits)

Before formalizing the Krein/γ₅ items the review rates "High":

1. **The three J's.** Maintain the disambiguation table: J_K (Krein fundamental
   symmetry, J_K² = +1, defines the indefinite pairing), J_mod (Tomita modular
   conjugation, antiunitary, state-dependent), J_C (charge conjugation,
   antiunitary, structure of the real spectral triple). The v2 text conflates
   them in at least the γ₅-Hermiticity and "real structure" passages. Each
   theorem must name which J it consumes.
2. **Grading split.** The cochain/form degree ℤ-grading and the chirality
   ℤ₂-grading are distinct; the Dirac-operator sign conventions differ between
   them. Fix the convention ONCE (chirality = Krein signature of the
   null-edge pairing; form degree stays bookkeeping) and audit every anticommutator.

Both are finite tasks and cheap; skipping them is how a "high-confidence"
formalization produces a verified theorem about the wrong operator.

---

## 3. Kinematic core (Gates I1, I1.7, I1.8, I1.9)

### 3.1 Build order (adopted)
det(p⁰I + p·σ) = (p⁰)² − |p|²; then P ⪰ 0 ⟺ p⁰ ≥ |p| (eigenvalues p⁰ ± |p|);
then, for P ≠ 0, rank P = 1 ⟺ det P = 0 ⟺ p future-null; then Cauchy–Binet in
the 2×n form det(LL†) = Σ_{i<j} |⟨λᵢλⱼ⟩|², ⟨λᵢλⱼ⟩ = λᵢ¹λⱼ² − λᵢ²λⱼ¹.

**Kinematic cross-check worth stating in the paper:** each rank-one term
λᵢλᵢ† is a future-null momentum pᵢ, and |⟨λᵢλⱼ⟩|² = det(λᵢλᵢ† + λⱼλⱼ†) =
(pᵢ+pⱼ)² = 2pᵢ·pⱼ. So the Plücker identity is exactly the expansion
m² = (Σpᵢ)² = Σ_{i<j} 2pᵢ·pⱼ with the null diagonal terms vanishing. The
quantum-information content is the refinement of each pairwise invariant mass
into a squared spinor bracket — the amplitude-level object of massive
spinor-helicity (AHH). This one paragraph inoculates the paper against "this
is just (Σp)²" and against "this is numerology": it is both, exactly.

### 3.2 Gate I1.7 — Stiefel splitting theorem (proof)
Let P ≻ 0 be 2×2 and n ≥ 2. If LL† = P, set V := P^{−1/2}L; then
VV† = P^{−1/2}PP^{−1/2} = I₂, and L = P^{1/2}V. Conversely L = P^{1/2}V with
VV† = I₂ gives LL† = P. So the fiber of null decompositions is
St₂(ℂⁿ) = {V ∈ M_{2×n} : VV† = I₂}, with transitive right U(n) action;
for n = 2, St₂(ℂ²) = U(2). ∎
Adopt the boxed slogan: the massive little group SU(2) is the minimal
two-null-split gauge — with the refinement of §4.4 (what the leftover U(1) is).

### 3.3 Gate I1.8 — normalized dictionary (checked)
ρ_P = P/trP = ½(I + v·σ): eigenvalues (1±v)/2 = e^{±η}/(2cosh η);
det ρ_P = m²/4E²; tr ρ_P² = (1+v²)/2; 2(1 − tr ρ_P²) = m²/E²;
concurrence of the canonical purification C(ρ_P) = 2√det ρ_P = m/E = sech η;
S(ρ_P) = H₂((1+v)/2). The invariance bookkeeping: the normalized state knows
only m/E; the scale lives in unnormalized P (m = E·C). This is the FVG-anchored
formulation from our earlier session and should anchor P2.

### 3.4 Gate I1.9 — the first-order bridge (from our super-Dirac session)
(γ·P)² = det(P)·𝟙 in the Clifford algebra (for P = p_μσ^μ this is
(γ·p)² = p²𝟙). This is the one-line theorem connecting the PSD-cone story to
the Dirac-operator story, and it is the reason det(P) = Φ†Φ can be read as an
on-shell constraint rather than a tautology. Slot it immediately after I1 in
the build order; it is Lean-trivial and load-bearing for the narrative.

---

## 4. Gate I3 — the determinant-line clock (development: the review's gap, closed)

The review's diagnosis: at rest ρ_P = I/2, modular flow is trivial, so the
de Broglie clock is NOT the modular flow of the momentum state. Correct. The
repair below makes the clock a theorem-shaped object.

### 4.1 The clock bundle
Fix m > 0 and the mass shell H_m = {P ≻ 0 : det P = m²} ≅ ℝ³ . For P ∈ H_m the
minimal-split fiber is F_P = {L ∈ GL₂(ℂ) : LL† = P} ≅ U(2) (§3.2). Quotient by
the spin gauge SU(2) (right action): F_P/SU(2) ≅ U(2)/SU(2) ≅ U(1), coordinatized
by the phase of det L (note |det L|² = det P = m², so |det L| = m identically).
This defines a principal U(1)-bundle 𝒟_m → H_m — the **determinant line /
clock bundle**. H_m is contractible, so 𝒟_m is trivializable: there is no
topological obstruction; the physics is in the dynamics (honest note).

### 4.2 Proposition I3.5 (zitterbewegung frequency of the determinant line) — THEOREM
Let a positive-energy Dirac plane wave evolve freely; in the rest frame,
ψ(τ) = e^{−imτ}ψ(0). Suppose the minimal split is constructed linearly from
the field (any linear construction: columns built from the spinor doublet).
Then L(τ) = e^{−imτ}L(0), hence P(τ) = L(τ)L(τ)† = P(0) (the momentum state
sees nothing), while

    det L(τ) = e^{−2imτ} det L(0):

the clock fiber rotates uniformly at angular frequency **2m — the
zitterbewegung frequency.** Along a boosted worldline the phase is
2(E dt − p·dx) = 2m dτ, so the statement is covariant. The de Broglie/Compton
clock e^{−imτ} is the continuous square root of the det-line motion, unique up
to sign. ∎

Three payoffs:
1. It explains WHY the momentum-state modular flow could not be the clock: the
   clock lives in exactly the U(1) that P = LL† forgets (§4.1). The review's
   objection and the repair are now the same statement.
2. The factor 2 is not a blemish; it is the known relation between
   zitterbewegung (2mc²/ℏ) and the Compton clock (mc²/ℏ), and the sign
   ambiguity of the square root is precisely the spinorial double cover
   (§4.4). The checkerboard/ZB thread of the program now has a
   finite-dimensional theorem underneath it.
3. Experimental anchor (for prose, not proof): the Compton-clock
   interferometry of Lan et al. (Science 2013) measures exactly the e^{−imτ}
   object; the Gouanère channeling resonance is the contested cousin. Cite as
   context, claim nothing.

### 4.3 The connection (definition, PROPOSAL)
On F_P write L = P^{1/2}V, V ∈ U(2). Define the clock connection as the u(1)
Maurer–Cartan component θ := (1/2i) tr(V†dV). Parallel transport = "spin frame
may precess (su(2) part free), clock does not tick" — then Proposition I3.5
says free Dirac evolution is NOT parallel: it has constant curvature-free
holonomy rate 2m against this connection, i.e. the mass IS the tick rate. The
gate content: items (1)–(2) of the review are theorems (done above), item (3)
is this definition, item (4) is the physics postulate now stated exactly:
**proper time = det-line holonomy / 2m.**

### 4.4 Synthesis: U(2) = spin × clock — the minimal-split gauge group factorizes
U(2) ≅ (SU(2) × U(1))/ℤ₂. So the redundancy of a minimal null split of a
massive momentum splits into exactly two physical gauge structures:

    SU(2)  = the massive little group  (spin frame)      [review's I1.7]
    U(1)   = the determinant line       (internal clock)  [Gate I3]

and the ℤ₂ identification (−I, −1) is the spinorial double-valuedness that
makes the clock the square root of the det-line motion (Prop. I3.5). One
sentence for the paper: **spin and time are the two factors of the
minimal-split gauge group; the momentum forgets both.** This is the cleanest
conceptual output of the v2.1 revision and costs three finite lemmas
(U(2)/SU(2) ≅ U(1); the ℤ₂ quotient; I3.5).

---

## 5. Gate L0 — Lorentz ensemble viability (development: a specific resolution)

The review is right that this is the program's biggest structural risk, and
right that Bombelli–Henson–Sorkin is more dangerous than v2 acknowledged. I
propose resolving L0 by THEOREM + ONTOLOGY REVISION rather than hoping:

### L0.1 (no-go, to be proved) — finite valency dies
No nontrivial ensemble of locally-finite-valency null-direction graphs on a
Poisson sprinkling is Lorentz-invariant in distribution. Proof strategy: a
finite nonempty set of null directions at a point defines a measurable
equivariant map into finite subsets of the celestial sphere CP¹; the stabilizer
of a finite subset is virtually compact while SL(2,ℂ) admits no invariant
probability measure on CP¹ (no invariant mean; noncompact Möbius action), and
the BHS argument excludes equivariant selection. This upgrades BHS from
"direction field" to "finite direction set," which is the form the null-edge
model needs. Finite, well-posed, and worth doing carefully — it is the
program's own no-go and should be owned, not feared.

### L0.2 (the escape that is also a theorem) — links live
In a Poisson sprinkling, the **link relation** (covering relation of the causal
order: x ≺ y with empty open interval) is defined order-theoretically, hence
exactly Lorentz-invariant in distribution. Moreover links are **asymptotically
null**: the probability a related pair (x,y) is a link is e^{−ρV(x,y)}, and in
d = 4 the interval volume V ~ τ⁴ vanishes on the cone, so link partners
concentrate along near-null separations at all scales. The valency is infinite
in every frame — which is the BHS tax, paid honestly.

### L0.3 (making infinite valency usable) — the damped kernel is forced
The Benincasa–Dowker / generalized causal-set d'Alembertian construction is
exactly the device that turns infinite null-hugging valency into a finite,
covariant operator: layered sums with alternating damped weights, reproducing
□ + curvature corrections on slowly varying fields. Known cost (state it):
nonlocality is irreducible, and fluctuations of the discrete operator are a
real, documented issue (the Aslanbeigi–Saravani–Sorkin line) — the ensemble
average is covariant, single realizations are noisy.

### Ontology revision (adopt)
**Null edges are not primitive finite adjacency data; they are the link
structure of the causal order, and every dynamical use of them must factor
through a damped, layered transport kernel.** This is the review's Escape B
and C merged, with L0.1 explaining why no cheaper escape exists and L0.2–L0.3
explaining why the model survives. The tetrahedral/finite-valency picture is
reclassified as a gauge-fixed regulator (Escape C) whose exact-invariance
claims are withdrawn; the C1 gap computation is unaffected (it is a statement
about the regulator's operator, and its role was always to exhibit a
doubling-free kernel, not an invariant ensemble).

---

## 6. M1′ — metric from the ensemble: symbol, not covariance

The review's signature objection is correct (the tetrahedral second moment is
diag(1, ⅓I), Euclidean-positive). The repair, sharpened into two regimes:

1. **Vacuum / no preferred frame:** raw direction covariance does not exist
   invariantly (boost orbits have infinite volume — the same no-mean fact as
   L0). The invariant object is the **transport operator** of L0.3, and the
   metric is recovered as its **principal symbol**: B̂(k) → −η^{μν}k_μk_ν + …
   on slowly varying fields. Slogan: *the metric is the symbol of the
   invariant kernel.* This is exactly what the BD operators already achieve,
   so M1′ costs a reading, not a discovery.
2. **Matter present (mean timelike u):** the review's reconstruction is right
   and becomes a theorem-shaped statement: isotropic angular covariance in the
   u-frame ⟹ g = u♭⊗u♭ − h uniquely from cone + counting scale; anisotropy ⟹
   Finsler-like effective medium, to be flagged, not hidden.

---

## 7. Gates Q1/Q2 — DPI now, QNEC honestly

**Q1 (exact, formalize now).** For nested finite algebras A_s ⊂ A_{s+1} and
states ρ, σ: S_rel(ρ|_{A_s} ‖ σ|_{A_s}) is monotone under restriction and
nonnegative — finite-dimensional Uhlmann/Petz DPI. So with
S_rel(s) := Δ⟨K_s⟩ − ΔS_s (vacuum-subtracted, per the review), positivity and
monotonicity along nested cuts are FREE exact theorems. Check whether
Physlib/Lean-QuantumInfo already contains finite DPI before building it.

**Q2 (the actual content).** QNEC is the SECOND difference — convexity of
S_rel along null cut deformations — and is not free. Protocol upgrade: use
free-fermion Gaussian technology (Peschel): entropies and modular Hamiltonians
are exact functions of the two-point correlation matrix, so every rung of the
review's ladder (massless calibration → vacuum subtraction → massive →
quenches) is EXACT linear algebra, no Monte Carlo, reproducible to machine
precision, and small instances are even Lean-checkable. Geometry: nested
causal diamonds along a null ray of the 1+1 checkerboard lattice (which ties
Q2 to the program's ZB thread and to Prop. I3.5's frequency). Deliverable
framing per the review: calibrated discrete QNEC, counterterm-modified QNEC,
or a finite-spacing violation — all three are papers.

---

## 8. Gate S1 — mirror erasure (SMG), first instance

Adopt the weakened form: anomaly cancellation is necessary; sufficiency only
in exhibited models (Wang–You framing; Golterman–Shamir constraints
respected). First concrete instance for the null-edge mirror sector: the
Fidkowski–Kitaev ℤ₈ setting (16 Majoranas / the 3-4-5-0-adjacent testbed) —
prove in the finite model that (i) the symmetric quartic interaction gaps the
mirror block uniquely, or (ii) an LSM-type obstruction appears, or (iii)
gapping forces topological order. This is a finite, decidable computation on a
small Hilbert space and is the correct first rung; the general "iff" is
withdrawn per the review.

---

## 9. Gate Λ1′ — relative Hodge theory: the correct home for the Λ mode

The review worries that small causal diamonds are topologically trivial, so
harmonic cohomology has nothing to hold. The fix is that the bookkeeping
complex on a diamond with boundary must be taken RELATIVE:

- Absolute cohomology of a small diamond D: trivial (contractible). ✓ review.
- **Relative cohomology H⁴(D, ∂D) ≅ ℝ** (Lefschetz duality with H₀(D)) — the
  volume class — is nontrivial on every diamond, however small.
- Discrete mixed-boundary Hodge: C^k splits as dC^{k−1}_rel ⊕ δC^{k+1} ⊕ H^k
  with Dirichlet conditions on ∂D; finite linear algebra, Lean-ready.

So the Λ identification should be: **Λ = the coefficient of the harmonic
representative of the relative top class H⁴(D,∂D)** — i.e., the global volume
zero-mode, exactly the unimodular-gravity integration constant the review
suspects, now with a precise discrete home. Sorkin's everpresent-Λ then enters
as the conjugacy Λ ↔ V giving δΛ ~ 1/√V fluctuations — an interpretation
layer, clearly separated from the formalizable decomposition. This upgrades
the P9 Hodge–Helmholtz work from our earlier sessions: the Λ-risk we localized
into "harmonic cohomology" is now localized into ONE relative class of ONE
degree, with boundary conditions specified.

---

## 10. Spectral action

Reclassified as consistency gate G1′.4: heat-kernel asymptotics of the
null-edge operator must reproduce the right Seeley–DeWitt coefficients in the
continuum phase. Not near-term; not evidence.

---

## 11. Revised theorem ladder (v2.1, merged with the review's)

0. **C0 — convention cleanup** (three-J table; grading split). Prerequisite.
1. **I1 — Plücker mass identity** (build order §3.1, incl. the (Σp)² cross-check).
2. **I1.7 — Stiefel splitting** (§3.2).
3. **I1.8 — normalized dictionary** (§3.3; FVG anchor).
4. **I1.9 — (γ·P)² = det P (first-order bridge)** (§3.4).
5. **I2 — finite modular faithfulness** (timelike ⟺ faithful ⟺ finite modular
   Hamiltonian; null ⟺ pure ⟺ singular flow: "null edges do not age").
6. **I3 — determinant-line clock** (§4; Prop. I3.5 and the U(2) = spin × clock
   factorization are the new theorems).
7. **L0 — Lorentz ensemble** (§5: prove L0.1 no-go; adopt links + damped
   kernel; reclassify tetrahedral picture as regulator).
8. **C1 — tetrahedral operator gap** (unchanged; now explicitly a
   regulator-level statement).
9. **Q1 — finite DPI** (§7; check Physlib first).
10. **Q2 — discrete QNEC** (§7; Peschel-exact ladder on checkerboard null cuts).
11. **Λ1′ — relative Hodge + volume mode** (§9).
12. **S1 — mirror erasure, Fidkowski–Kitaev instance** (§8).
13. **M1′/G1′ — metric as symbol; emergent geometry** (§6; after L0 and Q2).

## 12. Publication plan v2.1

**P2 first**, exactly as the review says, with the sharpened title claim:
"Relativistic kinematics as quantum information on the 2×2 PSD cone, formally
verified." Contents: I1, I1.7, I1.8, I1.9, I2, A2 (superadditivity with the
cosh χ identity), plus — new — I3.5 and the U(2) = spin × clock factorization,
which give the paper a genuinely novel theorem rather than only a verified
dictionary. Verify the Physlib/Lean-QuantumInfo status and reuse their DPI/
entropy layers if present. P1 (C1 gap) stays the flagship contingent on the
analytic proof; frame hyperdiamond prior art as opening motivation. P3 (QNEC)
after P2's code exists, with the three-outcomes framing. P4 (program paper)
last.

## 13. Risk register (what would falsify what)

- L0.1 turning out FALSE (a Lorentz-invariant finite-valency ensemble exists)
  would be a pleasant shock; the proof attempt is cheap either way.
- Prop. I3.5 is robust, but the CLAIM "proper time = det-line holonomy" is a
  postulate; a dynamics in which the split does not transform linearly under
  evolution would decouple the clock from the fiber. State as postulate.
- Q2 may yield a finite-spacing QNEC violation; per the framing, that is a
  result, not a failure.
- The Λ1′ identification is falsifiable within the model: if the bookkeeping
  cochain's harmonic part fails to project onto the relative volume class
  under the correct boundary conditions, the Λ story dies cleanly.

## 14. Explicit non-claims

No claim that gravity has been derived (DPI slogan weakened per review); no
claim of exact Lorentz invariance of any finite-valency structure (withdrawn);
no claim that the de Broglie clock has been derived from modular flow (it
provably is not — §4); no claim that SMG erasure is guaranteed by anomaly
freedom; no claim that the spectral action is obtained. The v2.1 center of
gravity is the finite-dimensional kinematic core plus three new finite
theorems (I3.5, U(2) factorization, Λ-relative-class), all Lean-shaped.

— end —
