# D13 — DEC Hodge-Dirac convergence adaptation strategy

No-build strategy/audit deliverable for Gate D of the null-edge / null-strand
super-Dirac program. Question: can Gate D **inherit or adapt** the DEC/FEEC
Hodge-Dirac convergence scaffold (primarily Dabetic-Hiptmair, arXiv:2507.19405)
instead of inventing a continuum proof from scratch?

Provenance of the operator data used below: `Sources__NullStrand_Lean_Roadmap_Improved.md`
(dual-soldered square, tetrahedral inverse-Gram frame, retarded/advanced
doubling) and `Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` §24
(Gate D source pack and the two-lane split). Conventions follow
`COMMON_CONTEXT.md` (safe thesis, no double counting, Lorentzian mostly-minus,
`Phi_H` odd under internal grading `chi_E`, commuting with spacetime chirality
`Gamma_s`).

---

## 0. One-paragraph verdict

**Conditional, leaning "inherit the scaffold, not the theorem."** The *algebraic*
core of the DEC Hodge-Dirac story — exact combinatorial coboundary `d` with
`d^2 = 0`, a discrete Hodge star, codifferential `delta = *^{-1} d^T *`, and the
square identity `(d+delta)^2 = d delta + delta d` (Hodge Laplacian) — is directly
reusable and gives an immediate, analysis-free Lean toy. The *convergence
theorem* of Dabetic-Hiptmair is **Riemannian, elliptic, self-adjoint, with an
SPD discrete Hodge star on a shape-regular refining mesh family**. The null-edge
operator is **Lorentzian, built on null edges (`G_AA = 0`, indefinite-but-invertible
Gram), soldered on a spinor/Clifford module rather than the de Rham complex, and
doubled into a non-self-adjoint retarded/advanced (Krein) operator**. Those are
exactly the four hypotheses the DEC convergence proof leans on. So Gate D can
inherit (a) the cochain square scaffold and (b) the connection-Laplacian *gauge*
lane (Ramanan / Singer-Wu), but it **cannot inherit the convergence theorem
itself** without first supplying a positive/elliptic auxiliary model and a
documented bridge back to the Lorentzian operator. See §7 acceptance/failure.

---

## 1. Closest mathematical object to the null-edge finite operator

Candidate classes considered: (i) DEC Hodge-Dirac `d + delta` on the de Rham
cochain complex; (ii) FEEC Hodge-Dirac (Whitney forms, mass-matrix Hodge star);
(iii) graph Dirac operators; (iv) connection-Laplacian discretizations
(Ramanan, Singer-Wu).

The null-edge finite operator (corrected, post diagonal-trace obstruction) is

```text
D_N = sum_a c(alpha^a) nabla_a,     alpha^a = sum_B G^AB ell_B^flat,
```

i.e. a **soldered first-order Clifford-module operator**: Clifford multiplication
by dual coframe covectors `alpha^a` composed with primal-null finite differences
`nabla_a`. Its square is the Lichnerowicz/Weitzenböck shape
`D_N^2 = K_null + C_diamond + T_frame` (sign conventions reconciled in §5).

Ranking by structural proximity:

1. **Closest: FEEC/connection-Laplacian soldered Dirac.** `D_N` acts on a
   spinor/Clifford module via a *soldering map* `c(alpha^a)` (a discrete
   coframe), and `K_null` is a Bochner/connection Laplacian `nabla^* nabla`.
   This is the operator class of a Clifford-module Dirac operator, **not** the
   de Rham Hodge-Dirac.
2. **Second: connection-Laplacian discretizations (Ramanan / Singer-Wu).** These
   are the right convergence template for the *gauge/holonomy and Higgs
   covariant-gradient* part (`nabla_a -> nabla_a^A`, the `C_diamond` curvature
   endomorphism, the `-i Gamma_s C_a [nabla_a, Phi]` cross term).
3. **Third (template only): DEC Hodge-Dirac (Dabetic-Hiptmair).** Shares the
   *square-to-Laplacian logic*, the exact combinatorial `d`, and the
   de Rham / commuting-diagram scaffold, but lives on `Omega^bullet` (the full
   form complex), not on a spinor bundle. Reusable as **architecture and proof
   template**, not as a drop-in operator identity.
4. **Graph Dirac:** useful for the finite spectral / species side (Gate C,
   Yumoto-Misumi) but too structureless to carry the soldering/curvature data.

