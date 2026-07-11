# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-11T13:37:37`
- Finished: `2026-07-11T13:37:46`
- Timeout seconds: `900`
- Max budget USD: `1.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 1.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write Bash' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
HOSTILE SEMANTIC AUDIT. Context: Paper F classifies a concrete three-dimensional Ward charge model. Intended new claim: for charge-commuting maps preserving a supplied odd-odd-even grading, physical-line compression plus the ordered two-dimensional null-frame block is a complete literal invariant. The inherited imaginary shear is nonidentity, a Ward automorphism, physically identical and constraint-homotopy equivalent to identity, yet changes the retained frame block; therefore physical compression ceases to be complete after retaining this supplied grading/frame decoration. Audit the verbatim Lean for mathematical shape, vacuity, hidden assumptions, false physical language, hollow repackaging, and whether the witness actually proves the obstruction. Explicitly distinguish a meaningful finite decorated theorem from a full graph-derived locality/soldering/gauge classification. Return PASS/PASS WITH REQUIRED EDITS/FAIL, issue severities, exact replacement prose, and the next nontrivial theorem. Do not edit files.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/Carrier/WardGradedFrameDecoration.lean (149 lines)

```lean
import PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization

/-!
# A graded null-frame decoration refines the finite Ward quotient

Physical-line compression completely classifies charge-commuting maps modulo
constraint homotopy in `WardQuotientFactorization`. This module retains two
additional pieces of the same finite carrier: the grading separating the
two-dimensional constraint block from the physical line, and the induced
action on a fixed null-frame block.

For grading-preserving charge-commuting maps, the physical-line action together
with the null-frame block is a complete literal invariant. The existing
imaginary shear gives the obstruction: it is a nonidentity Ward automorphism,
acts identically on the physical line, and is constraint-exact relative to the
identity, but changes the retained null-frame action.

Scope: this is an exact finite decorated-Ward theorem. The null frame is
supplied, not derived from graph locality or continuum soldering, and the
result does not classify full decorated null-edge carriers.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration

open WardAutomorphismQuotient WardQuotientFactorization

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- The two constraint directions are odd and the surviving physical line is
even. -/
def grading : Mat3 := !![-1, 0, 0; 0, -1, 0; 0, 0, 1]

/-- Inclusion of the ordered two-vector null frame. -/
def nullI : Matrix (Fin 3) (Fin 2) Complex := !![1, 0; 0, 1; 0, 0]

/-- Projection onto the ordered two-vector null frame. -/
def nullP : Matrix (Fin 2) (Fin 3) Complex := !![1, 0, 0; 0, 1, 0]

/-- Preservation of the supplied constraint/physical grading. -/
def PreservesGrading (U : Mat3) : Prop := U * grading = grading * U

/-- The action retained on the ordered null frame. -/
def nullFrameAction (U : Mat3) : Matrix (Fin 2) (Fin 2) Complex :=
  nullP * U * nullI

/-- The decorated observable retains both physical-line action and null-frame
action. -/
def decoratedAction (U : Mat3) :=
  (physP * U * physI, nullFrameAction U)

/-- Inside the charge-commuting Ward family, grading preservation removes
exactly the two off-block coordinates. -/
theorem wardFamily_preservesGrading_iff (a b c d e : Complex) :
    PreservesGrading (wardFamily a b c d e) ↔ c = 0 ∧ d = 0 := by
  constructor
  · intro h
    have h02 := congrFun (congrFun h (0 : Fin 3)) (2 : Fin 3)
    have h21 := congrFun (congrFun h (2 : Fin 3)) (1 : Fin 3)
    constructor
    · simp [PreservesGrading, grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ] at h02
      linear_combination (1 / 2 : Complex) * h02
    · simp [PreservesGrading, grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ] at h21
      linear_combination (-1 / 2 : Complex) * h21
  · rintro ⟨rfl, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PreservesGrading, grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ]

/-- Exact null-frame block of a grading-preserving Ward-family element. -/
theorem nullFrameAction_family (a b e : Complex) :
    nullFrameAction (wardFamily a b 0 0 e) = !![a, b; 0, a] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullFrameAction, nullP, nullI, wardFamily, Matrix.mul_apply,
      Fin.sum_univ_succ]

