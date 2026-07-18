import LorentzComponentCharacter.Core

/-!
# Eta-Lorentz structure group and component characters

Focused follow-up package.  The target is to bundle eta-preserving matrices as
a subgroup of `GL(4, Real)`, lift every matrix satisfying the eta identity into
that subgroup, and package the already-proved time and determinant signs as
honest homomorphisms to `Multiplicative (ZMod 2)`.
-/

namespace LorentzComponentCharacter.AtlasStructureGroup

open Matrix
open LorentzComponentCharacter

noncomputable section

/-- The two-element additive group, read multiplicatively. -/
abbrev ComponentGroup := Multiplicative (ZMod 2)

/-- Eta-preserving invertible four-by-four real matrices. -/
def EtaLorentzGroup : Subgroup (GL (Fin 4) Real) where
  carrier := {g | IsEtaLorentz (g : Matrix (Fin 4) (Fin 4) Real)}
  one_mem' := by
    sorry
  mul_mem' := by
    intro g h hg hh
    sorry
  inv_mem' := by
    intro g hg
    sorry

/-- The underlying concrete matrix of a bundled eta-Lorentz element. -/
def toMatrix (g : EtaLorentzGroup) : Matrix (Fin 4) (Fin 4) Real :=
  (g.1 : Matrix (Fin 4) (Fin 4) Real)

@[simp]
theorem toMatrix_one :
    toMatrix (1 : EtaLorentzGroup) = 1 := by
  rfl

@[simp]
theorem toMatrix_mul (g h : EtaLorentzGroup) :
    toMatrix (g * h) = toMatrix g * toMatrix h := by
  rfl

/-- Every bundled element satisfies the eta-Lorentz identity. -/
theorem toMatrix_isEtaLorentz (g : EtaLorentzGroup) :
    IsEtaLorentz (toMatrix g) := by
  exact g.property

/-- The explicit inverse supplied by eta-orthogonality. -/
def matrixUnitOfIsEtaLorentz
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    GL (Fin 4) Real := by
  let Minv := eta * M.transpose * eta
  have hinv_mul : Minv * M = 1 := by
    sorry
  exact {
    val := M
    inv := Minv
    val_inv := mul_eq_one_comm.mp hinv_mul
    inv_val := hinv_mul }

/-- Canonical lift of any eta-preserving matrix into the structure group. -/
def ofMatrix (M : Matrix (Fin 4) (Fin 4) Real)
    (hM : IsEtaLorentz M) : EtaLorentzGroup := by
  let g := matrixUnitOfIsEtaLorentz M hM
  exact ⟨g, by simpa [g, matrixUnitOfIsEtaLorentz] using hM⟩

@[simp]
theorem toMatrix_ofMatrix
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    toMatrix (ofMatrix M hM) = M := by
  rfl

/-- Time orientation as a group character. -/
def timeCharacter : MonoidHom EtaLorentzGroup ComponentGroup where
  toFun g := Multiplicative.ofAdd (timeSign (toMatrix g))
  map_one' := by
    sorry
  map_mul' := by
    intro g h
    sorry

/-- Determinant orientation as a group character. -/
def determinantCharacter : MonoidHom EtaLorentzGroup ComponentGroup where
  toFun g := Multiplicative.ofAdd (determinantSign (toMatrix g))
  map_one' := by
    sorry
  map_mul' := by
    intro g h
    sorry

/-- The time character is trivial exactly on the future-preserving component. -/
theorem timeCharacter_eq_one_iff (g : EtaLorentzGroup) :
    timeCharacter g = 1 <-> 0 <= toMatrix g 0 0 := by
  sorry

/-- The determinant character is trivial exactly on the nonnegative
determinant component. -/
theorem determinantCharacter_eq_one_iff (g : EtaLorentzGroup) :
    determinantCharacter g = 1 <-> 0 <= (toMatrix g).det := by
  sorry

end

end LorentzComponentCharacter.AtlasStructureGroup
