import PhysicsSM.Algebra.Octonion.ComplexOctonion

/-!
# The `C(x)H(x)O` Dixon algebra (item-2 spine: the substantial missing build)

SM-branch spine. Furey 1806.00612's electroweak/Lorentz sector lives in the full
Dixon algebra `C(x)H(x)O`, NOT `C(x)O` alone: the weak ladders (eq. 30) combine
the `H`-quaternion units `i_1, i_2, i_3` (a SEPARATE tensor factor - eq. 13's
Dirac matrices are bar operators of these) with the colour `C(x)O` element
`tau_j = omega + omega-dag`. This module builds `C(x)H(x)O` in the tractable
representation

  `C(x)H(x)O  =  H (x)_R (C(x)O)  =  Quaternion over ComplexOctonion`,

i.e. an element is `x_0 + x_1 i_1 + x_2 i_2 + x_3 i_3` with each `x_k` a
`ComplexOctonion` (the colour factor). The `H`-units commute with `C(x)O` (tensor
product), so the product is the quaternion HAMILTON product with `ComplexOctonion`
coefficients (each coefficient a `ComplexOctonion` product, in order).

This is the substrate the original Aristotle no-go (661e5230) correctly said was
missing. Foundation only here (type, product, `H`-units, and the verified
quaternion relations); the weak `beta`-ladders and the CAR/su(2)_L closure are
the successor build.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonAlgebra

open PhysicsSM.Algebra.Octonion.ComplexOctonion

/-- A Dixon-algebra element `x_0 + x_1 i_1 + x_2 i_2 + x_3 i_3`, each coefficient
a complexified octonion (the colour `C(x)O` factor); `i_1,i_2,i_3` are the `H`
quaternion units. -/
@[ext]
structure Dixon where
  /-- Coefficient of `1`. -/
  x0 : ComplexOctonion
  /-- Coefficient of the `H`-unit `i_1`. -/
  x1 : ComplexOctonion
  /-- Coefficient of the `H`-unit `i_2`. -/
  x2 : ComplexOctonion
  /-- Coefficient of the `H`-unit `i_3`. -/
  x3 : ComplexOctonion
  deriving Inhabited

namespace Dixon

instance : Zero Dixon := ⟨⟨0, 0, 0, 0⟩⟩
instance : Add Dixon := ⟨fun a b => ⟨a.x0 + b.x0, a.x1 + b.x1, a.x2 + b.x2, a.x3 + b.x3⟩⟩
instance : Neg Dixon := ⟨fun a => ⟨-a.x0, -a.x1, -a.x2, -a.x3⟩⟩

@[simp] theorem zero_x0 : (0 : Dixon).x0 = 0 := rfl
@[simp] theorem zero_x1 : (0 : Dixon).x1 = 0 := rfl
@[simp] theorem zero_x2 : (0 : Dixon).x2 = 0 := rfl
@[simp] theorem zero_x3 : (0 : Dixon).x3 = 0 := rfl
@[simp] theorem add_x0 (a b : Dixon) : (a + b).x0 = a.x0 + b.x0 := rfl
@[simp] theorem add_x1 (a b : Dixon) : (a + b).x1 = a.x1 + b.x1 := rfl
@[simp] theorem add_x2 (a b : Dixon) : (a + b).x2 = a.x2 + b.x2 := rfl
@[simp] theorem add_x3 (a b : Dixon) : (a + b).x3 = a.x3 + b.x3 := rfl
@[simp] theorem neg_x0 (a : Dixon) : (-a).x0 = -a.x0 := rfl
@[simp] theorem neg_x1 (a : Dixon) : (-a).x1 = -a.x1 := rfl
@[simp] theorem neg_x2 (a : Dixon) : (-a).x2 = -a.x2 := rfl
@[simp] theorem neg_x3 (a : Dixon) : (-a).x3 = -a.x3 := rfl

/-- The Dixon product: the quaternion Hamilton product with `ComplexOctonion`
coefficients. `H`-units commute with the `C(x)O` factor, so each coefficient is a
`ComplexOctonion` product (order preserved); the signs are the quaternion table
`i_1^2 = i_2^2 = i_3^2 = -1`, `i_1 i_2 = i_3`, `i_2 i_3 = i_1`, `i_3 i_1 = i_2`.
Subtraction is written `+ (- _)` since `ComplexOctonion` carries no bundled `Sub`. -/
def mul (a b : Dixon) : Dixon where
  x0 := a.x0 * b.x0 + (-(a.x1 * b.x1)) + (-(a.x2 * b.x2)) + (-(a.x3 * b.x3))
  x1 := a.x0 * b.x1 + a.x1 * b.x0 + a.x2 * b.x3 + (-(a.x3 * b.x2))
  x2 := a.x0 * b.x2 + (-(a.x1 * b.x3)) + a.x2 * b.x0 + a.x3 * b.x1
  x3 := a.x0 * b.x3 + a.x1 * b.x2 + (-(a.x2 * b.x1)) + a.x3 * b.x0

