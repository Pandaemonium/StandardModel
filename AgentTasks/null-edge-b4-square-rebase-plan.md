# B4 finite-square rebase plan: rest the finite Dirac square on NullSolderFrame foundations

Type: no-build proof-planning job (with Lean theorem sketches).
Status label: draft-only planning artifact. Nothing here is a promotion request.

This plan tells a future B4 agent how to rebuild the finite Dirac-square package
(`K_null`, `K_full`, `Cdiamond`, `Tframe`, finite-square decomposition, the
`Cdiamond = 0` collapse, and the `Phi_H^2` no-double-counting match) on top of
the new `NullSolderFrame` foundations instead of the stale local encodings that
the kinetic-normalization file currently inherits from the older tetrad-postulate
file.

Sources used:

- `materials/null-edge-null-solder-frame-foundations-report.md` (B-core: B0 data
  package, B1 simplex frame, B3 inverse-Gram, B2 trace obstruction).
- `materials/null-edge-kinetic-normalization-report.md` (A6: `Knull`, `Kfull`,
  `Cdiamond`, `Tframe`, `mass_shell_iff`, and the imported finite-square
  identities).
- `materials/CONVENTIONS.md` (mostly-minus, dual-soldered architecture,
  no-double-counting `K_null = Phi_H^2`, claim labels, frame defect).
