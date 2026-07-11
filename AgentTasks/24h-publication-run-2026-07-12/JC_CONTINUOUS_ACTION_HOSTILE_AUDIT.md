# Hostile audit — even-exterior cover action & coordinate 2×2 block stabilizer

Adversarial referee report on the two verbatim modules. Nothing was edited or
re-proved. Source 2 (`...H2BlockStabilizer`, imports only Mathlib) was
re-compiled independently in the pinned toolchain and elaborates with **zero
errors and zero `sorry`**. Source 1
(`...JordanCliffordExteriorCoverAction`) imports
`PhysicsSM.Gauge.QunitQubitQutritRepresentation`, which is **absent from the
delivered repository**, so it cannot be compiled or its `#print axioms` pins
re-run here; its API usage against Mathlib was checked and is correct
(`exteriorPower.map`, `map_id`, `map_comp`, `finrank_eq`, `Module.finrank_prod`
all exist with the shapes used; `choose 5 0 + choose 5 2 + choose 5 4 = 16`
confirmed by `decide`).

## 1. Verdict: **PASS WITH REQUIRED SCOPE EDITS**

The mathematics is correct and non-vacuous, the intended non-claims (item 4) are
respected in the *code*, and no `SMCoveringTriple`/`SMProductCoveringTriple`
conflation occurs at the Lean level. The required edits are docstring
de-inflation ("continuous", "S(U(2)×U(1))", "chirality") and a hard scope fence
around the word "Z6" so the manuscript cannot silently promote the *unit-level*
kernel to the *true product-cover* kernel.

## 2. Findings

### HIGH

- **H1 — Source 1 is entirely conditional on an unaudited, missing import.**
  Every substantive fact in Source 1 is imported, not proved here:
  `generationActLinear` (that `actQubitPlusQutrit` is even a genuine, nontrivial
  ℂ-linear action), `generationActLinear_one`/`generationActLinear_mul` (rest on
  `actQubitPlusQutrit_one`/`actQubitPlusQutrit_mul`), and
  `generationActLinear_kernel` (rests on `kernelElt_actQubitPlusQutrit_eq_id`).
  The module is a **pure functorial lift**: `exteriorAct`, `evenExteriorAct`,
  `evenExteriorRepresentation`, `exteriorAct_kernel`, `evenExteriorAct_kernel`,
  `sixKernelElements_evenExteriorRepresentation_eq_one` add exterior-power
  packaging but no new physics. If `actQubitPlusQutrit` were trivial, or
  `UnitCoveringKernelElt` degenerate, the headline collapses while every theorem
  here still compiles. The `#print axioms` guards cannot be confirmed in this
  repo. Treat all of Source 1 as *trusted-import-conditional*.

- **H2 — "Z6" scope: unit-level only, never the true product cover.**
  Source 1 touches exactly `UnitCoveringTriple`, `UnitCoveringKernelElt`,
  `sixUnitCoveringKernelElts`. It says nothing about `SMCoveringTriple` or the
  true `SMProductCoveringTriple`, so there is **no code-level conflation** — but
  that is precisely the danger: the manuscript must not read
  `sixKernelElements_evenExteriorRepresentation_eq_one` as a statement about the
  physical Standard-Model Z6 = (U(1)×SU(2)×SU(3))/Z6 kernel. It is inclusion of
  a *unit-level* kernel family into the kernel of a *raw product* action.

### MEDIUM

- **M1 — "continuous" is unproven (Source 1 docstrings, and the name
  `evenExteriorRepresentation` / "continuous unit cover").** Nothing
  topological is established: `evenExteriorRepresentation` is a bare `MonoidHom`
  of the discrete monoid `UnitCoveringTriple` into `Module.End`. No topology,
  no continuity, no Lie-group structure is present. Remove "continuous".

