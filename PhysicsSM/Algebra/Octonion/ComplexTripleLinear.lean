import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexC3ActionLaws

/-!
# Algebra.Octonion.ComplexTripleLinear

Promotes `ComplexTriple` to a complex vector space and packages its coordinate
map as a complex-linear equivalence with `Fin 3 -> Complex`.

## Mathematical context

The modules `ComplexSplitting` and `ComplexTripleModule` define the six-real-
coordinate complement to the chosen complex line in the octonions, together
with the coordinate maps

- `ComplexTriple.toComplexVec : ComplexTriple -> Fin 3 -> Complex`,
- `ComplexTriple.ofComplexVec : (Fin 3 -> Complex) -> ComplexTriple`,
- `ComplexTriple.complexSmul : Complex -> ComplexTriple -> ComplexTriple`.

After choosing `e111` as the imaginary unit, this file formalizes the statement
that the complement is `Complex^3` as a complex vector space.

## Convention choices

All conventions follow `ComplexSplitting` and `ComplexTripleModule`:

- `w1 = w1_re + i * w1_im`  (basis pair `e001, e110`)
- `w2 = w2_re + i * w2_im`  (basis pair `e010, e101`)
- `w3 = w3_re + i * w3_im`  (basis pair `e100, e011`)
- Coordinate ordering: `Fin 3 = {0 -> w1, 1 -> w2, 2 -> w3}`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted - proofs complete.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Complex scalar multiplication accessor lemmas -/

