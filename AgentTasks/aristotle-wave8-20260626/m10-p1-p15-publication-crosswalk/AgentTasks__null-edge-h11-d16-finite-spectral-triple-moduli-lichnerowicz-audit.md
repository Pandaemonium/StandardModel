# H11/D16 audit: finite spectral-triple moduli, Phi_H, and the generalized Lichnerowicz super-Dirac square

**Type:** no-build mathematical/physical/strategy audit (Wave 7).
**Scope:** compare the internal zero-order `Phi_H` block and the super-Dirac square
`D_h = i D_N(A) + Gamma_s Phi_H`, `D_h^2 = -K_h + Phi_H^2 + C_diamond + T_frame - i Gamma_s sum_a C_a [nabla_a^A, Phi_H]`
against finite spectral-triple Dirac moduli (Cacic), pseudo-Riemannian/Krein finite triples
(Bochniak–Sitarz), the generalized Lichnerowicz formula (Ackermann–Tolksdorf), and the
Dirac–Yukawa operator (Tolksdorf). Furey arXiv:2505.07923 is used only as an internal-spectrum
comparison, never as a kinetic solution.

**Verdict in one line (full verdict in §13):** finite spectral triples are a *helpful template for the
internal block only* (state space, grading, reality, first-order axiom, and the moduli bookkeeping of
`Phi_H`), but they are a *real risk of generic reparametrization* if imported as the source of the
kinetic term or as the definition of mass. Keep them on the `Phi_H` side of the wall; never let them
supply `K_h`.

---

## 0. Notation lock used throughout this audit

```text
D_h(A,H) = i D_N(A) + Gamma_s Phi_H,    D_N(A) = sum_a C_a nabla_a^A,   C_a = c(alpha^a)
H_E      = internal/finite Hilbert (or Krein) space
chi_E    = internal Z/2 grading on H_E         (the finite-triple gamma)
Gamma_s  = spacetime chirality on the spinor/null factor
J        = real structure / charge conjugation (on the full or internal space)
Phi_H    = zero-order internal endomorphism carrying the Yukawa/Higgs block
K_h      = null-edge kinetic shell (the kinetic-side invariant; the Plucker/null spread lives here)
B        = canonical quadratic-obstruction map; on-shell K_h = B^dagger B, with B = Phi_H block
```

Guardrail inherited from COMMON_CONTEXT and the working plan:
`Plucker/null spread = kinetic-side invariant; Phi_H^2 = zero-order internal block;
on shell K_null = Phi_H^2`, **not** `m_Plucker^2 + m_Higgs^2`. Section 5/§8 below is the no-double-count
discipline; it is the single most important constraint in this audit.

---

## 1. Should Phi_H be a finite spectral-triple Dirac operator, a constrained subfamily, or a separate legal Yukawa map?

**Recommendation: model Phi_H as a separate, legal, zero-order internal Yukawa/endomorphism map that
*sits inside* the moduli space of finite spectral-triple Dirac operators as a constrained subfamily —
but never identify Phi_H with the full finite Dirac operator D_F.**

Reasoning, by the three options:

1. **"Phi_H IS the finite Dirac D_F" — reject as the working identification.**
   In Connes' almost-commutative picture the total operator is
   `D = D_M ⊗ 1 + Gamma_M ⊗ D_F`. If one literally sets `Gamma_s Phi_H = Gamma_M ⊗ D_F`, then
   `Phi_H = D_F` and the *entire* finite Dirac moduli space (Cacic) becomes free internal data. That is
   exactly the generic-reparametrization failure mode: every Yukawa, every mixing angle, every Majorana
   block is then "explained" only by being stored. It also imports the order-one (first-order) axiom on
   the *internal* operator, which `Phi_H` does **not** need in the null-edge program because the
   spacetime first-order structure is already carried by `D_N(A)`.