- `materials/null-edge-next-wave-strategy.md` and
  `materials/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 20.3 / 21.2
  (Gate A as a hard promotion gate; serial B-core ordering before B4).

---

## 1. Comparison: B-core report vs. kinetic-normalization report

| Axis | B-core (`NullSolderFrameFoundations`, B0->B1->B3->B2) | Kinetic normalization (`NullEdgeKineticNormalization`, A6) |
|---|---|---|
| Mathematical setting | Finite linear algebra over a real vector space `V` with a Gram form `g`. | Finite (possibly non-commutative) `Ring R` with a `Fintype` index. |
| Edge data | Concrete null edge basis `ell_a`, dual covectors `alpha^a := (ell_a).dualBasis`. | Abstract free symbols: `C_a` is an opaque ring element, `nabla_a` an opaque ring element. |
| Soldering carrier | `alpha^a` (the genuine `dualBasis`), with `cliffordCoeff a = c(alpha^a)`. | `C_a` with only the *name* `C_a = c(alpha^a)`; the `alpha^a` is not the `dualBasis`, just a label. |
| Gram / inverse-Gram | `g`, `invGram`, `gram_inv`, explicit `simplexGram` / `simplexInvGram`, `tetra_inverse_gram`. | Absent. Mass-shell symbol `+p^2` is asserted by docstring, not contracted through `G^{ab}`. |
| Reconstruction identity | `reconstruction : xi = sum_a xi(ell_a) . alpha^a`. | Absent. |
| Diagonal-flat status | Modelled (`diagOp`) and rejected by `diagOp_trace_eq_zero_of_null` / `diag_soldering_ne_id`. | Not modelled; the abstract `C_a` could silently be either carrier. |
| Finite square | Not present (out of B-core scope). | `Boxnull`/`Knull`, `Cdiamond`, `Tframe`, `Kplus`/`Kfull`, `dirac_square_*` decompositions, `mass_shell_iff`. |
| Promotion status | Draft-surface finite identities; gated by Gate A / I1 / G1. | Draft-only; the graded `D^2` is an explicit Gate A target, not touched here. |

Key gap. The A6 file already fixes the **names** and the **finite-algebra
identities** correctly (it even encodes the anti-double-counting guardrail
`Kplus = Knull + Cdiamond` and `Kfull = Knull <-> Cdiamond = 0`). What it does
**not** do is tie its `C_a` to the *real* dual-soldering carrier. Its `C_a` is a
free ring element annotated `c(alpha^a)`; nothing forces `alpha^a` to be the
`dualBasis` of a null frame, and nothing forbids someone re-instantiating `C_a`
with the rejected diagonal flat `c(ell_a^flat)`. B4's job is to close exactly
that hole: make the finite square *consume* a `NullSolderFrame` so the soldering
carrier is provably the `dualBasis`, and route the mass-shell normalization
through `invGram`.

---

## 2. What in the finite square must be rebased onto `dualBasis` / inverse-Gram

The A6 file reuses, from `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`:

- definitions `Boxnull`, `Cdiamond`, `Tframe`, `Kplus`, `DN`;
- identities `boxnull_add_cdiamond`, `dirac_square_decomp`,
  `dirac_square_full_decomp`;
- and adds the canonical names `Knull`, `Kfull` plus
  `Knull_eq_Boxnull`, `Kfull_eq_Kplus`, `Kfull_eq_Knull_add_Cdiamond`,
  `dirac_square_eq_Kfull_add_Tframe`,
  `dirac_square_eq_Knull_add_Cdiamond_add_Tframe`,
  `Kplus_eq_Knull_add_Cdiamond`, `Kfull_eq_Knull_iff_Cdiamond_zero`,
  `mass_shell_iff`.

Rebase decisions (what changes, what is preserved):

1. **Soldering coefficients `C_a` -> `frame.cliffordCoeff`.** The free symbol
   `C_a = c(alpha^a)` must be supplied by the B0 datum, i.e.
   `C a := frame.cliffordCoeff a = c (frame.alpha a)`, where `frame.alpha a`
   is the `dualBasis` covector `alpha^a`. This is the single most important
   rebase: it makes "soldered to the dual basis" a *theorem-level* fact rather
   than a naming convention. The abstract `DN`, `Boxnull`/`Knull`, `Cdiamond`,
   `Tframe`, `Kplus`/`Kfull` are then specialized at this `C`.

2. **`DN` (`D_N = sum_a C_a nabla_a`) -> frame-soldered `DN`.** Keep the
   definitional shape; only the `C` argument is replaced by `frame.cliffordCoeff`.
   The transports `nabla_a` stay abstract ring elements (they model finite null
   transports `nabla_{ell_a}`; the geometric content of `ell_a` enters only
   through which `alpha^a` is soldered, per the dual-soldered convention).

3. **Mass-shell normalization -> `invGram` contraction.** The A6 file documents
   the symbol `+p^2` only in prose. On the rebase, the plane-wave / mass-shell
   reading must be expressed by contracting the soldered symbol with the
   inverse-Gram data `frame.invGram` (the `G^{ab}` so that `g_{ab} G^{bc} =
   delta_a^c`, B3). This is where `tetra_inverse_gram`
   (`simplexInvGram 4 = -3/4 . I + 1/4 . J`) becomes the concrete `d = 4` symbol
   normalization, and where `reconstruction` justifies that contracting against
   `alpha^a` recovers the covector. Concretely, the `mass_shell_iff` reading
   `-K_null + Phi_H^2 = 0 <-> K_null = Phi_H^2` should be paired with a lemma
   showing `K_null` is the `invGram`-contracted symbol so the match is between
   two well-typed mass invariants, not two unrelated ring scalars.

4. **Trace obstruction stays as a guard, not a carrier (see Section 3).** The
   `diagOp` / `diag_soldering_ne_id` material is *imported as a negative lemma*
   into the B4 file so the rebase carries an in-file proof that the diagonal-flat
   alternative is rejected.

Preserved unchanged (these are pure finite-ring identities, carrier-agnostic, so
they hold for any `C`, in particular the soldered one): `boxnull_add_cdiamond`,
`Kplus_eq_Knull_add_Cdiamond`, `Kfull_eq_Knull_add_Cdiamond`,
`dirac_square_eq_Kfull_add_Tframe`,
`dirac_square_eq_Knull_add_Cdiamond_add_Tframe`,
`Kfull_eq_Knull_iff_Cdiamond_zero`, `mass_shell_iff`. The rebase does **not**
re-prove them; it **instantiates** them at the soldered `C` and re-exports them
under frame-soldered names.

---

## 3. Preserving the trace obstruction (diagonal flats are a rejected object)

The dual-soldered architecture is locked (`CONVENTIONS.md`, "Dual-soldered Dirac
architecture"): the carrier is `alpha^a = (ell_a).dualBasis`, and the diagonal
architecture `sum_a c(ell_a^flat) nabla_{ell_a}` is forbidden as the basic Dirac
symbol because of the trace/symbol obstruction. The B-core B2 results
`diagOp_trace_eq_zero_of_null`, `diag_soldering_ne_id`, and
`simplex_diag_soldering_ne_id` are the machine-checked form of that obstruction
(`tr(diagOp) = sum_a b_a g(ell_a, ell_a) = 0` on a null frame, while `tr(id) =
d > 0`).

B4 must therefore:

- **never** instantiate the finite square's `C_a` with `c(ell_a^flat)` /
  `diagOp` data; the only admissible carrier is `frame.cliffordCoeff` (the
  `dualBasis`);
- **re-export** the obstruction lemma into the B4 namespace (or `import` it) as a
  documented negative comparison, with a handoff comment stating that
  `diagOp`-based soldering is rejected, not deprecated-but-usable;
- keep the diagonal flat `ell_a^flat` strictly inside B2-style negative lemmas;
  it is a comparison object, never the carrier of any `Knull`/`Kfull`/`DN`
  definition in B4.

This keeps the obstruction load-bearing: any future attempt to "simplify" B4 by
soldering to `ell_a^flat` is contradicted in-file by `diag_soldering_ne_id`.

---

## 4. Promotion-safe theorem statements (draft-only interfaces)

All statements below are written to be **promotion-safe**: they are pure finite
algebra, carry no continuum / no-doubling / prediction content, are conditioned
on explicit hypotheses, and must ship behind a draft-only banner until Gate A
clears (Section 5). They are stated against a `NullSolderFrame` `F`, an abstract
symbol target ring/algebra, a Clifford symbol map `c`, and abstract transports
`nabla : ι -> R`. Names are frame-soldered variants of the A6 names so that the
two never alias.

Notation in the sketches: `F : NullSolderFrame V n`; `C a := F.cliffordCoeff a`
(the dual-soldered coefficient `c (F.alpha a)`); `nab : Fin n -> R` the finite
transports; `[Invertible (4 : R)]` only where the symmetric/antisymmetric split
needs it.

### 4.1 `K_null` as the symmetric null kinetic block

```text
/-- Frame-soldered symmetric null kinetic block: the A6 `Knull` evaluated at the
    dual-soldered coefficients `C a = c (F.alpha a)`. Draft-only (Gate A). -/
