import PhysicsSM.Draft.NullEdge.CausalOperatorMetric

/-!
# Finite causal-order construction of the scalar metric operator

This module closes one finite boundary in the operator-first GR program: the
operator is constructed from a strict finite causal order and open-interval
cardinalities instead of being supplied as an arbitrary map.

For a finite order `C`, `openIntervalCount C y x` counts events strictly
between `y` and `x`. The generic `layeredOperator` weights every causal
predecessor by a function of this count. Its four-dimensional local and
smeared specializations implement the Benincasa-Dowker coefficients. The
source-sign operator is the Benincasa-Dowker `(-+++)` formula. At the purely
algebraic level, each project-facing operator is defined to be its exact
negative, encoding the intended overall wave-operator sign change for the
project `(+---)` convention. No metric, curvature-sign convention, or
continuum-limit identification is proved here.

Every construction is equivariant under an isomorphism of finite causal
orders, at fixed numerical scales and with scalar fields transported by the
carrier equivalence. This proves invariance under event relabeling that
preserves the order relation. The definitions take no embedding argument, but
the covariance theorems do not compare embeddings or transport scale
assignments, probe-selection rules, a manifold embedding, a tetrad, or a spin
structure. The local normalization also has exact inverse-length-squared
scaling under the stated nonzero algebraic hypotheses; physical scale choices
remain additional positive inputs.

The final section lifts the corrected principal-symbol pairing to actual
finite scalar fields. This is the application-level counterpart of the
pointwise scalar algebra in `CausalOperatorMetric`. At a common probe zero it
also identifies twice the pairing with the operator response on the probe
product, the exact algebraic anchor for quadratic-moment normalization.

Scope boundary: the order, dimension-four kernel, positive scales, scalar
fields, and probe fields remain inputs. This file does not derive a
manifoldlike phase, density, a scale-selection rule, compact probes, rank,
signature, volume agreement, or continuum convergence.

Provenance: clean-room formalization of equations (2), (8), and (9) of
D. M. T. Benincasa and F. Dowker, arXiv:1001.2725, with the continuum
convention cross-check from A. Belenchia, D. M. T. Benincasa, and F. Dowker,
arXiv:1510.04656. Claim grade: `M [comp]` for the finite algebra and
covariance; continuum reconstruction remains conjectural and separately
gated.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-! ## Finite strict causal orders and their intervals -/

/-- A finite strict causal order. Irreflexivity and transitivity exclude
directed causal cycles. -/
structure FiniteCausalOrder (V : Type*) [Fintype V] where
  before : V -> V -> Prop
  decidableBefore : DecidableRel before
  irrefl : forall x, ¬ before x x
  trans : forall {x y z}, before x y -> before y z -> before x z

instance {V : Type*} [Fintype V] (C : FiniteCausalOrder V) :
    DecidableRel C.before :=
  C.decidableBefore

variable {V W : Type*} [Fintype V] [Fintype W]

/-- The subtype of events strictly between `y` and `x`. -/
def FiniteCausalOrder.OpenInterval
    (C : FiniteCausalOrder V) (y x : V) :=
  {z : V // C.before y z ∧ C.before z x}

instance (C : FiniteCausalOrder V) (y x : V) :
    Fintype (C.OpenInterval y x) := by
  unfold FiniteCausalOrder.OpenInterval
  infer_instance

/-- Number of events in the strict open interval from `y` to `x`. -/
def FiniteCausalOrder.openIntervalCount
    (C : FiniteCausalOrder V) (y x : V) : Nat :=
  Fintype.card (C.OpenInterval y x)

/-- The `n`th past layer of `x`: predecessors with exactly `n` intervening
events. -/
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- An isomorphism of finite causal orders. -/
structure OrderIso (C : FiniteCausalOrder V) (D : FiniteCausalOrder W) where
  toEquiv : V ≃ W
  map_before_iff : forall x y,
    D.before (toEquiv x) (toEquiv y) ↔ C.before x y

/-- An order isomorphism induces an equivalence of every open interval. -/
def OrderIso.openIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    C.OpenInterval y x ≃
      D.OpenInterval (e.toEquiv y) (e.toEquiv x) where
  toFun z := ⟨e.toEquiv z.1,
    (e.map_before_iff y z.1).2 z.property.1,
    (e.map_before_iff z.1 x).2 z.property.2⟩
  invFun z := ⟨e.toEquiv.symm z.1,
    (e.map_before_iff y (e.toEquiv.symm z.1)).1
      (by simpa using z.property.1),
    (e.map_before_iff (e.toEquiv.symm z.1) x).1
      (by simpa using z.property.2)⟩
  left_inv z := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    D.openIntervalCount (e.toEquiv y) (e.toEquiv x) =
      C.openIntervalCount y x := by
  exact (Fintype.card_congr (e.openIntervalEquiv y x)).symm

/-- Relabel a scalar field along an order isomorphism. -/
def OrderIso.relabelField
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) : W -> K :=
  fun w => phi (e.toEquiv.symm w)