@[simp] theorem nullFrameAction_one : nullFrameAction (1 : Mat3) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullFrameAction, nullP, nullI, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- Physical-line plus null-frame action is a complete literal invariant of
grading-preserving charge-commuting maps. -/
theorem eq_iff_same_decoratedAction_of_graded_chain
    (U V : Mat3)
    (hUQ : U * Q = Q * U) (hVQ : V * Q = Q * V)
    (hUG : PreservesGrading U) (hVG : PreservesGrading V) :
    U = V ↔ decoratedAction U = decoratedAction V := by
  constructor
  · exact fun h => congrArg decoratedAction h
  · intro hdec
    obtain ⟨a, b, c, d, e, rfl⟩ := (commutes_Q_iff_family U).1 hUQ
    obtain ⟨a', b', c', d', e', rfl⟩ := (commutes_Q_iff_family V).1 hVQ
    rw [wardFamily_preservesGrading_iff] at hUG hVG
    rcases hUG with ⟨rfl, rfl⟩
    rcases hVG with ⟨rfl, rfl⟩
    have hphys := congrArg Prod.fst hdec
    have hnull := congrArg Prod.snd hdec
    change physP * wardFamily a b 0 0 e * physI =
      physP * wardFamily a' b' 0 0 e' * physI at hphys
    change nullFrameAction (wardFamily a b 0 0 e) =
      nullFrameAction (wardFamily a' b' 0 0 e') at hnull
    rw [physical_compression_family, physical_compression_family] at hphys
    rw [nullFrameAction_family, nullFrameAction_family] at hnull
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [wardFamily] at hphys hnull ⊢ <;>
      grind

/-- The inherited imaginary shear is invisible on the physical line and
constraint-exact, but the retained null frame detects it. -/
theorem exact_shear_changes_nullFrame :
    let U := wardFamily 1 Complex.I 0 0 1
    IsWardAutomorphism U ∧ PreservesGrading U ∧
      WardExactEquivalent U 1 ∧
      physP * U * physI = physP * (1 : Mat3) * physI ∧
      nullFrameAction U ≠ nullFrameAction 1 := by
  let U := wardFamily 1 Complex.I 0 0 1
  rcases nontrivial_exact_class_witness with ⟨hAuto, _, hExact⟩
  refine ⟨hAuto, ?_, hExact, ?_, ?_⟩
  · exact (wardFamily_preservesGrading_iff 1 Complex.I 0 0 1).2 ⟨rfl, rfl⟩
  · rw [physical_compression_family]
    ext i j
    fin_cases i
    fin_cases j
    simp [physP, physI, Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    rw [nullFrameAction_family, nullFrameAction_one] at h
    have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
    norm_num at h01

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.eq_iff_same_decoratedAction_of_graded_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eq_iff_same_decoratedAction_of_graded_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.exact_shear_changes_nullFrame' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_shear_changes_nullFrame

end PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration

```

### PhysicsSM/Draft/NullEdge/Carrier/WardQuotientFactorization.lean (162 lines)

```lean
import PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient
import PhysicsSM.Draft.NullEdge.Carrier.WardPhysicalCohomology

/-!
# Physical quotient factorization for the finite Ward automorphisms

The two existing Ward modules describe the same three-dimensional constraint
model from complementary directions: one classifies Krein-form-preserving
charge automorphisms, while the other identifies zero physical action with
constraint homotopy. This module composes them.

For Ward automorphisms `U` and `V`, equality of their induced actions on the
surviving physical line is equivalent to the exact relation
`U - V = Q H + H Q`. Thus the physical-line action is a complete invariant of
the finite Ward quotient.

Scope: this is the concrete finite Ward witness. It does not construct the
constraint, contraction, locality, gauge action, or automorphism group of the
full decorated null-edge carrier.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- The charge matrices used by the automorphism and cohomology modules agree
entrywise. -/
theorem charge_agrees : WardAutomorphismQuotient.Q = KugoOjima.Qmat := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.Q, KugoOjima.Qmat]

/-- The physical inclusions used by the two Ward modules agree entrywise. -/
theorem physical_inclusion_agrees :
    WardAutomorphismQuotient.physI = WardPhysicalCohomology.wardPhysI := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.physI, WardPhysicalCohomology.wardPhysI]

