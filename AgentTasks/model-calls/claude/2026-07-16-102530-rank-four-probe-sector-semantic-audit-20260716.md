# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-16T10:25:20`
- Finished: `2026-07-16T10:25:30`
- Timeout seconds: `360`
- Max budget USD: `2.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
# Independent semantic review: rank-four carrier probe-sector correction

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

## Project context

The NullStrand/null-edge program is attempting a conservative gate-by-gate
reconstruction of continuum Lorentzian geometry from finite causal order and
null-edge data. The current finite operator architecture uses zero-sum scalar
probe fields on closed Alexandrov carriers. A prior Lean module packaged a
`Fin 4` basis of the entire zero-sum carrier space as a four-probe frame and
proved conditional Gram-congruence and Lorentz-gauge results.

A semantic audit found that the whole zero-sum space has dimension
`|carrier| - 1`; therefore a `Fin 4` basis of that whole space is possible only
on five-event carriers. The prior algebra is correct, but its frame interface
cannot scale to physical refinement carriers.

The proposed successor module proves the obstruction and introduces a supplied
rank-four subspace of the whole zero-sum sector. It re-establishes the finite
Gram/Lorentz algebra and order-isomorphism covariance on that subspace. It also
proves arbitrary rank-four subspaces exist whenever the carrier has at least
five events, while explicitly withholding any claim that the arbitrary choice
is intrinsic or physical.

## Intended reading

1. `carrierProbeFrame_forces_card_five` is an exact semantic-domain audit of
   the old interface.
2. `RankFourCarrierProbeSector` is a supplied candidate subspace, not a graph
   derivation.
3. `rankFourCarrierProbeSector_nonempty_of_five_le_card` establishes only
   algebraic nonvacuity. It does not solve natural selection, overlap
   compatibility, Lorentzian inertia, or convergence.
4. The physically meaningful open gate is a bare-order construction of a
   rank-four subspace family `P_A` that is relabeling-natural, retarded-visible,
   overlap-compatible, Lorentzian under the corrected pairing, and stable in a
   refinement limit.
5. No preferred basis is sought; frames inside `P_A` are Lorentz gauge choices.

## Review questions

Please audit the embedded Lean source and report:

1. Is the cardinality obstruction mathematically and semantically exact?
2. Does the selected-sector successor genuinely remove the old physical
   vacuity, or merely hide it in a supplied structure?
3. Are any theorem names, docstrings, or claim grades stronger than the kernel
   statements warrant?
4. Is `mapOrderIso` only transport of an already selected sector, as intended,
   rather than a proof that an independently selected target sector is natural?
5. Does the arbitrary subspace existence theorem risk being mistaken for a
   graph-native selector, despite its docstring and surrounding note?
6. Is the proposed next gate scientifically well posed: derive the subspace and
   transition class, but retain basis freedom as local Lorentz gauge?
7. Identify any hidden assumptions, false-shape theorem, vacuity, or missing
   explicit witness that should block integration.

## Requested verdict format

Return exactly these sections:

1. `Verdict`: APPROVE, REVISE, or REJECT.
2. `Kernel/statement alignment`.
3. `Physical claim boundary`.
4. `Required changes before integration`.
5. `Recommended next reconstruction gate`.

Treat a theorem that is true but physically false-shaped as a blocking issue.
Do not credit prose intentions that the embedded declarations fail to encode.


## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/IntrinsicProbeSubspace.lean (301 lines)

```lean
import PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator

/-!
# Intrinsic scalar-probe subspaces without a preferred basis

An individually natural ordered probe list is fixed pointwise by every order
automorphism.  `FiniteCausalOrderOperator.lean` already proves that such probes
are constant on automorphism-transitive orders.  This module implements the
required escape: a probe **subspace** is transported under relabeling, while a
basis inside that subspace is gauge-relative and need not be fixed.

The canonical finite example is the zero-sum scalar-field subspace.  Relabeling
is a linear equivalence of scalar-field spaces and preserves the total sum, so
the zero-sum subspace is exactly natural under every finite-order isomorphism.
On the five-event antichain this subspace has real dimension four.  In contrast,
every individually natural probe that is also zero-sum vanishes there.  This
is an exact positive/negative split: bare-order symmetry permits a rank-four
probe space but forbids a canonical ordered basis of nonzero probes.

For a closed Alexandrov carrier, the same subspace feeds directly into the
induced smeared causal-operator corrected pairing.  The pairing is symmetric
and relabels exactly with the subspace.  No basis, coordinates, tetrad, or
target metric enters this statement.

The five-event antichain is a representation-theoretic control, not a physical
spacetime reconstruction.  Rank four there follows from carrier cardinality,
not causal dimension, and the module proves neither Lorentzian signature nor
slowly varying affine probes on a refinement family.