theorem KnullFrame_eq [Invertible (4 : R)] :
    KnullFrame F c nab
      = Knull (fun a => F.cliffordCoeff a) nab := by sorry
-- where  KnullFrame F c nab := (1/4) * sum_{a,b} {C a, C b} {nab a, nab b}
--        with C a := c (F.alpha a).
```

This is the rebase anchor: it says the symmetric block is literally the A6
`Knull` whose coefficients are soldered to `F.alpha` (the `dualBasis`), not to a
free symbol.

### 4.2 `K_full = K_null + Cdiamond`

```text
/-- Combined kinetic + curvature block splits as symmetric + commutator block.
    Pure finite-ring identity; holds at the soldered coefficients. -/
theorem KfullFrame_eq_KnullFrame_add_CdiamondFrame [Invertible (4 : R)] :
    KfullFrame F c nab
      = KnullFrame F c nab + CdiamondFrame F c nab := by sorry
-- instantiation of A6 `Kfull_eq_Knull_add_Cdiamond` at C a := c (F.alpha a).
```

### 4.3 Finite Dirac-square decomposition with `Tframe`

```text
/-- Finite null Dirac square, dual-soldered form. No continuum claim. -/
theorem diracSquareFrame_decomp [Invertible (4 : R)] :
    (DNFrame F c nab) ^ 2
      = KnullFrame F c nab + CdiamondFrame F c nab + TframeFrame F c nab := by
  sorry