instance : Mul Dixon := ⟨mul⟩

@[simp] theorem mul_x0 (a b : Dixon) :
    (a * b).x0 = a.x0 * b.x0 + (-(a.x1 * b.x1)) + (-(a.x2 * b.x2)) + (-(a.x3 * b.x3)) := rfl
@[simp] theorem mul_x1 (a b : Dixon) :
    (a * b).x1 = a.x0 * b.x1 + a.x1 * b.x0 + a.x2 * b.x3 + (-(a.x3 * b.x2)) := rfl
@[simp] theorem mul_x2 (a b : Dixon) :
    (a * b).x2 = a.x0 * b.x2 + (-(a.x1 * b.x3)) + a.x2 * b.x0 + a.x3 * b.x1 := rfl
@[simp] theorem mul_x3 (a b : Dixon) :
    (a * b).x3 = a.x0 * b.x3 + a.x1 * b.x2 + (-(a.x2 * b.x1)) + a.x3 * b.x0 := rfl

/-! Local `ComplexOctonion` unit/annihilator lemmas. `ComplexOctonion` carries no
`Monoid`/`Ring` instance, so `mul_one`/`one_mul`/`mul_zero`/`zero_mul` are not
available generically; each is a fast finite check (one factor is the concrete
`1` or `0`, so no symbolic octonion product appears). -/
@[local simp] private theorem co_mul_one (x : ComplexOctonion) : x * 1 = x := by
  ext <;> simp
@[local simp] private theorem co_one_mul (x : ComplexOctonion) : 1 * x = x := by
  ext <;> simp
@[local simp] private theorem co_mul_zero (x : ComplexOctonion) : x * 0 = 0 := by
  ext <;> simp
@[local simp] private theorem co_zero_mul (x : ComplexOctonion) : (0 : ComplexOctonion) * x = 0 := by
  ext <;> simp

/-- Embed the colour factor `C(x)O` as the scalar (`i`-free) part. -/
def ofColour (x : ComplexOctonion) : Dixon := ⟨x, 0, 0, 0⟩

/-- The Dixon identity `1 = ofColour 1`. -/
instance : One Dixon := ⟨⟨1, 0, 0, 0⟩⟩

@[simp] theorem one_x0 : (1 : Dixon).x0 = 1 := rfl
@[simp] theorem one_x1 : (1 : Dixon).x1 = 0 := rfl
@[simp] theorem one_x2 : (1 : Dixon).x2 = 0 := rfl
@[simp] theorem one_x3 : (1 : Dixon).x3 = 0 := rfl

/-- The `H`-quaternion unit `i_1`. -/
def i1 : Dixon := ⟨0, 1, 0, 0⟩
/-- The `H`-quaternion unit `i_2`. -/
def i2 : Dixon := ⟨0, 0, 1, 0⟩
/-- The `H`-quaternion unit `i_3`. -/
def i3 : Dixon := ⟨0, 0, 0, 1⟩