@[simp] theorem ComplexTriple.complexSmul_w1_re (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w1_re = z.re * w.w1_re - z.im * w.w1_im := rfl

@[simp] theorem ComplexTriple.complexSmul_w1_im (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w1_im = z.re * w.w1_im + z.im * w.w1_re := rfl

@[simp] theorem ComplexTriple.complexSmul_w2_re (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w2_re = z.re * w.w2_re - z.im * w.w2_im := rfl

@[simp] theorem ComplexTriple.complexSmul_w2_im (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w2_im = z.re * w.w2_im + z.im * w.w2_re := rfl

@[simp] theorem ComplexTriple.complexSmul_w3_re (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w3_re = z.re * w.w3_re - z.im * w.w3_im := rfl

@[simp] theorem ComplexTriple.complexSmul_w3_im (z : Complex) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).w3_im = z.re * w.w3_im + z.im * w.w3_re := rfl

/-! ## Additive commutative group -/

/-- `ComplexTriple` forms an additive commutative group under coordinate-wise
operations. -/
instance : AddCommGroup ComplexTriple where
  add_assoc a b c := by ext <;> simp [add_assoc]
  zero_add a := by ext <;> simp
  add_zero a := by ext <;> simp
  add_comm a b := by ext <;> simp [add_comm]
  neg_add_cancel a := by ext <;> simp
  sub_eq_add_neg a b := by ext <;> simp [sub_eq_add_neg]
  nsmul := fun n a => ⟨n * a.w1_re, n * a.w1_im, n * a.w2_re, n * a.w2_im,
                        n * a.w3_re, n * a.w3_im⟩
  nsmul_zero a := by ext <;> simp
  nsmul_succ n a := by ext <;> simp <;> ring
  zsmul := fun n a => ⟨n * a.w1_re, n * a.w1_im, n * a.w2_re, n * a.w2_im,
                        n * a.w3_re, n * a.w3_im⟩
  zsmul_zero' a := by ext <;> simp
  zsmul_succ' n a := by ext <;> simp <;> ring
  zsmul_neg' n a := by ext <;> simp <;> ring

/-! ## Complex module structure -/

/-- Complex scalar multiplication on `ComplexTriple`, using `complexSmul`. -/
noncomputable instance complexTripleSMulComplex : SMul Complex ComplexTriple :=
  ⟨ComplexTriple.complexSmul⟩

/-- The `SMul Complex` action agrees definitionally with `complexSmul`. -/
theorem ComplexTriple.smul_eq_complexSmul (z : Complex) (w : ComplexTriple) :
    z • w = ComplexTriple.complexSmul z w :=
  rfl

/-- `ComplexTriple` forms a module over `Complex` via coordinate-wise complex
scalar multiplication. -/
noncomputable instance : Module Complex ComplexTriple where
  one_smul w := ComplexTriple.complexSmul_one w
  mul_smul z1 z2 w := (ComplexTriple.complexSmul_complexSmul z1 z2 w).symm
  smul_zero z := by
    change ComplexTriple.complexSmul z 0 = 0
    ext <;> simp [ComplexTriple.complexSmul]
  smul_add z a b := by
    change ComplexTriple.complexSmul z (a + b) =
      ComplexTriple.complexSmul z a + ComplexTriple.complexSmul z b
    ext <;> simp [ComplexTriple.complexSmul] <;> ring
  add_smul z1 z2 w := by
    change ComplexTriple.complexSmul (z1 + z2) w =
      ComplexTriple.complexSmul z1 w + ComplexTriple.complexSmul z2 w
    ext <;> simp [ComplexTriple.complexSmul, Complex.add_re, Complex.add_im] <;> ring
  zero_smul w := ComplexTriple.complexSmul_zero w

/-! ## Coordinate linear equivalence -/

/-- The coordinate bijection `ComplexTriple <-> (Fin 3 -> Complex)` as an
additive group equivalence. -/
noncomputable def ComplexTriple.addEquivComplexVec :
    ComplexTriple ≃+ (Fin 3 -> Complex) where
  toFun := ComplexTriple.toComplexVec
  invFun := ComplexTriple.ofComplexVec
  left_inv w := ComplexTriple.ofComplexVec_toComplexVec w
  right_inv v := ComplexTriple.toComplexVec_ofComplexVec v
  map_add' a b := by
    ext k
    fin_cases k <;> simp [ComplexTriple.toComplexVec, Complex.ext_iff]

/-- The coordinate bijection `ComplexTriple <-> (Fin 3 -> Complex)` as a
`Complex`-linear equivalence. -/
noncomputable def ComplexTriple.linearEquivComplexVec :
    ComplexTriple ≃ₗ[Complex] (Fin 3 -> Complex) where
  toFun := ComplexTriple.toComplexVec
  invFun := ComplexTriple.ofComplexVec
  left_inv w := ComplexTriple.ofComplexVec_toComplexVec w
  right_inv v := ComplexTriple.toComplexVec_ofComplexVec v
  map_add' a b := ComplexTriple.addEquivComplexVec.map_add' a b
  map_smul' z w := by
    change ComplexTriple.toComplexVec (ComplexTriple.complexSmul z w) =
      z • ComplexTriple.toComplexVec w
    rw [ComplexTriple.toComplexVec_complexSmul]
    ext k
    simp [Pi.smul_apply]

/-! ## Simp lemmas -/

/-- The linear equivalence applies as `toComplexVec`. -/
@[simp]
theorem ComplexTriple.linearEquivComplexVec_apply (w : ComplexTriple) :
    ComplexTriple.linearEquivComplexVec w = w.toComplexVec :=
  rfl

/-- The inverse of the linear equivalence applies as `ofComplexVec`. -/
@[simp]
theorem ComplexTriple.linearEquivComplexVec_symm_apply (v : Fin 3 -> Complex) :
    ComplexTriple.linearEquivComplexVec.symm v = ComplexTriple.ofComplexVec v :=
  rfl

/-- `toComplexVec` commutes with complex scalar multiplication. -/
@[simp]
theorem ComplexTriple.toComplexVec_smul (z : Complex) (w : ComplexTriple) :
    (z • w).toComplexVec = z • w.toComplexVec := by
  change (ComplexTriple.complexSmul z w).toComplexVec = z • w.toComplexVec
  rw [ComplexTriple.toComplexVec_complexSmul]
  ext k
  simp [Pi.smul_apply]

end PhysicsSM.Algebra.Octonion