@[simp] theorem OrderIso.relabelField_apply
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) (x : V) :
    e.relabelField phi (e.toEquiv x) = phi x := by
  simp [OrderIso.relabelField]

/-! ## Layered order/count operators -/

/-- Weighted sum over all strict causal predecessors. The weight may depend
only on the open-interval count. -/
def FiniteCausalOrder.layeredPastSum
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (coefficient : Nat -> K) (phi : V -> K) (x : V) : K :=
  ∑ y : V, if C.before y x then
    coefficient (C.openIntervalCount y x) * phi y else 0

/-- A normalized diagonal-plus-past layered operator. -/
def FiniteCausalOrder.layeredOperator
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) : K :=
  prefactor * (diagonal * phi x + C.layeredPastSum coefficient phi x)

/-- The weighted past sum commutes with every order isomorphism. -/
theorem OrderIso.layeredPastSum_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} [Semiring K]
    (coefficient : Nat -> K) (phi : V -> K) (x : V) :
    D.layeredPastSum coefficient (e.relabelField phi) (e.toEquiv x) =
      C.layeredPastSum coefficient phi x := by
  unfold FiniteCausalOrder.layeredPastSum
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro y
  by_cases hbefore : C.before y x
  · have hmap : D.before (e.toEquiv y) (e.toEquiv x) :=
      (e.map_before_iff y x).2 hbefore
    simp [hbefore, hmap, e.openIntervalCount_eq]
  · have hmap : ¬ D.before (e.toEquiv y) (e.toEquiv x) :=
      fun h => hbefore ((e.map_before_iff y x).1 h)
    simp [hbefore, hmap]

/-- Every layered operator commutes with order isomorphisms. -/
theorem OrderIso.layeredOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} [Semiring K]
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) :
    D.layeredOperator prefactor diagonal coefficient
        (e.relabelField phi) (e.toEquiv x) =
      C.layeredOperator prefactor diagonal coefficient phi x := by
  unfold FiniteCausalOrder.layeredOperator
  rw [e.layeredPastSum_equivariant]
  simp

/-! ## Four-dimensional Benincasa-Dowker specializations -/

/-- Source-native local four-dimensional layer coefficients, indexed by open
interval cardinality. -/
def sourceLocal4DCoefficient : Nat -> Real
  | 0 => 1
  | 1 => -9
  | 2 => 16
  | 3 => -8
  | _ => 0

/-- Source-native four-dimensional normalization. -/
def sourceLocal4DPrefactor (ell : Real) : Real :=
  4 / (Real.sqrt 6 * ell ^ 2)