Claim grade: `M [orig]` for the finite linear-algebra and covariance results.
Provenance: program-internal response to the intrinsic ordered-probe
automorphism obstruction in `FiniteCausalOrderOperator.lean`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Linear relabeling and zero-sum fields -/

/-- Relabeling scalar fields along an order isomorphism is a real-linear
equivalence. -/
def fieldRelabelLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : (V → ℝ) ≃ₗ[ℝ] (W → ℝ) where
  toFun := e.relabelField
  invFun := (reverseOrderIso e).relabelField
  left_inv phi := by
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Total scalar-field sum as a linear functional. -/
def fieldSumLinearMap (U : Type*) [Fintype U] : (U → ℝ) →ₗ[ℝ] ℝ where
  toFun phi := ∑ x : U, phi x
  map_add' phi psi := by
    simp [Finset.sum_add_distrib]
  map_smul' c phi := by
    simp [Finset.mul_sum]

/-- Canonical codimension-one candidate probe space: scalar fields with zero
total sum. -/
def zeroSumFieldSubspace (U : Type*) [Fintype U] :
    Submodule ℝ (U → ℝ) :=
  LinearMap.ker (fieldSumLinearMap U)

/-- Relabeling preserves the total field sum. -/
theorem fieldSum_relabel
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    fieldSumLinearMap W (e.relabelField phi) =
      fieldSumLinearMap V phi := by
  unfold fieldSumLinearMap
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro x
  simp only [OrderIso.relabelField_apply]

/-- Membership in the zero-sum subspace is exactly preserved by relabeling. -/
theorem mem_zeroSum_relabel_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    e.relabelField phi ∈ zeroSumFieldSubspace W ↔
      phi ∈ zeroSumFieldSubspace V := by
  simp [zeroSumFieldSubspace, LinearMap.mem_ker, fieldSum_relabel]

/-! ## Basis-free intrinsic probe sectors -/

/-- A relabeling-natural scalar-probe subspace.  Unlike
`IntrinsicProbeSector`, this interface does not require individual basis
vectors to be fixed by automorphisms. -/
structure IntrinsicProbeSubspaceSector where
  space : ∀ {U : Type} [Fintype U],
    FiniteCausalOrder U → Submodule ℝ (U → ℝ)
  equivariant : ∀ {U Z : Type} [Fintype U] [Fintype Z]
    {C : FiniteCausalOrder U} {D : FiniteCausalOrder Z}
    (e : OrderIso C D) (phi : U → ℝ),
    phi ∈ @space U _ C ↔ e.relabelField phi ∈ @space Z _ D

/-- The zero-sum field assignment is an intrinsic probe-subspace sector. -/
def zeroSumProbeSector : IntrinsicProbeSubspaceSector where
  space := fun {U} _ _ => zeroSumFieldSubspace U
  equivariant := fun e phi => (mem_zeroSum_relabel_iff e phi).symm

/-- The subspace-level covariance law can equivalently be stated as exact
equality after `Submodule.map`. -/
theorem IntrinsicProbeSubspaceSector.map_space_eq
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) :
    (P.space C).map (fieldRelabelLinearEquiv e).toLinearMap =
      P.space D := by
  ext psi
  constructor
  · rintro ⟨phi, hphi, rfl⟩
    exact (P.equivariant e phi).1 hphi
  · intro hpsi
    let phi : V → ℝ := (fieldRelabelLinearEquiv e).symm psi
    have hphi : phi ∈ P.space C := by
      apply (P.equivariant e phi).2
      change fieldRelabelLinearEquiv e
        ((fieldRelabelLinearEquiv e).symm psi) ∈ P.space D
      simpa using hpsi
    exact ⟨phi, hphi, by simp [phi]⟩

/-- Relabeling restricts to a linear equivalence between the two natural
probe subspaces. -/
def IntrinsicProbeSubspaceSector.spaceLinearEquiv
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : P.space C ≃ₗ[ℝ] P.space D where
  toFun phi := ⟨e.relabelField phi.1, (P.equivariant e phi.1).1 phi.2⟩
  invFun psi :=
    ⟨(reverseOrderIso e).relabelField psi.1,
      (P.equivariant (reverseOrderIso e) psi.1).1 psi.2⟩
  left_inv phi := by
    apply Subtype.ext
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    apply Subtype.ext
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-! ## Symmetric controls and the rank-four split -/

/-- The antichain on five events, with full permutation symmetry. -/
def fiveEventAntichain : FiniteCausalOrder (Fin 5) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the five-event antichain lies in one automorphism orbit. -/
theorem fiveEventAntichain_automorphismTransitive :
    fiveEventAntichain.AutomorphismTransitive := by
  intro x y
  let swap : Fin 5 ≃ Fin 5 := Equiv.swap x y
  refine ⟨{
    toEquiv := swap
    map_before_iff := ?_
  }, ?_⟩
  · intro a b
    simp [fiveEventAntichain]
  · simp [swap]