/-- The physical projections used by the two Ward modules agree entrywise. -/
theorem physical_projection_agrees :
    WardAutomorphismQuotient.physP = WardPhysicalCohomology.wardPhysP := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.physP, WardPhysicalCohomology.wardPhysP]

/-- Constraint-homotopy equivalence on the concrete Ward endomorphisms. -/
def WardExactEquivalent (U V : Mat3) : Prop :=
  Exists fun H : Mat3 =>
    U - V = WardAutomorphismQuotient.Q * H + H * WardAutomorphismQuotient.Q

/-- Equality of physical-line actions is exactly constraint-homotopy
equivalence for all charge-commuting chain maps. Krein preservation and
invertibility are not needed for this quotient calculation. -/
theorem exactEquivalent_iff_same_physical_action_of_chain
    (U V : Mat3)
    (hU : U * WardAutomorphismQuotient.Q = WardAutomorphismQuotient.Q * U)
    (hV : V * WardAutomorphismQuotient.Q = WardAutomorphismQuotient.Q * V) :
    WardExactEquivalent U V <->
      WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * V * WardAutomorphismQuotient.physI := by
  have hchain : (U - V) * KugoOjima.Qmat = KugoOjima.Qmat * (U - V) := by
    rw [← charge_agrees]
    simp only [sub_mul, mul_sub]
    rw [hU, hV]
  have hzero := WardPhysicalCohomology.ward_zero_physical_iff_nullHomotopic
    (U - V) hchain
  rw [← physical_projection_agrees, ← physical_inclusion_agrees,
    ← charge_agrees] at hzero
  have hdistrib :
      WardAutomorphismQuotient.physP * (U - V) *
          WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI -
          WardAutomorphismQuotient.physP * V *
            WardAutomorphismQuotient.physI := by
    simp only [Matrix.mul_sub, Matrix.sub_mul]
  constructor
  · intro hexact
    have hz : WardAutomorphismQuotient.physP * (U - V) *
        WardAutomorphismQuotient.physI = 0 := hzero.2 hexact
    rw [hdistrib] at hz
    exact sub_eq_zero.mp hz
  · intro hphys
    apply hzero.1
    rw [hdistrib]
    exact sub_eq_zero.mpr hphys

/-- Equality of physical-line actions is exactly constraint-homotopy
equivalence for finite Ward automorphisms. This is the physically decorated
subclass of the chain-map theorem above. -/
theorem exactEquivalent_iff_same_physical_action
    (U V : Mat3) (hU : WardAutomorphismQuotient.IsWardAutomorphism U)
    (hV : WardAutomorphismQuotient.IsWardAutomorphism V) :
    WardExactEquivalent U V <->
      WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * V * WardAutomorphismQuotient.physI :=
  exactEquivalent_iff_same_physical_action_of_chain U V hU.1 hV.1

/-- The zero map is a charge-commuting chain map. -/
theorem zero_chain_map :
    (0 : Mat3) * WardAutomorphismQuotient.Q =
      WardAutomorphismQuotient.Q * (0 : Mat3) := by
  simp

/-- The chain-map theorem is genuinely more general: the zero chain map is
not a Ward automorphism because it does not preserve the nonzero Krein form. -/
theorem zero_chain_map_not_ward_automorphism :
    Not (WardAutomorphismQuotient.IsWardAutomorphism (0 : Mat3)) := by
  intro h
  have h22 := congrFun (congrFun h.2 (2 : Fin 3)) (2 : Fin 3)
  have hzero_one : (0 : Complex) = 1 := by
    simpa +decide [WardAutomorphismQuotient.G] using h22
  exact zero_ne_one hzero_one

/-- The existing imaginary shear witnesses a nonidentity automorphism in the
exact class of the identity. -/
theorem nontrivial_exact_class_witness :
    let U := WardAutomorphismQuotient.wardFamily 1 Complex.I 0 0 1
    WardAutomorphismQuotient.IsWardAutomorphism U /\ U ≠ 1 /\
      WardExactEquivalent U 1 := by
  rcases WardAutomorphismQuotient.nontrivial_exact_shear_witness with
    ⟨hAuto, hne, _, hExact⟩
  exact ⟨hAuto, hne, hExact⟩