2. **"Phi_H is a constrained subfamily of D_F" — accept as the *comparison/ledger* frame.**
   Use Cacic's classification to *read off* which components of a finite Dirac operator a null-edge
   `Phi_H` is allowed to populate, and which it must set to zero. This is the right way to *audit*
   freedom (see the moduli ledger, §6), and the right way to phrase predictions ("the null-edge
   structure forces the off-diagonal-only, J-even, chi_E-odd subfamily").

3. **"Phi_H is a separate legal Yukawa map" — accept as the *operational* definition for proof work.**
   Define `Phi_H` intrinsically as a self-adjoint (Krein-self-adjoint, §3) endomorphism of `H_E` that is
   **odd for chi_E** and **even for Gamma_s** (the grading guardrail of working-plan §15.5), with a
   block form `Phi_H = [[0, M^dagger],[M,0]]` in the chi_E grading. This is what the Yukawa-checkerboard
   and super-Dirac-square theorems actually need; it does not require the full real-spectral-triple
   apparatus to state or to square.

**Net:** *operationally* a separate legal Yukawa map (option 3); *for the moduli/prediction audit*,
view that map as a constrained subfamily of the Cacic Dirac moduli (option 2); *never* the full D_F
(option 1). The two acceptance criteria that keep this honest:
- (A) `Phi_H` is zero-order: `[Phi_H, b] = 0` for every internal algebra element `b` is **not** required
  — instead require `Phi_H` to be a bundle endomorphism over spacetime (no spacetime derivatives), so
  that the Lichnerowicz square treats it as the "potential/Yukawa" term of a Dirac operator of simple
  type (Tolksdorf), not as part of `K_h`.
- (B) `Phi_H` is chi_E-odd and Gamma_s-even, so `Phi_H^2` enters the square with a **+** sign
  (§7 sign analysis).

---

## 2. Which finite spectral-triple moduli become free internal mass/Yukawa parameters unless null-edge/Furey structure constrains them?

Cacic's moduli space of Dirac operators for a *fixed* finite real spectral triple
`(A_F, H_F, J_F, gamma_F)` is, schematically, the space of self-adjoint operators `D_F` satisfying
`gamma_F D_F = - D_F gamma_F` (odd), `J_F D_F = epsilon' D_F J_F` (reality sign), and the order-one
condition `[[D_F, a], J b J^{-1}] = 0`, modulo the unitaries commuting with `A_F`, `J_F`, `gamma_F`.
For the Standard-Model algebra `C ⊕ H ⊕ M_3(C)` this quotient is finite-dimensional and its coordinates
are exactly the physical Yukawa/mass data. The components that become **free internal parameters unless
constrained** are:

| # | Moduli coordinate | Physics | Default status | What could constrain it |
|---|---|---|---|---|
| M1 | Up-type Yukawa block `Y_u` (3×3 complex, mod unitaries) | quark up masses + part of CKM | **free** | null-edge texture / generation geometry |
| M2 | Down-type Yukawa block `Y_d` | quark down masses + part of CKM | **free** | same |
| M3 | Charged-lepton Yukawa `Y_e` | charged-lepton masses | **free** | same |
| M4 | Dirac neutrino Yukawa `Y_nu` | neutrino Dirac masses | **free** | almost-null weak channel suppression |
| M5 | Majorana block `M_R` (symmetric, on `nu_R`) | seesaw scale, light masses | **free** (and J-structure-sensitive) | reality `J`/Furey-imaginary-unit count |
| M6 | Relative scale / overall normalization of `Phi_H` | sets `v`·Yukawa vs cutoff | **free** | spectral-action constraint, link stiffness |
| M7 | Off-diagonal "leptoquark"/order-one-violating entries | usually forbidden | **forced to 0 by order-one axiom** | this is a *constraint already*, keep it |
| M8 | CKM/PMNS mixing angles + phases | flavor mixing, CP | **free** (the unitary quotient does NOT remove physical mixings) | generation-geometry relation |

Key audit points:

- **The order-one axiom already kills M7-type entries.** That is a genuine structural constraint the
  finite-triple frame *gives you for free*; the null-edge program should keep it and cite it, not
  reinvent it. Do not let `Phi_H` populate those entries.
- **Everything in M1–M6 and M8 is free internal data** in the bare finite triple. The honest statement
  is: *adopting a finite-triple Phi_H, by itself, explains none of these — it parametrizes them.*
  This is the generic-reparametrization risk made explicit.
- **Furey arXiv:2505.07923 is an internal-spectrum comparison only.** Use it to test whether a
  division-algebra internal structure *coincides* with a subfamily of the Cacic moduli (e.g. fixes the
  representation content, the number of generations slot, or relations among M1–M3). If it does, those
  coordinates move from "free" to "forced". It must **not** be used to supply the kinetic term `K_h`
  (it is not a kinetic solution); record any Furey-induced constraint only as a constraint on `Phi_H`,
  with an explicit acceptance test `R(theta) = 0` (working-plan prediction language).

**Acceptance criterion for a real prediction (Gate F):** a coordinate in {M1,…,M6,M8} is "constrained"
only if the null-edge or Furey structure forces `rank(dF) < dim M_EFT` or a nontrivial relation
`R(theta_EFT) = 0`. Absent that, the moduli ledger must list it as FREE.

---

## 3. How do pseudo-Riemannian/Krein finite-triple conventions interact with Gamma_s, chi_E, and the retarded/advanced double?

Bochniak–Sitarz (arXiv:1804.09482) replace the Hilbert positivity by a **Krein structure**: a
fundamental symmetry `beta` (`beta^2 = 1`, `beta = beta^*`) defines the Krein inner product, and the
Dirac operator is **Krein-self-adjoint**, `D^‡ := beta D^* beta = ± D`, rather than self-adjoint. The
signs (the "KO/metric signature data") are exactly the conventions that must be locked. Interaction with
the null-edge objects:

- **Gamma_s vs Krein fundamental symmetry.** In a Lorentzian/null spacetime the spinor chirality
  `Gamma_s` and the Krein `beta` are *different* operators but are linked: typically `beta` is built from
  one timelike Clifford generator (or `Gamma_s` times such), so `{Gamma_s, beta}` and `[Gamma_s, beta]`
  signs feed directly into whether `Phi_H^2` enters the square with `+` or `−`. **This is the single
  place where a sloppy sign silently flips a mass-squared.** It must be fixed before any square theorem
  (see §9, convention S4).
- **chi_E (internal grading) is independent of beta.** Treat the internal grading `chi_E` and the
  internal Krein fundamental symmetry `beta_E` as separate data. The finite triple has *both* a grading
  and a fundamental symmetry; conflating them is a known source of error. The clean choice:
  `Phi_H` is chi_E-odd (Yukawa flips internal chirality) and Krein-self-adjoint w.r.t. `beta_E`.
- **Retarded/advanced double.** The null-edge program's retarded/advanced doubling is structurally the
  *same kind of object* as the Krein doubling: a 2×2 block on (advanced, retarded) with an off-diagonal
  pairing playing the role of the indefinite Krein form. Map them explicitly:
  ```text
  Krein fundamental symmetry beta  <->  swap/pairing of the retarded-advanced double
  Krein-self-adjoint D^‡ = D       <->  reciprocity between retarded and advanced propagation
  ```
  Acceptance test: the retarded/advanced double must reproduce `D^‡ = ± D` with the *same* sign that
  makes `Phi_H^2` positive on shell. If the two doublings disagree in sign, the model double-counts a
  factor and the on-shell `K_null = Phi_H^2` identity breaks.
- **Pseudo-Riemannian caveat for Lichnerowicz.** Ackermann–Tolksdorf and Tolksdorf are stated in the
  Riemannian (elliptic, Hilbert) setting. The generalized Lichnerowicz identity is *algebraic* in the
  Clifford structure and survives to the Krein setting, but the *spectral-action / Wodzicki-residue*
  packaging (heat kernel) does **not** transfer naively to indefinite signature. So: the finite square
  is signature-robust; any continuum spectral-action statement is Riemannian-only until separately
  justified. Tag accordingly in the theorem sequence (§11).

---

## 4. Do generalized Lichnerowicz and Dirac–Yukawa results support or fail to support the desired square?

**They support the *form* of the desired square strongly, and they supply two of its terms essentially
for free; they do NOT supply `K_h` (the null-edge kinetic shell), and they assume Riemannian
ellipticity for the analytic half.**

- **Ackermann–Tolksdorf generalized Lichnerowicz (hep-th/9503153).** For a Dirac operator of *simple
  type* `D` over a Clifford module, the square is universally
  ```text
  D^2 = Delta_B - V,   Delta_B = ∇*∇ (Bochner/Laplace-type),   V = endomorphism (curvature + potential)
  ```
  with `V` an explicit local expression: scalar curvature `s/4` (the original Lichnerowicz term), the
  twisting curvature `F` (the `C_diamond`/Pauli term in the working plan), and — crucially — a term
  built from the *zeroth-order part* of `D`. This is exactly the structure the working-plan target
  asserts:
  ```text
  D_h^2 = -K_h + Phi_H^2 + C_diamond + T_frame - i Gamma_s sum_a C_a [nabla_a^A, Phi_H].
  ```
  Term-by-term:
  - `Delta_B` ⟷ `-K_h` (kinetic shell, after the null-edge symbol identification);
  - twisting curvature in `V` ⟷ `C_diamond(A)` (gauge curvature / Pauli coupling);
  - scalar-curvature/frame part of `V` ⟷ `T_frame` (tetrad/spin-connection defect);
  - zeroth-order (Yukawa) part of `V` ⟷ `Phi_H^2`;
  - cross term `{∇, zeroth-order}` ⟷ `-i Gamma_s sum_a C_a [nabla_a^A, Phi_H]` (Higgs-gradient term).
  So the **shape is endorsed by an established theorem**, which is strong support: the desired identity
  is the generalized Lichnerowicz formula for a Dirac–Yukawa operator of simple type.

- **Tolksdorf Dirac–Yukawa operator (hep-th/9612149).** Confirms that putting the Higgs/Yukawa in as the
  zeroth-order part of a Dirac operator of simple type, then taking the Lichnerowicz square + spectral
  action, yields the Einstein–Hilbert + Yang–Mills + Higgs action, with `|∇H|^2` and `V(H)` emerging
  from the bosonic trace — and, importantly, the **W/Z mass term appears via `|∇^A H|^2`, separately from
  the fermionic `Phi_H^2`**. This is direct external support for the working-plan separation
  "fermion masses live in `Phi_H^2`; W/Z masses live in `|∇^A H|^2`" (working-plan §15.10), and it is the
  reason the no-double-count discipline is *consistent with* known results rather than ad hoc.

- **Where they fail to support / must not be over-read.**
  1. They presuppose a *genuine Dirac operator of simple type on a Clifford module over a Riemannian
     manifold*. The null-edge `D_N(A)` is a finite-difference dual-soldered operator; its square is
     `K_h + C_diamond + T_frame` **only after** the dual-soldered commutator theorem and a symbol/scaling
     limit are proved. Lichnerowicz does not give you `K_h` — it gives you the *organization* of the
     square *assuming* the kinetic part is already a Laplace-type operator. The hard physics is precisely
     producing `K_h` with the right symbol; that is Gate D/G5, not something Lichnerowicz hands over.
  2. The `T_frame` term is only "compatibility defect = 0" when the tetrad/spin-connection compatibility
     holds. On a finite null-edge complex this is *not* automatic; it is a theorem target with a genuine
     failure mode (nonzero defect). Do not assume `T_frame = 0`.
  3. The Higgs-gradient cross term vanishes only for **covariantly constant `Phi_H`** (constant `M`).
     For the checkerboard toy this is fine (working-plan §6.1 "if M is constant, gradient terms vanish");
     for the full model it is a real term.

**Conclusion for the desired square:** *supported in form, conditional in substance.* The identity is the
right one to target; the burden of proof is (i) the dual-soldered kinetic square (`K_h`), (ii) the
grading/sign hypotheses (§9), and (iii) `T_frame` control — not the existence of the Lichnerowicz
organization itself.

---

## 5. How to avoid double-counting kinetic Plucker/null spread and internal Phi_H^2

This is the program's load-bearing guardrail. The double-count danger is to write
`m^2 = m_Plucker^2 + m_Higgs^2`. The correct statement is an **on-shell matching**, not a sum:

```text
K_h(xi) = Phi_H^2  on the massive mode   (equivalently  -K_h + Phi_H^2 = 0  in D_h^2 psi = 0).
```

Discipline to enforce it:

1. **One mass, two readings.** Plucker/null spread is a property of the **kinetic operator's spectrum**
   (`K_h`); `Phi_H^2` is a property of the **internal endomorphism**. The physical `m^2` is the common
   eigenvalue where they *match*, given by the finite spectral-matching schema
   `A = -K ⊗ I + I ⊗ B^dagger B`, `ker A = ⊕_{lambda=mu} E_lambda(K) ⊗ E_mu(B^dagger B)`
   (working-plan §16.4). The kernel condition `lambda = mu` is the matching; there is no addition.
2. **Never add a Plucker term inside Phi_H.** `Phi_H` is built only from the chirality-flip/Yukawa block
   `M`; it must not contain any minor/`psi_i ∧ psi_j` data. Audit: `Phi_H` depends only on internal/flavor
   indices, not on the spacetime null-momentum family.
3. **Never add a Yukawa block inside K_h.** `K_h` is built only from null-edge differences `nabla_a` and
   the dual-soldered symbol; it must not contain `M`. Audit: `K_h` depends only on spacetime/edge data.
4. **The cross/gradient term is the only legitimate mixing.** `-i Gamma_s sum_a C_a [nabla_a^A, Phi_H]`
   is first order in both and vanishes for constant `Phi_H`; it is *not* a mass term and must not be
   reabsorbed into either `K_h` or `Phi_H^2`.
5. **W/Z is a third, separate bucket.** Gauge-boson mass is `|∇^A H|^2` (condensate-holonomy stiffness),
   not in `K_h` and not in fermionic `Phi_H^2`. Keep three disjoint ledgers: kinetic `K_h`, fermion
   `Phi_H^2`, boson `|∇^A H|^2`.

**Failure test (must be run):** form `D_h^2` symbolically and check that the coefficient of any term
quadratic in `M` is exactly `Phi_H^2` and *never* appears added to a `K_h` eigenvalue; check that no
Plucker minor appears in the zeroth-order block. If both pass, no double count.

---

## 6. Deliverable A — finite spectral-triple moduli ledger for Phi_H

Coordinates of `Phi_H` viewed as a constrained subfamily of the Cacic Dirac moduli. "Constrained by
null-edge/Furey?" is the prediction-gate column; FREE = generic reparametrization unless a
`rank(dF)<dim` or `R(theta)=0` result is supplied.

| Coord | Object | Block in `Phi_H = [[0,M^†],[M,0]]` | Grading (chi_E / Gamma_s) | Reality `J` | Dim of freedom (SM-like) | Constrained by null-edge/Furey? | Ledger status |
|---|---|---|---|---|---|---|---|
| P-Yu | up-Yukawa `Y_u` | sub-block of `M` | odd / even | J-even | 9 real (3 masses + mixing share) | only if generation geometry forces texture | FREE |
| P-Yd | down-Yukawa `Y_d` | sub-block of `M` | odd / even | J-even | 9 real | same | FREE |
| P-Ye | charged-lepton `Y_e` | sub-block of `M` | odd / even | J-even | 6–9 real | same | FREE |
| P-Yn | Dirac neutrino `Y_nu` | sub-block of `M` | odd / even | J-even | 6–9 real | almost-null channel suppression? | FREE |
| P-MR | Majorana `M_R` | symmetric block | odd / even | **J-sensitive** (sign `epsilon'`) | 6–12 real | Furey imaginary-unit/reality count | FREE (test Furey) |
| P-norm | overall scale `‖Phi_H‖` | global | — | — | 1 | spectral-action / link stiffness | FREE (target) |
| P-mix | CKM/PMNS angles+phases | unitary content of `M` | — | — | 4 + 6 | generation geometry | FREE |
| P-LQ | leptoquark/order-one-violating | off-block | would break grading/order-one | — | (would-be many) | **FORBIDDEN** by order-one axiom + chi_E-odd | LOCKED to 0 |
| P-diag | chi_E-even diagonal mass | diagonal | even / — | — | (would-be) | **FORBIDDEN** by chi_E-odd requirement | LOCKED to 0 |

Reading: the program *inherits two genuine constraints for free* (P-LQ, P-diag locked to 0 by the
grading + order-one axiom). Everything else is FREE until a Gate-F result is produced. The ledger's
honest headline: **adopting a finite-triple `Phi_H` constrains the *structure* (which entries may be
nonzero) but not the *values* (the masses/mixings).**

---

## 7. Sign of Phi_H^2 in the square (the decisive computation)

With `D_h = i D_N + Gamma_s Phi_H` and the clean grading hypotheses
`{Gamma_s, C_a}=0`, `[Gamma_s, nabla_a^A]=0`, `[Gamma_s, Phi_H]=0`, `[C_a, Phi_H]=0`:

```text
D_h^2 = (i D_N)^2 + (Gamma_s Phi_H)^2 + i D_N (Gamma_s Phi_H) + (Gamma_s Phi_H)(i D_N)
      = -D_N^2 + Gamma_s^2 Phi_H^2 + i[Gamma_s, ...]-organized cross term
      = -D_N(A)^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a^A, Phi_H].
```

The `+Phi_H^2` sign requires **`Gamma_s^2 = +1`** and **`[Gamma_s, Phi_H] = 0`**. If instead
`Gamma_s Phi_H = -Phi_H Gamma_s` (anticommuting), the cross term changes character and, combined with a
Krein `Gamma_s^2 = -1` convention, the sign of `Phi_H^2` flips to `-Phi_H^2` — giving *tachyonic* internal
masses. This is the working-plan §15.5 warning made quantitative. **Lock `Gamma_s^2 = +1`,
`[Gamma_s, Phi_H] = 0`, `Phi_H` chi_E-odd, before any proof.**

---

## 8. Deliverable B — generalized Dirac-square comparison table

| Term in `D_h^2` | Null-edge meaning | Lichnerowicz (Ackermann–Tolksdorf) counterpart | Tolksdorf Dirac–Yukawa role | Status / risk |
|---|---|---|---|---|
| `-K_h(A)` | null-edge kinetic shell | `∇*∇` Bochner Laplacian (Laplace-type principal part) | kinetic term of fermions | **NOT given by Lichnerowicz**; needs dual-soldered symbol + scaling (Gate D/G5) |
| `+Phi_H^2` | fermion Yukawa/Higgs mass block | zeroth-order part of `V` in `D^2 = Δ_B − V` | `Y^†Y` mass term, singular values of `M` | supported; sign requires §7 conventions |
| `+C_diamond(A)` | gauge curvature / Pauli coupling | twisting curvature `F` term in `V` | Yang–Mills field strength coupling | supported; finite version needs curvature def |
| `+T_frame` | tetrad/spin-connection defect | scalar-curvature `s/4` + connection terms in `V` | gravitational (Einstein–Hilbert) part | **NOT automatically 0** on finite complex; theorem target |
| `-i Gamma_s Σ C_a[∇_a^A, Φ_H]` | Higgs-gradient / Yukawa variation | `{∇, zeroth-order}` cross term | source of `|∇^A H|^2` after spectral trace | first-order, vanishes for constant `Phi_H` |
| (separate) `|∇^A H|^2` | W/Z condensate stiffness | bosonic trace of cross term squared (spectral action) | gives W/Z masses | **distinct bucket**; do not fold into `Phi_H^2` |
| (separate) `V(H)` | Higgs radial Hessian gap | bosonic spectral-action potential | Higgs self-coupling/`lambda`, `v` | Riemannian spectral action only |

Two clean takeaways: (i) **three of five `D_h^2` terms are exactly the Lichnerowicz decomposition of a
Dirac–Yukawa operator** — strong form support; (ii) **the two that are not handed to you are precisely
the null-edge-specific ones**, `K_h` (symbol) and `T_frame` (compatibility), which is where the real
proof effort and the real novelty must go.

---

## 9. Deliverable C — sign / gradation conventions to lock before proof work

| ID | Convention | Required value | Why (failure mode if wrong) |
|---|---|---|---|
| S1 | spacetime chirality square | `Gamma_s^2 = +1` | wrong sign of `Phi_H^2` (tachyon) |
| S2 | Phi_H vs Gamma_s | `[Gamma_s, Phi_H] = 0` (commute) | flips `Phi_H^2` sign / corrupts cross term |
| S3 | Phi_H vs internal grading | `Phi_H` **odd** for `chi_E` (`chi_E Phi_H = -Phi_H chi_E`) | block form `[[0,M^†],[M,0]]` fails; allows forbidden diagonal mass |
| S4 | Krein fundamental symmetry | `beta_E` fixed; `Phi_H^‡ = beta_E Phi_H^* beta_E = +Phi_H` | indefinite-metric mass-sign ambiguity (§3) |
| S5 | reality sign | `J Phi_H = epsilon' Phi_H J`, `epsilon'` fixed by KO-dim | wrong Majorana `M_R` reality → wrong seesaw sign |
| S6 | Clifford anticommutation | `{C_a, C_b} = 2 g^{ab}` with **fixed null-frame `g^{ab}`** | wrong `K_h` symbol / light-cone sign |
| S7 | kinetic sign / mass-shell | `K = -nabla_- nabla_+` so that `D^2 = -K + Phi_H^2` ⇒ on-shell `K = Phi_H^2` | sign flip turns matching into a forbidden sum |
| S8 | symbol choice | use dual-soldered `C_a = c(alpha^a)`, **NOT** diagonal `c(ell_a) nabla_{ell_a}` | wrong continuum Dirac symbol (working-plan §15.10) |
| S9 | retarded/advanced ↔ Krein | doubling sign of `beta` = reciprocity sign of `D^‡` | inconsistency ⇒ double-counted factor, breaks `K_null=Phi_H^2` |
| S10 | term separation | `K_h`, `Phi_H^2`, `|∇^A H|^2` are disjoint buckets | double counting (§5) |

These must be a single fixed table in the Gate-A convention file *before* the square theorem is attempted;
S1–S4 and S7 are the ones that silently invert a mass-squared.

---

## 10. Deliverable D — recommended theorem sequence for the super-Dirac square

Ordered so every step is finite and provable before any continuum/analytic step. Each is a Lean target
(§11 gives the staging). "FIN" = finite/algebraic, provable now; "ANA" = needs analysis/continuum.

1. **T0 (FIN, Gate A) — convention lemma.** The grading/sign table (§9) is consistent: a single finite
   model `(H_E, chi_E, Gamma_s, beta_E, J)` exists realizing S1–S6 simultaneously. *Acceptance:* an
   explicit small example (one Dirac fermion) instantiates all signs.
2. **T1 (FIN) — Yukawa checkerboard square (constant M).** With commuting null differences and constant
   `M`, `K_L psi_L = M M^† psi_L`, `K_R psi_R = M^† M psi_R`. (working-plan §6.1/§15.5). *This is the
   anchor and should be proved first.*
3. **T2 (FIN) — graded-square algebraic identity.** Under S1–S3 + `[C_a,Phi_H]=0`,
   `D_h^2 = -D_N^2 + Phi_H^2 - i Gamma_s Σ C_a[nabla_a^A, Phi_H]` as an operator identity on the finite
   complex. *Pure algebra; no symbol limit.*
4. **T3 (FIN) — dual-soldered kinetic decomposition.** `D_N(A)^2 = K_h(A) + C_diamond(A) + T_frame` on
   the finite complex, with `C_diamond` the finite gauge curvature and `T_frame` the explicit
   compatibility defect (possibly nonzero). *Acceptance:* identify each term; do **not** assume
   `T_frame=0`.
5. **T4 (FIN) — assembled finite super-Dirac square.** Combine T2+T3:
   `D_h^2 = -K_h + Phi_H^2 + C_diamond + T_frame - i Gamma_s Σ C_a[nabla_a^A, Phi_H]`.
6. **T5 (FIN) — no-double-count theorem.** In T4, the `M`-quadratic part equals exactly `Phi_H^2` and no
   Plucker minor appears in the zeroth-order block; `K_h` is `M`-independent. (Formalizes §5.)
7. **T6 (FIN) — spectral matching / mass-shell.** `ker(D_h) ∩ {const modes}` is the matched locus
   `K_h = Phi_H^2`; with `A = -K⊗I + I⊗B^†B`, `ker A = ⊕_{lambda=mu} E_lambda(K)⊗E_mu(B^†B)`.
8. **T7 (FIN) — moduli/constraint theorem (Gate F).** State which `Phi_H` coordinates are forced (P-LQ,
   P-diag = 0) and which are free; if a Furey/null-edge relation exists, state it as `R(theta)=0` with
   `rank(dF) < dim`. (Formalizes the ledger §6.)
9. **T8 (FIN, Krein) — pseudo-Riemannian consistency.** T4 survives with `D_h^‡ = ± D_h` under S4/S5/S9;
   retarded/advanced double reproduces the Krein form with consistent sign.
10. **T9 (ANA, continuum) — Lichnerowicz limit.** Under a stated symbol/scaling hypothesis, the finite
    `K_h` converges to `∇*∇` and T4 becomes the generalized Lichnerowicz formula of a Dirac–Yukawa
    operator (Ackermann–Tolksdorf). **Conditional/continuum; do not attempt before T1–T8.**
11. **T10 (ANA, Riemannian only) — spectral action / EHYMH.** Heat-kernel trace yields
    Einstein–Hilbert + Yang–Mills + Higgs with W/Z from `|∇^A H|^2` (Tolksdorf). Riemannian-only;
    flagged non-transferable to Krein without separate work.

Critical-path note: **T1→T2→T3→T4→T5** is the spine. T3 (`T_frame`) and T9 (`K_h` symbol limit) are the
two genuine risks; everything else is bookkeeping or finite algebra.

---

## 11. Deliverable D' — which statements should be finite Lean targets *before* any continuum Lichnerowicz theorem

All of T0–T8 are finite Lean targets and should be done first. Concretely the minimal finite Lean spine:

- **L1 = T1**: constant-`M` checkerboard square, stated on `H_L, H_R` finite-dim with two commuting
  finite-difference operators. (Smallest, prove first — matches existing S1 backlog item
  `NullEdgeYukawaCheckerboard.lean`.)
- **L2 = T2**: graded operator-square identity from the four grading hypotheses (pure linear algebra on a
  finite-dim space; an excellent isolated Lean lemma).
- **L3 = T3**: `D_N^2 = K_h + C_diamond + T_frame` finite decomposition.
- **L4 = T4 + T5**: assembled square + no-double-count.
- **L5 = T6**: finite spectral matching `ker A = ⊕_{lambda=mu} ...` (a clean finite spectral-theory lemma).
- **L6 = T7**: moduli ledger as a theorem (forbidden entries = 0; free-parameter count).
- **L7 = T8**: Krein/pseudo-Riemannian self-adjointness sign.

Only after L1–L7 build should T9/T10 (continuum Lichnerowicz, spectral action) be *stated*, and they must
be stated **conditionally** (explicit symbol-limit and Riemannian hypotheses), per the working-plan rule
that G4 results remain conditional unless every analytic structure is constructed.

---

## 12. Which gate does this route strengthen most?

| Gate | Effect of this route | Strength |
|---|---|---|
| **Gate H** (internal spectrum, Furey bridge, legal Yukawa blocks) | Directly: defines `Phi_H` as a legal chi_E-odd zero-order block, places it in the Cacic moduli, sets the Furey comparison as a constraint test. | **STRONGEST** |
| **Gate A** (conventions, signs, gradings) | Strongly: §7/§9 force the sign/grading table (S1–S10) to be locked; the Krein interaction is made explicit. | Strong (2nd) |
| **Gate B** (finite spine, P1/P1.5) | Moderate: T1 checkerboard is a P1.5 toy; T5/T6 reuse the obstruction `B^†B` schema. | Moderate |
| **Gate F** (prediction/moduli rank) | Moderate-but-conditional: the moduli ledger is the substrate for any `rank(dF)<dim` claim, but no prediction is delivered yet. | Conditional |

**Recommendation:** treat this as primarily a **Gate H** job that *forces* Gate A to finish its sign
table. It feeds Gate F (gives it the ledger) but does not by itself close Gate F.

---

## 13. Deliverable E — verdict: helpful template or generic-reparametrization risk?

**Verdict: a helpful template for the internal block, on strict conditions; a real reparametrization risk
if those conditions are relaxed.**

- **Helpful, because:** (i) Cacic's moduli classification gives an exact, citable accounting of the
  internal freedom of `Phi_H` and tells you *for free* which entries are forbidden (order-one axiom +
  chi_E grading lock P-LQ, P-diag to 0); (ii) Ackermann–Tolksdorf/Tolksdorf show the desired square is
  literally the generalized Lichnerowicz formula of a Dirac–Yukawa operator, validating three of its
  five terms and validating the fermion/W-Z bucket separation; (iii) Bochniak–Sitarz give the right
  Krein language to align with `Gamma_s`/retarded-advanced doubling.

- **A risk, because:** the bare finite triple *parametrizes* rather than *explains* all Yukawa/mass/mixing
  data (ledger §6: M1–M6, M8 all FREE). If `Phi_H` is identified with the full finite Dirac `D_F`, or if
  the finite triple is allowed to supply the kinetic term, the program collapses into "the Standard Model
  stored on a lightlike graph" — exactly the working-plan stop rule's failure case.

- **The conditions that keep it helpful (must all hold):**
  1. `Phi_H` is a *separate zero-order chi_E-odd Krein-self-adjoint Yukawa map*, **not** the full `D_F`,
     and **never** contributes to `K_h` (§1, §5).
  2. The sign/grading table S1–S10 is locked first (§9); `Gamma_s^2=+1`, `[Gamma_s,Phi_H]=0`,
     `Phi_H` chi_E-odd in particular (§7).
  3. No double counting: `K_h`, `Phi_H^2`, `|∇^A H|^2` are disjoint; on shell `K_null = Phi_H^2` is a
     *matching*, not a sum (§5, T5).
  4. Finite Lean spine L1–L7 (T0–T8) is proved before any continuum Lichnerowicz / spectral-action
     statement, and the continuum statements stay conditional (§10–§11).
  5. Furey arXiv:2505.07923 is used only to *test* whether internal coordinates move from FREE to FORCED
     via an explicit `R(theta)=0`; never as a kinetic input.

- **Honest downgrade if a Gate-F constraint never appears:** call the result *null-edge spectral
  reconstruction* — "the known mass mechanisms (Plucker invariant, Yukawa gap, condensate stiffness)
  appear as distinct finite obstruction forms inside one first-order null-edge operator whose square is a
  generalized Lichnerowicz–Dirac–Yukawa identity" — **not** a derivation of the mass spectrum. That
  downgrade is still a publishable, machine-checkable contribution (the finite square spine T1–T8), and
  it is the safe claim boundary.

---

## 14. One-paragraph executive summary

Model `Phi_H` as a separate, legal, zero-order, `chi_E`-odd, Krein-self-adjoint Yukawa endomorphism that
*lives inside* (but is not equal to) the Cacic finite-Dirac moduli space; use that moduli classification
only to audit freedom (most Yukawa/mass/mixing coordinates are FREE; the order-one axiom + grading lock
the leptoquark/diagonal entries to zero). The desired super-Dirac square is exactly the generalized
Lichnerowicz formula of a Dirac–Yukawa operator (Ackermann–Tolksdorf, Tolksdorf), which validates the
`Phi_H^2`, gauge-curvature, and frame terms and the fermion/W-Z bucket separation — but does **not**
supply the null-edge kinetic shell `K_h` or guarantee `T_frame = 0`, which remain the genuine theorem
targets. Lock the sign/grading table (especially `Gamma_s^2=+1`, `[Gamma_s,Phi_H]=0`, `Phi_H` chi_E-odd,
and the Krein/retarded-advanced sign) before any proof; enforce on-shell *matching* `K_null = Phi_H^2`
rather than a sum to avoid double counting; prove the finite spine (constant-M checkerboard → graded
square → kinetic decomposition → assembled square → no-double-count → spectral matching → moduli ledger →
Krein consistency) before any continuum/ spectral-action statement. This route most strengthens Gate H and
forces Gate A to finish. Finite spectral triples are a helpful template under these conditions and a
generic-reparametrization risk without them.
```