/-- The total-sum functional on five events is onto. -/
theorem finFive_fieldSum_surjective :
    Function.Surjective (fieldSumLinearMap (Fin 5)) := by
  intro value
  refine ⟨fun x => if x = 0 then value else 0, ?_⟩
  simp [fieldSumLinearMap]

/-- The canonical zero-sum probe subspace on five events has dimension four. -/
theorem finrank_fiveEvent_zeroSum :
    Module.finrank ℝ (zeroSumFieldSubspace (Fin 5)) = 4 := by
  have hrange : LinearMap.range (fieldSumLinearMap (Fin 5)) = ⊤ :=
    LinearMap.range_eq_top.2 finFive_fieldSum_surjective
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker (fieldSumLinearMap (Fin 5))
  rw [hrange] at hrank
  simp [zeroSumFieldSubspace] at hrank ⊢
  omega

/-- On the same symmetric order, an individually natural probe that is also
zero-sum must vanish pointwise. -/
theorem intrinsicProbe_zero_of_fiveEvent_meanZero
    {r : Nat} (P : IntrinsicProbeSector r) (a : Fin r)
    (hzeroSum : P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) (x : Fin 5) :
    P.probe fiveEventAntichain a x = 0 := by
  have hconstant : ∀ y : Fin 5,
      P.probe fiveEventAntichain a y =
        P.probe fiveEventAntichain a 0 := by
    intro y
    exact P.probe_constant_of_automorphismTransitive fiveEventAntichain
      fiveEventAntichain_automorphismTransitive a y 0
  have hsum :
      (∑ y : Fin 5, P.probe fiveEventAntichain a y) = 0 := by
    exact hzeroSum
  simp_rw [hconstant] at hsum
  have hbase : P.probe fiveEventAntichain a 0 = 0 := by
    norm_num at hsum ⊢
    exact hsum
  rw [hconstant x, hbase]

/-- The positive/negative split on the five-event symmetric control: the
natural zero-sum subspace has rank four, while every individually natural
zero-sum probe vanishes. -/
theorem fiveEvent_rankFour_subspace_but_no_natural_vectors
    {r : Nat} (P : IntrinsicProbeSector r)
    (hzeroSum : ∀ a, P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) :
    Module.finrank ℝ (zeroSumProbeSector.space fiveEventAntichain) = 4 ∧
      ∀ a x, P.probe fiveEventAntichain a x = 0 := by
  constructor
  · exact finrank_fiveEvent_zeroSum
  · intro a x
    exact intrinsicProbe_zero_of_fiveEvent_meanZero P a (hzeroSum a) x

/-! ## Basis-free carrier pairing -/

/-- Zero-sum probe subspace on one closed Alexandrov carrier. -/
def carrierProbeSubspace
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Submodule ℝ (ClosedCarrier A → ℝ) :=
  zeroSumFieldSubspace (ClosedCarrier A)

/-- Corrected causal-operator pairing restricted to the basis-free carrier
probe subspace. -/
def carrierProbePairing
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) : ℝ :=
  correctedPairingAt
    (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
    x f.1 h.1

/-- The restricted pairing remains symmetric without a chosen probe basis. -/
theorem carrierProbePairing_comm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x h f := by
  exact correctedPairingAt_comm _ _ _ _

/-- Relabeling equivalence between zero-sum probe subspaces of isomorphic
closed carriers. -/
def carrierProbeLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) :
    carrierProbeSubspace A ≃ₗ[ℝ] carrierProbeSubspace (A.map e) :=
  zeroSumProbeSector.spaceLinearEquiv (inducedOrderIso e A)

/-- The basis-free carrier pairing is exactly covariant under ambient order
isomorphisms. -/
theorem carrierProbePairing_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x)
        (carrierProbeLinearEquiv e A f)
        (carrierProbeLinearEquiv e A h) =
      carrierProbePairing A ell nonlocalityScale x f h := by
  exact OrderIso.correctedPairingAt_projectSmeared4D_equivariant
    (inducedOrderIso e A) ell nonlocalityScale x f.1 h.1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant

end PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

```

### PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean (390 lines)

```lean
import PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Gauge-relative four-probe frames and Lorentzian carrier forms

`IntrinsicProbeSubspace.lean` shows that a scalar-probe subspace can be natural
under every finite-order isomorphism even when no ordered list of nonzero
probes can be selected pointwise naturally. This module supplies the next
finite tetrad bridge.

The active smeared causal operator is first bundled as a real-linear map. Its
corrected principal-symbol pairing therefore becomes a genuine symmetric
bilinear form on each closed Alexandrov carrier's zero-sum probe subspace. A
four-probe frame is a basis of that subspace indexed by `Fin 4`, and its Gram
matrix is the matrix of the corrected bilinear form in that basis.

