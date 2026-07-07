import Mathlib

/-!
# Finite Kugo-Ojima

This module is a clean-room finite-dimensional formalization of the
Kugo-Ojima quartet mechanism as linear algebra over `Complex`.

We work on `V := EuclideanSpace Complex (Fin n)`.  A fundamental symmetry is a
linear map `J : V -> V` with `J * J = id`; it twists the Hilbert inner product
into the Krein form

`kreinForm J x y = inner Complex x (J y)`.

The Krein adjoint is `A# = J * adjoint(A) * J`.  The main result is the finite
quartet-completeness identity: for a nilpotent Krein-self-adjoint charge `Q`,
the radical of the Krein form restricted to `ker Q` is exactly `range Q`, and
the induced form on `ker Q / range Q` is nondegenerate.  Positivity of that
induced form is deliberately not claimed here.

Provenance: Aristotle project `38eeb1a6-e465-46b5-bb9a-21e5c490a104`, task
`5d6b94e8-1b32-4795-aa1a-cbc90fc61de3`, clean-room formalization from
finite-dimensional linear algebra, with style context from
`PhysicsSM/Draft/NullEdge/Carrier/CarrierIndexProtection.lean`.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.KugoOjima

variable {n : ℕ}

local notation "V" => EuclideanSpace ℂ (Fin n)

/-- The Krein form `B x y = <x, J y>` twisted by the fundamental symmetry `J`. -/
noncomputable def kreinForm (J : V →ₗ[ℂ] V) (x y : V) : ℂ :=
  inner ℂ x (J y)

/-- The Krein adjoint `A# = J * adjoint(A) * J`. -/
noncomputable def kreinAdjoint (J A : V →ₗ[ℂ] V) : V →ₗ[ℂ] V :=
  J ∘ₗ LinearMap.adjoint A ∘ₗ J

/-- The `B`-orthogonal of a submodule `S`: `{x | forall v in S, B v x = 0}`. -/
noncomputable def orthoB (J : V →ₗ[ℂ] V) (S : Submodule ℂ V) : Submodule ℂ V :=
  Submodule.comap J Sᗮ

/-- Membership in the `B`-orthogonal unfolds to the stated pairing condition. -/
theorem mem_orthoB (J : V →ₗ[ℂ] V) (S : Submodule ℂ V) (x : V) :
    x ∈ orthoB J S ↔ ∀ v ∈ S, kreinForm J v x = 0 := by
  simp only [orthoB, Submodule.mem_comap, Submodule.mem_orthogonal, kreinForm]

