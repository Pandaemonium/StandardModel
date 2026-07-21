# Aristotle semantic context pack

Generated: 2026-07-20T12:22:17
Query: `Froehlich Morchio Strocchi finite SU2 Higgs gauge-invariant vector observable leading term X dagger W X custodial gauge index bridge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean`

Score: `0.799`

```text
j g₀₀`, `g₁₀ = −conj g₀₁`).
* `su2_entries_of_unitary_det_one` — those entry identities follow from
  `g` unitary with `det g = 1`.
* `fmsW_su2L_invariant` — `O^W` is invariant under SU(2)_L gauge transformations
  at the source (`gs ∈ SU(2)`) together with a unitary `gt` at the target.
* `fmsW_leading` — `⟪H̃(H₀), ρ(X) H₀⟫ = (v²/4)(x₀ − i x₁)`, the `W^∓` field
  combination `A¹ ∓ i A²`, now carried by a genuinely SU(2)_L-covariant operator.

### Scope caveat (manuscript-safe wording for Gate E)

`O^W` is **not** a fully gauge-invariant scalar: under the residual `U(1)_em`
it picks up a phase (the electric charge `±1` of the `W`).  This is physically
correct — the W boson is electrically charged, so its interpolating operator is
custodial-covariant, not invariant.  The honest label remains:

> *gauge-invariant orbit-stiffness reconstruction with an SU(2)_L-covariant
> (custodial) W/Z composite whose vacuum expansion has the W/Z field as the
> leading fluctuation and the orbit-stiffness mass as the quadratic term — not a
> completed physical composite-spectrum (pole / two-point) theorem.*

All declarations live in the `Draft` namespace.
-/
```

### 2. `AgentTasks/null-edge-e13-fms-composite-observable-next-note.md` [The next theorem (E13), proved in the module]

Score: `0.793`

```text
### The next theorem (E13), proved in the module
- **Unification (main result):** for the second-order holonomy `U(ε)=1+iε ρ(X)−(ε²/2)ρ(X)²`, the exactly gauge-invariant singlet composite expands as `O(ε)=v²/2 + iε(v²/4)(x₃−x₂) − (ε²/2)q(X)` (`fms_singlet_second_order`): its linear term is the gauge-invariant Z field and its quadratic term is exactly minus one-half the orbit-stiffness mass form `q(X)`. The bridge `⟪H₀,ρ(X)²H₀⟫=q(X)` (`cinner_H0_rho_sq_H0`) follows from `ρ(X)` being Hermitian (`rho_isHermitian`). The quadratic cost vanishes exactly along `u(1)_em` (`fms_singlet_no_quadratic_cost_iff`).
- **Gauge-invariant W carrier:** using the conjugate doublet `H̃=iσ²H*`, the custodial operator `O^W=H̃_s†U_e H_t` (`fmsW`) is SU(2)_L-invariant (`fmsW_su2L_invariant`, via `Htilde_su2_covariant` and `su2_entries_of_unitary_det_one`), with leading term `(v²/4)(x₀−i x₁)` = the `W^∓` combination `A¹∓iA²` (`fmsW_leading`) — replacing E12's non-covariant `τ¹` matrix element.
```

### 3. `AgentTasks/null-edge-fms-wz-composite-audit.md` [1.3 The corrected composites]

Score: `0.788`

```text
### 1.3 The corrected composites

**(a) Singlet (already the link-stiffness object, T8).**

```text
O_e = H_s^dagger U_e H_t.

O_e -> H_s^dagger g_s^dagger g_s U_e g_t^{-1} g_t H_t = H_s^dagger U_e H_t.
```

Gauge invariant by one-line cancellation. This is the composite already behind
Theorem B / T8: `|U_e H_t - H_s|^2 = |H_t|^2 + |H_s|^2 - 2 Re O_e`, whose
quadratic small-holonomy term is the gauge-boson mass. It is a single complex
scalar, so it captures the *charged-current contraction*, not the three separate
W/Z directions.

**(b) Triplet (the correct FMS W/Z composite).** Build the Higgs frame. Let

```text
~H = i sigma^2 H^*            (conjugate doublet, Y = -1)
Phi = ( ~H , H )             2x2 matrix, columns ~H and H
X   = Phi / sqrt(H^dagger H) in SU(2)   (the Higgs SU(2) frame)
```

Two algebraic facts (finite identities, good Lean lemmas):