-- DNFrame F c nab := sum_a (c (F.alpha a)) * nab a
-- instantiation of A6 `dirac_square_eq_Knull_add_Cdiamond_add_Tframe`.
```

(Optionally also the two-term form `(DNFrame ...)^2 = KfullFrame ... +
TframeFrame ...`, instantiating `dirac_square_eq_Kfull_add_Tframe`, which does
not need `Invertible 4`.)

### 4.4 Conditions under which `Cdiamond = 0`

```text
/-- If every soldered symbol pair commutes, the curvature block vanishes and the
    full block collapses to the symmetric block. -/
theorem CdiamondFrame_eq_zero_of_comm
    (hC : ∀ a b, Commute (c (F.alpha a)) (c (F.alpha b))) :
    CdiamondFrame F c nab = 0 := by sorry

/-- Distinctness criterion (A6 guardrail C-2), soldered form: `K_full` and
    `K_null` coincide exactly when the curvature block vanishes. -/
theorem KfullFrame_eq_KnullFrame_iff_Cdiamond_zero [Invertible (4 : R)] :
    KfullFrame F c nab = KnullFrame F c nab
      ↔ CdiamondFrame F c nab = 0 := by sorry
```

Frame-defect companion (the `Tframe` analogue, `CONVENTIONS.md` "Frame/tetrad
defect"): if `[nab a, c (F.alpha b)] = 0` for all `a, b` then
`TframeFrame F c nab = 0`. State it as a separate lemma; do **not** hide a
nonzero `Tframe`.

### 4.5 Conditions under which the no-double-counting `Phi_H^2` match can be stated

The locked rule (`CONVENTIONS.md`, "No double counting") is that the operator
match is `K_null = Phi_H^2`, never `m_Plucker^2 + m_Higgs^2`. The promotion-safe
statement keeps this as a single mass-shell equivalence and **only** under the
Gate-A grading hypotheses that make the super-Dirac square produce `+Phi_H^2`:

```text
/-- No-double-counting mass-shell reading, abstract form (A6 `mass_shell_iff`):
    a single relation `K_null = Phi_H^2`, never two additive mass terms. -/
theorem massShellFrame_iff (k phi2 : R) :
    -k + phi2 = 0 ↔ k = phi2 := by sorry

/-- The match may only be *invoked* for the soldered kinetic block under the
    `+Phi_H^2` grading hypotheses (Working Plan 20.3 / 21.2):
      Gamma_s^2 = 1, {Gamma_s, C_a} = 0, [Gamma_s, nab a] = 0,
      [Gamma_s, Phi] = 0, [C_a, Phi] = 0.
    Stated as a conditional so it cannot be read as a continuum/prediction claim. -/
theorem noDoubleCount_massShell
    (Gam Phi : R)
    (hG2 : Gam ^ 2 = 1)
    (hGC : ∀ a, Gam * c (F.alpha a) + c (F.alpha a) * Gam = 0)
    (hGn : ∀ a, Commute Gam (nab a))
    (hGP : Commute Gam Phi)
    (hCP : ∀ a, Commute (c (F.alpha a)) Phi) :
    -- under these hypotheses the on-shell match is the single relation
    KnullFrame F c nab = Phi ^ 2 ↔ -(KnullFrame F c nab) + Phi ^ 2 = 0 := by
  sorry
```

Guardrail wording for this lemma's docstring: it is a *reconstruction/structural*
statement, not a prediction; it asserts one mass relation, asserts no continuum
limit, and asserts no branch/no-doubling determinant result (that lives behind
Gate C, `CONVENTIONS.md` "Branch-count / no-doubling test").

---

## 5. Dependency order and the Gate-A promotion bar

### 5.1 Serial B-core order, then B4

```text
B0  NullSolderFrame data package (ell_a, alpha^a = dualBasis, Gram, invGram,
    reconstruction, cliffordCoeff)
      |
      v