Mathlib's change-of-basis theorem then gives the exact congruence law

`G_c = M^T G_b M`.

Consequently, if one frame normalizes the pairing to the project convention
`eta = diag(1,-1,-1,-1)`, a second frame has the same normalization exactly
when its transition matrix is `eta`-orthogonal. Thus a successful four-mode
operator reconstruction determines a Lorentz gauge class of probe frames,
not a preferred tetrad. The existence of such a normalized frame is also
preserved and reflected by every ambient causal-order isomorphism.

This is a finite conditional reconstruction theorem. It does not prove that a
four-probe frame exists on physical refinement carriers, that the corrected
form has Lorentzian inertia there, or that either object converges to a smooth
cotangent frame and metric.

Claim grade: `M [orig]` for the finite linearity, congruence, gauge, and
order-covariance statements. Provenance: program-internal composition of the
active Benincasa-Dowker operator, the intrinsic probe-subspace bridge,
Mathlib's bilinear-form change-of-basis theorem, and the project's
`MinkowskiConvention` grounded in Mathlib's `indefiniteDiagonal`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## The active operator as a linear map -/

/-- The layered past sum is additive in its scalar field. -/
theorem layeredPastSum_add_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (f h : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (f + h) x =
      C.layeredPastSum coefficient f x +
        C.layeredPastSum coefficient h x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore, mul_add]

/-- The layered past sum is homogeneous in its scalar field. -/
theorem layeredPastSum_smul_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (c : ℝ) (f : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (c • f) x =
      c * C.layeredPastSum coefficient f x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore]
  ring

/-- Every real layered operator is a linear map on finite scalar fields. -/
def layeredOperatorLinearMap
    (C : FiniteCausalOrder V) (prefactor diagonal : ℝ)
    (coefficient : Nat → ℝ) : (V → ℝ) →ₗ[ℝ] (V → ℝ) where
  toFun := C.layeredOperator prefactor diagonal coefficient
  map_add' f h := by
    funext x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_add_real]
    simp only [Pi.add_apply]
    ring
  map_smul' c f := by
    funext x
    change C.layeredOperator prefactor diagonal coefficient (c • f) x =
      c * C.layeredOperator prefactor diagonal coefficient f x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_smul_real]
    simp only [Pi.smul_apply, smul_eq_mul]
    ring

/-- Linear-map packaging of the source-native local four-dimensional
operator. -/
def sourceLocal4DLinearMap (C : FiniteCausalOrder V) (ell : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  layeredOperatorLinearMap C (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient

/-- Linear-map packaging of the source-native smeared four-dimensional
operator, including its equal-scale branch. -/
def sourceSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  if smearingEpsilon ell nonlocalityScale = 1 then
    sourceLocal4DLinearMap C ell
  else
    layeredOperatorLinearMap C
      (4 / (Real.sqrt 6 * nonlocalityScale ^ 2)) (-1)
      (sourceSmeared4DCoefficient
        (smearingEpsilon ell nonlocalityScale))

/-- Linear-map packaging of the active project-sign smeared operator. -/
def projectSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  -sourceSmeared4DLinearMap C ell nonlocalityScale

/-- The bundled linear map has exactly the previously defined active operator
as its underlying function. -/
@[simp] theorem projectSmeared4DLinearMap_apply
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) (f : V → ℝ) :
    projectSmeared4DLinearMap C ell nonlocalityScale f =
      projectSmeared4DOperator C ell nonlocalityScale f := by
  ext x
  simp only [projectSmeared4DLinearMap, sourceSmeared4DLinearMap,
    sourceLocal4DLinearMap, layeredOperatorLinearMap,
    projectSmeared4DOperator, sourceSmeared4DOperator,
    LinearMap.neg_apply, Pi.neg_apply]
  split_ifs <;> rfl

/-! ## Corrected pairing as a symmetric bilinear form -/

/-- A linear finite-field operator produces a bilinear corrected pairing at
each event. -/
def correctedPairingBilinFormAt
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) :
    LinearMap.BilinForm ℝ (V → ℝ) :=
  LinearMap.mk₂ ℝ (fun f h => correctedPairingAt B x f h)
    (by
      intro f g h
      simp [correctedPairingAt, add_mul]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)
    (by
      intro f h k
      simp [correctedPairingAt, mul_add]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)

omit [Fintype V] in
/-- The bilinear packaging evaluates to the original corrected pairing. -/
@[simp] theorem correctedPairingBilinFormAt_apply
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) (f h : V → ℝ) :
    correctedPairingBilinFormAt B x f h = correctedPairingAt B x f h :=
  rfl