```text
Phi^dagger Phi = (H^dagger H) I_2,     det Phi = H^dagger H   =>   X in SU(2).
Under SU(2)_L:  Phi -> g Phi           (uses sigma^2 g^* sigma^2 = g for g in SU(2))
Under U(1)_Y :  Phi -> Phi e^{i theta sigma^3}  (the hypercharge acts on the right)
```

So under the gauge group the frame transforms as

```text
X_v -> g_v X_v r_v,    r_v = e^{i theta_v sigma^3}   (a global-custodial / hypercharge factor on the right).
```

Define the framed link composite and its components

```text
W_e := X_s^dagger U_e X_t,        W_e^a := (1/2) tr( sigma^a W_e ).
```

Gauge behaviour:

```text
W_e -> (g_s X_s r_s)^dagger ( g_s U_e g_t^{-1} ) ( g_t X_t r_t )
     = r_s^dagger ( X_s^dagger U_e X_t ) r_t
     = r_s^dagger W_e r_t.
```

The local SU(2)_L factors `g_s, g_t` cancel **completely**: `W_e` is
**SU(2)_L gauge invariant**. The only residual is the right factor
`r_s^dagger ( ) r_t`, which is the *global custodial / hyperch
```

### 4. `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean`

Score: `0.781`

```text
her-order content
   to the orbit-stiffness mass.
3. No statement about poles, two-point functions, scattering states, or continuum
   spectra — and this file makes **no** such claim either.

## What this file (E13) adds

### Part A — adjoint algebra of the composite inner product

* `cinner_mulVec_left` — `⟪x, M w⟫ = ⟪Mᴴ x, w⟫`.
* `rho_isHermitian` — the Lie-algebra representation `ρ(X)` is Hermitian.

### Part B — the gauge-invariant composite second-order expansion (main result)

* `cinner_H0_rho_sq_H0` — `⟪H₀, ρ(X)² H₀⟫ = q(X)` (the mass form), the key
  bridge identifying the composite's curvature with the orbit-stiffness mass.
* `cinner_H0_rho_H0`, `cnorm2_H0` — the linear (Z) coefficient and the vacuum
  value.
* `fms_singlet_second_order` — for the second-order holonomy
  `U(ε) = 1 + iε ρ(X) − (ε²/2) ρ(X)²` the **exactly gauge-invariant** singlet
  composite expands as
  `O(ε) = v²/2 + iε (v²/4)(x₃−x₂) − (ε²/2) q(X)`,
  i.e. its `ε`-linear term is the gauge-invariant `Z` field and its `ε²` term is
  exactly minus one half the orbit-stiffness mass form.  This unifies E12's
  Part B and Part C inside a single gauge-invariant observable.
* `fms_singlet_no_quadratic_cost_iff` — the composite has vanishing quadratic
  (`ε²`) cost exactly along `u(1)_em` (the photon direction).

### Part C — the custodial W interpolating operator (SU(2)_L-covariant)

E12 had no gauge-invariant W carrier.  Using the conjugate Higgs doublet
`H̃ = iσ² H*`, we build `O_e^W = H̃_s^† U_e H_t` and prove:

* `Htilde_su2_covariant` — `H̃(g H) = g H̃(H)` for any SU(2)-type `g`
  (entries `g₁₁ = conj g₀₀`, `g₁₀ = −conj g₀₁`).
* `su2_entries_of_unitary_det_one` — those entry identities follow from
  `g` unitary with `det g = 1`.