/-- The existing physical phase is the negative control: it is a Ward
automorphism outside the exact class of the identity. -/
theorem physical_phase_distinct_class_control :
    let U := WardAutomorphismQuotient.wardFamily 1 0 0 0 Complex.I
    WardAutomorphismQuotient.IsWardAutomorphism U /\
      Not (WardExactEquivalent U 1) := by
  rcases WardAutomorphismQuotient.physical_phase_not_exact_control with
    ⟨hAuto, _, hNotExact⟩
  refine ⟨hAuto, ?_⟩
  rintro ⟨H, hH⟩
  exact hNotExact ⟨H, hH⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.exactEquivalent_iff_same_physical_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactEquivalent_iff_same_physical_action

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.exactEquivalent_iff_same_physical_action_of_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactEquivalent_iff_same_physical_action_of_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.zero_chain_map_not_ward_automorphism' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_chain_map_not_ward_automorphism

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.nontrivial_exact_class_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_exact_class_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.physical_phase_distinct_class_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_phase_distinct_class_control

end PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization

```

### PhysicsSM/Draft/NullEdge/Carrier/WardAutomorphismQuotient.lean (200 lines)

```lean
import Mathlib

/-!
# Automorphism quotient of the finite Ward witness

This module classifies the complex matrices that commute with the finite Ward
charge and preserve its Krein form.  It computes their action on the
one-dimensional physical line and proves that physical-identity automorphisms
differ from the identity by an explicit constraint-exact term.

The initially proposed condition `U.conjTranspose * G * U = 1` was false: the
Krein Gram `G` is not the identity.  The exact imaginary-shear counterexample
has all proposed coordinate properties but satisfies `U.conjTranspose * G * U
= G`.  The theorem therefore uses the standard and minimal form-preservation
condition `U.conjTranspose * G * U = G`.

Scope: the concrete three-dimensional Ward witness.  This is not a
classification of full null-edge carrier automorphisms and does not impose
graph locality, soldering, gauge, grading, or Clifford constraints.

Provenance: corrected theorem and proofs from Aristotle project
`7399f4a8-60eb-4f69-a373-fbcda8367007`.  The false frozen condition was also
found independently in `WARD_AUTOMORPHISM_AUDIT_2026-07-11.md`.  The returned
source was independently compiled against the pinned toolchain.

Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient

open Complex

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

def Q : Mat3 := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

def G : Mat3 := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

def physI : Matrix (Fin 3) (Fin 1) Complex := !![0; 0; 1]

def physP : Matrix (Fin 1) (Fin 3) Complex := !![0, 0, 1]

def contractS : Mat3 := !![0, 0, 0; 1, 0, 0; 0, 0, 0]

def wardFamily (a b c d e : Complex) : Mat3 :=
  !![a, b, c; 0, a, 0; 0, d, e]

/-- A Ward automorphism commutes with `Q` and preserves the Krein Gram `G`. -/
def IsWardAutomorphism (U : Mat3) : Prop :=
  U * Q = Q * U /\ U.conjTranspose * G * U = G

/-- Every charge-commuting matrix has exactly the displayed five-parameter
upper-block form. -/
theorem commutes_Q_iff_family (U : Mat3) :
    U * Q = Q * U <->
      Exists fun a : Complex => Exists fun b : Complex =>
        Exists fun c : Complex => Exists fun d : Complex =>
          Exists fun e : Complex => U = wardFamily a b c d e := by
  constructor
  · intro h
    unfold Q at h
    simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply]
    simp_all +decide [Fin.sum_univ_succ, Matrix.vecMul]
    unfold wardFamily
    simp +decide [Matrix.vecHead, Matrix.vecTail] at *
    grind
  · rintro ⟨a, b, c, d, e, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;> simp +decide [Q, wardFamily]

/-- Exact Krein-form-preservation equations inside the charge-commuting
family.  The conjugate mixed equation is derived from the displayed third
equation inside the proof. -/
theorem wardFamily_kreinUnitary_iff (a b c d e : Complex) :
    (wardFamily a b c d e).conjTranspose * G * wardFamily a b c d e = G <->
      star a * a = 1 /\
      star e * e = 1 /\
      star a * c + star d * e = 0 /\
      star b * a + star a * b + star d * d = 0 := by
  constructor <;> intro h
  · unfold wardFamily G at h
    norm_num [← Matrix.ext_iff, Fin.forall_fin_succ] at h
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ] at h
    simp_all +decide [add_comm, add_assoc]
  · obtain ⟨h1, h2, h3, h4⟩ := h
    have h3' : star c * a + star e * d = 0 := by
      simpa [mul_comm] using congrArg Star.star h3
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [G, wardFamily, Matrix.mul_apply, Fin.sum_univ_succ] <;>
      simp_all [add_comm, add_assoc]