**Headline correction to the source framing:** §24.1 of the working plan calls
Hodge-Dirac convergence "the right scaffold." More precisely: the *de Rham
Hodge-Dirac* is the right **template**, but the null-edge operator is a
**Clifford/connection Dirac**, so the load-bearing convergence theory is the
connection-Laplacian lane, with Dabetic-Hiptmair supplying the square and the
commuting-diagram skeleton.

---

## 2. Standard DEC/cochain data vs genuinely null-edge-specific pieces

| Operator piece | Standard DEC/FEEC data? | Null-edge-specific perturbation? |
| --- | --- | --- |
| primal complex, incidence, `d` with `d^2=0` | yes (combinatorial, exact) | no |
| primal-dual pairing / metric on chains | yes, but **SPD** | **null/indefinite** Gram `G_AB`, `G_AA=0` |
| discrete Hodge star `*_h`, codifferential `delta` | yes (SPD, well-centered dual mesh) | no SPD star; only indefinite inverse-Gram `G^AB` |
| soldering `c(alpha^a)` (coframe -> Clifford) | yes (Whitney/Clifford soldering) | yes but **Lorentzian/null** coframe |
| Bochner Laplacian `K_null = nabla^* nabla` | yes (connection-Laplacian lane) | no (standard) |
| curvature endomorphism `C_diamond = 1/4[C_a,C_b][nabla_a,nabla_b]` | yes (Weitzenböck term) | normalization is the open audit (D3/D6) |
| frame defect `T_frame = sum C_a[nabla_a,C_b]nabla_b` | **identically 0** (Whitney soldering is exact) | **genuinely null-edge-specific**; non-zero unless discrete tetrad postulate holds |
| internal zero-order block `Phi^2` (`Phi_H`) | not in pure DEC; appears in spectral-triple/Dirac-Yukawa | yes; lives in `H_internal`, odd under `chi_E` |
| cross term `-i Gamma_s sum_a C_a[nabla_a,Phi]` | appears in generalized Lichnerowicz (Ackermann-Tolksdorf) | yes |
| retarded/advanced doubling `D_double` (Krein) | **not present**; DEC is self-adjoint elliptic | **genuinely null-edge-specific** |

**Two terms carry all the novelty:** `T_frame` (the discrete tetrad/spin-connection
non-compatibility defect, which is *zero* in any exact-soldering DEC/FEEC scheme)
and the **Krein retarded/advanced doubling** (which leaves the self-adjoint
elliptic class entirely). Everything else is either standard DEC/connection data
or a standard generalized-Lichnerowicz endomorphism. The **indefinite/null Gram**
is the structural obstruction that prevents the standard pieces from being
imported verbatim.

---

## 3. Theorem chain: finite cochains -> continuum (Hodge-)Dirac square

Standard FEEC/DEC convergence chain (the Dabetic-Hiptmair skeleton), annotated
with the norms/hypotheses each step consumes:

1. **Mesh family.** `{K_h}` shape-regular, quasi-uniform, refining with `h -> 0`;
   metric data on a fixed smooth manifold `M`. *Hypothesis: shape regularity +
   quasi-uniformity.*
2. **Cochains + coboundary.** `C^k(K_h)`, `d_h` = signed incidence, `d_h^2 = 0`.
   *Exact, combinatorial; no approximation.*
3. **Discrete Hodge star.** `*_h : C^k -> C^{n-k}` from the primal-dual pairing;
   diagonal (DEC) needs **well-centered/Delaunay** dual mesh, mass-matrix (FEEC)
   needs SPD Whitney mass matrices. Defines `delta_h = (-1)^{...} *_h^{-1} d_h^T *_h`.
   *Hypothesis: metric positivity (SPD), dual-mesh regularity.*
4. **de Rham / Whitney maps.** de Rham map `R_h : Omega^k -> C^k` (integration
   over simplices) and Whitney interpolation `W_h : C^k -> Omega^k`. **Commuting
   diagram** `R_h d = d_h R_h`. *Hypothesis: cochain projection / Fortin
   operator exists.*
5. **Consistency.** `||W_h R_h omega - omega|| -> 0`; crucially
   `||*_h - W_h^* * W_h|| -> 0`. The Hodge star is the **only inconsistent piece**;
   well-centeredness/quasi-uniformity are spent here. *Norm: `L^2`/`H Lambda`.*
6. **Stability.** Discrete Poincaré / inf-sup / discrete Hodge decomposition;
   uniform-in-`h` bounds. *Hypothesis: elliptic regularity of the continuum
   Hodge Laplacian, discrete compactness.*