* `fmsW_su2L_invariant` — `O^W` is invariant under SU(2)_L gauge tra
```

### 5. `AgentTasks/null-edge-fms-wz-composite-wave3-20260626.md` [Integration (2026-06-26)]

Score: `0.780`

```text
## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-fms-wz-composite-audit.md`. Key finding
(a correction / negative result): the schematic composite `O_e^a = H_s^dagger tau^a U_e H_t`
is **NOT gauge invariant** -- it transforms in the adjoint at the source vertex
(gauge-covariant, not invariant), because a single doublet cannot carry a global custodial
triplet index. Corrected composites: the singlet `O_e = H_s^dagger U_e H_t` (the existing T8
link-stiffness object) and, as the actual FMS W/Z observable, the Higgs-framed triplet
`W_e^a = (1/2) tr(sigma^a X_s^dagger U_e X_t)` with `X = (~H, H)/sqrt(H^dagger H) in SU(2)`.
Worked the vacuum expansion (leading fluctuation `(i/2) eps A_e^a`), separated
photon/stabilizer (`u(1)_em = ker B_EW`) from the three massive orbit directions, gave the
smallest Lean target (SU(2)_L gauge invariance of `W_e^a`) plus lemmas L1-L5, and a phrase
table. Recommends narrowing the CONVENTIONS.md FMS entry and updating proof-chain T11 with
the corrected definitions. Labelled reconstruction/structural, not a prediction. No
Lean/build in scope.
```

### 6. `AgentTasks/null-edge-fms-wz-composite-audit.md` [1.3 The corrected composites]

Score: `0.774`

```text
The local SU(2)_L factors `g_s, g_t` cancel **completely**: `W_e` is
**SU(2)_L gauge invariant**. The only residual is the right factor
`r_s^dagger ( ) r_t`, which is the *global custodial / hypercharge* rotation, not
a local SU(2)_L gauge transformation. Promoting it to full invariance is the job
of the hypercharge link (Deliverable 4). Thus `W_e^a` is the gauge-invariant
finite-link triplet, and its index `a` is now a *physical* (global custodial)
label distinguishing `W^1, W^2, W^3`, not a gauge index.

Minimal honest correction statement:

```text
Replace   O_e^a = H_s^dagger tau^a U_e H_t          (gauge-covariant, adjoint at source)
with      W_e^a = (1/2) tr( sigma^a X_s^dagger U_e X_t )   (SU(2)_L gauge invariant; global custodial triplet)
```

---
```

### 7. `AgentTasks/null-edge-fms-finite-composite-report-2026-06-26.md` [What it proves, mapped to the requested tasks]

Score: `0.772`

```text
## What it proves, mapped to the requested tasks
1. **Finite gauge-invariant Higgs-link functional** — `linkStiffnessEW = ∑_e ‖U_e H_{t(e)} − H_{s(e)}‖²` for a genuinely non-abelian (`U(2)`/`SU(2)`) matrix-valued connection on `ℂ²` doublets (the electroweak upgrade of the abelian link file), with exact gauge invariance `linkStiffnessEW_gauge_invariant` under `H_v ↦ g_v H_v`, `U_e ↦ g_{s(e)} U_e g_{t(e)}⁻¹` (unitary `g_v`); supported by `cnorm2_mulVec_of_unitary` / `cinner_mulVec_of_unitary`.
2. **Orbit-stiffness theorem** — holonomy level: `holonomyCost_eq_zero_iff_stabilizer` (zero cost ⇔ stabilises the Higgs reference section) and `holonomyCost_pos_of_not_stabilizer` (positive otherwise); Lie-algebra level: `massForm`, its closed form `massForm_eq = (v²/8)(x₀²+x₁²+(x₂−x₃)²)`, and `massForm_kernel` showing the zero set is `span ℝ {Q} = u(1)_em` (the unique massless/photon direction).
3. **Corrected FMS composite observable** — `fmsComposite = H_s^† τ^a U_e H_t`, with the gauge-invariant singlet variant (`τ = 1`) proved invariant (`fmsSinglet_gauge_invariant`).
4. **Toy expansion theorem (W/Z as leading term)** — for the linearised holonomy `U = 1 + iε ρ(X)`: `fms_leading_W` gives the `τ¹` matrix element `(v²/4)(x₀ − i x₁)` (the `W^∓` combination `A¹ ∓ i A²`), `fms_leading_Z` gives the `τ³` element `(v²/4)(x₂ − x₃)` (the `Z` combination `A³ − B`), and `fms_linear_expansion_W` assembles the full linear expansion whose vacuum constant vanishes, so the W field is the leading fluctuation. The orthogonal photon combination is absent, consistent with `massForm_kernel`.
5. **Separated coefficient normalisation** — `massForm_coupling_form`, `mW = gv/2`, `mZ = √(g²+g'²)v/2` (`mW_sq`, `mZ_sq`), and the bridge `massForm_physical_normalization` identifying the mass form with the ca
```

### 8. `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean`

Score: `0.772`

```text
import Mathlib
import PhysicsSM.Draft.NullEdgeFMSFiniteComposite

/-!
# Next FMS step: the gauge-invariant composite second-order expansion and the
custodial (SU(2)_L-covariant) W interpolating operator (Gate E, E13)

Null-edge unified-mass Wave-10 follow-up to E12
(`PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`; Working Plan §25.5 / §26.6).