/-- The active corrected pairing restricted to one carrier's natural probe
subspace, as a genuine bilinear form. -/
def carrierProbeBilinForm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    LinearMap.BilinForm ℝ (carrierProbeSubspace A) :=
  (correctedPairingBilinFormAt
      (projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale) x).comp
    (carrierProbeSubspace A).subtype (carrierProbeSubspace A).subtype

/-- The carrier bilinear form is definitionally the existing basis-free
carrier pairing. -/
@[simp] theorem carrierProbeBilinForm_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbeBilinForm A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x f h := by
  change correctedPairingAt
      (⇑(projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale))
      x f.1 h.1 =
    correctedPairingAt
      (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
      x f.1 h.1
  congr 1
  funext u
  exact projectSmeared4DLinearMap_apply
    (inducedOrder A) ell nonlocalityScale u

/-- The active carrier form is symmetric. -/
theorem carrierProbeBilinForm_isSymm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    (carrierProbeBilinForm A ell nonlocalityScale x).IsSymm := by
  refine LinearMap.BilinForm.isSymm_def.mpr (fun f h => ?_)
  simp only [carrierProbeBilinForm_apply]
  exact carrierProbePairing_comm A ell nonlocalityScale x f h

/-! ## Four-probe frames, Gram congruence, and Lorentz gauge -/

/-- A four-probe carrier frame is a basis of the natural probe subspace. Its
existence is a substantive rank-four condition. -/
abbrev CarrierProbeFrame
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :=
  Module.Basis (Fin 4) ℝ (carrierProbeSubspace A)

/-- Matrix of the active corrected pairing in a four-probe frame. -/
def carrierProbeGram
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Matrix (Fin 4) (Fin 4) ℝ :=
  LinearMap.BilinForm.toMatrix b
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- Entries of the frame Gram matrix are the corrected pairings of its probe
vectors. -/
theorem carrierProbeGram_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) (i j : Fin 4) :
    carrierProbeGram A ell nonlocalityScale x b i j =
      carrierProbePairing A ell nonlocalityScale x (b i) (b j) := by
  simp [carrierProbeGram]

/-- **Exact tetrad change law.** Corrected-pairing matrices in any two
four-probe frames are related by matrix congruence. -/
theorem carrierProbeGram_change
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A) :
    (b.toMatrix c)ᵀ * carrierProbeGram A ell nonlocalityScale x b *
        b.toMatrix c =
      carrierProbeGram A ell nonlocalityScale x c := by
  exact LinearMap.BilinForm.toMatrix_mul_basis_toMatrix (b := b) c
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- A frame is Lorentz-normalized when the reconstructed pairing matrix is the
project's mostly-minus Minkowski matrix. -/
def IsLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Prop :=
  carrierProbeGram A ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Basis-free Lorentzian-inertia gate: some four-probe frame normalizes the
active carrier form to `(+---)`. -/
def HasLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : CarrierProbeFrame A,
    IsLorentzNormalized A ell nonlocalityScale x b

/-- **Recovered local gauge group, conditional on the signature gate.** Once
one probe frame is Lorentz-normalized, another is Lorentz-normalized exactly
when their basis-change matrix is `eta`-orthogonal. -/
theorem isLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A)
    (hb : IsLorentzNormalized A ell nonlocalityScale x b) :
    IsLorentzNormalized A ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsLorentzNormalized at hb ⊢
  rw [← carrierProbeGram_change A ell nonlocalityScale x b c, hb]

/-- Lorentzian inertia implies nondegeneracy of the reconstructed carrier
bilinear form. -/
theorem carrierProbeBilinForm_nondegenerate_of_lorentzian
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (hLorentz : HasLorentzianInertia A ell nonlocalityScale x) :
    (carrierProbeBilinForm A ell nonlocalityScale x).Nondegenerate := by
  rcases hLorentz with ⟨b, hb⟩
  apply (LinearMap.BilinForm.nondegenerate_iff_det_ne_zero b).2
  change (carrierProbeGram A ell nonlocalityScale x b).det ≠ 0
  rw [hb, MinkowskiConvention.eta_det]
  norm_num

/-! ## Exact transport under causal-order isomorphism -/

/-- Push a four-probe frame along the intrinsic carrier equivalence. -/
def mapCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame A) : CarrierProbeFrame (A.map e) :=
  b.map (carrierProbeLinearEquiv e A)

/-- Pull a four-probe frame back along the intrinsic carrier equivalence. -/
def pullCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame (A.map e)) : CarrierProbeFrame A :=
  b.map (carrierProbeLinearEquiv e A).symm

