# The ℂ⊗ℍ⊗𝕆 (Dixon) convention reference — authoritative

Status: authoritative convention doc for the null-edge → SM electroweak/Lorentz
program (Furey 1806.00612, the division-algebra Standard Model). Written
2026-07-17 to consolidate conventions after operator-structure/convention errors
proved costly. When a claim here disagrees with a Lean module, the **kernel-checked
module wins** and this doc must be fixed; every non-trivial statement below cites
either a repo module or a verbatim Furey PDF equation.

Grounding source: Furey, "SU(3)×SU(2)×U(1)/Z6 as a symmetry of division algebraic
ladder operators," Eur. Phys. J. C (2018) 78:375 (arXiv:1806.00612). Equation
numbers below are that paper's, extracted from the actual PDF via pdfplumber
(NOT the garbled Neo4j OCR).

---

## 1. The three tensor factors and their physical roles

The Dixon algebra is `R ⊗ C ⊗ H ⊗ O`; in this program the `R` is implicit and we
work with **`C ⊗ H ⊗ O`**. The factors are *independent tensor slots* (elements of
different factors commute), each with a distinct physical role:

| factor | dim | physical role | Furey section |
|--------|-----|---------------|---------------|
| `C`    | 2   | complexification; `i ↦ -i` is charge conjugation on Dirac spinors | §3.5 |
| `H`    | 4   | **spin / chirality / Lorentz** (the `C⊗H ≅ Cl(2)` Weyl/Dirac sector) | §3 |
| `O`    | 8   | **colour** (the `C⊗O ≅ Cl(6)` `SU(3)_C` sector) | §4 |

The weak `Cl(4)` (§5) is built from the `H`-chirality `Cl(2)` and the `O`-isospin
`Cl(2)` acting together.

---

## 2. THE most costly convention: the `H`-units are a SEPARATE triple from the octonion units

This caused repeated errors. Furey's `‡` (eq. 30 text) negates **three distinct
families**:

> `‡` maps `i ↦ -i` (complex), `i_j ↦ -i_j` for `j = 1,2,3` (quaternion), and
> `e_k ↦ -e_k` for `k = 1,...,7` (octonion), while reversing multiplication order.

So there are:

* **one** complex unit `i` (the `C` factor),
* **three** quaternion units `i_1, i_2, i_3` (the `H` factor; `i_j² = -1`,
  `{i_m, i_n} = 2δ_mn` for `m,n ∈ {1,2}`, and `i_3 = i_1 i_2` a bivector — eq. 6,
  §3.2),
* **seven** octonion units `e_1, ..., e_7` (the `O` factor).

The eq-29/30 weak-ladder units `i_1, i_2` are the **`H`-quaternion** units, NOT
octonion units `e_1, e_2`. Reading them as octonion units puts the `beta`-ladders
in `C⊗O` instead of `C⊗H⊗O` and silently corrupts the whole weak sector. (The
original Aristotle no-go `661e5230` correctly flagged that the `C⊗H` factor is
genuinely needed; an intermediate "`C⊗O`-constructible" claim was wrong.)

---

## 3. The XOR octonion basis (repo `O` convention)

Independent of Furey. Repo octonions use the XOR binary-label basis (see
`PhysicsSM/Algebra/Octonion/Basic.lean` and AGENTS.md):

* Bases `e000` (unit) … `e111`; coordinates `c0 … c7`.
* Product index = bitwise XOR of the two input labels; sign from the Fano
  orientation in `Octonion.Basic`.
* Anchor products: `e011·e111 = e100`, `e101·e111 = e010`, `e110·e111 = e001`.

This is **not** Baez (2002) or Furey (2015) verbatim; any external octonion
formula needs relabeling + sign correction via
`PhysicsSM/Algebra/Octonion/ConventionBridge` (see `Scripts/oracle/validate_octonion.py`).

`C⊗O` is the repo type `ComplexOctonion` (`re + i·im`, two octonions), with
`ComplexOctonion.I = ⟨0, e0⟩` the complex unit and multiplication
`(a+i b)(c+i d) = (ac-bd) + i(ad+bc)` (`ComplexOctonion.lean`).

---

## 4. The Dixon algebra `C⊗H⊗O` in Lean (`DixonAlgebra.lean`)

Tractable representation: **`H`-valued over `C⊗O`** — a `Dixon` element is
`x_0 + x_1 i_1 + x_2 i_2 + x_3 i_3` with each `x_k : ComplexOctonion` (the colour
coefficient). Kernel-checked structure (sorry-free, standard-three axiom guards):

* Product = the **quaternion Hamilton product with `ComplexOctonion` coefficients**
  (`Dixon.mul`): signs from `i_1² = i_2² = i_3² = -1`, `i_1 i_2 = i_3`,
  `i_2 i_3 = i_1`, `i_3 i_1 = i_2`. Verified: `i1_sq`, `i1_i2`, `i2_i3`, `i3_i1`,
  `i2_i1` (`= -i_3`).