/-- Local source-native four-dimensional causal-set d'Alembertian. -/
def sourceLocal4DOperator
    (C : FiniteCausalOrder V) (ell : Real)
    (phi : V -> Real) (x : V) : Real :=
  C.layeredOperator (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient phi x

/-- Project `(+---)` local operator, obtained by negating the source-native
`(-+++)` operator. -/
def projectLocal4DOperator
    (C : FiniteCausalOrder V) (ell : Real)
    (phi : V -> Real) (x : V) : Real :=
  -sourceLocal4DOperator C ell phi x

/-- Mesoscopic smearing ratio `epsilon = (ell / L)^4`. -/
def smearingEpsilon (ell nonlocalityScale : Real) : Real :=
  (ell / nonlocalityScale) ^ 4

/-- Broad-layer kernel from source equation (9). -/
def sourceSmearedKernel (epsilon : Real) (n : Nat) : Real :=
  let nr : Real := n
  (1 - epsilon) ^ n *
    (1 - 9 * epsilon * nr / (1 - epsilon) +
      8 * epsilon ^ 2 * nr * (nr - 1) / (1 - epsilon) ^ 2 -
      (4 / 3) * epsilon ^ 3 * nr * (nr - 1) * (nr - 2) /
        (1 - epsilon) ^ 3)

/-- Full source-native broad-layer weight, including the leading `epsilon`. -/
def sourceSmeared4DCoefficient (epsilon : Real) (n : Nat) : Real :=
  epsilon * sourceSmearedKernel epsilon n

/-- Smeared source-native operator. The explicit branch at `epsilon = 1`
records the source statement that the smeared operator reduces to the local
one, avoiding a spurious totalized-division value in equation (9). -/
def sourceSmeared4DOperator
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) : Real :=
  let epsilon := smearingEpsilon ell nonlocalityScale
  if epsilon = 1 then sourceLocal4DOperator C ell phi x
  else C.layeredOperator
    (4 / (Real.sqrt 6 * nonlocalityScale ^ 2)) (-1)
    (sourceSmeared4DCoefficient epsilon) phi x

/-- Project `(+---)` smeared operator. -/
def projectSmeared4DOperator
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) : Real :=
  -sourceSmeared4DOperator C ell nonlocalityScale phi x

/-- The source-native local operator is intrinsic under order relabeling. -/
theorem OrderIso.sourceLocal4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (phi : V -> Real) (x : V) :
    sourceLocal4DOperator D ell (e.relabelField phi) (e.toEquiv x) =
      sourceLocal4DOperator C ell phi x := by
  exact e.layeredOperator_equivariant _ _ _ _ _

/-- The project-sign local operator is intrinsic under order relabeling. -/
theorem OrderIso.projectLocal4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (phi : V -> Real) (x : V) :
    projectLocal4DOperator D ell (e.relabelField phi) (e.toEquiv x) =
      projectLocal4DOperator C ell phi x := by
  unfold projectLocal4DOperator
  rw [e.sourceLocal4DOperator_equivariant]

/-- The source-native smeared operator is intrinsic under order relabeling. -/
theorem OrderIso.sourceSmeared4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) :
    sourceSmeared4DOperator D ell nonlocalityScale
        (e.relabelField phi) (e.toEquiv x) =
      sourceSmeared4DOperator C ell nonlocalityScale phi x := by
  simp only [sourceSmeared4DOperator]
  by_cases hepsilon : smearingEpsilon ell nonlocalityScale = 1
  · simp only [hepsilon, if_true]
    exact e.sourceLocal4DOperator_equivariant ell phi x
  · simp only [hepsilon, if_false]
    exact e.layeredOperator_equivariant _ _ _ _ _

/-- The project-sign smeared operator is intrinsic under order relabeling. -/
theorem OrderIso.projectSmeared4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) :
    projectSmeared4DOperator D ell nonlocalityScale
        (e.relabelField phi) (e.toEquiv x) =
      projectSmeared4DOperator C ell nonlocalityScale phi x := by
  unfold projectSmeared4DOperator
  rw [e.sourceSmeared4DOperator_equivariant]

/-- Equal nonzero discreteness and nonlocality scales reduce the smeared
operator exactly to the local operator. -/
theorem sourceSmeared4DOperator_same_scale
    (C : FiniteCausalOrder V) (ell : Real) (hell : ell ≠ 0)
    (phi : V -> Real) (x : V) :
    sourceSmeared4DOperator C ell ell phi x =
      sourceLocal4DOperator C ell phi x := by
  have hepsilon : smearingEpsilon ell ell = 1 := by
    simp [smearingEpsilon, hell]
  simp [sourceSmeared4DOperator, hepsilon]

/-- The local prefactor has exact inverse-square scale weight. -/
theorem sourceLocal4DPrefactor_scale
    (lambda ell : Real) (hlambda : lambda ≠ 0) (hell : ell ≠ 0) :
    sourceLocal4DPrefactor (lambda * ell) =
      (lambda ^ 2)⁻¹ * sourceLocal4DPrefactor ell := by
  have hsqrt : Real.sqrt 6 ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 (by norm_num))
  unfold sourceLocal4DPrefactor
  field_simp [hlambda, hell, hsqrt]

