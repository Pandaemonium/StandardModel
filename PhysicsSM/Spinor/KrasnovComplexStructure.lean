import Mathlib
import PhysicsSM.Spinor.OctonionicQubit
import PhysicsSM.Algebra.Octonion.ComplexSplitting

/-!
# Spinor.KrasnovComplexStructure

The algebraic centralizer of the complex structure `J = R_{e111}` on `𝕆²`,
and basic closure properties.

## Mathematical context

In Krasnov's approach to the Standard Model gauge group (arXiv:1912.11282),
the complex structure on `𝕆²` given by componentwise right multiplication
by the imaginary unit `e111` plays a central role. The centralizer of this
complex structure — the set of endomorphisms of `𝕆²` that commute with
`J = R_{e111}` — is the algebraic object whose intersection with `Spin(9)`
is expected to yield the Standard Model gauge group `S(U(2) × U(3))`.

This module defines the commutativity predicate, proves that the centralizer
is closed under identity, composition, additive operations, and inverses (for
equivalences), and packages the centralizer as a subtype.

## Claim boundary

This is the coordinate centralizer API needed before a `Spin(9)` centralizer
theorem can be stated honestly. It does not define `Spin(9)`, prove a
centralizer theorem, or prove the representation-theoretic Standard Model
matching.

## Stretch: `O = C ⊕ C³` splitting on `𝕆²`

The `ComplexSplitting` module provides the decomposition of a single octonion
into its chosen-complex-line part and its complement (complex triple) part.
We lift this splitting componentwise to `𝕆²` and prove that `rightMulE111`
preserves the `C` and `C³` summands.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Linearity of rightMulE111

`rightMulE111` is componentwise right multiplication by `e111`, which is
a linear operation on the real vector space `𝕆²`. These lemmas express that
linearity concretely. -/

private theorem qubit_ext_tac {a b : OctonionicQubit}
    (h1 : a.fst = b.fst) (h2 : a.snd = b.snd) : a = b :=
  OctonionicQubit.ext h1 h2

/-- `rightMulE111` distributes over the pointwise sum of two qubits
    defined by adding fst and snd components separately. -/
theorem rightMulE111_mk_add (a b : OctonionicQubit) :
    rightMulE111 ⟨a.fst + b.fst, a.snd + b.snd⟩ =
      ⟨(rightMulE111 a).fst + (rightMulE111 b).fst,
       (rightMulE111 a).snd + (rightMulE111 b).snd⟩ := by
  apply qubit_ext_tac
  · simp only [rightMulE111]; ext <;> simp <;> ring
  · simp only [rightMulE111]; ext <;> simp <;> ring

/-- `rightMulE111` commutes with negation. -/
theorem rightMulE111_neg (q : OctonionicQubit) :
    rightMulE111 (-q) = -(rightMulE111 q) := by
  apply qubit_ext_tac
  · simp only [rightMulE111, neg_fst]; ext <;> simp [e111]
  · simp only [rightMulE111, neg_snd]; ext <;> simp [e111]

/-- `rightMulE111` commutes with scalar multiplication. -/
theorem rightMulE111_smul (r : ℝ) (q : OctonionicQubit) :
    rightMulE111 (r • q) = r • (rightMulE111 q) := by
  apply qubit_ext_tac
  · simp only [rightMulE111]; ext <;> simp [e111]
  · simp only [rightMulE111]; ext <;> simp [e111]

/-- `rightMulE111` maps zero to zero. -/
theorem rightMulE111_zero :
    rightMulE111 (0 : OctonionicQubit) = 0 := by
  apply qubit_ext_tac
  · simp only [rightMulE111, zero_fst]; ext <;> simp [e111]
  · simp only [rightMulE111, zero_snd]; ext <;> simp [e111]

/-! ## The commutativity predicate -/

/--
An endomorphism `f : 𝕆² → 𝕆²` commutes with the complex structure
`rightMulE111` if `f (J q) = J (f q)` for all `q : 𝕆²`.

This is the defining property of the algebraic centralizer of `J`.
-/
def CommutesWithRightMulE111 (f : OctonionicQubit → OctonionicQubit) : Prop :=
  ∀ q : OctonionicQubit, f (rightMulE111 q) = rightMulE111 (f q)

/-! ## Identity commutes -/

