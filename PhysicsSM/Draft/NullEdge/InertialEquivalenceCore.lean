import Mathlib

/-!
# Inertial/gravitational equivalence finite core (Opus, verified Aristotle f1061eda)

Gate A6: I(v)=v(dag)Mv nonneg + zero iff kernel; the trace-pairing identity
I(v)=Tr(M(vv(dag))) - see the PRECISION note on it below, it is a representation
identity and NOT evidence for the equivalence principle; trace channel-blind
under unitary equivalence; a PSD 2x2
witness with equal trace/spectrum but channel-dependent response (channel-blind
source vs channel-dependent pole). ContinuumGRBridge named as a SEPARATE unproved
grade - no continuum GR folded in. Namespace kept as the prover's
FiniteEquivalenceCore (verbatim). Provenance: verified at pin from task 3ceb6c5f.
Standard three. Claim grade M, [comp]. -/

open scoped BigOperators ComplexConjugate ComplexOrder

set_option autoImplicit false

namespace FiniteEquivalenceCore

/-- The energy cost (inertial response) of a finite state to a mass-response matrix. -/
noncomputable def inertialResponse {n : Type*} [Fintype n]
    (M : Matrix n n ℂ) (v : n → ℂ) : ℂ :=
  star v ⬝ᵥ M.mulVec v

/-- The finite, channel-blind source obtained by trace-pairing with a probe. -/
noncomputable def gravitationalSource {n : Type*} [Fintype n]
    (M A : Matrix n n ℂ) : ℂ :=
  Matrix.trace (M * A)

/-- The rank-one probe `v v†`. -/
def rankOneProbe {n : Type*} (v : n → ℂ) : Matrix n n ℂ :=
  Matrix.vecMulVec v (star v)

/-
Positivity of inertia, and precisely its massless directions.
`Matrix.PosSemidef` includes the Hermitian condition, so no redundant Hermiticity
hypothesis is needed.
-/
theorem inertia_nonneg_and_eq_zero_iff_kernel {n : Type*} [Fintype n]
    {M : Matrix n n ℂ} (hM : M.PosSemidef) (v : n → ℂ) :
    0 ≤ (inertialResponse M v).re ∧
      (inertialResponse M v = 0 ↔ M.mulVec v = 0) := by
  constructor
  · exact hM.re_dotProduct_nonneg v
  · exact hM.dotProduct_mulVec_zero_iff v

/-
**Finite trace-pairing identity.** The quadratic form of `M` on `v` equals the
trace pairing of `M` with the rank-one probe `v v(dag)`.

PRECISION (self-audit, 2026-07-21, over-claim mode: hollow telescoping). This
theorem has **no hypotheses on `M` whatsoever** - it holds for every matrix,
Hermitian or not, positive or not, physical or not. It is therefore the
definition of trace pairing rewritten, and it carries **zero discriminating
information about the equivalence principle**: nothing could fail it, so its
holding is not evidence for anything.

The earlier reading, "the same matrix supplies the inertial response and the
gravitational source", overstates it. That sentence sounds like a claim that two
independently-motivated physical roles are filled by one object, which is the
actual content of an equivalence principle. What is proved is that ONE matrix,
paired two notationally different ways, gives the same number.

The genuine A6 content must come from elsewhere: an argument that the `M`
appearing in the dynamics' inertial response is the same `M` appearing in an
independently-motivated gravitational field equation. That is a MODELLING claim
requiring two separate derivations to meet, and it is not established here or
anywhere else in this repository. Gate A6 should be recorded as OPEN on that
basis.
-/
theorem inertialResponse_eq_gravitationalSource_rankOne {n : Type*} [Fintype n]
    (M : Matrix n n ℂ) (v : n → ℂ) :
    inertialResponse M v = gravitationalSource M (rankOneProbe v) := by
  unfold inertialResponse gravitationalSource rankOneProbe;
  simp +decide [Matrix.trace, Matrix.mul_apply, Matrix.vecMulVec]
  simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc, mul_comm]