7. **Operator/spectral convergence.** `D_h = d_h + delta_h -> D = d + delta` in
   graph-norm; `D_h^2 -> Delta` (Hodge Laplacian) spectrally (eigenvalues +
   eigenspaces in `L^2`). *This is the Dabetic-Hiptmair payload.*
8. **Boundary conditions.** Closed `M`, or relative/absolute cohomology bc
   imposed on cochains (essential vs natural).

**Null-edge adaptation (what each step becomes, and where it breaks):**

- Steps 1-2 transfer: the tetrahedral null frame + primal-null differences give
  `d_h`-like incidence and `nabla_a`. **But** a *refining mesh family* is not yet
  defined — the program currently fixes one tetrahedral frame; convergence needs
  a family `h -> 0`. **(missing)**
- Step 3 **breaks**: the null Gram `G_AB` has `G_AA = 0` and indefinite
  signature. The inverse-Gram `G^AB` exists (the `4x4` tetrahedral Gram is
  invertible) and supplies the soldering, but it is **not an SPD Hodge star**.
  No diagonal well-centered DEC star and no SPD FEEC mass matrix is available.
  This is the central obstruction.
- Step 4 partially transfers: combinatorial `d` and a commuting diagram are
  plausible, but the **Whitney/Clifford soldering interpolation is not built**,
  and `T_frame != 0` is exactly the statement that the discrete soldering does
  **not** commute with `nabla` (the commuting diagram fails unless the discrete
  tetrad postulate `[nabla_a, C_b]=0` holds). **(conditional)**
- Steps 5-7 **break for the Lorentzian/Krein operator**: elliptic regularity and
  self-adjoint spectral convergence do not apply to the retarded/advanced doubled
  operator. Boguna-Krioukov (arXiv:2506.18745) is the explicit warning class:
  nonlocal/indefinite discrete d'Alembertians can fail basic continuum tests.
- Step 8 differs: the null-edge program replaces "closed manifold / cohomology
  bc" with **causal support** (retarded/advanced), a different and largely
  unstudied boundary condition for convergence.

**Net theorem chain that is actually inheritable (honest version):**

```text
(finite cochain scaffold)  ->  (finite soldered square identity)  ->
(connection-Laplacian convergence of the Riemannian/positive auxiliary part)
  -> [BRIDGE: Wick/positive model <-> Lorentzian-null operator]  ->
(continuum Dirac square)        <-- bridge is the open, possibly-failing step
```

The first two arrows are finite and Lean-realistic now. The third is Ramanan /
Singer-Wu territory (gauge/Higgs covariant gradient). The bracketed **bridge** is
the genuine research risk and the place a hard-failure can occur.

---

## 4. Where the dual-soldered null frame enters

Among "quadrature rule / coframe-soldering map / perturbation of DEC /
incompatible structure," the dual-soldered null frame is **primarily a discrete
coframe (soldering) map, and simultaneously a perturbation of DEC, built on an
indefinite metric that is partially incompatible with the DEC Hodge star.**

- **Not a quadrature rule.** It does not approximate an integral; it assigns
  Clifford generators `C_a = c(alpha^a)` to coframe covectors. The inverse-Gram
  `G^AB` is metric raising, not a cubature weight.
- **It is a coframe/soldering map.** `c(alpha^a)` is the discrete analogue of the
  vierbein/soldering form `e^a_mu`. The tetrad postulate appears as `[nabla_a,
  C_b]=0`; its failure is exactly `T_frame`.
- **It is a perturbation of DEC** in the sense that `K_null` is the
  Bochner/Hodge-Laplacian piece and `C_diamond` is the Weitzenböck endomorphism;
  these are standard DEC/connection terms, and the soldered Dirac square *adds*
  `T_frame` on top.
- **It is partially incompatible** because the null Gram supplies no SPD Hodge
  star. The DEC Hodge star needs positive metric + well-centered dual mesh; a
  null coframe gives an invertible but indefinite Gram. So the soldering can be
  defined, but the *metric/Hodge-star half* of DEC does not come along for free.

Conclusion: the null frame is a legitimate discrete coframe and DEC perturbation;
the incompatibility is localized in the **Hodge star / metric positivity**, not in
the coframe concept itself.

---

## 5. Expressing `D_N^2 = K_null + C_diamond + T_frame` in DEC/FEEC terms

Sign reconciliation first. The roadmap writes the full super-Dirac square
(mostly-minus, with `D = i D_N + Gamma_s Phi`):

