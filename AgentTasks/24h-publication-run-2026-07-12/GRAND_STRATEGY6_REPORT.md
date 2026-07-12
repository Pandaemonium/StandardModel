# GRAND STRATEGY REVIEW 6 — corrected 3+1 program

Document-only strategy packet. No Lean or build was run in producing this
report. Sources read in full: `MEMO_3PLUS1_ATTACK.md`,
`CORRECTED_CHARGE_AUDIT_REPORT.md`, `GLOBAL_CHIRALITY_AUDIT_REPORT.md`,
`COMMUTATOR_REGULATOR_AUDIT_REPORT.md`,
`B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`,
`B_MASSLESS_CHARGE_CENSUS_ORACLE_2026-07-11.md`,
`SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md`, `PAPER_GATE_MATRIX.md`,
and the charge/chirality/no-go passages of
`Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
(≈1408–1466, 1490–1520, 1755–1790, 2080–2110).

Claim discipline (inherited from the memo): **KERNEL** = kernel-checked Lean;
**VERIFY** = primary-source literature fact that must be full-text checked
before any manuscript use; everything else is strategy.

---

## 0. The binding correction, restated so nothing downstream drifts

The massive four-component Dirac tangent is **class-A neutral**. Kernel content
(`massBlend_sq`, endpoints `massBlend_start/_end`, plus the anticommutation
control `exists_nonanticommuting_blend_failure`): for anticommuting involutions
`F,β`, the family `F_s = cos(πs/2)F + sin(πs/2)β` is involutory for every `s`
and ends at the constant `β`. This is a *pointwise unit-circle family of gapped
involutions*, hence an explicit algebraic contraction of the full tangent to a
constant. The topological reading ("null-homotopic ⇒ total class-A charge = 0")
is an informal corollary, **not** a kernel homotopy theorem.

Consequence that governs the whole program: **charge lives only in the two
globally split Weyl sectors** selected by `Ξ = −i α₁α₂α₃`, and only when the
global splitting hypothesis `[U(q),Ξ]=0` holds at every momentum. The kernel
knows exactly when that holds for the live ordered step:
`splitStep_commutes_iff_sin_theta_zero` gives `[U(q,θ),Ξ]=0 ⇔ sin θ=0`, with no
momentum exception (the commutator's matrix factor is determinant-one at every
`q`). So the massless walk is globally split; every genuine mass angle mixes the
sectors.

Two adversarial invariants that must survive into every sentence below:

- **A local Jacobian sign is not a global invariant.** `localCrossingCharge J =
  sign(det J)` is a total function of a supplied `3×3` matrix. `sign(det J) =
  Chern/Berry monopole charge` is a separate theorem that is **not** present.
  Whenever a sum of these signs is used, the sum's vanishing must be established
  either by *exact enumeration of the complete crossing set* (rung 1) or by the
  *external Read+Floquet composition* (rung 4) — never by asserting the local
  sign is itself a conserved topological charge.
- **Chirality mixing ≠ alias removal.** Adding a `Ξ`-odd term makes the
  *sectorwise* no-go inapplicable (it breaks the `[U,Ξ]=0` hypothesis). It does
  **not** by itself remove any crossing: aliases are the zero set of
  `det(U∓I)`, defined with no reference to `Ξ`. A `Ξ`-odd perturbation lifts an
  alias only if it actually moves the eigenvalue off `±1` there, which requires
  an **exact root-exclusion certificate** (rung 3), not merely a nonzero
  `U_perp`. Every claim that "we broke the chiral class, therefore we made
  de-aliasing progress" is rejected.

---

## 1. Ranking of the next six-hour theorem program by publication leverage

| Rank | Rung | 6h feasibility | Leverage | Kill risk |
| --- | --- | --- | --- | --- |
| **1** | R1 — exact 16-crossing 0/π census → conditional doubling no-go (kernel) | High (finite algebra + crossing classification) | **Highest**: first exact kernel-checked discrete-time doubling census for the ordered-Pauli architecture; upgrades the decorative `diracSectorCharges_cancel` into an instance of a real theorem via the finite hinge | Depends on the in-flight massless crossing *completeness* classification landing; packaging defect F1 must be repaired first |
| **2** | R4 — external Read+Floquet composition, source-verified (VERIFY, not kernel) | Low as a *proof*; feasible as an audited source/convention memo | High: the only route that generalizes R1 from *this symbol* to a *class* no-go (the actual discrete-time Nielsen–Ninomiya prize) | Convention drift (Read `R_3`=quaternionic; Bessho–Sato π-sign; algebraic K₁ vs topological K¹ vs stable rank); must **never** be encoded as a Lean axiom |
| **3** | R2 — smallest exact finite-range unitary `Ξ`-odd commutator ansatz (kernel, finite algebra) | High | Medium: sharp probe of the escape class; most likely a *negative* "mixing reshuffles, does not de-alias" result, itself publishable | Easy to overclaim; the quarter-turn collapses to central `±I` (pure 0↔π reshuffle) are the standing traps |
| **4** | R3 — exact root-exclusion certificate for an alias-free candidate (kernel checker) | Medium (point/regression form cheap; full exclusion hard) | Low as a positive result (a genuine single-cone finite-range chiral exclusion would *contradict* R1/R4); high as a **falsifier/regression harness** and for the massive Wilson exclusion | A purported positive certificate for a chiral single cone is almost surely a bug; treat positive results as red flags to audit |

Rationale for the order. R1 is the only rung that is both *now-provable in the
kernel* and *directly field-relevant*: an exact, exhaustive, sign-resolved 0/π
crossing census is, per the literature audit, not stated in any of Bessho–Sato
2006.04204, Higashikawa 1806.06868, D'Ariano 1705.08552, or Mlodinow–Brun
1802.03910 for the literal ordered-Pauli normal form — so the exact enumeration
is a genuine novelty *at the level of the specific architecture* (see §7 for the
adversarial novelty limits). R4 is higher-prestige but is an
external-composition gate, not a six-hour kernel deliverable; the honest
six-hour output there is a reproducible source/convention memo, not a theorem.
R2 is cheap finite algebra and clarifies the escape class, but its expected
value is a negative result. R3's positive form is essentially precluded by R1/R4
for the chiral class and is most useful as a regression/falsification tool and
for the *massive* (Wilson) exclusion, which is already half-done at the
Hamiltonian level.

---

## 2. R1 — the 16-crossing 0/π charge census as a rigorous no-go

### 2.1 The exact oracle to be landed (from `B_MASSLESS_CHARGE_CENSUS_ORACLE`)

For the positive Weyl restriction of the ordered massless step
`U(q) = exp(−i qx σ₁) exp(−i qy σ₂) exp(−i qz σ₃) = u₀ I − i u·σ` with

```
u₀ = cx cy cz − sx sy sz,   u₁ = sx cy cz + cx sy sz,
u₂ = cx sy cz − sx cy sz,   u₃ = cx cy sz + sx sy cz,
```

the real Jacobian of `(u₁,u₂,u₃)` in `(qx,qy,qz)` has the exact determinant

```
det J(q) = u₀(q) · (cos²qy − sin²qy) = u₀(q) · cos 2qy.
```

Crossing set on the principal torus representative: **8 cube corners**
`qⱼ ∈ {0,π}` and **8 body centers** `qⱼ ∈ {±π/2}`. At corners `cos 2qy = 1`, so
`det J = u₀`; at body centers `cos 2qy = −1`, so `det J = −u₀`. The signed sums
within each quasienergy sector are

```
Σ_{U=+I} sign(det J) = (+4) + (−4) = 0     (quasienergy 0)
Σ_{U=−I} sign(det J) = (−4) + (+4) = 0     (quasienergy π)
```

### 2.2 What the kernel must actually prove (do not skip any)

1. **Pauli coefficients** `u₀..u₃` from the *actual* restricted live step (not a
   hand-copied matrix) — algebraic identity, KERNEL.
2. **Jacobian identity**: the displayed `3×3` matrix is the actual `fderiv`
   (or finite difference matched to `fderiv`) of `(u₁,u₂,u₃)`; and
   `det J = u₀·cos 2qy` — KERNEL. *This is the step that ties `localCrossingCharge`
   to a real derivative and removes the "supplied fixture" hedge.*
3. **Completeness**: the `±I` crossing set on the fundamental domain is *exactly*
   these 16 points — supplied by the in-flight massless crossing classification
   (`det(U⁴∓1) = 4 P_{0,π}`; the three momentum cosines vanish simultaneously).
   Until completeness lands, R1 is conditional on an *assumed* crossing set and
   must be labelled so.
4. **Sixteen exact signs and the two sector sums = 0** — finite `decide`/`ring`
   over ℚ once `u₀` is evaluated at each point (each `u₀ ∈ {+1,−1}`), KERNEL.
5. **The finite hinge**: feed `Σ = 0` and "one nondegenerate crossing" into the
   already-landed `ChargeBalanceForcesPartner` (memo A4) to conclude *no isolated
   nondegenerate crossing exists in either sector*.

### 2.3 The honest no-go statement (does NOT pretend local = global)

> **R1 (conditional doubling census, per-architecture).** For the `2×2` Weyl
> restriction of the ordered massless cubic step, the exact set of `±I`
> crossings on the fundamental domain is the sixteen points above; the
> Jacobian-sign charge `sign(det J)` takes the enumerated values `±1` at each;
> and within each quasienergy sector (`U=+I` at `0`, `U=−I` at `π`) the sixteen
> signs sum to zero. By the finite hinge `ChargeBalanceForcesPartner`, no single
> isolated nondegenerate crossing is possible in this architecture: every
> nondegenerate crossing has a distinct nondegenerate partner.

The rigor comes from **exhaustive enumeration of a complete crossing set**, not
from asserting that each `sign(det J)` is a conserved monopole charge. The
sentence "the signed sum vanishes" is here a *computed arithmetic fact about
this specific map on a complete finite set*, exactly the discipline the audit
demands (`CORRECTED_CHARGE_AUDIT` S1/S4, §7 hinge). It is a **witness that this
architecture doubles**, not a proof that any architecture must.

### 2.4 Nondegenerate fixture and killer counterexample

- **Nondegenerate fixture.** `q = (0,0,0)`: `U = +I`, `u₀ = +1`,
  `cos 2qy = 1`, so `det J = +1 > 0`, charge `+1`, Jacobian invertible. A clean
  single nondegenerate corner crossing with a well-defined `±1` sign.
- **Killer counterexample (degenerate control).** A rank-deficient supplied
  Jacobian — `singularControlJacobian = diagonal ![1,1,0]`, `det = 0`,
  `singularControl_charge = 0`. This must be **excluded** from the census: a
  degenerate crossing carries no `±1` sign and cannot be counted as one of the
  sixteen. Second control (memo/oracle-required): a **wrong-parity cube corner**
  where `u ≠ 0` is *not* a `±I` crossing at all and must not enter the set —
  guarding against inflating the census with non-crossings.

### 2.5 Standing traps for R1

- The `det J = u₀·cos 2qy` factor is **asymmetric** in `qx,qy,qz` (the ordering
  breaks cubic symmetry). Do not "symmetrize" it; the `cos 2qy` factor is what
  flips corner vs body-center signs and produces the cancellation. A symmetrized
  guess destroys the theorem.
- "Principal torus representative": confirm no double counting of the `±π/2`
  body centers and that the sixteen exhaust the fundamental domain. If the
  classification returns a different fundamental cell, re-derive the count there.
- Packaging defect **F1** (`GLOBAL_CHIRALITY_AUDIT`): the dependency modules
  (`Clifford3Plus1WalkSymbol`, `SU2LocalCrossingCharge`, `Compact3Plus1DiracRate`,
  `FullBlochSplitDeterminants`, `CubicWeylSectorCharge`) and the
  `PhysicsSM.Draft.NullEdge.*` module path are **not present** in this project
  (only `RequestProject/Main.lean` exists here). R1 cannot be kernel-checked
  until those modules are shipped and `lakefile.toml` module roots align. This
  is a reproducibility gate, not a soundness defect — but it blocks the six-hour
  landing and must be repaired first.

---

## 3. R2 — smallest exact finite-range unitary commutator ansatz

### 3.1 The primitive (from `CommutatorRegulator.lean`, B2)

`regulator cp sp cq sq A G = phaseStep cp sp A · phaseStep cq sq G ·
phaseStep cp (−sp) A · phaseStep cq (−sq) G`, i.e. the group commutator
`[a,b]=a b a⁻¹ b⁻¹` with `a = exp(−ipA)`, `b = exp(−iqG)` for Hermitian
involutions `A,G` on the trig circle. KERNEL facts already available: it is
unitary (`regulator_unitary`); trivial when either angle is zero
(`regulator_first/second_axis_zero`); `regulator 0 1 0 1 A G = A G A G`; central
`−I` at the quarter turn for anticommuting double involutions
(`anticommuting_quarterTurn_eq_neg_one`); and a genuinely non-central rational
witness (`exists_noncentral_quarterTurn`). The audit's smallest honest successor
is the companion `commuting_quarterTurn_eq_one` (commuting involutions ⇒ `+I`),
pinning both central values by the sign of `[A,G]`.

### 3.2 The decision: what is the smallest ansatz worth testing

**Decision.** The smallest ansatz worth testing is a **single `Ξ`-odd
commutator plaquette multiplied onto the massless ordered step**:

```
U'(q) = U_massless(q) · regulator(cos qᵢ, sin qᵢ, cos qⱼ, sin qⱼ, A, G),
        with A chirality-EVEN (Ξ A = A Ξ),  G chirality-ODD (Ξ G = −G Ξ).