/-- The Krein adjunction identity `B (A x) y = B x (A# y)`. -/
theorem krein_adjoint_pairing (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (A : V →ₗ[ℂ] V) (x y : V) :
    kreinForm J (A x) y = kreinForm J x (kreinAdjoint J A y) := by
  have hJJ : ∀ z, J (J z) = z := by
    exact fun z => LinearMap.congr_fun hJinv z
  unfold kreinForm kreinAdjoint
  simp +decide [hJJ, LinearMap.adjoint_inner_right]

/-- `J`, packaged as a linear equivalence via `J * J = id`. -/
noncomputable def Jequiv (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id) :
    V ≃ₗ[ℂ] V :=
  LinearEquiv.ofLinear J J hJinv hJinv

/-- The dimension of the `B`-orthogonal of `S` is the Hilbert codimension of `S`. -/
theorem finrank_orthoB (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (S : Submodule ℂ V) :
    Module.finrank ℂ (orthoB J S) = n - Module.finrank ℂ S := by
  have h_orthoB :
      Module.finrank ℂ (Submodule.comap J Sᗮ) = Module.finrank ℂ Sᗮ := by
    have h_orthoB :
        Submodule.comap J Sᗮ =
          Submodule.map (Jequiv J hJinv).symm.toLinearMap Sᗮ := by
      convert Submodule.comap_equiv_eq_map_symm (Jequiv J hJinv) Sᗮ
    convert LinearEquiv.finrank_map_eq _ _
    rw [h_orthoB]
  have := Submodule.finrank_add_finrank_orthogonal S
  simp_all +decide
  exact eq_tsub_of_add_eq (by linarith!)

/-- The Krein adjoint has the same rank as the original map. -/
theorem finrank_range_kreinAdjoint (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (A : V →ₗ[ℂ] V) :
    Module.finrank ℂ (LinearMap.range (kreinAdjoint J A))
      = Module.finrank ℂ (LinearMap.range A) := by
  have h_range :
      LinearMap.range (J ∘ₗ LinearMap.adjoint A ∘ₗ J) =
        Submodule.map J (LinearMap.range (LinearMap.adjoint A)) := by
    simp +decide [LinearMap.range_comp]
    rw [show J.range = ⊤ by
      exact LinearMap.range_eq_top.mpr <|
        LinearMap.surjective_of_comp_eq_id _ _ hJinv]
    aesop
  have h_rank_eq :
      Module.finrank ℂ (LinearMap.range (LinearMap.adjoint A)) =
        Module.finrank ℂ (LinearMap.range A) := by
    have h_rank_eq : LinearMap.ker (LinearMap.adjoint A) = (LinearMap.range A)ᗮ := by
      ext
      simp [LinearMap.adjoint]
      simp +decide [Submodule.mem_orthogonal, ContinuousLinearMap.adjoint]
      simp +decide [ContinuousLinearMap.ext_iff]
      simp +decide [inner_eq_zero_symm]
    have := LinearMap.finrank_range_add_finrank_ker (LinearMap.adjoint A)
    have := Submodule.finrank_add_finrank_orthogonal (LinearMap.range A)
    simp_all +decide
    rw [h_rank_eq] at *
    linarith
  convert congr_arg
      (fun x : Submodule ℂ (EuclideanSpace ℂ (Fin n)) => Module.finrank ℂ x)
      h_range using 1
  convert h_rank_eq.symm using 1
  convert LinearEquiv.finrank_map_eq
    (Jequiv J hJinv) (LinearMap.range (LinearMap.adjoint A)) using 1

/-- The `B`-orthogonal of `ker A` is exactly `range A#`. -/
theorem orthoB_ker_eq_range (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (A : V →ₗ[ℂ] V) :
    orthoB J (LinearMap.ker A) = LinearMap.range (kreinAdjoint J A) := by
  refine' (Submodule.eq_of_le_of_finrank_le _ _).symm
  · intro y hy
    obtain ⟨w, rfl⟩ := hy
    simp [mem_orthoB]
    intro v hv
    have := krein_adjoint_pairing J hJinv A v w
    simp_all +decide [kreinForm]
  · rw [finrank_orthoB J hJinv, finrank_range_kreinAdjoint J hJinv]
    have := LinearMap.finrank_range_add_finrank_ker A
    aesop

/-- A nilpotent charge satisfies `range Q <= ker Q`. -/
theorem kugo_ojima_range_le_ker (Q : V →ₗ[ℂ] V) (hQ2 : Q ∘ₗ Q = 0) :
    LinearMap.range Q ≤ LinearMap.ker Q := by
  exact fun x hx => by
    obtain ⟨y, rfl⟩ := hx
    exact LinearMap.congr_fun hQ2 y

/-- For a nilpotent Krein-self-adjoint charge, the restricted radical is `range Q`. -/
theorem kugo_ojima_radical (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (Q : V →ₗ[ℂ] V) (hQ2 : Q ∘ₗ Q = 0) (hQadj : kreinAdjoint J Q = Q) :
    LinearMap.ker Q ⊓ orthoB J (LinearMap.ker Q) = LinearMap.range Q := by
  have h := orthoB_ker_eq_range J hJinv Q
  rw [h, hQadj, inf_eq_right.mpr (kugo_ojima_range_le_ker Q hQ2)]

/-- Nondegeneracy of the induced Krein form on `ker Q / range Q`, in representative
form. -/
theorem kugo_ojima_nondegenerate (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (Q : V →ₗ[ℂ] V) (hQ2 : Q ∘ₗ Q = 0) (hQadj : kreinAdjoint J Q = Q)
    (x : V) (hx : x ∈ LinearMap.ker Q) (hxr : x ∉ LinearMap.range Q) :
    ∃ y ∈ LinearMap.ker Q, kreinForm J y x ≠ 0 := by
  contrapose! hxr
  have := kugo_ojima_radical J hJinv Q hQ2 hQadj
  simp_all +decide [Submodule.ext_iff]
  exact this x |>.1 ⟨hx, by
    rw [mem_orthoB]
    tauto⟩

/-- **Finite Kugo-Ojima.** For a nilpotent Krein-self-adjoint charge `Q`, `range Q`
lies in `ker Q`, the radical of `B` restricted to `ker Q` is exactly `range Q`,
and the induced form on cohomology is nondegenerate.  Positivity is not claimed. -/
theorem finite_kugo_ojima (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (Q : V →ₗ[ℂ] V) (hQ2 : Q ∘ₗ Q = 0) (hQadj : kreinAdjoint J Q = Q) :
    LinearMap.range Q ≤ LinearMap.ker Q ∧
    LinearMap.ker Q ⊓ orthoB J (LinearMap.ker Q) = LinearMap.range Q ∧
    (∀ x ∈ LinearMap.ker Q, x ∉ LinearMap.range Q →
      ∃ y ∈ LinearMap.ker Q, kreinForm J y x ≠ 0) :=
  ⟨kugo_ojima_range_le_ker Q hQ2, kugo_ojima_radical J hJinv Q hQ2 hQadj,
    fun x hx hxr => kugo_ojima_nondegenerate J hJinv Q hQ2 hQadj x hx hxr⟩

/-- A `J`-unitary commuting with `Q` preserves `ker Q`, preserves `range Q`, and
preserves the Krein form on representatives. -/
theorem descent_unitary (J : V →ₗ[ℂ] V) (hJinv : J ∘ₗ J = LinearMap.id)
    (Q : V →ₗ[ℂ] V) (U : V →ₗ[ℂ] V)
    (hUunit : kreinAdjoint J U ∘ₗ U = LinearMap.id) (hUQ : U ∘ₗ Q = Q ∘ₗ U) :
    (∀ x ∈ LinearMap.ker Q, U x ∈ LinearMap.ker Q) ∧
    (∀ y ∈ LinearMap.range Q, U y ∈ LinearMap.range Q) ∧
    (∀ x y : V, kreinForm J (U x) (U y) = kreinForm J x y) := by
  refine' ⟨_, _, _⟩
  · intro x hx
    replace hUQ := LinearMap.congr_fun hUQ x
    aesop
  · simp_all +decide [LinearMap.ext_iff]
  · intro x y
    have := krein_adjoint_pairing J hJinv U x (U y)
    simp_all +decide [LinearMap.ext_iff]

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.finite_kugo_ojima' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_kugo_ojima

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.orthoB_ker_eq_range' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orthoB_ker_eq_range

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.descent_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms descent_unitary

end PhysicsSM.Draft.NullEdge.Carrier.KugoOjima