/-- Pushing a frame along an order isomorphism leaves its corrected-pairing
matrix exactly unchanged. -/
theorem carrierProbeGram_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) :
    carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) (mapCarrierProbeFrame e A b) =
      carrierProbeGram A ell nonlocalityScale x b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x)
      (carrierProbeLinearEquiv e A (b i))
      (carrierProbeLinearEquiv e A (b j)) =
    carrierProbePairing A ell nonlocalityScale x (b i) (b j)
  exact carrierProbePairing_equivariant e A ell nonlocalityScale x (b i) (b j)

/-- Pulling a target frame back along an order isomorphism also leaves its Gram
matrix exactly unchanged. -/
theorem carrierProbeGram_pullOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame (A.map e)) :
    carrierProbeGram A ell nonlocalityScale x
        (pullCarrierProbeFrame e A b) =
      carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing A ell nonlocalityScale x
      ((carrierProbeLinearEquiv e A).symm (b i))
      ((carrierProbeLinearEquiv e A).symm (b j)) =
    carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x) (b i) (b j)
  symm
  simpa using carrierProbePairing_equivariant e A ell nonlocalityScale x
    ((carrierProbeLinearEquiv e A).symm (b i))
    ((carrierProbeLinearEquiv e A).symm (b j))

/-- The basis-free Lorentzian-inertia gate is exactly invariant under every
ambient causal-order isomorphism. -/
theorem hasLorentzianInertia_orderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    HasLorentzianInertia (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) ↔
      HasLorentzianInertia A ell nonlocalityScale x := by
  constructor
  · rintro ⟨b, hb⟩
    refine ⟨pullCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_pullOrderIso]
    exact hb
  · rintro ⟨b, hb⟩
    refine ⟨mapCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_mapOrderIso]
    exact hb

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff

end PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

```

### PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean (351 lines)

```lean
import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-!
# Selected rank-four carrier probe sectors

`ProbeFrameLorentzGauge.lean` correctly proves finite Gram-congruence and
Lorentz-gauge statements, but its `CarrierProbeFrame A` is a `Fin 4` basis of
the *entire* zero-sum scalar-field space on `ClosedCarrier A`.  This module
makes the resulting cardinality obstruction explicit:

`finrank (zeroSumFieldSubspace U) = |U| - 1`,

so the old frame hypothesis forces `|ClosedCarrier A| = 5`.  In particular,
that interface cannot be the physical four-mode sector on a large refinement
carrier.  The old theorems remain valid conditional finite algebra; this file
records their exact domain of possible application.

The successor interface is `RankFourCarrierProbeSector A`: a supplied
rank-four subspace of the full zero-sum carrier space.  Frames are bases of
that selected subspace.  The corrected pairing restricts to it, obeys the
same exact Gram congruence, and leaves only Lorentz-related normalized frames.
Order isomorphisms transport the selected subspace, its frames, and its Gram
matrix exactly.

This repairs the type-level architecture but does not derive the selected
subspace from a bare causal order.  A physical reconstruction must still give
an intrinsic, overlap-compatible rule selecting four slowly varying probe
modes, prove Lorentzian inertia on them, and establish continuum convergence.

Claim grade: `M [orig]` for the finite obstruction, selected-sector linear
algebra, and order-covariance statements.  Provenance: program-internal
semantic audit of `IntrinsicProbeSubspace.lean` and
`ProbeFrameLorentzGauge.lean`, using Mathlib finite-dimensional linear algebra.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RankFourProbeSector

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix
open ProbeFrameLorentzGauge

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Exact obstruction for the whole zero-sum space -/

/-- On every nonempty finite type, the total-sum functional is onto. -/
theorem fieldSumLinearMap_surjective
    (U : Type*) [Fintype U] [Nonempty U] :
    Function.Surjective (fieldSumLinearMap U) := by
  classical
  intro value
  let u : U := Classical.choice (inferInstance : Nonempty U)
  refine ⟨fun x => if x = u then value else 0, ?_⟩
  simp [fieldSumLinearMap, u]

/-- The zero-sum scalar-field space on a nonempty finite type has exactly
codimension one. -/
theorem finrank_zeroSumFieldSubspace
    (U : Type*) [Fintype U] [Nonempty U] :
    Module.finrank ℝ (zeroSumFieldSubspace U) = Fintype.card U - 1 := by
  have hrange : LinearMap.range (fieldSumLinearMap U) = ⊤ :=
    LinearMap.range_eq_top.2 (fieldSumLinearMap_surjective U)
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker (fieldSumLinearMap U)
  rw [hrange] at hrank
  simp [zeroSumFieldSubspace] at hrank ⊢
  omega

