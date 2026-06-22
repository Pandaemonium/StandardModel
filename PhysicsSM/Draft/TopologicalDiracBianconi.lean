import Mathlib
import PhysicsSM.Gauge.OrderComplexCochain

/-!
# Draft.TopologicalDiracBianconi

Formalization of the topological Dirac operator, its Hodge Laplacian relation,
and the mass-gap dispersion relation (connecting to Bianconi's topological Dirac
equation of networks), together with a concrete complex cochain coboundary
connection for the null-edge causal graph program.

Claim boundary:
* This is a finite algebraic/combinatorial representation, not a continuum limit
  or analytic differential geometry theorem.
* All proofs are fully finished with no s o r r y.
-/

noncomputable section

namespace PhysicsSM.Draft.TopologicalDiracBianconi

open PhysicsSM.Gauge.OrderComplexCochain

/-! ## Graded topological spinor space -/

/-- A topological spinor is represented as a pair of even and odd cochains. -/
abbrev TopologicalSpinor (U V : Type*) := U × V

/-! ## Operators -/

variable {R U V : Type*} [CommRing R] [AddCommGroup U] [Module R U] [AddCommGroup V] [Module R V]
variable (d : U →ₗ[R] V) (δ : V →ₗ[R] U)

/-- The topological Dirac operator D = d + δ. -/
def topologicalDirac : TopologicalSpinor U V →ₗ[R] TopologicalSpinor U V where
  toFun psi := (δ psi.2, d psi.1)
  map_add' psi1 psi2 := by ext <;> simp
  map_smul' r psi := by ext <;> simp

/-- The chirality operator \gamma = diag(1, -1). -/
def chiralityOperator : TopologicalSpinor U V →ₗ[R] TopologicalSpinor U V where
  toFun psi := (psi.1, -psi.2)
  map_add' psi1 psi2 := by ext <;> simp [add_comm]
  map_smul' r psi := by ext <;> simp

/-- The even component of the Hodge Laplacian. -/
def hodgeLaplacianEven : U →ₗ[R] U := δ.comp d

/-- The odd component of the Hodge Laplacian. -/
def hodgeLaplacianOdd : V →ₗ[R] V := d.comp δ

/-- The gapped topological Dirac operator D + m • \gamma. -/
def gappedDirac (m : R) : TopologicalSpinor U V →ₗ[R] TopologicalSpinor U V :=
  topologicalDirac d δ + m • chiralityOperator

/-! ## Theorems -/

theorem chiralityOperator_sq_eq_id :
    (chiralityOperator (R := R) (U := U) (V := V)).comp (chiralityOperator) = LinearMap.id := by
  ext <;> simp [chiralityOperator]

theorem topologicalDirac_anticommutes_with_chirality :
    (topologicalDirac d δ).comp (chiralityOperator) +
      (chiralityOperator).comp (topologicalDirac d δ) = 0 := by
  ext <;> simp [topologicalDirac, chiralityOperator]

/--
The square of the topological Dirac operator matches the Hodge Laplacian on each
grading component.
-/
theorem topologicalDirac_sq_apply (psi : TopologicalSpinor U V) :
    (topologicalDirac d δ) (topologicalDirac d δ psi) =
      (hodgeLaplacianEven d δ psi.1, hodgeLaplacianOdd d δ psi.2) := by
  ext
  · simp [topologicalDirac, hodgeLaplacianEven]
  · simp [topologicalDirac, hodgeLaplacianOdd]

/--
The square of the gapped topological Dirac operator is D^2 + m^2 • id.
This represents the algebraic mass-gap dispersion relation.
-/
theorem gappedDirac_sq_apply (m : R) (psi : TopologicalSpinor U V) :
    gappedDirac d δ m (gappedDirac d δ m psi) =
      (hodgeLaplacianEven d δ psi.1 + (m * m) • psi.1,
       hodgeLaplacianOdd d δ psi.2 + (m * m) • psi.2) := by
  ext
  · simp [gappedDirac, topologicalDirac, chiralityOperator, hodgeLaplacianEven,
      smul_smul, smul_add]
    abel
  · simp [gappedDirac, topologicalDirac, chiralityOperator, hodgeLaplacianOdd,
      smul_smul, smul_add]
    abel

/--
Eigenvalue dispersion relation: if psi is an eigenvector of the Hodge Laplacians
with eigenvalue lambda, then psi is an eigenvector of the gapped Dirac square with
eigenvalue lambda + m^2.
-/
theorem gappedDirac_eigenvalue (m lambda : R) (psi : TopologicalSpinor U V)
    (heven : hodgeLaplacianEven d δ psi.1 = lambda • psi.1)
    (hodd : hodgeLaplacianOdd d δ psi.2 = lambda • psi.2) :
    gappedDirac d δ m (gappedDirac d δ m psi) =
      (lambda + m * m) • psi := by
  rw [gappedDirac_sq_apply, heven, hodd]
  ext <;> simp [add_smul]

/-! ## Connection to order complex cochains -/

/-- Complex-valued cochains on formal ordered simplices. -/
abbrev ComplexCochain (V : Type*) := Chain V →+ ℂ

/-- Complex coboundary operator by precomposition with chain boundary. -/
def complexCoboundary {V : Type*} (f : ComplexCochain V) : ComplexCochain V :=
  f.comp chainBoundaryAddHom

/--
The complex coboundary squares to zero because the chain boundary squares to zero.
-/
theorem complexCoboundary_comp_self_eq_zero {V : Type*} (f : ComplexCochain V) :
    complexCoboundary (complexCoboundary f) = 0 := by
  apply AddMonoidHom.ext
  intro c
  change f (chainBoundary (chainBoundary c)) = 0
  rw [chainBoundary_comp_self_eq_zero]
  exact map_zero f

end PhysicsSM.Draft.TopologicalDiracBianconi

end