/-- The identity function commutes with `rightMulE111`. -/
theorem id_commutesWithRightMulE111 :
    CommutesWithRightMulE111 id :=
  fun _ => rfl

/-! ## Composition closure -/

/-- If `f` and `g` both commute with `rightMulE111`, so does `f ∘ g`. -/
theorem comp_commutesWithRightMulE111
    {f g : OctonionicQubit → OctonionicQubit}
    (hf : CommutesWithRightMulE111 f) (hg : CommutesWithRightMulE111 g) :
    CommutesWithRightMulE111 (f ∘ g) := by
  intro q
  change f (g (rightMulE111 q)) = rightMulE111 (f (g q))
  rw [hg q, hf (g q)]

/-! ## Inverse closure for equivalences -/

/-- If an equivalence `e : 𝕆² ≃ 𝕆²` commutes with `rightMulE111` in the
    forward direction, then its inverse also commutes with `rightMulE111`. -/
theorem equiv_symm_commutesWithRightMulE111
    (e : OctonionicQubit ≃ OctonionicQubit)
    (he : CommutesWithRightMulE111 e) :
    CommutesWithRightMulE111 e.symm := by
  intro q
  apply e.injective
  rw [e.apply_symm_apply, he (e.symm q), e.apply_symm_apply]

/-! ## Additive closure -/

/-- If `f` and `g` commute with `rightMulE111`, so does their pointwise sum
    (when `𝕆²` is given its componentwise addition). -/
theorem add_commutesWithRightMulE111
    {f g : OctonionicQubit → OctonionicQubit}
    (hf : CommutesWithRightMulE111 f) (hg : CommutesWithRightMulE111 g) :
    CommutesWithRightMulE111 (fun q =>
      ⟨(f q).fst + (g q).fst, (f q).snd + (g q).snd⟩) := by
  intro q
  -- Extract component equalities from hf, hg
  have hf1 := congrArg OctonionicQubit.fst (hf q)
  have hf2 := congrArg OctonionicQubit.snd (hf q)
  have hg1 := congrArg OctonionicQubit.fst (hg q)
  have hg2 := congrArg OctonionicQubit.snd (hg q)
  simp only [rightMulE111] at *
  apply qubit_ext_tac
  · -- fst: use right distributivity of octonion multiplication
    rw [hf1, hg1]; ext <;> simp <;> ring
  · rw [hf2, hg2]; ext <;> simp <;> ring

/-- The zero function commutes with `rightMulE111`. -/
theorem zero_commutesWithRightMulE111 :
    CommutesWithRightMulE111 (fun _ => (0 : OctonionicQubit)) := by
  intro _
  rw [rightMulE111_zero]

/-- The negation of a commuting function also commutes. -/
theorem neg_commutesWithRightMulE111
    {f : OctonionicQubit → OctonionicQubit}
    (hf : CommutesWithRightMulE111 f) :
    CommutesWithRightMulE111 (fun q => -(f q)) := by
  intro q
  change -(f (rightMulE111 q)) = rightMulE111 (-(f q))
  rw [hf q, rightMulE111_neg]

/-- Scalar multiplication of a commuting function also commutes. -/
theorem smul_commutesWithRightMulE111
    (r : ℝ) {f : OctonionicQubit → OctonionicQubit}
    (hf : CommutesWithRightMulE111 f) :
    CommutesWithRightMulE111 (fun q => r • (f q)) := by
  intro q
  change r • (f (rightMulE111 q)) = rightMulE111 (r • (f q))
  rw [hf q, rightMulE111_smul]

/-! ## rightMulE111 commutes with itself -/

/-- `rightMulE111` commutes with itself (trivially). -/
theorem rightMulE111_commutesWithSelf :
    CommutesWithRightMulE111 rightMulE111 :=
  fun _ => rfl

/-! ## The centralizer subtype -/

/--
The algebraic centralizer of `rightMulE111`: the subtype of endomorphisms
`𝕆² → 𝕆²` that commute with the complex structure `J = R_{e111}`.