```text
D^2 = -Box_null - C_diamond - T_frame + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The prompt's `D_N^2 = K_null + C_diamond + T_frame` is the **bare kinetic block**
with `K_null := -Box_null` and an overall sign convention flip; the two agree once
`K_null` is declared the kinetic mass-shell operator (plane-wave symbol `P^2`),
per the roadmap's "mass-shell sign convention" guardrail. **Document this once in
Gate A and import it; do not let `Box`/`K`/`D^2` drift** (this is the standing
G2 sign-dashboard hazard).

DEC/FEEC dictionary, term by term:

| Null-edge term | DEC/FEEC / connection-Laplacian object |
| --- | --- |
| `K_null = -Box_null` | discrete **Bochner / Hodge Laplacian** `nabla^* nabla` (DEC: `delta_h d_h + d_h delta_h` on the relevant degree; FEEC: Whitney-mass weighted) |
| `C_diamond = 1/4 [C_a,C_b][nabla_a,nabla_b]` | **Weitzenböck curvature endomorphism** = Clifford-contracted discrete curvature `1/4 F_{ab} c^a c^b`; the connection-Laplacian-lane discrete `F` term |
| `T_frame = sum_{a,b} C_a [nabla_a,C_b] nabla_b` | **discrete tetrad/spin-connection defect**; identically `0` in exact-soldering DEC/FEEC; the commuting-diagram-failure term |
| `+Phi^2` | zero-order endomorphism of the generalized Lichnerowicz formula (spectral-triple internal block) |
| `-i Gamma_s C_a [nabla_a,Phi]` | first-order Yukawa/Higgs-gradient cross term (Dirac-Yukawa, Ackermann-Tolksdorf / Tolksdorf class) |

So the finite square is **a discrete generalized-Lichnerowicz / Weitzenböck
decomposition**: `D_N^2 = (Bochner Laplacian) + (curvature endomorphism) +
(soldering defect)`. The standard FEEC fact is that with exact soldering the last
term vanishes and one recovers `nabla^* nabla + Weitzenböck`. The **null-edge
content is precisely the non-vanishing `T_frame` and the indefinite/null metric
sitting inside `nabla^* nabla`**.

This is a clean, fully finite linear-algebra statement — no limits — which is why
it is the right Lean entry point (§6).

---

## 6. First Lean-realistic toy theorem (no analysis infrastructure)

Goal: capture the *inheritance* claim with finite linear algebra only, no
filters, no `h -> 0`, no Sobolev spaces. Propose a single new draft file
`PhysicsSM/Draft/DECHodgeDiracFiniteSquare.lean` with two independent finite
theorems.

**Toy A — finite DEC Hodge-Dirac square (the inheritable scaffold).**
Over a finite-dimensional inner-product setting (cochain spaces as
`EuclideanSpace`/`Matrix` blocks), with a coboundary `d` satisfying `d ∘ d = 0`
and an SPD discrete Hodge star `M` (so `delta := M⁻¹ dᵀ M`), prove

```text
(d + delta)^2 = d * delta + delta * d        -- discrete Hodge Laplacian
```

i.e. the cross terms `d∘d` and `delta∘delta` vanish. Pure linear algebra;
`decide`/`ring`/`Matrix` lemmas suffice. This proves Lean **can host** the
Dabetic-Hiptmair square, which is the honest meaning of "inherit the scaffold."

**Toy B — soldered square reduces to DEC shape under the tetrad postulate.**
With finite Clifford generators `C_a` (a `[C_a,C_b]_+ = 2 G^{ab}` relation on a
finite module) and finite-difference operators `nabla_a` as commuting linear
maps, define `D_N := sum_a C_a nabla_a` and prove the finite identity

```text
D_N^2 = K_null + C_diamond + T_frame,
  K_null   := sum_a G^{aa-block} nabla_a^2  (Bochner piece),
  C_diamond:= 1/4 sum_{a,b} [C_a,C_b][nabla_a,nabla_b],
  T_frame  := sum_{a,b} C_a [nabla_a, C_b] nabla_b,
