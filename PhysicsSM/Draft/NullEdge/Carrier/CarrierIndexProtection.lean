import Mathlib

/-!
# Index protection of massless chiral modes: the finite McKean-Singer mechanism

The mass thesis explains what pushes states OFF the light cone; this file formalizes the
converse jewel — what must STAY on it. For a chirality-odd carrier written in Weyl block
form `D = [[0, D₋], [D₊, 0]]` on `M = M₊ ⊕ M₋` (the `Γ = ±1` sectors), the **chiral
index**

>  `ind(D) := dim ker D₊ − dim ker D₋`

counts massless positive-chirality modes minus massless negative-chirality modes (for a
carrier, `ker D₊ = ker D ∩ M₊` is precisely the massless chiral sector). The finite
McKean-Singer mechanism is pure rank-nullity: whenever the two blocks have equal rank,

>  `ind(D) = dim M₊ − dim M₋`,

a number fixed by the complex alone. The rank hypothesis is **automatic** for
* Hilbert-self-adjoint carriers (`D₋ = D₊†`, since `rank f† = rank f` —
  `finrank_range_adjoint`), and
* Krein-self-adjoint carriers (`D₋ = J₊ ∘ D₊† ∘ J₋` with fundamental symmetries `J±`
  invertible, since conjugation by equivalences preserves rank —
  `finrank_range_conj_equiv`) — the case of the null-edge carrier `D^# = D`.

## Physics readout (finite identity, honestly scoped)

**No potential `φ` and no transport `∇` can change the chiral index**: mass generation
can gap chiral modes only in `±` pairs; a surplus `|dim M₊ − dim M₋|` of massless chiral
modes is topologically protected. In the null-edge program this is the complement of the
mass thesis: mass = obstruction to null transport; masslessness (of the protected
surplus) = index theory of the complex. This is the finite-dimensional shadow of the
Atiyah-Singer/McKean-Singer index theorem — `str(e^{−tD²}) = ind(D)` — whose finite
content is exactly the pairing of nonzero-mass² modes across chirality; the heat-kernel
supertrace version (matrix exponential) is deliberately NOT formalized here, only the
`t → ∞` combinatorial core, which is the part with kernel-checkable content on a finite
complex.

Claim labels: everything here is a **finite identity** on finite-dimensional modules.
No continuum limit, no spectral claim, no statement about which physical carrier
realizes which `dim M₊ − dim M₋`.

Provenance: McKean-Singer (1967) "Curvature and the eigenvalues of the Laplacian";
standard folklore finite version (e.g. Getzler-Berline-Vergne, ch. 1 exercises);
clean-room formalization from rank-nullity, no external code.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier

section Core

variable {K : Type*} [DivisionRing K] {Mp Mm : Type*}
  [AddCommGroup Mp] [Module K Mp] [AddCommGroup Mm] [Module K Mm]

/-- The **chiral index** of an odd (Weyl block) operator pair `D₊ : M₊ → M₋`,
`D₋ : M₋ → M₊`: massless positive-chirality modes minus massless negative-chirality
modes, `dim ker D₊ − dim ker D₋ : ℤ`. -/
noncomputable def chiralIndex (Dp : Mp →ₗ[K] Mm) (Dm : Mm →ₗ[K] Mp) : ℤ :=
  (Module.finrank K (LinearMap.ker Dp) : ℤ) - (Module.finrank K (LinearMap.ker Dm) : ℤ)

/-- **Finite McKean-Singer, combinatorial core.** If the two chiral blocks have equal
rank, the chiral index equals the graded dimension `dim M₊ − dim M₋` — a number fixed by
the complex alone. Pure rank-nullity. -/
theorem chiralIndex_eq_graded_dimension
    [FiniteDimensional K Mp] [FiniteDimensional K Mm]
    (Dp : Mp →ₗ[K] Mm) (Dm : Mm →ₗ[K] Mp)
    (hrank : Module.finrank K (LinearMap.range Dp)
      = Module.finrank K (LinearMap.range Dm)) :
    chiralIndex Dp Dm
      = (Module.finrank K Mp : ℤ) - (Module.finrank K Mm : ℤ) := by
  have h1 := LinearMap.finrank_range_add_finrank_ker Dp
  have h2 := LinearMap.finrank_range_add_finrank_ker Dm
  rw [chiralIndex]
  omega