/-- Full coordinate classification of the finite Ward automorphism group. -/
theorem wardAutomorphism_classification (U : Mat3) :
    IsWardAutomorphism U <->
      Exists fun a : Complex => Exists fun b : Complex =>
        Exists fun c : Complex => Exists fun d : Complex =>
          Exists fun e : Complex =>
            U = wardFamily a b c d e /\
            star a * a = 1 /\
            star e * e = 1 /\
            star a * c + star d * e = 0 /\
            star b * a + star a * b + star d * d = 0 := by
  simp +decide only [IsWardAutomorphism]
  grind +suggestions

/-- The induced action on the physical line is exactly the final coordinate
`e`; the null-sector shear coordinates are invisible after compression. -/
theorem physical_compression_family (a b c d e : Complex) :
    physP * wardFamily a b c d e * physI = !![e] := by
  ext i j
  unfold physP wardFamily physI
  fin_cases i
  fin_cases j
  norm_num [Matrix.mul_apply, Fin.sum_univ_succ]

/-- Explicit homotopy for an automorphism whose physical action is the
identity. -/
def identityKernelHomotopy (U : Mat3) : Mat3 :=
  contractS * (U - 1) + (physI * physP) * (U - 1) * contractS

theorem physical_identity_is_exact (U : Mat3)
    (hcomm : U * Q = Q * U) (hphys : physP * U * physI = 1) :
    U - 1 = Q * identityKernelHomotopy U + identityKernelHomotopy U * Q := by
  unfold identityKernelHomotopy
  simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply] at *
  simp +decide [Fin.sum_univ_succ, Q, contractS, physI, physP] at *
  exact ⟨⟨hcomm.2.1, hcomm.1.2.1.symm, hcomm.1.2.2.symm⟩,
    hcomm.2.2, sub_eq_zero.mpr hphys⟩

/-- Nontrivial kernel witness: an imaginary null-sector shear is a Ward
automorphism, is not the identity, acts identically on the physical line, and
is constraint-exact. -/
theorem nontrivial_exact_shear_witness :
    let U := wardFamily 1 Complex.I 0 0 1
    IsWardAutomorphism U /\
      Ne U 1 /\
      physP * U * physI = 1 /\
      (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · constructor <;>
      norm_num [← List.ofFn_inj, IsWardAutomorphism, Q, G, physI, physP, wardFamily]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    have := congrFun (congrFun h 0) 1
    norm_num [wardFamily] at this
  · convert physical_compression_family 1 Complex.I 0 0 1 using 1
    ext i j
    fin_cases i
    fin_cases j
    rfl
  · use !![Complex.I, 0, 0; 0, 0, 0; 0, 0, 0]
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Q, wardFamily]

/-- Negative control: a genuine physical phase is a Ward automorphism but its
difference from the identity is not constraint-exact. -/
theorem physical_phase_not_exact_control :
    let U := wardFamily 1 0 0 0 Complex.I
    IsWardAutomorphism U /\
      physP * U * physI = !![Complex.I] /\
      Not (Exists fun H : Mat3 => U - 1 = Q * H + H * Q) := by
  refine ⟨?_, ?_, ?_⟩
  · constructor <;> norm_num [wardFamily, Q, G]
    · ext i
      fin_cases i
    · ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · convert physical_compression_family 1 0 0 0 Complex.I using 1
  · simp +decide [← Matrix.ext_iff]
    intro x
    use 2, 2
    simp +decide [Q, wardFamily, Matrix.mul_apply]
    norm_num [Fin.sum_univ_succ, Complex.ext_iff]

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.wardAutomorphism_classification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wardAutomorphism_classification

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.physical_identity_is_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_identity_is_exact

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.nontrivial_exact_shear_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_exact_shear_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient.physical_phase_not_exact_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_phase_not_exact_control

end PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient

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