/-- The local source operator inherits inverse-square scale weight. -/
theorem sourceLocal4DOperator_scale
    (C : FiniteCausalOrder V) (lambda ell : Real)
    (hlambda : lambda ≠ 0) (hell : ell ≠ 0)
    (phi : V -> Real) (x : V) :
    sourceLocal4DOperator C (lambda * ell) phi x =
      (lambda ^ 2)⁻¹ * sourceLocal4DOperator C ell phi x := by
  unfold sourceLocal4DOperator FiniteCausalOrder.layeredOperator
  rw [sourceLocal4DPrefactor_scale lambda ell hlambda hell]
  ring

/-! ## Corrected principal-symbol pairing on finite scalar fields -/

/-- Corrected pairing evaluated at one event for an operator on finite scalar
fields. Pointwise multiplication is the probe-algebra product. -/
def correctedPairingAt
    (B : (V -> Real) -> V -> Real) (x : V)
    (f h : V -> Real) : Real :=
  (2 : Real)⁻¹ *
    (B (f * h) x - f x * B h x - h x * B f x +
      f x * h x * B 1 x)

/-- Add a pointwise scalar potential to a finite scalar-field operator. -/
def addScalarPotentialField
    (B : (V -> Real) -> V -> Real) (potential : V -> Real) :
    (V -> Real) -> V -> Real :=
  fun f x => B f x + potential x * f x

omit [Fintype V] in
/-- The corrected finite-field pairing is symmetric for every operator. -/
theorem correctedPairingAt_comm
    (B : (V -> Real) -> V -> Real) (x : V) (f h : V -> Real) :
    correctedPairingAt B x f h = correctedPairingAt B x h f := by
  unfold correctedPairingAt
  rw [mul_comm f h]
  ring

omit [Fintype V] in
/-- At a common zero of two probes, twice the corrected pairing is exactly the
operator response on their pointwise product. This is the finite algebra behind
quadratic-moment normalization; obtaining a geometric normalization still
requires a justified probe and a convergent operator response. -/
theorem operator_mul_eq_two_correctedPairingAt_of_centered
    (B : (V -> Real) -> V -> Real) (x : V) (f h : V -> Real)
    (hf : f x = 0) (hh : h x = 0) :
    B (f * h) x = 2 * correctedPairingAt B x f h := by
  unfold correctedPairingAt
  simp only [hf, hh, zero_mul, mul_zero, sub_zero]
  ring

omit [Fintype V] in
/-- Pointwise scalar potentials cancel exactly from the finite-field pairing. -/
theorem correctedPairingAt_addScalarPotentialField
    (B : (V -> Real) -> V -> Real) (potential : V -> Real)
    (x : V) (f h : V -> Real) :
    correctedPairingAt (addScalarPotentialField B potential) x f h =
      correctedPairingAt B x f h := by
  unfold correctedPairingAt addScalarPotentialField
  simp only [Pi.mul_apply, Pi.one_apply]
  ring