B1  simplex / tetrahedral frame  (simplexGram, simplexInvGram, simplexFrame,
    simplexFrame_null)            -- general d = n >= 2, d = 4 a special case
      |
      v
B3  explicit inverse-Gram        (simplex_gram_mul_invGram, tetra_inverse_gram,
    tetra_gram_mul_inv)
      |
      v
B2  diagonal trace obstruction   (diagOp, diagOp_trace_eq_zero_of_null,
    diag_soldering_ne_id, simplex_diag_soldering_ne_id)
      |
      v
B4  finite-square rebase         (this plan: KnullFrame, KfullFrame,
    CdiamondFrame, TframeFrame, DNFrame, decompositions, Cdiamond=0,
    massShell match)
```

B1 -> B3 -> B2 is the required serial order from the B-core report and
`null-edge-next-wave-strategy.md` (B0 -> B1 -> B3 -> B2 -> B4): the simplex frame
(B1) must exist before its inverse-Gram is computed (B3), and the inverse-Gram /
nullity must exist before the trace obstruction (B2), which consumes `g(ell_a,
ell_a) = 0`. B4 depends on **all** of B0/B1/B3/B2: it solders to `alpha^a`
(B0), normalizes through `invGram` (B3, concretely `tetra_inverse_gram`),
specializes at the simplex frame (B1), and re-exports the obstruction (B2).

If any of B1/B3/B2 is incomplete: **hold B4** and re-launch the stuck node in
serial order (next-wave-strategy `B.partial`). B4 may be *developed*
experimentally on a partial B-core, but only as draft.

### 5.2 What must NOT be promoted before Gate A

Gate A (`A1` super-Dirac sign theorem + `A2` wrong-grading counterexamples,
supported by `A6` naming and `A3` convention-integration audit) is a **hard
promotion gate** (Working Plan 21.2, next-wave-strategy A-node). Until it clears:

- **No finite-square theorem may be promoted to a trusted surface** — this is
  exactly the B4/T14/B5/D7/M5 family, i.e. every declaration in Section 4
  (`KnullFrame_eq`, `KfullFrame_eq_*`, `diracSquareFrame_decomp`,
  `CdiamondFrame_eq_zero_*`, `noDoubleCount_massShell`, ...). They stay
  draft-only with a banner.
- **No `D^2` graded super-Dirac square claim** may be stated as resolved; the
  `+Phi_H^2` vs `-Phi_H^2` sign is precisely what `A1`/`A2` settle. B4's
  `noDoubleCount_massShell` may only be *conditioned* on the grading hypotheses,
  never assert that they hold.
- **No no-doubling / branch-count promotion** (that is Gate C, a separate kill
  switch) and **no continuum / square-limit promotion** (still unlocked,
  `CONVENTIONS.md` "Still not fully locked").
- **No prediction language** anywhere; B4 is reconstruction/structural at most.

Promotion of B4 is unlocked only on the joint condition `A.pass` **and**
`B.pass` (B-core lands) **and** the live-verification re-audit of S8/S9/S10 onto
B0 (next-wave-strategy B-node). Until then: develop now, promote later.

---

## 6. Minimal Lean skeleton for the future B4 rebase

This is the file a B4 agent should start from. It compiles as a skeleton once the
referenced B-core and A6 modules exist in the live tree (they are absent from the
current request snapshot, so this is provided as a sketch, not built here). Keep
every proof as a hole (`by sorry`) until B-core lands; keep the draft banner
until Gate A clears.

```lean
import Mathlib
-- B-core foundations (B0 -> B1 -> B3 -> B2):
import PhysicsSM.Draft.NullSolderFrameFoundations
-- A6 finite-square names and identities:
import PhysicsSM.Draft.NullEdgeKineticNormalization

/-!
# Draft.NullEdgeFiniteSquareRebase  (Gate-B job B4)