* **Tensor-commutation** `ofColour_comm_i_j`: the `H`-units commute with the whole
  colour factor `ofColour x`. THIS is what makes the construction genuinely the
  tensor product `C⊗H⊗O` (the colour factor is itself non-commutative and
  non-associative, yet the `H`-units commute through it).
* **`H`-unit anticommutation** `i1_i2_anticomm` `{i_j, i_k} = 0` (`j ≠ k`): the
  fermionic Clifford structure the colour factor `C⊗O` alone cannot supply.

---

## 5. Left / right / bar actions — what each rotates (Furey §3, eq. 13)

Furey works with the algebra acting on itself. Three actions:

* **Left** `L_x(z) = x z` — rotates **SPIN** states (§3, p.4-5).
* **Right** `R_y(z) = z y` — rotates **CHIRALITY** (`C⊗H`, §3.6) and, in the colour
  sector, **ISOSPIN** (`C⊗O`, §5.1). The weak `Cl(4)` is the two RIGHT actions
  together (chirality ⊗ isospin), p.8.
* **Bar** `(x|y)` with **`(x|y) z = x z y`** (eq. 13 text) — two-sided. The `C⊗H`
  Dirac matrices (eq. 13, Weyl basis) are bar operators:

  `γ⁰ = 1|i_1`,  `γ¹ = i_1|i_2`,  `γ² = i_2|i_2`,  `γ³ = i_3|i_2`.

Repo scaffolding: `PhysicsSM/Draft/NullEdge/DixonLeftRightAction.lean` has
`Lmul`, `Rmul`, and `bar x y z = (x*z)*y` on `ComplexOctonion` (parenthesization
explicit; `C⊗O` non-associative), with `bar_eq_rmul_lmul`. The landed
`ChiralityFromActionSplit` is the finite matrix shadow of "left and right actions
are conceptually distinct and do not mix" (the algebraic origin of "the weak force
is left-handed").

States are **minimal left ideals** `Ψ = Cl(2n) v` on an idempotent vacuum `v`
(eq. 8), so **`z = 1` is not a physical state** — relevant to §7 below.

---

## 6. The ladder operators (colour `O`; §4) and the weak `beta`'s (§5)

Colour ladders (`PhysicsSM/Algebra/Furey/LadderOperators.lean`): `alpha_1,
alpha_2, alpha_3` and daggers, satisfying the CAR **at the element level**
(kernel-checked in `C⊗O`):

`alpha_i alpha_j‡ + alpha_j‡ alpha_i = delta_ij`,  `{alpha_i, alpha_j} = 0`.

Key derived colour objects:

* `omega ≡ a_1 a_2 a_3` (Furey p.7, "define ω ≡ a a a") — the nilpotent
  triple-ladder (`(omega)² = 0`). In the repo this is
  `WeakBetaLaddersFromColor.omega = alpha1*alpha2*alpha3`.
* The colour **idempotent** `v = omega omega‡ = (1 - i e_111)/2` (repo
  `MinimalLeftIdeal.omega`, kernel `omega*omega=omega`) and the complementary
  `omega‡ omega = (1 + i e_111)/2`. **They sum to 1, so `{omega, omega‡} = 1`.**
  (Do NOT confuse the two "omega"s: the nilpotent ladder `a_1a_2a_3` vs the
  idempotent `(1-ie_111)/2` — same letter, different objects, different files.)
* Isospin `Cl(2)` generators (eq. 29): `tau_1 = omega + omega‡`,
  `tau_2 = i omega - i omega‡`, `tau_3 = omega omega‡ - omega‡ omega`.

Weak `Cl(4)` ladders (eq. 30), `i_1, i_2` the `H`-units, `tau_1` colour, `i`
complex:

`beta_1 = (1/2)(-i_2 + i i_1 tau_1)`,   `beta_2 = omega‡ i i_1`.

CAR target (eq. 31): `{beta_i, beta_j} = {beta_i‡, beta_j‡} = 0`,
`{beta_i, beta_j‡} = delta_ij` for `i,j ∈ {1,2}`. su(2)_L (eq. 35):
`T_j = tau_j (1/2)(1 + i_3)`, with `(1/2)(1+i_3)` a chirality projector; leptonic
ideal `L ~ 1 ⊕ 2 ⊕ 1` (eq. 32/36).

---

## 7. THE operator-vs-element CAR distinction (the second costly lesson)

Furey's `beta`'s are written as algebra ELEMENTS (eq. 30) but the eq-31 CAR is an
**OPERATOR** relation, NOT an element identity. Kernel fact
(`DixonWeakLadders.betaH_like_anticomm_ne_zero`): the ELEMENT anticommutator
`{beta_1, beta_2}_element = (1/2){omega,omega‡} = 1/2 ≠ 0` (the `H`-unit cross
terms cancel via `{i_1,i_2}=0`; the colour `{omega,omega‡}=1` survives).