/-- Any finite scalar-field operator that commutes with an order isomorphism
has an intrinsic corrected pairing under simultaneous relabeling of the event
and both probes. -/
theorem OrderIso.correctedPairingAt_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D)
    (operatorC : (V -> Real) -> V -> Real)
    (operatorD : (W -> Real) -> W -> Real)
    (hoperator : forall phi x,
      operatorD (e.relabelField phi) (e.toEquiv x) = operatorC phi x)
    (x : V) (f h : V -> Real) :
    correctedPairingAt operatorD (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt operatorC x f h := by
  have hmul :
      e.relabelField f * e.relabelField h = e.relabelField (f * h) := by
    rfl
  have hone : (1 : W -> Real) = e.relabelField (1 : V -> Real) := by
    funext w
    simp [OrderIso.relabelField]
  unfold correctedPairingAt
  rw [hmul, hoperator]
  rw [hoperator]
  rw [hoperator]
  rw [hone, hoperator]
  simp

/-- The corrected pairing built from the project local operator is intrinsic
under simultaneous relabeling of order, event, and probes. -/
theorem OrderIso.correctedPairingAt_projectLocal4D_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (x : V) (f h : V -> Real) :
    correctedPairingAt (projectLocal4DOperator D ell) (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt (projectLocal4DOperator C ell) x f h := by
  apply e.correctedPairingAt_equivariant
  intro phi y
  exact e.projectLocal4DOperator_equivariant ell phi y

/-- The corrected pairing built from the project smeared operator is intrinsic
under simultaneous relabeling of order, event, and probes. -/
theorem OrderIso.correctedPairingAt_projectSmeared4D_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (x : V) (f h : V -> Real) :
    correctedPairingAt
        (projectSmeared4DOperator D ell nonlocalityScale) (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt
        (projectSmeared4DOperator C ell nonlocalityScale) x f h := by
  apply e.correctedPairingAt_equivariant
  intro phi y
  exact e.projectSmeared4DOperator_equivariant
    ell nonlocalityScale phi y

/-! ## Intrinsic probes and varying-carrier convergence -/

/-- A finite probe family selected naturally from the order under every order
isomorphism. This interface certifies label independence only; it does not say
that the probes are slowly varying, coordinate-like, independent, or
geometrically complete. -/
structure IntrinsicProbeSector (r : Nat) where
  probe : forall {U : Type} [Fintype U],
    FiniteCausalOrder U -> Fin r -> U -> Real
  equivariant : forall {U Z : Type} [Fintype U] [Fintype Z]
    {C : FiniteCausalOrder U} {D : FiniteCausalOrder Z}
    (e : OrderIso C D) (a : Fin r),
    e.relabelField (K := Real) (@probe U _ C a) = @probe Z _ D a

/-- A finite causal order is automorphism-transitive when every event can be
carried to every other event by an order automorphism. -/
def FiniteCausalOrder.AutomorphismTransitive
    (C : FiniteCausalOrder V) : Prop :=
  forall x y, exists e : OrderIso C C, e.toEquiv x = y

/-- Every individually natural probe is fixed pointwise along each order-
automorphism orbit. This is the finite obstruction to treating a canonical
probe list as a gauge-relative frame. -/
theorem IntrinsicProbeSector.probe_orderAutomorphism_invariant
    {r : Nat} (P : IntrinsicProbeSector r)
    {U : Type} [Fintype U]
    (C : FiniteCausalOrder U) (e : OrderIso C C)
    (a : Fin r) (x : U) :
    P.probe C a (e.toEquiv x) = P.probe C a x := by
  have h := congrFun (P.equivariant e a) (e.toEquiv x)
  simpa [OrderIso.relabelField] using h.symm

/-- On an automorphism-transitive order, every probe in an individually
natural probe family is constant. A physical probe sector on symmetric orders
must therefore be transported as a subspace up to basis change, rather than as
a pointwise-fixed ordered basis. -/
theorem IntrinsicProbeSector.probe_constant_of_automorphismTransitive
    {r : Nat} (P : IntrinsicProbeSector r)
    {U : Type} [Fintype U]
    (C : FiniteCausalOrder U) (htrans : C.AutomorphismTransitive)
    (a : Fin r) (x y : U) :
    P.probe C a x = P.probe C a y := by
  obtain ⟨e, he⟩ := htrans x y
  simpa [he] using
    (P.probe_orderAutomorphism_invariant C e a x).symm

/-- The two-event antichain is a concrete symmetric strict causal order. -/
def twoEventAntichain : FiniteCausalOrder (Fin 2) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the two-event antichain lies in one order-automorphism
orbit. This witnesses that the symmetry hypothesis in the probe no-go is
nonvacuous. -/
theorem twoEventAntichain_automorphismTransitive :
    twoEventAntichain.AutomorphismTransitive := by
  intro x y
  let swap : Fin 2 ≃ Fin 2 := Equiv.swap x y
  refine ⟨{
    toEquiv := swap
    map_before_iff := ?_
  }, ?_⟩
  · intro a b
    simp [twoEventAntichain]
  · simp [swap]

/-- Individually natural probes cannot distinguish the two distinct events of
the symmetric antichain. -/
theorem IntrinsicProbeSector.twoEventAntichain_probe_eq
    {r : Nat} (P : IntrinsicProbeSector r) (a : Fin r) :
    P.probe twoEventAntichain a 0 = P.probe twoEventAntichain a 1 := by
  exact P.probe_constant_of_automorphismTransitive
    twoEventAntichain twoEventAntichain_automorphismTransitive a 0 1

open Filter in
/-- Four-evaluation convergence for intrinsically selected probes on varying
finite carriers. The limit is constructed from the six displayed scalar
limits; no metric, product rule, rank, signature, or convergence premise is
hidden in the conclusion. -/
theorem tendsto_intrinsicProbePairing_projectSmeared4D
    {I : Type*} {l : Filter I} {r : Nat}
    {U : I -> Type} [forall i, Fintype (U i)]
    (C : forall i, FiniteCausalOrder (U i))
    (P : IntrinsicProbeSector r) (a b : Fin r)
    (ell nonlocalityScale : I -> Real) (x : forall i, U i)
    (f0 h0 qProd qRight qLeft qOne : Real)
    (hf : Tendsto (fun i => P.probe (C i) a (x i)) l (nhds f0))
    (hh : Tendsto (fun i => P.probe (C i) b (x i)) l (nhds h0))
    (hProd : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) a * P.probe (C i) b) (x i)) l (nhds qProd))
    (hRight : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) b) (x i)) l (nhds qRight))
    (hLeft : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) a) (x i)) l (nhds qLeft))
    (hOne : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        1 (x i)) l (nhds qOne)) :
    Tendsto (fun i => correctedPairingAt
        (projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i))
        (x i) (P.probe (C i) a) (P.probe (C i) b)) l
      (nhds ((2 : Real)⁻¹ *
        (qProd - f0 * qRight - h0 * qLeft + f0 * h0 * qOne))) := by
  have hFRight := hf.mul hRight
  have hHLeft := hh.mul hLeft
  have hFHOne := (hf.mul hh).mul hOne
  have hBracket := ((hProd.sub hFRight).sub hHLeft).add hFHOne
  have hHalf :
      Tendsto (fun _ : I => (2 : Real)⁻¹) l (nhds (2 : Real)⁻¹) :=
    tendsto_const_nhds
  simpa only [correctedPairingAt, Pi.mul_apply, Pi.one_apply] using
    hHalf.mul hBracket