DRAFT-ONLY. Finite linear/ring algebra only. Mostly-minus signature.

This module rebases the finite Dirac-square package onto the `NullSolderFrame`
foundation: the soldering coefficients are the *dual-basis* covectors
`alpha^a = (ell_a).dualBasis` (`NullSolderFrame.cliffordCoeff`), and the
mass-shell normalization is routed through the inverse-Gram data.

PROMOTION BAR: no declaration in this file may be promoted to a trusted surface
before Gate A clears (super-Dirac sign theorem A1 + wrong-grading
counterexamples A2 + naming A6 + convention audit A3); see
`AgentTasks/null-edge-b4-square-rebase-plan.md` Section 5.2.

GUARDRAILS: no Euclidean edge-sum collapse; no continuum/square-limit claim; no
no-doubling/branch-count claim (Gate C); no prediction language. The diagonal
flat `ell_a^flat` is a REJECTED comparison object (trace obstruction B2), never
the carrier — see `diag_soldering_ne_id` re-exported below.
-/

namespace PhysicsSM.Draft.NullEdgeFiniteSquareRebase

open PhysicsSM.Draft

section Rebase

-- Geometry: a null-solder frame supplying `ell_a`, `alpha^a = dualBasis`,
-- Gram `g`, inverse-Gram `invGram`, reconstruction, and `cliffordCoeff`.
variable {V : Type*} [AddCommGroup V] [Module ℝ V] {n : ℕ}
variable (F : NullSolderFrame V n)

-- Symbol algebra: the Clifford target ring and abstract finite transports.
variable {R : Type*} [Ring R]
variable (c : Module.Dual ℝ V →ₗ[ℝ] R)   -- Clifford symbol map; C a := c (F.alpha a)
variable (nab : Fin n → R)               -- finite null transports nabla_{ell_a}

/-- Dual-soldered coefficient: `C a = c (alpha^a)` with `alpha^a` the dualBasis. -/
def Csolder (a : Fin n) : R := c (F.alpha a)

/-- Frame-soldered finite null Dirac operator `D_N = sum_a C_a nabla_a`. -/
def DNFrame : R := sorry   -- := ∑ a, Csolder F c a * nab a   (reuse A6 `DN` shape)

/-- Frame-soldered symmetric kinetic block (A6 `Knull` at soldered coeffs). -/
def KnullFrame [Invertible (4 : R)] : R := sorry

/-- Frame-soldered curvature/commutator block (A6 `Cdiamond` at soldered coeffs). -/
def CdiamondFrame [Invertible (4 : R)] : R := sorry

/-- Frame-soldered frame/tetrad defect (A6 `Tframe` at soldered coeffs). -/
def TframeFrame : R := sorry

/-- Frame-soldered combined block (A6 `Kfull` at soldered coeffs). -/
def KfullFrame : R := sorry

-- === Section 4.1 — K_null as the symmetric null kinetic block ===
theorem KnullFrame_eq [Invertible (4 : R)] :
    KnullFrame F c nab = Knull (Csolder F c) nab := by sorry

-- === Section 4.2 — K_full = K_null + Cdiamond ===
theorem KfullFrame_eq_KnullFrame_add_CdiamondFrame [Invertible (4 : R)] :
    KfullFrame F c nab = KnullFrame F c nab + CdiamondFrame F c nab := by sorry

-- === Section 4.3 — finite Dirac-square decomposition with Tframe ===
theorem diracSquareFrame_decomp [Invertible (4 : R)] :
    (DNFrame F c nab) ^ 2
      = KnullFrame F c nab + CdiamondFrame F c nab + TframeFrame F c nab := by
  sorry

theorem diracSquareFrame_decomp_full :
    (DNFrame F c nab) ^ 2 = KfullFrame F c nab + TframeFrame F c nab := by sorry