So the element product is the WRONG model. Two live operator readings (open —
`DixonWeakCARConjecture.lean` pre-registers reading A with a kill-condition):

* **(A) right-action on the ideal.** `R_{beta}(z) = z beta`, CAR on the leptonic
  ideal `L = v_w Cl(4)` (`v_w = beta_1‡ beta_2‡ beta_2 beta_1`, eq. 32). `z=1 ∉ L`,
  so the element `1/2` is irrelevant. Matches Furey's explicit "right action."
* **(B) bar operators on all `z`.** `(x|y)z = xzy`; here `(x|y)·1 = xy ≠` element
  product, so `1/2` is again not an obstruction. Matches eq. 13's `x|y` Diracs.

Caution recorded from experience: the colour `alpha`'s DO satisfy the CAR at the
element level (they are single ladders); the weak `beta`'s do NOT (they carry
`tau_1 = omega+omega‡`). Do not assume the weak sector inherits the colour
sector's element-level CAR. Determining (A) vs (B) and proving it is the open
Aristotle target; brute `norm_num` on the 4–6-fold non-associative products is
infeasible — use the colour-CAR / idempotent lemmas.

---

## 8. Module map (what implements what)

| concept | module |
|---------|--------|
| octonions `O`, XOR basis | `PhysicsSM/Algebra/Octonion/Basic.lean` |
| octonion conjugation `e_k ↦ -e_k` | `PhysicsSM/Algebra/Octonion/Conjugation.lean` (`conj`) |
| `C⊗O` = `ComplexOctonion` | `PhysicsSM/Algebra/Octonion/ComplexOctonion.lean` (`complexConj` = `i ↦ -i`) |
| colour ladders, element CAR | `PhysicsSM/Algebra/Furey/LadderOperators.lean` |
| colour idempotent, ideal, states | `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean` |
| `omega, tau_j, beta_i` (colour reading), element-CAR failure | `PhysicsSM/Draft/NullEdge/WeakBetaLaddersFromColor.lean` |
| left/right/bar action scaffolding | `PhysicsSM/Draft/NullEdge/DixonLeftRightAction.lean` |
| **`C⊗H⊗O` Dixon algebra** | `PhysicsSM/Draft/NullEdge/DixonAlgebra.lean` |
| faithful eq-30 `beta`'s + `‡`, element-CAR fact | `PhysicsSM/Draft/NullEdge/DixonWeakLadders.lean` |
| pre-registered operator-CAR conjecture (A/B + kill) | `PhysicsSM/Draft/NullEdge/DixonWeakCARConjecture.lean` |
| chirality projector, RH=singlet | `PhysicsSM/Draft/NullEdge/WeakIsospinChiralityProjector.lean` |
| abstract su(2)_L, U(2), SU(5) hypercharge | `WeakIsospinTwoModeSU2Aristotle`, `ElectroweakU2FromLadders`, `SU5HyperchargeUnification` |

Roadmap / running design log:
`AgentTasks/null-edge-S2b-weak-isospin-from-ladder-design-2026-07-17.md`
(CORRECTIONs 2–5). Claim-governing status:
`Sources/Null_Edge_Ten_Ambitious_Goals_Status_2026-07-17.md` (Item 2).

---

## 9. Furey PDF equation quick-index (verbatim-checked)

* eq. 6 — spin ladders `α = ½(i_1 + i i_2)`, `α† = ½(-i_1 + i i_2)` (`H`-units).
* eq. 7 — `{α,α}={α†,α†}=0`, `{α,α†}=1`.
* eq. 8 — `Ψ_R = ψ↑ α† v_s + ψ↓ v_s` (spinor as minimal left ideal on vacuum `v_s`).
* eq. 13 — Dirac γ's as bar operators; `(x|y)z = xzy`.
* eq. 28 — `C⊗O ≅ S_16`, `Cl(6)_colour ⊗ Cl(2)_isospin`.
* eq. 29 — `Cl(4)` generators `{τ_1 i_1, τ_2 i_1, τ_3 i_1, i_2}`; the `τ_j`.
* eq. 30 — `β_1 = ½(-i_2 + i i_1 τ_1)`, `β_2 = ω‡ i i_1`; the `‡` definition.
* eq. 31 — the CAR `{β_i,β_j}={β_i‡,β_j‡}=0`, `{β_i,β_j‡}=δ_ij`.
* eq. 32 — leptonic ideal `L = v_w Cl(4)`, `v_w = β_1‡ β_2‡ β_2 β_1`.
* eq. 35 — `T_j = τ_j ½(1+i_3)` (su(2)_L; `½(1+i_3)` chirality projector).
* eq. 36 — `L ~ 1 ⊕ 2 ⊕ 1`.