```

and the **tetrad-postulate corollary**: `(∀ a b, [nabla_a, C_b] = 0) → T_frame = 0`,
hence `D_N^2 = K_null + C_diamond`, matching the exact-soldering DEC/FEEC shape.

Both are finite identities provable now. They deliver exactly the audit's
load-bearing claims: the scaffold is hostable (A), and the null-edge square *is*
the DEC/Weitzenböck square plus a soldering defect that vanishes iff the discrete
tetrad postulate holds (B). **Crucially, neither asserts continuum convergence** —
that is deferred behind the §3 bridge and is not faked.

Guardrails for the Lean job: distinctive names (avoid `Matrix.det`, `delta`,
`star` collisions — use `decHodgeDirac`, `nullSolderedSquare`, `frameDefect`);
mark anything using `Classical`/reals `noncomputable`; keep `import Mathlib`.

---

## 7. Acceptance and hard-failure criteria for Gate D (via this route)

**Acceptance (staged):**

- **D-acc-1 (finite, now):** Toy A and Toy B compile sorry-free; the term-by-term
  DEC dictionary of §5 is realized as a kernel-checked identity, and the tetrad
  postulate provably kills `T_frame`.
- **D-acc-2 (structural):** explicit, written identification of the *exact*
  perturbations outside standard DEC/FEEC: (i) indefinite/null Gram → no SPD
  Hodge star, (ii) non-zero `T_frame`, (iii) Krein retarded/advanced doubling.
- **D-acc-3 (gauge lane):** a connection-Laplacian convergence statement
  (Ramanan / Singer-Wu template) for the *positive/Riemannian* covariant-gradient
  part `nabla_a^A`, with the curvature endomorphism `C_diamond` converging to
  `1/4 F_{ab} c^a c^b`. (D14.)
- **D-acc-4 (bridge, hardest):** EITHER a documented positive/elliptic auxiliary
  model (e.g. Wick-rotated or signature-deformed) for which a Dabetic-Hiptmair-type
  convergence holds, together with an explicit, assumption-tracked bridge back to
  the Lorentzian-null operator; OR an honest, proved statement that the operator
  lies outside the convergence class and a named replacement (e.g. local
  causal-set d'Alembertian à la Boguna-Krioukov) is adopted.

Gate D **passes** if D-acc-1..3 hold and D-acc-4 is resolved in *either*
direction with claims labeled accordingly (reconstruction vs convergence).

**Hard failure:**

- **D-fail-1:** the null/indefinite Gram admits *no* consistent discrete Hodge
  star meeting the convergence hypotheses, AND no positive auxiliary bridge
  preserves the soldering → DEC Hodge-Dirac convergence is not inheritable.
- **D-fail-2:** the retarded/advanced Krein operator exhibits causal-set-style
  non-convergence (Boguna-Krioukov failure mode): the discrete symbol does not
  approach a local continuum d'Alembertian as the frame family refines.
- **D-fail-3:** `T_frame` is non-zero AND not interpretable as a discrete
  spin-connection/torsion term (i.e. frame variation is not covariantly
  transported) → continuum contamination, no Dirac square.

Any hard failure triggers the safe downgrade: **freeze Gate D as a finite
dual-soldered reconstruction / finite Lichnerowicz identity**, drop continuum
convergence claims, and keep the finite square (Toys A/B) as the trusted surface.

---

## 8. Ordering: does this route precede or replace D1/D2/D6/D7?

Recommendation:

- **Keep D2 first.** Estimate-framework selection (filters vs asymptotic
  notation vs normed finite-difference API) is cheap and decides the analysis
  API for everything downstream. D13 does not remove this need.
- **D13 (this) PRECEDES and reframes D1 and D7.** The bespoke "smooth local
  symbol asymptotic" (D1) and "flat continuum square limit" (D7) should be
  recast as *instances* of the connection-Laplacian lane and the DEC square
  template, not built from scratch. The finite Toys A/B replace the missing
  scaffold those jobs assumed.
- **D13 does NOT replace D6.** The Lichnerowicz comparison audit becomes the
  *curvature-endomorphism (`C_diamond`) normalization check* inside this scaffold
  (the Pauli/`1/4 F_{ab}c^a c^b` coefficient). D6 is complementary and should run
  alongside D-acc-3.
- **Net Gate D reorder:**
  `D2 -> D13 -> (finite Toys A/B) -> D6 (curvature normalization) -> D14 (connection-Laplacian) -> D1/D7 reframed -> D11/D15 (Krein/causal-set convergence + falsification)`.

This route therefore **reorders and subsumes** the from-scratch continuum jobs
without deleting them, and **adds** the explicit Krein/causal-set falsification
checkpoint (D11/D15) that the original D1/D7 framing lacked.

---

## 9. Assumptions table: DEC/FEEC required vs null-edge available

| Assumption | DEC/FEEC (Dabetic-Hiptmair) requires | Null-edge currently provides | Status |
| --- | --- | --- | --- |
| metric signature | Riemannian (positive-definite) | Lorentzian, mostly-minus | **mismatch** |
| chain metric / Gram | SPD primal-dual pairing | null edges `G_AA=0`, indefinite invertible `G_AB` | **mismatch** |
| discrete Hodge star `*_h` | well-centered/Delaunay (DEC) or SPD Whitney mass (FEEC) | inverse-Gram `G^AB` (indefinite); no SPD star | **mismatch** |
| operator class | Hodge-Dirac `d+delta` on de Rham complex | soldered Clifford Dirac `c(alpha^a)nabla_a` on spinor module | related, **different bundle** |
| self-adjoint / elliptic | yes (spectral convergence relies on it) | retarded/advanced Krein-doubled, `J`-self-adjoint, non-elliptic | **mismatch** |
| coframe / soldering | exact Whitney soldering, `T_frame ≡ 0` | discrete null coframe; `T_frame=0` only under tetrad postulate | **conditional** |
| commuting de Rham diagram | `R_h d = d R_h`, Whitney interpolation exists | combinatorial `d` plausible; Whitney/soldering interpolation not built | **missing** |
| refining mesh family | shape-regular, quasi-uniform, `h->0` | single fixed tetrahedral frame; no refinement family | **missing** |
| boundary conditions | closed manifold / cohomology bc | causal (retarded/advanced) support; not a studied convergence bc | **different/missing** |
| stability / regularity | discrete Poincaré + elliptic regularity | none established (Lorentzian, indefinite) | **missing** |
| convergence norm | graph-norm / spectral, `L^2`-`H Lambda` | none; only finite/affine symbol so far | **missing** |
| Bochner Laplacian `K_null` | yes (`nabla^* nabla`) | yes (finite) | **available** |
| curvature endomorphism `C_diamond` | yes (Weitzenböck) | yes (finite); normalization = D6 audit | **available (finite)** |

Pattern: the **finite/algebraic** rows are available; every **analytic/continuum**
row (positive Hodge star, ellipticity, mesh family, regularity, convergence norm,
boundary conditions) is mismatched or missing. This is the precise content of the
"conditional" verdict.

---

## 10. Recommended first Aristotle proof job after this audit

**`PhysicsSM/Draft/DECHodgeDiracFiniteSquare.lean`** — finite, analysis-free,
containing Toy A and Toy B of §6:

1. `decHodgeDirac_sq` : with `d ∘ d = 0` and SPD discrete star `M`,
   `(d + M⁻¹ dᵀ M)^2 = d (M⁻¹ dᵀ M) + (M⁻¹ dᵀ M) d`.
2. `nullSoldered_sq` : `D_N^2 = K_null + C_diamond + T_frame` as a finite
   Clifford-module identity, plus corollary
   `frameDefect_eq_zero_of_tetrad : (∀ a b, [nabla_a, C_b] = 0) → T_frame = 0`.

This is the honest, kernel-checkable kernel of "inherit the DEC scaffold": it
proves the square logic is hostable and that the null-edge square is the
DEC/Weitzenböck square plus a soldering defect controlled by the discrete tetrad
postulate — **without** asserting any continuum limit. Continuum convergence
remains gated behind D-acc-3/D-acc-4 and the §3 bridge.

---

## 11. Concise verdict

**Conditional.**

- **Inherit (promising):** the cochain square scaffold, the generalized-Lichnerowicz/
  Weitzenböck term dictionary, and the connection-Laplacian *gauge* convergence
  lane (Ramanan / Singer-Wu) for the positive covariant-gradient part. These give
  an immediate finite Lean toy.
- **Do not inherit without a bridge (likely mismatch):** the Dabetic-Hiptmair
  *convergence theorem* itself. It assumes Riemannian metric positivity, an SPD
  discrete Hodge star, ellipticity/self-adjointness, and a refining shape-regular
  mesh — all four of which the Lorentzian, null-Gram, Krein-doubled null-edge
  operator currently violates.
- **Decisive risk:** the indefinite/null Hodge star and the retarded/advanced
  Krein doubling, against which Boguna-Krioukov's causal-set d'Alembertian
  warnings are the explicit falsification class.

Proceed by inheriting the scaffold (Toys A/B), running the connection-Laplacian
gauge lane and the D6 curvature-normalization audit, and treating the
positive/elliptic bridge as the single make-or-break continuum step — with the
finite dual-soldered reconstruction as the pre-committed safe downgrade.