-- === Section 4.4 — conditions under which Cdiamond = 0 ===
theorem CdiamondFrame_eq_zero_of_comm [Invertible (4 : R)]
    (hC : ∀ a b, Commute (Csolder F c a) (Csolder F c b)) :
    CdiamondFrame F c nab = 0 := by sorry

theorem KfullFrame_eq_KnullFrame_iff_Cdiamond_zero [Invertible (4 : R)] :
    KfullFrame F c nab = KnullFrame F c nab ↔ CdiamondFrame F c nab = 0 := by sorry

theorem TframeFrame_eq_zero_of_comm
    (hT : ∀ a b, Commute (nab a) (Csolder F c b)) :
    TframeFrame F c nab = 0 := by sorry

-- === Section 4.5 — no-double-counting Phi_H^2 match (conditional only) ===
theorem massShellFrame_iff (k phi2 : R) : -k + phi2 = 0 ↔ k = phi2 := by sorry

theorem noDoubleCount_massShell [Invertible (4 : R)]
    (Gam Phi : R)
    (hG2 : Gam ^ 2 = 1)
    (hGC : ∀ a, Gam * Csolder F c a + Csolder F c a * Gam = 0)
    (hGn : ∀ a, Commute Gam (nab a))
    (hGP : Commute Gam Phi)
    (hCP : ∀ a, Commute (Csolder F c a) Phi) :
    KnullFrame F c nab = Phi ^ 2 ↔ -(KnullFrame F c nab) + Phi ^ 2 = 0 := by
  sorry

end Rebase

-- === Trace obstruction re-export (B2): diagonal flats are REJECTED ===
-- Handoff: `ell_a^flat` soldering is impossible (trace 0 vs trace d); keep this
-- visible so no future edit re-solders the square to diagonal flats.
-- Re-export / restate:  NullSolderFrame.diag_soldering_ne_id ,
--                       NullSolderFrame.diagOp_trace_eq_zero_of_null .

end PhysicsSM.Draft.NullEdgeFiniteSquareRebase
```

### Handoff notes for the B4 agent

1. Fill the `def` bodies by reusing the A6 spellings (`Knull`, `Cdiamond`,
   `Tframe`, `Kplus`/`Kfull`, `DN`) applied to `Csolder F c`; do **not** redefine
   the finite-ring identities — instantiate `Kfull_eq_Knull_add_Cdiamond`,
   `dirac_square_eq_Knull_add_Cdiamond_add_Tframe`,
   `Kfull_eq_Knull_iff_Cdiamond_zero`, `mass_shell_iff` at the soldered `C`.
2. Add the `invGram` mass-shell normalization lemma (Section 2, item 3) once the
   symbol-to-`p^2` contraction is settled with B3 `tetra_inverse_gram`.
3. Re-export the B2 obstruction; never solder to `ell_a^flat`.
4. Keep the draft banner and the Section 5.2 promotion bar until Gate A clears;
   keep all conclusions labelled reconstruction/structural, never prediction.

---

## 7. Guardrail compliance summary

- **Mostly-minus signature.** Nullity enters via the B-core `g(ell_a, ell_a) = 0`
  frame; the symbol is normalized to `+p^2` (`K_null = -Box_analytic`), matching
  `CONVENTIONS.md` "Metric signature". No opposite-signature statement is made.
- **No Euclidean edge-sum collapse.** Coefficients are soldered to the dual basis
  `alpha^a` and contracted through `invGram` (`G^{ab}`), never an undualized
  `sum_a ell_a` Euclidean sum; the diagonal flat sum is explicitly rejected (B2).
- **No continuum theorem.** Everything is finite linear/ring algebra; no
  square-limit or symbol-limit claim appears.
- **No prediction language.** All Section 4 statements are reconstruction /
  structural; the `Phi_H^2` match is one conditional mass relation, not a fixed
  EFT parameter.
- **No finite-square promotion before Gate A.** Section 5.2 makes the entire B4
  package draft-only until `A1`/`A2`/`A6`/`A3` clear, with the promotion bar
  written into the file banner.
```