- **M2 — `det_eq_upperBlock_det_mul_corner` docstring inflation ("the
  coordinate `S(U(2) x U(1))` determinant relation").** The theorem has **no
  unitarity and no `det = 1` hypothesis**; it is a generic Laplace/cofactor
  factorization `det U = det(upper 2×2) · U 2 2` valid for *any* 2+1
  block-diagonal matrix. It carries zero special-unitary content and does not
  impose the `S(U(2)×U(1))` constraint (that would require
  `det(2×2)·U 2 2 = 1`). Rescope docstring to "determinant factorization of a
  2+1 block-diagonal matrix."

- **M3 — "positive-chirality five-mode spinor" (Source 1, `EvenExterior`).**
  Chirality is a **naming label only**: no Clifford multiplication, no Spin(10)
  Γ-grading, no chirality operator is defined or shown to select Λ⁰⊕Λ²⊕Λ⁴.
  The even-degree choice is defensible convention, but "positive-chirality" is
  decoration, not a theorem. Keep as informal name, flag as unproven.

### LOW

- **L1 — the "six" earn nothing about being six.** The kernel theorems are
  universally quantified over the *type* `UnitCoveringKernelElt` (stronger than
  six), and `sixKernelElements_...` merely specializes it. Distinctness,
  nonidentity, and exhaustion-of-Z6 of `sixUnitCoveringKernelElts` are **not
  established here** (imported). Do not claim "six distinct nontrivial
  generators."

- **L2 — `IsUnitary3` slightly over-strong for the forward direction.** The ⇒
  branch of `stabilizesUpperBlock_iff_blockDiagonal` uses only `hU.2`
  (`U * Uᴴ = 1`) plus stabilization; `hU.1` is unused there. Not a defect
  (the ⇐ / witnesses want the full two-sided condition), just noted.

- **L3 — `EvenExterior` uses `×` (Prod), not `⊕`.** Mathematically fine (finite
  biproduct; `Module.finrank_prod` gives additivity, hence the honest
  `evenExterior_finrank = 16`), but manuscript spinor language should say
  "direct sum".

### Non-findings (checked, clean)

- **Dimension numerology is correct, not fudged.** `finrank GenerationSpace = 5`
  (C²+C³), `Λ⁰,Λ²,Λ⁴ = 1,10,5`, total `16`. `evenExterior_finrank` proves it via
  `Module.finrank_prod` + `exteriorPower.finrank_eq`; no hand-set constant.
- **Multiplication order is a genuine left action, not reversed.**
  `generationActLinear_mul : gen (x*y) = (gen x).comp (gen y)` and
  `exteriorAct_mul` via `exteriorPower.map_comp`
  (`map n (g ∘ₗ f) = map n g ∘ₗ map n f`) compose consistently; the `MonoidHom`
  `map_mul'` is `f(x*y) = f x * f y` in `Module.End` (mul = comp). No
  anti-homomorphism bug (consistent with `(A*B).mulVec = A.mulVec ∘ B.mulVec`).
- **Exterior degrees/chirality shape is correct.** Even part {0,2,4} of C⁵ is a
  16-dim Weyl half-spinor of Spin(10); degree list is right.
- **Source 2 iff is true and non-vacuous, no hidden determinant assumption.**
  Forward direction genuinely uses unitarity (`hcorner: |U 2 2|²=1` forces
  `conj(U 2 2) ≠ 0`); ⇐ is direct computation. `phaseWitness = diag(i,−i,1)` is
  a bona fide **nonidentity** (`phaseWitness_ne_one`) **special** unitary
  (`phaseWitness_det = 1`, `phaseWitness_unitary`) stabilizer
  (`phaseWitness_stabilizes`). `mixingControl` (the `(1 2)` transposition) is a
  real unitary **negative** control (`mixingControl_not_stabilizes`). All
  verified.

## 3. Strongest manuscript sentence earned by each module

- **Source 1 (earned, conditional on the trusted import):** "The trusted
  unit-level cover `UnitCoveringTriple` acts ℂ-linearly on the 5-dimensional
  C²+C³ space; this action lifts functorially to a monoid representation on the
  16-dimensional even exterior module Λ⁰×Λ²×Λ⁴, and every element of the trusted
  unit-level covering-kernel type `UnitCoveringKernelElt` — in particular the six
  explicit `sixUnitCoveringKernelElts` — acts as the identity endomorphism; i.e.
  the trusted unit-level Z6 is *contained in* the kernel of the even-exterior
  representation." (No exactness, no continuity, no chirality theorem, no descent
  to the true G_SM.)