/-! ## Non-vacuity controls -/

/-- The strict order on two events is a concrete finite causal order. -/
def twoEventOrder : FiniteCausalOrder (Fin 2) where
  before := fun x y => x < y
  decidableBefore := inferInstance
  irrefl := fun x => lt_irrefl x
  trans := fun hxy hyz => lt_trans hxy hyz

/-- The unique causal link in the two-event order has an empty open interval. -/
theorem twoEvent_openIntervalCount :
    twoEventOrder.openIntervalCount 0 1 = 0 := by
  decide

/-- Scalar field supported on the first event of the two-event order. -/
def twoEventLinkedField : Fin 2 -> Real :=
  fun x => if x = 0 then 1 else 0

/-- The linked predecessor contributes exactly the first source layer
coefficient. This is a nonzero order/count witness for the operator kernel. -/
theorem twoEvent_layeredPastSum_witness :
    twoEventOrder.layeredPastSum sourceLocal4DCoefficient
      twoEventLinkedField 1 = 1 := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [Fin.sum_univ_two, twoEvent_openIntervalCount]
  norm_num [twoEventOrder, twoEventLinkedField,
    sourceLocal4DCoefficient]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.openIntervalCount_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.openIntervalCount_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.projectSmeared4DOperator_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.projectSmeared4DOperator_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.sourceLocal4DOperator_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sourceLocal4DOperator_scale

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.twoEvent_layeredPastSum_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms twoEvent_layeredPastSum_witness

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.correctedPairingAt_projectSmeared4D_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.correctedPairingAt_projectSmeared4D_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.operator_mul_eq_two_correctedPairingAt_of_centered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms operator_mul_eq_two_correctedPairingAt_of_centered

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.tendsto_intrinsicProbePairing_projectSmeared4D' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tendsto_intrinsicProbePairing_projectSmeared4D

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.IntrinsicProbeSector.probe_constant_of_automorphismTransitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IntrinsicProbeSector.probe_constant_of_automorphismTransitive

end PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