```

Justification against the requirements:

- **Exactly unitary**: product of unitaries (`isUnitary_mul`), for Hermitian
  involutions on the circle. KERNEL-ready.
- **Finite Laurent range**: each `phaseStep(cos q, sin q, ·)` is degree-one in
  `z=cos+i sin`; the plaquette adds range one to the base step. Range grows by
  exactly one axis-pair.
- **Correct jet structure (A5)**: the leading bilinear expansion is
  `regulator ≈ I − sp·sq·[A,G] + …`, so the odd part begins at order
  `sin qᵢ · sin qⱼ` — **zero constant and linear odd jets**, matching
  `diracFirstJet_perp_eq_zero`. The leading coefficient `GA−AG` is `Ξ`-odd
  exactly when `A` is `Ξ`-even and `G` is `Ξ`-odd (manuscript ≈1466: for the
  live `(α₁,β)` pair this coefficient is nonzero and equals its full odd
  projection).

One plaquette (one axis-pair, one `Ξ`-odd commutator) is the *minimal* object
that is simultaneously exact-unitary, finite-range, and first-jet-preserving
with a nonzero `Ξ`-odd quadratic term. Anything smaller (a single `phaseStep`,
or a plaquette with `[A,G]=0`) has no `Ξ`-odd content.

### 3.3 The adversarial verdict (state this loudly)

A single `Ξ`-odd plaquette **breaks the global chiral splitting** (so the
sectorwise no-go A2/`splitStep_commutes_iff_sin_theta_zero` no longer applies) —
but by the two standing invariants of §0 this is **not** de-aliasing. Expected
outcome, aligned with Route C's finite-lab result ("reshuffle-and-gap, not
sector deletion; the naive 'the kick deletes the π-sector modes' is FALSE at
eigenvector level"): the plaquette redistributes/hybridizes crossings without
lowering their count, because charge conservation for the finite-range
translation-invariant class survives. The publishable statement is therefore
most likely the **negative/sharp** one: *a single `Ξ`-odd commutator plaquette
removes the global chiral grading yet provably retains the aliases* (verified by
an R3 point certificate that a specific alias is still a root of `det(U'∓I)`).

### 3.4 Nondegenerate fixture and killer counterexample

- **Nondegenerate fixture.** `exists_noncentral_quarterTurn`:
  `A = swap⊕I₂`, `G = [[3/5,4/5],[4/5,−3/5]]⊕I₂` (both Hermitian involutions);
  the quarter-turn regulator restricts to the rotation by `2·arctan(3/4)`
  (`cos = 7/25, sin = 24/25`), `≠ ±I` — a genuine, non-central, exactly-unitary
  mixing element.
- **Killer counterexample (collapse controls).** (i) commuting involutions ⇒
  `regulator 0 1 0 1 A G = +I` (`commuting_quarterTurn_eq_one`); (ii)
  anticommuting double involutions ⇒ `−I` (`anticommuting_quarterTurn_eq_neg_one`).
  Both are *central* at the quarter turn: they merely **exchange 0- and
  π-quasienergy modes** and add no `Ξ`-odd content — the exact "collapse to
  central `±I` and reshuffle zero/π" negative control the memo B2 demands.
  Additional control: `exists_failure_without_second_involution` shows the
  collapse identity fails if `G²≠1`, i.e. the involution hypotheses are
  load-bearing (do not silently drop them when embedding into the walk).

---

## 4. R3 — exact root-exclusion certificate for an alias-free candidate

### 4.1 The certificate format (from B4)

Encode the torus by `z_j = c_j + i s_j` with `c_j² + s_j² = 1` (real polynomial
ring `ℝ[c₁,s₁,c₂,s₂,c₃,s₃]`). The intended Dirac point is `z = (1,1,1)`
(`q = 0`). An **alias-free** candidate `U(z)` requires that
`det(U − I)` and `det(U + I)` have **no common torus root other than the
origin**. The kernel-checkable certificate is a Positivstellensatz /
Nullstellensatz witness:

- Introduce the Rabinowitsch saturation variable `w` with
  `w · ρ(z) = 1`, where `ρ(z)` vanishes *only* at the intended origin (e.g.
  `ρ = (c₁−1)² + (c₂−1)² + (c₃−1)²` restricted to the torus), thereby excising
  the origin.
- Provide explicit polynomials `gₖ` and SOS multipliers such that

```
1 = Σ gₖ · (torus & crossing equations)  +  (w·ρ − 1)·h  +  SOS
```

  i.e. `1` lies in the saturated ideal generated by
  `{c_j²+s_j²−1, Re det(U∓I), Im det(U∓I), w·ρ−1}`. The kernel decides the
  certificate by checking the *polynomial identity* over ℚ (`ring`/`decide`,
  or `native_decide` on the coefficient vector) — an oracle (Gröbner/resultant)
  *discovers* the `gₖ`; the kernel only *checks* the resulting identity.

### 4.2 The adversarial verdict (this is the crux of the whole packet)

For the **chiral finite-range translation-invariant single-cone** target, a
*positive* exclusion certificate essentially **cannot exist**: it would assert a
single isolated crossing, contradicting R1 (this architecture) and R4 (the
class). Any positive certificate returned for such a candidate is a red flag —
audit for (a) a dropped body-center or π-quasienergy root, (b) a wrong
fundamental domain, (c) loss of exact unitarity, or (d) a hidden non-finite
range. **Do not publish a positive single-cone chiral exclusion without an
independent recount of the complete crossing set.**

The certificate's honest uses are two:

1. **Point/regression falsifier (cheap, kernel-now).** To *refute* an alias-free
   claim, exhibit one extra root: substitute explicit coordinates (e.g. a body
   center `(π/2,π/2,π/2)`) and check `det(U'∓I) = 0` by `decide` over ℚ. This is
   the natural R2 companion: certify that the `Ξ`-odd plaquette did *not* remove
   the alias.
2. **Massive-candidate exclusion (positive, and legitimate).** The **Wilson**
   route is where a positive exclusion is both true and already half-landed:
   `WilsonDiracRegulator.H_sq` gives
   `H_W(q)² = (Σ sin²q_j + M_W(q)²) I` with `M_W = m + r Σ(1−cos q_j)`, and
   `massless_energy_eq_zero_iff` shows for `m=0, r>0` the energy vanishes iff
   `cos q₁=cos q₂=cos q₃=1` — every non-origin corner is lifted (e.g. `(π,0,0)`
   has energy² `= 4r²`). This *is* a valid exclusion certificate, but at the
   **Hamiltonian** level. The open gate is the exact-unitary discrete-time
   version: `exp(−itH_W)` is unitary but is **not** asserted to be a finite
   Laurent polynomial / strictly finite-range one-step update. R3's real prize
   is a finite-range unitary carrying the Wilson exclusion — and this is
   precisely where breaking chirality (Wilson term is a chirality-flip mass) is
   *legitimately* coupled to de-aliasing, unlike the free R2 plaquette.

### 4.3 Nondegenerate fixture and killer counterexample

- **Nondegenerate fixture.** The Wilson corner lift: at `(π,0,0)`,
  `M_W = 2r`, energy² `= 4r² > 0` for `r>0` — a manifest, kernel-checked
  positive lower bound excluding that corner. This is the *template* for a valid
  exclusion certificate (an explicit positive scalar bound).
- **Killer counterexample.** The **massless ordered step itself**: any purported
  alias-free certificate is refuted by substituting `q = (π/2,π/2,π/2)` (a body
  center), where `U = ±I` is a genuine crossing — `det(U∓I) = 0` there by direct
  ℚ evaluation. A candidate that "passes" an exclusion check while this root
  survives has a broken certificate.

---

## 5. R4 — the external Read + Floquet theorem, with every hypothesis

This is the composition that would upgrade R1 (this symbol) to a **class-level
discrete-time Nielsen–Ninomiya no-go**. It is **VERIFY**, to be checked in full
primary text; it must **never** be encoded as a Lean axiom. Only the finite
implication (`Σ charges = 0 ⇒ partner`, already `ChargeBalanceForcesPartner`) is
kernel content.

### 5.1 Statement to be assembled

> **R4 (target composite, VERIFY).** Let `U(z) ∈ M_N(ℂ[z₁^±,z₂^±,z₃^±])` be a
> finite-Laurent-range symbol that is exactly unitary on `T³` and translation
> invariant, admitting a constant Hermitian involution `Ξ` (`Ξᴴ=Ξ`, `Ξ²=1`)
> with `[U(z),Ξ]=0` for all `z` (global chirality). Then within each quasienergy
> sector (`0` and `π`) the total Weyl-sector charge is zero; hence no isolated
> single nondegenerate `±1`-crossing exists in either sector.

### 5.2 Read side — hypotheses (arXiv:1608.04696v3, PRB 95, 115309)

- **Ring and automorphism.** `U` is an **automorphism of the same free complex
  Laurent module** `R₁^{(d)} = ℂ[z₁^±,…,z_d^±]` (`d=3`), with the `sharp`
  involution convention matching unitarity. (Notation caveat: Read's `R_3` is
  the **quaternionic** ring; read the attachment's `R_3` only as "three-variable
  ring.")
- **K₁ computation.** Bass–Heller–Swan iterated:
  `K₁(R[t,t⁻¹]) ≅ K₁(R) ⊕ K₀(R)`, giving
  `K₁(ℂ[z₁^±,z₂^±,z₃^±]) ≅ ℂ* ⊕ ℤ³`.
- **Change of rings.** Under `Laurent → C(T³)`, the image in `K¹(T³)` has **no
  nonzero `SK₁` / strong three-dimensional component**; only the constant unit
  (`ℂ*`) and the three coordinate windings (`ℤ³`) survive. The higher-dimensional
  strong topology is exactly the missing term.
- **Stabilization hypothesis (load-bearing).** The finite-rank block that the
  crossing census lives in must **survive stabilization**: `⊕`-ing trivial
  blocks (stable-rank passage) must not **erase** the finite-rank obstruction
  relevant to the charge count. This is the composition gate most likely to be
  overstated; it must be checked, not assumed.
- **Separation hypothesis.** Determinant monomials / coordinate delays must be
  separated before asserting zero *strong* sector charge (algebraic `K₁` vs
  topological `K¹(T³)` vs stable rank vs determinant-delay must stay distinct).

### 5.3 Floquet side — hypotheses (Bessho–Sato, arXiv:2006.04204, PRL 127, 196404)

- **Charge–bulk duality.** The sum of local gapless-mode charges equals a bulk
  dynamical topological invariant.
- **0/π branch convention (load-bearing).** A **dimension-dependent sign** is
  recorded for the quasienergy-`π` contribution; the exact `0` vs `π` sign
  convention must be copied verbatim from the displayed theorem before use.
- **Symmetry class (load-bearing).** The **class-A vs symmetry-protected** case
  must be fixed. R4 uses the `Ξ`-graded (chiral) case; the class-A neutral
  massive tangent (§0) is *outside* the charged sectors and must not be double
  counted.
- **Positive control.** Higashikawa–Nakagawa–Ueda (arXiv:1806.06868) realize a
  single Weyl fermion with a topologically nontrivial *Floquet* unitary — proof
  that the bulk invariant cannot simply be omitted (a naive
  "sum-of-local-charges = 0" without the bulk term is false).
- **Adversarial control.** Gupta–Short (arXiv:2601.15885v2) remove conventional
  doublers/pseudo-doublers but **retain residual low-energy solutions**; the
  census must determine whether their tangent (non-involutory, per
  `StationaryAmplitudeNoGo`), global chirality, or residual modes supply the
  compensating structure.

### 5.4 What R4 does and does not give

- Gives: a *class* no-go for **globally chiral** (`[U,Ξ]=0`) finite-range
  exact-unitary symbols — the honest discrete-time Nielsen–Ninomiya statement.
- Does **not** give: any statement about the **escape class** with a `Ξ`-odd
  term whose constant/linear jets vanish (R2's object). Quadratic chirality
  mixing is exactly what R4 does not cover, which is why R2/R3 remain the live
  construction frontier and R4 alone does not settle the full problem.
- Six-hour deliverable: **not** a theorem, but a reproducible
  source/convention memo (memo milestone M2) that a hostile reviewer can
  replay — exact theorem numbers, rings, involutions, the algebraic→topological
  map, the stabilization statement, the 0/π sign, and counterexamples if
  polynomial-unitarity scope or stabilization was overstated.

### 5.5 Nondegenerate fixture and killer counterexample

- **Nondegenerate fixture.** The global-chirality gate is exact and kernel-true:
  `splitStep_commutes_iff_sin_theta_zero` — at `sin θ = 0` the ordered step
  satisfies `[U(q),Ξ]=0` at every momentum, with the commutator's matrix factor
  determinant-one everywhere (no momentum exception). This is a genuine instance
  of R4's global-chirality hypothesis, and R1 discharges its conclusion by
  enumeration for this instance.
- **Killer counterexample.** A **single Weyl fermion realized by a nontrivial
  Floquet unitary** (Higashikawa 1806.06868): if one *drops the bulk dynamical
  invariant* from the charge sum, R4's conclusion appears violated — this is the
  standing proof that the bulk term is mandatory and that "local charges sum to
  zero" cannot be asserted without it. Any R4 write-up omitting the bulk
  invariant is refuted by this construction.

---

## 6. Manuscript-safe wording at each success level

Graded wording, honoring the audits' hedges (`\Kernel`, `\NewResult`, `\NoGo`,
"supplied", "Jacobian-sign", "route to", VERIFY). Never upgrade a level.

### R1 — census no-go

- **Partial (completeness not yet landed).** "For the `2×2` Weyl restriction of
  the ordered massless cubic step, the Pauli-vector Jacobian has exact
  determinant `u₀·cos 2q_y`; on the *assumed* sixteen-point crossing set the
  Jacobian-sign charges sum to zero in each quasienergy sector. Completeness of
  that crossing set is supplied separately by the massless crossing
  classification (in flight)."
- **Full (completeness landed).** "The `±I` crossing set of the ordered massless
  cubic Weyl step is *exactly* sixteen points (eight cube corners, eight body
  centers); the Jacobian-sign charge sums to zero within each quasienergy sector
  by exact enumeration; hence by the finite hinge no isolated nondegenerate
  crossing exists in this architecture. \NewResult \Kernel."
- **Never write.** "The local Jacobian sign is a conserved topological charge",
  "class-A charge conservation forces doubling" (the sum is *enumerated*, not
  derived from a monopole theorem), or "this proves discrete-time
  Nielsen–Ninomiya" (it is one architecture; the class statement is R4).

### R2 — commutator ansatz

- **Partial.** "A single `Ξ`-odd commutator plaquette
  `regulator(·,·,·,·,A,G)` with `A` chirality-even and `G` chirality-odd is an
  exact-unitary, finite-Laurent-range factor whose odd part has zero constant
  and linear jets and nonzero quadratic term. \NewResult \Kernel."
- **Full (expected negative).** "Composing this plaquette with the massless step
  breaks the global chiral grading (`[U',Ξ]≠0`) yet provably retains the
  aliases: an exact point certificate exhibits a surviving root of `det(U'∓I)`.
  Chirality mixing here reshuffles, and does not remove, crossings."
- **Never write.** "The commutator regulator de-aliases the walk", "breaking the
  chiral class removes the doublers", or any sentence conflating `U_perp ≠ 0`
  with alias removal. The quarter-turn `±I` collapses are 0↔π **reshuffles**,
  not de-aliasing.

### R3 — root-exclusion certificate

- **Partial (falsifier).** "An exact ℚ point certificate shows `det(U∓I)=0` at
  the body center `(π/2,π/2,π/2)`, refuting alias freedom of the candidate.
  \NoGo \Kernel."
- **Full (massive Wilson only).** "At the nearest-neighbor Hamiltonian level the
  Wilson identity `H_W² = (Σ sin²q_j + M_W²)I` with `M_W=m+rΣ(1−cos q_j)`
  excludes every non-origin corner (`m=0,r>0`), e.g. energy² `=4r²` at
  `(π,0,0)`. \NewResult \Kernel. This does **not** yet supply a finite-range
  exactly-unitary discrete-time update; `exp(−itH_W)` is unitary but not
  asserted finite Laurent."
- **Never write.** "An exact certificate proves a finite-range unitary single
  Dirac cone" (this would contradict R1/R4 for the chiral class; audit before
  any such claim), or "Positivstellensatz certifies no-doubling" without the
  saturation-away-from-origin and stabilization caveats.

### R4 — external composition

- **Partial (source memo).** "Read's algebraic `K₁` calculation excludes a
  strong stable `K¹(T³)` component for complex Laurent automorphisms; composing
  it with the symmetry-resolved Floquet crossing-charge bookkeeping is the
  remaining mathematical gate. Source-supported; finite-rank stabilization and
  the 0/π sign convention are VERIFY, not kernel-checked here."
- **Full (only after full-text verification).** "For finite-range exactly
  unitary translation-invariant symbols admitting a constant Hermitian
  involution `Ξ` with `[U,Ξ]=0` everywhere, the total Weyl-sector charge
  vanishes in each quasienergy sector; no isolated single crossing exists — a
  discrete-time Nielsen–Ninomiya no-go for the globally chiral class. The
  escape class with quadratic `Ξ`-odd mixing is not covered."
- **Never write.** "Read + Bessho–Sato give a doubling theorem" (route to, not
  theorem), Read's `R_3` as "three-variable" (it is quaternionic), or any
  omission of the bulk dynamical invariant (refuted by the single-Weyl Floquet
  control), or the composite as a Lean assumption.

---

## 7. Adversarial novelty audit

- **The census principle is not new; the exact incarnation is.** Floquet 0/π
  charge accounting and 3D Weyl-node counting are established (Bessho–Sato;
  Higashikawa; D'Ariano; Mlodinow–Brun). Per `SPARK_LIT_..._CENSUS`, **none** of
  these states an exact 16-node cube-corner-plus-body-center 0/π Jacobian-sign
  census for the *literal* ordered-Pauli normal form
  `exp(−iq_xσ₁)exp(−iq_yσ₂)exp(−iq_zσ₃)`. R1's novelty is therefore *the exact
  kernel-checked enumeration for this specific architecture*, not the discovery
  of doubling. Claim only that.
- **The commutator regulator is a classical object.** Group commutators of
  circle phase steps and Wilson chirality-flip terms are standard. R2's only
  novelty is the `Ξ`-odd-leading, zero-first-jet packaging (A5); do not present
  the primitive itself as new.
- **Root exclusion is standard computer algebra.** Gröbner/resultant/
  Positivstellensatz on trigonometric varieties is routine. R3's contribution is
  the application and the *kernel check of the resulting identity*, not the
  method.
- **The two hardest not-yet-earned claims.** (i) "class-A charge = 0" as a
  *homotopy* theorem (kernel has only the pointwise involutory family —
  `CORRECTED_CHARGE_AUDIT` S3, G3); (ii) the analytic identification of `GA−AG`
  as the *mixed second derivative* of the exact commutator (kernel has only the
  algebraic coefficient — manuscript ≈1466, memo A5 "analytic Taylor estimate
  remains open"). Keep both as separate gates.
- **The one confusion that would sink the paper.** Presenting a broken chiral
  grading (`U_perp ≠ 0`) as de-aliasing. Every rung above is designed so that
  de-aliasing is only ever claimed with an accompanying **root-exclusion
  certificate** (R3), never from chirality mixing (R2) alone.

---

## 8. Six-hour execution order (concrete)

1. **Repair packaging (F1)** — ship the five dependency modules and align
   `lakefile.toml`/module roots so the census file elaborates. Blocks R1.
2. **R1 kernel** — land the Pauli-coefficient identity, the Jacobian identity
   `det J = u₀·cos 2q_y`, the sixteen exact signs, the two sector sums = 0, and
   the `ChargeBalanceForcesPartner` composition. Ship the two negative controls
   (rank-deficient Jacobian; non-crossing corner). Conditional on completeness
   from the crossing classification — mark the hedge if it has not landed.
3. **R2 kernel** — add `commuting_quarterTurn_eq_one`; state the single `Ξ`-odd
   plaquette `U' = U_massless · regulator`; prove exact unitarity and finite
   range; verify the zero-first-jet / nonzero-quadratic `Ξ`-odd coefficient.
   Expect and record the negative de-aliasing outcome.
4. **R3 point certificate** — the ℚ falsifier that `det(U'∓I)=0` at a body
   center (regression companion to R2). Restate the Wilson Hamiltonian exclusion
   as the positive template; flag the exact-unitary discrete-time version open.
5. **R4 memo (VERIFY)** — reproducible Read/Bessho–Sato source-and-convention
   memo with theorem numbers, rings, involutions, stabilization statement, and
   the 0/π sign. Not kernel; never an axiom.

Highest-leverage deliverable achievable and defensible in six hours: **R1
full**, gated only on the crossing-completeness classification and the F1
packaging repair.