/-
The state probe is Hermitian (the finite meaning of a symmetric probe).
-/
theorem rankOneProbe_isHermitian {n : Type*} (v : n → ℂ) :
    (rankOneProbe v).IsHermitian := by
  unfold rankOneProbe;
  ext i j
  simp +decide [Matrix.vecMulVec, mul_comm]

/-- Two finite response matrices are unitarily equivalent when one is obtained
from the other by a unitary change of eigen-channel basis. -/
def UnitarilyEquivalent {n : Type*} [Fintype n] [DecidableEq n]
    (M M' : Matrix n n ℂ) : Prop :=
  ∃ U : Matrix n n ℂ,
    U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1 ∧
      M' = U * M * U.conjTranspose

/-
A unitary change of eigen-channel basis cannot change the total source.
-/
theorem trace_eq_of_unitarilyEquivalent {n : Type*} [Fintype n] [DecidableEq n]
    {M M' : Matrix n n ℂ} (h : UnitarilyEquivalent M M') :
    Matrix.trace M = Matrix.trace M' := by
  cases h ; simp_all +decide [ mul_assoc, Matrix.trace_mul_comm ( ‹_› : Matrix n n ℂ ) ]

/-
The total source is channel-blind, while a fixed-channel pole/residue is not.
Indeed these two positive Hermitian operators are unitarily equivalent (hence
have the same spectrum and the same smallest positive eigenvalue, namely `1`),
and have the same trace, but their response in channel `0` differs. This is the
precise finite contrast: a mass gap, or even the whole unordered spectrum, does
not determine a pole attached to a specified channel.
-/
theorem gap_does_not_fix_pole :
    let M : Matrix (Fin 2) (Fin 2) ℂ := !![(1 : ℂ), 0; 0, 2]
    let M' : Matrix (Fin 2) (Fin 2) ℂ := !![(2 : ℂ), 0; 0, 1]
    let e₀ : Fin 2 → ℂ := fun i => if i = 0 then 1 else 0
    M.PosSemidef ∧ M'.PosSemidef ∧
      UnitarilyEquivalent M M' ∧
      Matrix.trace M = Matrix.trace M' ∧
      inertialResponse M e₀ = 1 ∧ inertialResponse M' e₀ = 2 := by
  refine' ⟨ _, _, _, _, _ ⟩ <;> norm_num [ Matrix.PosSemidef, UnitarilyEquivalent ];
  · norm_num [ Finsupp.sum_fintype, Fin.sum_univ_succ ];
    refine' ⟨ by ext i j; fin_cases i <;> fin_cases j <;> norm_num, _ ⟩;
    norm_num [ mul_assoc, mul_comm, mul_left_comm ];
    norm_num [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
    exact fun x => by norm_cast; positivity;
  · constructor <;> norm_num [ Fin.sum_univ_succ, Finsupp.sum_fintype ];
    · ext i j ; fin_cases i <;> fin_cases j <;> norm_num;
    · norm_num [ Complex.ext_iff, mul_comm ];
      intro x; ring_nf ;
      norm_num [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
      norm_cast ; positivity;
  · refine' ⟨ Matrix.of ( fun i j => if i = 1 ∧ j = 0 then 1 else if i = 0 ∧ j = 1 then 1 else 0 ), _, _, _ ⟩ <;> norm_num [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
  · unfold inertialResponse; norm_num [ Matrix.mulVec ] ;
    norm_num [ Matrix.vecHead, Matrix.vecTail ]

/-- A name for the deliberately separate continuum-GR grade: establishing this
relation would require continuum fields and a coframe/metric variation, none of
which is asserted by the finite theorem above. -/
def ContinuumGRBridge (finiteTrace continuumSource : ℂ) : Prop :=
  finiteTrace = continuumSource

end FiniteEquivalenceCore