This is the algebraic object whose intersection with `Spin(9)` is expected
to yield the Standard Model gauge group. The `Spin(9)` intersection is not
formalized here.
-/
def RightMulE111Centralizer :=
  { f : OctonionicQubit → OctonionicQubit // CommutesWithRightMulE111 f }

/-- The identity element of the centralizer. -/
def RightMulE111Centralizer.id : RightMulE111Centralizer :=
  ⟨_root_.id, id_commutesWithRightMulE111⟩

/-- Composition in the centralizer. -/
def RightMulE111Centralizer.comp
    (f g : RightMulE111Centralizer) : RightMulE111Centralizer :=
  ⟨f.val ∘ g.val, comp_commutesWithRightMulE111 f.property g.property⟩

/-- The coercion from `RightMulE111Centralizer` to the underlying function. -/
instance : CoeFun RightMulE111Centralizer (fun _ => OctonionicQubit → OctonionicQubit) :=
  ⟨Subtype.val⟩

/-- Composition in the centralizer is associative. -/
theorem RightMulE111Centralizer.comp_assoc
    (f g h : RightMulE111Centralizer) :
    (f.comp g).comp h = f.comp (g.comp h) := by
  apply Subtype.ext; rfl

/-- Identity is a left unit for composition. -/
theorem RightMulE111Centralizer.id_comp
    (f : RightMulE111Centralizer) :
    RightMulE111Centralizer.id.comp f = f := by
  apply Subtype.ext; rfl

/-- Identity is a right unit for composition. -/
theorem RightMulE111Centralizer.comp_id
    (f : RightMulE111Centralizer) :
    f.comp RightMulE111Centralizer.id = f := by
  apply Subtype.ext; rfl

/-! ## The centralizer for equivalences -/

/--
The subtype of equivalences `𝕆² ≃ 𝕆²` that commute with `rightMulE111`.
This is the "invertible" part of the centralizer.
-/
def RightMulE111CentralizerEquiv :=
  { e : OctonionicQubit ≃ OctonionicQubit // CommutesWithRightMulE111 e }

/-- Inverse of a centralizer equivalence stays in the centralizer. -/
def RightMulE111CentralizerEquiv.symm
    (e : RightMulE111CentralizerEquiv) : RightMulE111CentralizerEquiv :=
  ⟨e.val.symm, equiv_symm_commutesWithRightMulE111 e.val e.property⟩

/-- Composition of centralizer equivalences. -/
def RightMulE111CentralizerEquiv.trans
    (e₁ e₂ : RightMulE111CentralizerEquiv) : RightMulE111CentralizerEquiv :=
  ⟨e₁.val.trans e₂.val,
   fun q => by
    simp only [Equiv.trans_apply]
    rw [e₁.property q, e₂.property]⟩

/-- The identity equivalence is in the centralizer. -/
def RightMulE111CentralizerEquiv.refl : RightMulE111CentralizerEquiv :=
  ⟨Equiv.refl _, fun _ => rfl⟩

/-! ## Stretch: `𝕆² = (C ⊕ C³)²` splitting -/

/--
The decomposition of an octonionic qubit into its chosen-complex-line
parts and complement (complex triple) parts. This lifts the
`𝕆 = C ⊕ C³` splitting from `ComplexSplitting.lean` componentwise to `𝕆²`.
-/
structure OctonionicQubitSplitting where
  /-- The chosen-complex-line part of the first component. -/
  fst_line : ChosenComplex
  /-- The complement (C³) part of the first component. -/
  fst_complement : ComplexTriple
  /-- The chosen-complex-line part of the second component. -/
  snd_line : ChosenComplex
  /-- The complement (C³) part of the second component. -/
  snd_complement : ComplexTriple
  deriving Inhabited

/-- Split an octonionic qubit into its `(C ⊕ C³)²` components. -/
def splitQubit (q : OctonionicQubit) : OctonionicQubitSplitting :=
  { fst_line := q.fst.toChosenComplex
    fst_complement := q.fst.toComplexTriple
    snd_line := q.snd.toChosenComplex
    snd_complement := q.snd.toComplexTriple }

/-- Reconstruct an octonionic qubit from its split components. -/
def OctonionicQubitSplitting.toQubit (s : OctonionicQubitSplitting) : OctonionicQubit :=
  { fst := s.fst_line.toOctonion + s.fst_complement.toOctonion
    snd := s.snd_line.toOctonion + s.snd_complement.toOctonion }

/-- The split-then-reconstruct round-trip recovers the original qubit. -/
theorem splitQubit_roundtrip (q : OctonionicQubit) :
    (splitQubit q).toQubit = q := by
  apply qubit_ext_tac
  · simp only [splitQubit, OctonionicQubitSplitting.toQubit]
    ext <;> simp [ChosenComplex.toOctonion, ComplexTriple.toOctonion,
      Octonion.toChosenComplex, Octonion.toComplexTriple]
  · simp only [splitQubit, OctonionicQubitSplitting.toQubit]
    ext <;> simp [ChosenComplex.toOctonion, ComplexTriple.toOctonion,
      Octonion.toChosenComplex, Octonion.toComplexTriple]

/-! ### rightMulE111 preserves the C summand -/

/--
Right multiplication by `e111` preserves the chosen complex line on each
component of `𝕆²`.

For an octonion `a` in the chosen complex line (i.e., `a = a₀ + a₇ e111`),
we have `a * e111 = a₀ e111 - a₇`, which is again in the complex line.
-/
theorem rightMulE111_preserves_line_fst (q : OctonionicQubit)
    (h : InChosenComplexLine q.fst) :
    InChosenComplexLine (rightMulE111 q).fst := by
  simp only [rightMulE111]
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [e111, h1, h2, h3, h4, h5, h6]

theorem rightMulE111_preserves_line_snd (q : OctonionicQubit)
    (h : InChosenComplexLine q.snd) :
    InChosenComplexLine (rightMulE111 q).snd := by
  simp only [rightMulE111]
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [e111, h1, h2, h3, h4, h5, h6]

/-! ### rightMulE111 preserves the C³ summand -/

/--
Right multiplication by `e111` preserves the complement on each component
of `𝕆²`. For an octonion `a` in the complement (i.e., `a.c0 = 0` and
`a.c7 = 0`), `a * e111` is again in the complement.
-/
theorem rightMulE111_preserves_complement_fst (q : OctonionicQubit)
    (h : InChosenComplexComplement q.fst) :
    InChosenComplexComplement (rightMulE111 q).fst := by
  simp only [rightMulE111]
  exact rightMul_e111_preserves_complement h

theorem rightMulE111_preserves_complement_snd (q : OctonionicQubit)
    (h : InChosenComplexComplement q.snd) :
    InChosenComplexComplement (rightMulE111 q).snd := by
  simp only [rightMulE111]
  exact rightMul_e111_preserves_complement h

/-! ### rightMulE111 in splitting coordinates -/

/--
The action of `rightMulE111` on the complex-line part of an octonion.
If `z` is in the chosen complex line with coordinates `(re, im)`, then
`z * e111` has coordinates `(-im, re)` — i.e., multiplication by
`i` in the chosen copy of `ℂ`.
-/
theorem rightMulE111_line_coords (z : ChosenComplex) :
    (z.toOctonion * e111).toChosenComplex = ⟨-z.im, z.re⟩ := by
  ext <;> simp [ChosenComplex.toOctonion, e111, Octonion.toChosenComplex]

/--
The action of `rightMulE111` on the complement (C³) part. Right multiplication
by `e111` acts as the *conjugate* complex structure (`-J`) on the complement
triple coordinates:
`(w₁_re, w₁_im, w₂_re, w₂_im, w₃_re, w₃_im)` ↦
`(w₁_im, -w₁_re, w₂_im, -w₂_re, w₃_im, -w₃_re)`.
-/
theorem rightMulE111_complement_coords (w : ComplexTriple) :
    (w.toOctonion * e111).toComplexTriple =
      ⟨w.w1_im, -w.w1_re, w.w2_im, -w.w2_re, w.w3_im, -w.w3_re⟩ := by
  ext <;> simp [ComplexTriple.toOctonion, e111, Octonion.toComplexTriple]

/-! ## J² = -id -/

/-- The complex structure `J = rightMulE111` squares to minus the identity
on `𝕆²`. This is the defining algebraic property of a complex structure. -/
theorem rightMulE111_sq_neg (q : OctonionicQubit) :
    rightMulE111 (rightMulE111 q) = -q :=
  OctonionicQubit.rightMulE111_sq_neg q

/-- Function-level form of `rightMulE111_sq_neg`. -/
theorem rightMulE111_sq_neg_linearMap :
    (rightMulE111 ∘ rightMulE111) = fun q => -q :=
  funext rightMulE111_sq_neg

end PhysicsSM.Spinor.KrasnovComplexStructure