## What E12 proved (recap)

E12 established, at theorem level, a finite gauge-invariant electroweak orbit
stiffness:

* `linkStiffnessEW_gauge_invariant` — exact gauge invariance of
  `S_H = ∑_e ‖U_e H_t − H_s‖²`.
* `holonomyCost_eq_zero_iff_stabilizer` / `holonomyCost_pos_of_not_stabilizer`
  — finite orbit stiffness: zero cost iff the holonomy stabilises the Higgs
  reference section, positive otherwise.
* `massForm_eq`, `massForm_kernel` — the infinitesimal orbit-stiffness mass form
  `q(X) = ‖ρ(X) H₀‖² = (v²/8)(x₀²+x₁²+(x₂−x₃)²)` with kernel `span ℝ {Q} =
  u(1)_em`.
* `fmsSinglet_gauge_invariant` — exact gauge invariance of the *singlet*
  composite `O_e = H_s^† U_e H_t`.
* `fms_leading_W`, `fms_leading_Z` — the `ε`-linear coefficients of the `τ¹` /
  `τ³` composites at the vacuum.

## What E12 did *not* prove (the honest gap)

1. E12's W/Z leading terms `fms_leading_W`, `fms_leading_Z` are matrix elements
   of the *non-gauge-invariant* `τ¹`, `τ³` composites `H₀^† τ^a ρ H₀`.  Only the
   `τ = 1` singlet was shown gauge invariant; the `τ¹` (W) channel had **no**
   gauge-invariant carrier.
2. E12 keeps the mass form (Part B) and the composite (Part C) as **separate**
   objects.  Nothing tied the gauge-invariant composite's higher-order content
   to the orbit-stiffness mass.
3. No statement about poles, two-point functions, scattering states, or continuum
   spectra — and this file makes **no** such claim either.

## What
```

## Scoped paper hits

### 1. Weak and Higgs physics from the lattice

Score: `0.763`
Zotero key: `QX3TJUP8`
arXiv: `2603.12882`
URL: http://arxiv.org/abs/2603.12882

Abstract:

The manifestly gauge-invariant and non-perturbatively complete lattice formulation of the weak interactions and the Brout-Englert-Higgs effect is connected to the usual perturbative description in phenomenology via the Fröhlich-Morchio-Strocchi mechanism. However, slight differences between the two have been observed, which can potentially be accounted for by augmenting perturbation theory. We report on our ongoing lattice investigations of these additional effects using a setup with two generations of leptons coupled vectorially to the gauge-Higgs system. We explore the spectrum, inner structure in terms of weak (quasi-)PDFs, and spectral functions of the system to eventually compare cross sections to experimental results.

### 2. The Fröhlich-Morchio-Strocchi mechanism: A underestimated legacy

Score: `0.751`
Zotero key: `5PE7S5PT`
arXiv: `2305.01960`
DOI: `10.1007/978-3-031-44988-8_11`
URL: http://arxiv.org/abs/2305.01960

Abstract:

There is an odd tension in electroweak physics. Perturbation theory is extremely successful. At the same time, fundamental field theory gives manifold reasons why this should not be the case. This tension is resolved by the Fröhlich-Morchio-Strocchi mechanism. However, the legacy of this work goes far beyond the resolution of this tension, and may usher in a fundamentally and ontologically different perspective on elementary particles, and even quantum gravity.

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.749`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Eigenvalue based taste breaking of staggered, Karsten-Wilczek and Borici-Creutz fermions with stout smearing in the Schwinger model

Score: `0.737`
Zotero key: `CIQCUN6I`
arXiv: `2409.15024`
URL: https://arxiv.org/abs/2409.15024

Abstract:

Studies eigenvalue-based taste breaking for staggered, Karsten-Wilczek, and Borici-Creutz fermions in the Schwinger model. A continuum eigenvalue is represented by a pair of near-degenerate eigenvalues, and the splitting quantifies cutoff-induced taste symmetry breaking, including behavior of would-be zero modes in topological backgrounds.

### 5. Comment on 'Gauge networks in noncommutative geometry'

Score: `0.736`
Zotero key: `Q55ZUJSZ`
arXiv: `2508.17338`
DOI: `10.48550/arXiv.2508.17338`
URL: https://arxiv.org/abs/2508.17338

Abstract:

A critique of the gauge-network spectral-action construction arguing that the continuum limit is pure Yang-Mills without a Higgs scalar.