/-- **Index protection.** Two carriers with rank-symmetric blocks — ANY two potentials,
ANY two transports — have the same chiral index: mass generation cannot lift protected
chiral zero modes. -/
theorem chiralIndex_protected
    [FiniteDimensional K Mp] [FiniteDimensional K Mm]
    (Dp Dp' : Mp →ₗ[K] Mm) (Dm Dm' : Mm →ₗ[K] Mp)
    (hrank : Module.finrank K (LinearMap.range Dp)
      = Module.finrank K (LinearMap.range Dm))
    (hrank' : Module.finrank K (LinearMap.range Dp')
      = Module.finrank K (LinearMap.range Dm')) :
    chiralIndex Dp Dm = chiralIndex Dp' Dm' := by
  rw [chiralIndex_eq_graded_dimension Dp Dm hrank,
    chiralIndex_eq_graded_dimension Dp' Dm' hrank']

end Core

section InnerProduct

variable {𝕜 : Type*} [RCLike 𝕜] {E F : Type*}
  [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
  [NormedAddCommGroup F] [InnerProductSpace 𝕜 F]
  [FiniteDimensional 𝕜 E] [FiniteDimensional 𝕜 F]

/-- The kernel of the adjoint is the orthogonal complement of the range (finite
dimensions). -/
theorem ker_adjoint_eq_orthogonal_range (f : E →ₗ[𝕜] F) :
    LinearMap.ker (LinearMap.adjoint f) = (LinearMap.range f)ᗮ := by
  ext x
  rw [LinearMap.mem_ker, Submodule.mem_orthogonal]
  constructor
  · intro h u hu
    obtain ⟨y, rfl⟩ := hu
    rw [← LinearMap.adjoint_inner_right, h, inner_zero_right]
  · intro h
    have h0 : (inner 𝕜 (f (LinearMap.adjoint f x)) x : 𝕜) = 0 :=
      h _ ⟨LinearMap.adjoint f x, rfl⟩
    have h1 : (inner 𝕜 (LinearMap.adjoint f x) (LinearMap.adjoint f x) : 𝕜) = 0 := by
      rw [LinearMap.adjoint_inner_right]
      exact h0
    exact inner_self_eq_zero.mp h1

/-- The adjoint has the same rank as the map (finite dimensions): rank-nullity on the
adjoint plus `dim range + dim rangeᗮ = dim F`. -/
theorem finrank_range_adjoint (f : E →ₗ[𝕜] F) :
    Module.finrank 𝕜 (LinearMap.range (LinearMap.adjoint f))
      = Module.finrank 𝕜 (LinearMap.range f) := by
  have h1 := LinearMap.finrank_range_add_finrank_ker (LinearMap.adjoint f)
  have h2 := Submodule.finrank_add_finrank_orthogonal (LinearMap.range f)
  rw [ker_adjoint_eq_orthogonal_range] at h1
  omega

omit [FiniteDimensional 𝕜 E] [FiniteDimensional 𝕜 F] in
/-- Conjugating by linear equivalences (e.g. fundamental symmetries `J`) preserves
rank. -/
theorem finrank_range_conj_equiv (g : F →ₗ[𝕜] E) (Jpre : F ≃ₗ[𝕜] F) (Jpost : E ≃ₗ[𝕜] E) :
    Module.finrank 𝕜
        (LinearMap.range (Jpost.toLinearMap ∘ₗ g ∘ₗ Jpre.toLinearMap))
      = Module.finrank 𝕜 (LinearMap.range g) := by
  rw [LinearMap.range_comp, LinearMap.range_comp, LinearEquiv.range,
    Submodule.map_top, LinearEquiv.finrank_map_eq]

/-- **Index protection, Hilbert-self-adjoint form.** For the adjoint pair
`(D₊, D₊†)` — the block form of a Hilbert-self-adjoint odd carrier — the chiral index
IS the graded dimension, with no rank hypothesis: it is independent of `D₊`
altogether. -/
theorem chiralIndex_adjoint_pair (Dp : E →ₗ[𝕜] F) :
    chiralIndex Dp (LinearMap.adjoint Dp)
      = (Module.finrank 𝕜 E : ℤ) - (Module.finrank 𝕜 F : ℤ) :=
  chiralIndex_eq_graded_dimension Dp (LinearMap.adjoint Dp)
    (finrank_range_adjoint Dp).symm

/-- **Index protection, Krein-self-adjoint form.** For the Krein-adjoint pair
`(D₊, J_E ∘ D₊† ∘ J_F)` with invertible fundamental symmetries `J` — the block form of
a KREIN-self-adjoint odd carrier, the null-edge case — the chiral index is again the
graded dimension, independent of `D₊`, `φ`, `∇`, and of the `J`s. -/
theorem chiralIndex_krein_pair (Dp : E →ₗ[𝕜] F) (JE : E ≃ₗ[𝕜] E) (JF : F ≃ₗ[𝕜] F) :
    chiralIndex Dp (JE.toLinearMap ∘ₗ LinearMap.adjoint Dp ∘ₗ JF.toLinearMap)
      = (Module.finrank 𝕜 E : ℤ) - (Module.finrank 𝕜 F : ℤ) :=
  chiralIndex_eq_graded_dimension Dp _
    (by rw [finrank_range_conj_equiv, finrank_range_adjoint])

end InnerProduct

end PhysicsSM.Draft.NullEdge.Carrier