/-- Shared tactic for the finite `H`-relation checks (all coefficients are
`0` or `1`, so the `ComplexOctonion` products reduce to `0`/`1`). -/
macro "dixon_unit" : tactic =>
  `(tactic|
    (ext <;>
      simp [i1, i2, i3, mul, ofColour, ComplexOctonion.mul_re,
        ComplexOctonion.mul_im, ComplexOctonion.one_re, ComplexOctonion.one_im] <;>
      ring))

/-- **`i_1^2 = -1`** (a genuine `H`-quaternion relation on the Dixon algebra). -/
theorem i1_sq : i1 * i1 = -1 := by dixon_unit
/-- **`i_2^2 = -1`**. -/
theorem i2_sq : i2 * i2 = -1 := by dixon_unit
/-- **`i_3^2 = -1`**. -/
theorem i3_sq : i3 * i3 = -1 := by dixon_unit
/-- **`i_1 i_2 = i_3`** (the cyclic Hamilton relation). -/
theorem i1_i2 : i1 * i2 = i3 := by dixon_unit
/-- **`i_2 i_3 = i_1`**. -/
theorem i2_i3 : i2 * i3 = i1 := by dixon_unit
/-- **`i_3 i_1 = i_2`**. -/
theorem i3_i1 : i3 * i1 = i2 := by dixon_unit
/-- **`i_2 i_1 = -i_3`** (anticommutation - the quaternions are non-commutative). -/
theorem i2_i1 : i2 * i1 = -i3 := by dixon_unit

/-! ## The tensor structure: `H`-units commute with the colour factor

The single fact that makes this `H (x)_R (C(x)O)` construction genuinely the
tensor product `C(x)H(x)O` (rather than an arbitrary `H`-valued algebra) is that
the `H` quaternion units commute with the whole colour factor `ofColour x` - even
though the colour factor itself is non-commutative and non-associative. This is
exactly Furey's "the `H` and `O` factors are independent tensor slots." -/

/-- Shared tactic for the colour/`H`-unit commutation checks. Crucially this does
NOT expand the colour product into octonion coordinates (that is an 8x8 symbolic
sum and times out); it stops `ext` at the Dixon level and closes each
`ComplexOctonion` coordinate with the colour factor's own `mul_one`/`one_mul`/
`mul_zero`/`zero_mul`. -/
macro "dixon_comm" : tactic =>
  `(tactic|
    (refine Dixon.ext ?_ ?_ ?_ ?_ <;>
      simp [i1, i2, i3, mul, ofColour]))

/-- **`i_1` commutes with every colour element:** `(ofColour x) i_1 = i_1 (ofColour x)`. -/
theorem ofColour_comm_i1 (x : ComplexOctonion) : ofColour x * i1 = i1 * ofColour x := by
  dixon_comm
/-- **`i_2` commutes with every colour element.** -/
theorem ofColour_comm_i2 (x : ComplexOctonion) : ofColour x * i2 = i2 * ofColour x := by
  dixon_comm
/-- **`i_3` commutes with every colour element.** -/
theorem ofColour_comm_i3 (x : ComplexOctonion) : ofColour x * i3 = i3 * ofColour x := by
  dixon_comm

/-- The colour embedding is multiplicative: `ofColour (x*y) = ofColour x * ofColour y`
(the colour factor sits as a subalgebra; note it is NOT commutative). -/
theorem ofColour_mul (x y : ComplexOctonion) :
    ofColour (x * y) = ofColour x * ofColour y := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [ofColour, mul]

/-! ## The payoff: the `H`-units ANTICOMMUTE (the fermionic Clifford structure)

This is the mechanistic reason item 2 needs the `C(x)H` factor. The weak sector
is a `Cl(4)` Clifford algebra whose CAR `{beta_i, beta_j} = 0` requires
ANTICOMMUTING generators. The colour factor alone cannot supply them: the
colour-built ladders give `{beta_1, beta_2} = -1/2` (nonzero,
`WeakBetaLaddersFromColor.beta12_anticommutator_ne_zero`). The `H`-units DO
anticommute - `{i_j, i_k} = 0` for `j != k`, together with `i_j^2 = -1` this is a
`Cl(3)`-type generating set - so the `C(x)H` tensor slot is exactly the missing
fermionic Clifford structure the original no-go (661e5230) demanded. -/

/-- **`{i_1, i_2} = 0`**: the first `H`-units anticommute (`i_1 i_2 = i_3`,
`i_2 i_1 = -i_3`). -/
theorem i1_i2_anticomm : i1 * i2 + i2 * i1 = 0 := by
  rw [i1_i2, i2_i1]; ext <;> simp [i3]
/-- **`{i_2, i_3} = 0`**. -/
theorem i2_i3_anticomm : i2 * i3 + i3 * i2 = 0 := by
  rw [i2_i3]; refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [i1, i2, i3, mul]
/-- **`{i_3, i_1} = 0`**. -/
theorem i3_i1_anticomm : i3 * i1 + i1 * i3 = 0 := by
  rw [i3_i1]; refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [i1, i2, i3, mul]

end Dixon

end PhysicsSM.Draft.NullEdge.DixonAlgebra

/-! ## Build-enforced assumption-footprint guard

The three flagship structural facts - a Hamilton relation, the `H`-unit
anticommutation (the fermionic payoff), and the `H`/colour tensor-commutation -
each on the standard-three axiom base only. -/

/-- info: 'PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.i1_i2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.i1_i2

/-- info: 'PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.i1_i2_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.i1_i2_anticomm

/-- info: 'PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.ofColour_comm_i1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon.ofColour_comm_i1