/-- If the full zero-sum carrier space has finrank four, the carrier has
exactly five events. -/
theorem fullCarrierProbe_finrank_four_forces_card_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hrank : Module.finrank ℝ (carrierProbeSubspace A) = 4) :
    Fintype.card (ClosedCarrier A) = 5 := by
  letI : Nonempty (ClosedCarrier A) := ⟨carrierBottom A⟩
  change Module.finrank ℝ
    (zeroSumFieldSubspace (ClosedCarrier A)) = 4 at hrank
  rw [finrank_zeroSumFieldSubspace] at hrank
  have hpos : 0 < Fintype.card (ClosedCarrier A) := Fintype.card_pos
  omega

/-- **Exact semantic boundary of the old frame interface.** A `Fin 4` basis
of the entire zero-sum carrier space can exist only on a five-event carrier. -/
theorem carrierProbeFrame_forces_card_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (b : CarrierProbeFrame A) :
    Fintype.card (ClosedCarrier A) = 5 := by
  apply fullCarrierProbe_finrank_four_forces_card_five A
  have hdim := Module.finrank_eq_card_basis b
  simpa using hdim

/-- On every carrier whose cardinality is not five, the old whole-space
four-frame type is empty. -/
theorem no_carrierProbeFrame_of_card_ne_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hcard : Fintype.card (ClosedCarrier A) ≠ 5) :
    ¬ Nonempty (CarrierProbeFrame A) := by
  rintro ⟨b⟩
  exact hcard (carrierProbeFrame_forces_card_five A b)

/-- The old Lorentz-inertia predicate is likewise impossible away from
five-event carriers, independently of the operator coefficients. -/
theorem no_old_hasLorentzianInertia_of_card_ne_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (hcard : Fintype.card (ClosedCarrier A) ≠ 5) :
    ¬ HasLorentzianInertia A ell nonlocalityScale x := by
  rintro ⟨b, _⟩
  exact hcard (carrierProbeFrame_forces_card_five A b)

/-! ## Corrected selected-sector interface -/

/-- A supplied rank-four candidate inside the full zero-sum carrier probe
space.  This structure records the algebraic target; a graph-native
reconstruction must still derive `space` and its overlap compatibility. -/
structure RankFourCarrierProbeSector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) where
  space : Submodule ℝ (carrierProbeSubspace A)
  finrank_eq_four : Module.finrank ℝ space = 4

/-- The corrected interface is algebraically nonvacuous on every carrier with
at least five events.  This existence proof chooses an arbitrary independent
four-tuple; it does not provide the intrinsic selector required by physics. -/
theorem rankFourCarrierProbeSector_nonempty_of_five_le_card
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hcard : 5 ≤ Fintype.card (ClosedCarrier A)) :
    Nonempty (RankFourCarrierProbeSector A) := by
  letI : Nonempty (ClosedCarrier A) := ⟨carrierBottom A⟩
  have hfour : 4 ≤ Module.finrank ℝ (carrierProbeSubspace A) := by
    change 4 ≤ Module.finrank ℝ
      (zeroSumFieldSubspace (ClosedCarrier A))
    rw [finrank_zeroSumFieldSubspace]
    omega
  obtain ⟨f, hf⟩ := exists_linearIndependent_of_le_finrank hfour
  refine ⟨⟨Submodule.span ℝ (Set.range f), ?_⟩⟩
  simpa using finrank_span_eq_card hf

/-- A gauge-relative frame of a selected rank-four probe sector. -/
abbrev SectorFrame
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) :=
  Module.Basis (Fin 4) ℝ P.space

/-- Every packaged rank-four sector admits a `Fin 4`-indexed basis.  The basis
chosen by `finBasis` is not asserted to be natural or physically preferred. -/
def someSectorFrame
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) : SectorFrame P := by
  letI : Module.Free ℝ P.space :=
    Module.Free.of_divisionRing ℝ P.space
  exact (Module.finBasis ℝ P.space).reindex
    (finCongr P.finrank_eq_four)

/-- A selected rank-four sector has at least one frame, without selecting a
preferred frame as mathematical data. -/
theorem sectorFrame_nonempty
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) : Nonempty (SectorFrame P) :=
  ⟨someSectorFrame P⟩

/-- On a carrier larger than five events, every selected rank-four sector is
a proper subspace of the full zero-sum carrier space. -/
theorem space_ne_top_of_five_lt_card
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (hcard : 5 < Fintype.card (ClosedCarrier A)) :
    P.space ≠ ⊤ := by
  intro htop
  have hrank : Module.finrank ℝ (carrierProbeSubspace A) = 4 := by
    have htopRank := congrArg
      (fun S : Submodule ℝ (carrierProbeSubspace A) =>
        Module.finrank ℝ S) htop
    change Module.finrank ℝ P.space =
      Module.finrank ℝ
        (⊤ : Submodule ℝ (carrierProbeSubspace A)) at htopRank
    rw [finrank_top] at htopRank
    exact htopRank.symm.trans P.finrank_eq_four
  have hfive := fullCarrierProbe_finrank_four_forces_card_five A hrank
  omega