- **Source 2 (earned outright, fully verified):** "A 3×3 unitary matrix
  preserves the upper-left 2×2 block under conjugation iff it is 2+1
  block-diagonal; for such a matrix the determinant factorizes as
  det = det(upper 2×2)·(corner); and there is an explicit nonidentity
  special-unitary stabilizer diag(i,−i,1) together with an explicit unitary
  element (the (1 2) transposition) that fails to stabilize."

## 4. Forbidden statements (must NOT appear in the manuscript)

1. "The kernel of the even-exterior action **equals** Z6" — no converse /
   exactness / kernel classification is proved (explicitly disclaimed).
2. Any claim that the weak/color (2+3) split is **derived from Jordan data**.
3. Any Furey intertwiner claim / identification with the corrected Furey
   left-action module.
4. Any intrinsic **F4** transitivity/stabilizer statement, or identity-component
   glue (Source 2 is explicitly only an SU(3)-coordinate rung).
5. Any **topological/Lie quotient** statement, or asserting the action is
   "continuous" — only a discrete `MonoidHom` is proved.
6. Any statement that the action **descends to / factors through** the true
   Standard-Model gauge group G_SM = S(U(2)×U(3)) = (U(1)×SU(2)×SU(3))/Z6, or
   anything phrased with `SMProductCoveringTriple`/`SMCoveringTriple` or its
   kernel — Source 1 only touches `UnitCoveringTriple`.
7. That `sixUnitCoveringKernelElts` are distinct / nonidentity / exhaust Z6
   (not established here).
8. That `det_eq_upperBlock_det_mul_corner` is an "S(U(2)×U(1))" or det=1 result
   (it assumes neither unitarity nor det=1).

## 5. Smallest theorem needed for an exact product-cover action-kernel = Z6

Two ingredients are missing and both must be supplied over the **true**
`SMProductCoveringTriple` (not `UnitCoveringTriple`):

- **(port)** Restate the representation over `SMProductCoveringTriple`, giving
  `evenExteriorRepresentation' : SMProductCoveringTriple →* Module.End ℂ EvenExterior`
  and the inclusion `∃ k, k.toSMProductCoveringTriple = x → evenExteriorAct' x = id`
  (mechanical re-run of the present Source-1 argument).

- **(new content — the actual theorem to prove)** the *converse*,
  faithfulness-modulo-centre:

  ```
  theorem evenExteriorAct'_kernel_exact (x : SMProductCoveringTriple) :
      evenExteriorAct' x = LinearMap.id ↔
        ∃ k : SMProductCoveringKernelElt, k.toSMProductCoveringTriple = x
  ```

  Only the `→` (forward) direction is genuinely new. Its **smallest sufficient
  lemma** is degree-2 faithfulness on the bifundamental summand of Λ²: writing
  Λ²(C²⊕C³) = Λ²C² ⊕ (C²⊗C³) ⊕ Λ²C³, prove that if `exteriorAct 2 x` fixes the
  C²⊗C³ (bi-fundamental, hypercharge-weighted) summand pointwise then the triple
  `(u, A, B) ∈ U(1)×SU(2)×SU(3)` lies in the order-6 centre — i.e. the induced
  map on that summand is injective modulo Z6. Combined with the ported
  inclusion, this yields kernel = Z6 exactly. (Λ¹ = the defining C²+C³ rep is the
  *odd* part and is unavailable in the even module, which is exactly why the
  degree-2 bifundamental is the minimal faithful window.)