/-! ## Restricted pairing, Gram congruence, and Lorentz gauge -/

/-- Restriction of the active corrected carrier pairing to a selected
rank-four sector. -/
def sectorBilinForm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    LinearMap.BilinForm ℝ P.space :=
  (carrierProbeBilinForm A ell nonlocalityScale x).comp
    P.space.subtype P.space.subtype

/-- The restricted bilinear form evaluates as the original carrier pairing
on the included probe vectors. -/
@[simp] theorem sectorBilinForm_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : P.space) :
    sectorBilinForm A P ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x f.1 h.1 := by
  simp [sectorBilinForm]

/-- Matrix of the selected-sector pairing in one gauge-relative frame. -/
def sectorGram
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Matrix (Fin 4) (Fin 4) ℝ :=
  LinearMap.BilinForm.toMatrix b
    (sectorBilinForm A P ell nonlocalityScale x)

/-- Entries of the selected-sector Gram matrix are the original corrected
pairings of the included probe vectors. -/
theorem sectorGram_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) (i j : Fin 4) :
    sectorGram A P ell nonlocalityScale x b i j =
      carrierProbePairing A ell nonlocalityScale x (b i).1 (b j).1 := by
  simp [sectorGram]

/-- Exact Gram congruence for two frames of the same selected sector. -/
theorem sectorGram_change
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : SectorFrame P) :
    (b.toMatrix c)ᵀ * sectorGram A P ell nonlocalityScale x b *
        b.toMatrix c =
      sectorGram A P ell nonlocalityScale x c := by
  exact LinearMap.BilinForm.toMatrix_mul_basis_toMatrix (b := b) c
    (sectorBilinForm A P ell nonlocalityScale x)

/-- A selected-sector frame is Lorentz-normalized when its Gram matrix is the
project's mostly-minus Minkowski matrix. -/
def IsSectorLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Prop :=
  sectorGram A P ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Corrected Lorentzian-inertia gate on a selected rank-four sector. -/
def HasSectorLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : SectorFrame P,
    IsSectorLorentzNormalized A P ell nonlocalityScale x b

/-- Conditional recovery of the Lorentz gauge group on the corrected
selected-sector interface. -/
theorem isSectorLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : SectorFrame P)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale x b) :
    IsSectorLorentzNormalized A P ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsSectorLorentzNormalized at hb ⊢
  rw [← sectorGram_change A P ell nonlocalityScale x b c, hb]

/-! ## Exact transport under causal-order isomorphism -/

/-- Transport a selected rank-four sector by the intrinsic carrier
relabeling equivalence. -/
def RankFourCarrierProbeSector.mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    {A : MarkedDiamond C} (P : RankFourCarrierProbeSector A)
    (e : OrderIso C D) :
    RankFourCarrierProbeSector (A.map e) where
  space := P.space.map (carrierProbeLinearEquiv e A).toLinearMap
  finrank_eq_four := by
    rw [LinearEquiv.finrank_map_eq]
    exact P.finrank_eq_four

/-- Relabeling restricts to a linear equivalence from a selected sector to
its transported image. -/
def sectorMapLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) :
    P.space ≃ₗ[ℝ] (P.mapOrderIso e).space :=
  (carrierProbeLinearEquiv e A).submoduleMap P.space

/-- Push a selected-sector frame along an ambient order isomorphism. -/
def mapSectorFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) :
    SectorFrame (P.mapOrderIso e) :=
  b.map (sectorMapLinearEquiv e A P)

/-- The included value of a transported frame vector is the intrinsic
relabeling of the included source vector. -/
@[simp] theorem mapSectorFrame_apply_coe
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) (i : Fin 4) :
    ((mapSectorFrame e A P b i).1 : carrierProbeSubspace (A.map e)) =
      carrierProbeLinearEquiv e A (b i).1 :=
  rfl

/-- Transport of a selected sector and frame leaves the corrected Gram matrix
exactly unchanged. -/
theorem sectorGram_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) :
    sectorGram (A.map e) (P.mapOrderIso e) ell nonlocalityScale
        (closedCarrierEquiv e A x) (mapSectorFrame e A P b) =
      sectorGram A P ell nonlocalityScale x b := by
  ext i j
  rw [sectorGram_apply, sectorGram_apply]
  simp only [mapSectorFrame_apply_coe]
  exact carrierProbePairing_equivariant e A ell nonlocalityScale x
    (b i).1 (b j).1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.carrierProbeFrame_forces_card_five' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.carrierProbeFrame_forces_card_five

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_change

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.isSectorLorentzNormalized_change_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.isSectorLorentzNormalized_change_iff

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_mapOrderIso' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_mapOrderIso

end PhysicsSM.Draft.NullEdge.RankFourProbeSector

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
