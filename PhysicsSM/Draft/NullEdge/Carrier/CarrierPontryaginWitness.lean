import PhysicsSM.Draft.NullEdge.Carrier.CarrierFlatSectorPositivity

/-!
# The kappa = 2 Pontryagin witness: certified Krein positivity on the flat sector

This file closes the convergence point flagged across Fable call-03, the M4 witness
handoff (Aristotle project `578f32e6`, `M4_PAULI_PONTRYAGIN_WITNESS_HANDOFF_2026-07-07.md`),
and both Codex review-flags on `CarrierFlatSectorPositivity`: the abstract flat-sector
bricks (`flat_sector_positivity`, `kreinForm_hermitian`) were CONDITIONAL on `Γ` being a
genuine fundamental symmetry with positive inertia, and no kernel-checked model supplied
one. Here we build that model explicitly on `V := ℂ⁴ = ℂ² ⊗ ℂ²` (spinor `⊗` transport):

* `Γ = σz ⊗ I = diag(1,1,-1,-1)` — **certified fundamental symmetry**: self-adjoint
  (`Gamma_selfAdjoint`), an involution (`Gamma_involutive`), with inertia `(2,2)` —
  both eigenspaces exactly 2-dimensional (`finrank_eigenspace_plus`,
  `finrank_eigenspace_minus`), so `κ = 2 > 0`: the Pontryagin `Π₂` reading of Fable
  call-03, NOT the vacuous `κ = 0` Hilbert case and NOT the trivial definite case.
* `γ₀ = i(σx ⊗ I)`, `γ₁ = i(σy ⊗ I)` — the anti-Hermitian gammas of the corrected M4
  model (carried for fidelity to the handoff data; the flat-sector bricks consume no
  Clifford hypotheses, see honesty note below).
* `∇₀ = ∇₁ = diag(0,0,1,1)` — null transport whose flat sector is EXACTLY the `Γ = +1`
  chirality sector: the transport obstruction is concentrated on the negative-chirality
  half, and every chiral-positive state is flat.
* `φ = c • 1`, `c ≠ 0` — the uniform turn/potential of the handoff.

Headline results:

* `witness_mass_form_strictly_positive`: on the (nonzero) flat chiral-positive state
  `ψ₀` the Krein mass form evaluates to `|c|²` and is **strictly positive** — the first
  kernel-checked strictly-positive mass-form value in the program, with every
  ingredient explicit and the fundamental symmetry certified rather than hypothesized.
* `witness_two_dim_nonneg_sector`: the mass form is nonnegative on the whole
  2-dimensional flat chirality-positive subspace `span{ψ₀, ψ₁}` — the finite witness
  form of the `exists_nonneg_mass_subspace` endgame item (a `κ`-dimensional nonnegative
  subspace, here realized concretely with `κ = 2`).

## Scope / honesty (draft)

* This file certifies the **flat-sector** positivity instantiation. The off-flat
  forward-sector positivity (CRACK 3) remains OPEN.
* The 8-hypothesis GLUE witness (all Move-1 hypotheses + `Q_A/Q_C/Q_T` simultaneously
  nonzero, needing the non-flat `∇ = I ⊗ σ` model whose flat sector is trivial) is a
  SEPARATE open target (`WITNESS_SATISFIABILITY.md`); this file does not claim it. The
  two witnesses genuinely differ: a model with all slots active has empty flat sector,
  so the positivity witness must (and does) redistribute the transport obstruction.
* The gammas are definitions only; no Clifford relation is stated here, because the
  flat-sector bricks do not consume one — claiming more would be docstring-outrunning-
  kernel.

Provenance: Fable call-03 (J := Γ chirality as fundamental symmetry, inertia (2,2),
κ = 2); M4 Pauli witness handoff (corrected data); clean-room formalization, standard
Pauli/Kronecker conventions with block index `2·s + t` (s = spinor, t = transport).
-/

open scoped BigOperators InnerProductSpace ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.Carrier

namespace PontryaginWitness

/-- The witness space: `ℂ⁴ = ℂ² ⊗ ℂ²` (spinor factor `⊗` transport factor) with its
Euclidean Hilbert inner product, indexed by `2·s + t`. -/
abbrev V : Type := EuclideanSpace ℂ (Fin 4)

/-- The chirality matrix `σz ⊗ I = diag(1,1,-1,-1)`. -/
noncomputable def GammaMat : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal ![1, 1, -1, -1]

/-- The chirality operator `Γ` — the candidate fundamental symmetry `J := Γ` of
Fable call-03. -/
noncomputable def Gamma : V →ₗ[ℂ] V := Matrix.toEuclideanLin GammaMat

/-- The null-transport matrix `diag(0,0,1,1)`: kernel = the `Γ = +1` chirality
sector. -/
noncomputable def nablaMat : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal ![0, 0, 1, 1]

/-- Two null edges, both carrying the transport `diag(0,0,1,1)` — the flat sector is
exactly the positive-chirality half. -/
noncomputable def nabla : Fin 2 → (V →ₗ[ℂ] V) := fun _ => Matrix.toEuclideanLin nablaMat

/-- The anti-Hermitian gammas of the corrected M4 model: `γ₀ = i(σx ⊗ I)`,
`γ₁ = i(σy ⊗ I)` (carried for model fidelity; no Clifford hypothesis is consumed by the
flat-sector bricks). -/
noncomputable def gammaE : Fin 2 → (V →ₗ[ℂ] V) :=
  ![Matrix.toEuclideanLin !![0, 0, Complex.I, 0; 0, 0, 0, Complex.I;
      Complex.I, 0, 0, 0; 0, Complex.I, 0, 0],
    Matrix.toEuclideanLin !![0, 0, 1, 0; 0, 0, 0, 1; -1, 0, 0, 0; 0, -1, 0, 0]]

/-- The uniform turn/potential `φ = c • 1` of the M4 handoff. -/
noncomputable def phi (c : ℂ) : V →ₗ[ℂ] V := c • LinearMap.id

/-- `ψ₀ = e₀`: flat, chirality-positive, nonzero. -/
noncomputable def psi0 : V := EuclideanSpace.single 0 1

/-- `ψ₁ = e₁`: the second flat chirality-positive basis state. -/
noncomputable def psi1 : V := EuclideanSpace.single 1 1

/-- `χ₀ = e₂`: a chirality-negative basis state (for the inertia count). -/
noncomputable def chi0 : V := EuclideanSpace.single 2 1

/-- `χ₁ = e₃`: the second chirality-negative basis state. -/
noncomputable def chi1 : V := EuclideanSpace.single 3 1

/-! ## Diagonal action on basis states -/

/-- Local bridge (the corresponding Mathlib lemma is deprecated in this pin):
components of a matrix-induced Euclidean map are `mulVec` components. -/
theorem ofLp_toEuclideanLin (M : Matrix (Fin 4) (Fin 4) ℂ) (v : V) :
    (Matrix.toEuclideanLin M v).ofLp = M.mulVec v.ofLp := rfl

/-- A diagonal matrix acts on a standard basis vector by scaling with the matching
diagonal entry. -/
theorem toEuclideanLin_diagonal_single (d : Fin 4 → ℂ) (i : Fin 4) (a : ℂ) :
    Matrix.toEuclideanLin (Matrix.diagonal d) (EuclideanSpace.single i a)
      = EuclideanSpace.single i (d i * a) := by
  ext j
  rw [ofLp_toEuclideanLin, Matrix.mulVec_diagonal,
    EuclideanSpace.single_apply, EuclideanSpace.single_apply]
  by_cases h : j = i
  · subst h; simp
  · simp [h]

/-- Negation passes through `EuclideanSpace.single` in the value slot. -/
theorem single_neg_val (i : Fin 4) :
    EuclideanSpace.single i (-1 : ℂ) = -EuclideanSpace.single i 1 := by
  ext j
  by_cases h : j = i <;> simp [EuclideanSpace.single_apply, h]

theorem Gamma_psi0 : Gamma psi0 = psi0 := by
  rw [Gamma, psi0, GammaMat, toEuclideanLin_diagonal_single]
  norm_num

theorem Gamma_psi1 : Gamma psi1 = psi1 := by
  rw [Gamma, psi1, GammaMat, toEuclideanLin_diagonal_single]
  norm_num

theorem Gamma_chi0 : Gamma chi0 = -chi0 := by
  rw [Gamma, chi0, GammaMat, toEuclideanLin_diagonal_single]
  norm_num [show (![1, 1, -1, -1] : Fin 4 → ℂ) 2 = -1 from rfl, single_neg_val]

theorem Gamma_chi1 : Gamma chi1 = -chi1 := by
  rw [Gamma, chi1, GammaMat, toEuclideanLin_diagonal_single]
  norm_num [show (![1, 1, -1, -1] : Fin 4 → ℂ) 3 = -1 from rfl, single_neg_val]

theorem nabla_psi0 : ∀ e, nabla e psi0 = 0 := by
  intro e
  rw [nabla, psi0, nablaMat, toEuclideanLin_diagonal_single]
  norm_num

theorem nabla_psi1 : ∀ e, nabla e psi1 = 0 := by
  intro e
  rw [nabla, psi1, nablaMat, toEuclideanLin_diagonal_single]
  norm_num

theorem psi0_ne_zero : psi0 ≠ 0 := by
  rw [psi0]
  intro h
  have h0 := congrArg (fun v : V => v.ofLp 0) h
  simp [EuclideanSpace.single_apply] at h0

/-! ## Γ is a certified fundamental symmetry: self-adjoint involution, inertia (2,2) -/

theorem GammaMat_conjTranspose : GammaMat.conjTranspose = GammaMat := by
  rw [GammaMat, Matrix.diagonal_conjTranspose]
  congr 1
  funext i
  fin_cases i <;> simp

/-- **Γ is self-adjoint** — the first fundamental-symmetry axiom, certified. -/
theorem Gamma_selfAdjoint : LinearMap.adjoint Gamma = Gamma := by
  rw [Gamma, ← Matrix.toEuclideanLin_conjTranspose_eq_adjoint, GammaMat_conjTranspose]

theorem GammaMat_sq : GammaMat * GammaMat = 1 := by
  rw [GammaMat, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one]
  congr 1
  funext i
  fin_cases i <;> norm_num

/-- **Γ is an involution** — the second fundamental-symmetry axiom, certified. -/
theorem Gamma_involutive : Gamma ∘ₗ Gamma = LinearMap.id := by
  apply LinearMap.ext
  intro x
  ext j
  rw [LinearMap.comp_apply, LinearMap.id_apply, Gamma,
    ofLp_toEuclideanLin, ofLp_toEuclideanLin,
    Matrix.mulVec_mulVec, GammaMat_sq, Matrix.one_mulVec]

/-- The `+1` and `-1` chirality eigenspaces are disjoint (hand-rolled: a vector fixed
and negated by `Γ` satisfies `2x = 0`, hence vanishes over `ℂ`). -/
theorem eigenspace_disjoint :
    Disjoint (Module.End.eigenspace Gamma 1) (Module.End.eigenspace Gamma (-1)) := by
  rw [Submodule.disjoint_def]
  intro x h1 h2
  rw [Module.End.mem_eigenspace_iff] at h1 h2
  have h1' : Gamma x = x := by simpa using h1
  have h2' : Gamma x = -x := by simpa [neg_smul] using h2
  have hx : x = -x := h1'.symm.trans h2'
  have h2x : (2 : ℂ) • x = 0 := by
    rw [two_smul]
    nth_rewrite 2 [hx]
    exact add_neg_cancel x
  exact (smul_eq_zero.mp h2x).resolve_left two_ne_zero

theorem linearIndependent_psi : LinearIndependent ℂ ![psi0, psi1] := by
  rw [LinearIndependent.pair_iff]
  intro s t h
  have h0 := congrArg (fun v : V => v.ofLp 0) h
  have h1 := congrArg (fun v : V => v.ofLp 1) h
  simp [psi0, psi1, EuclideanSpace.single_apply] at h0 h1
  exact ⟨h0, h1⟩

theorem linearIndependent_chi : LinearIndependent ℂ ![chi0, chi1] := by
  rw [LinearIndependent.pair_iff]
  intro s t h
  have h0 := congrArg (fun v : V => v.ofLp 2) h
  have h1 := congrArg (fun v : V => v.ofLp 3) h
  simp [chi0, chi1, EuclideanSpace.single_apply] at h0 h1
  exact ⟨h0, h1⟩

theorem span_psi_le_eigenspace_plus :
    Submodule.span ℂ (Set.range ![psi0, psi1]) ≤ Module.End.eigenspace Gamma 1 := by
  rw [Submodule.span_le]
  rintro x ⟨i, rfl⟩
  fin_cases i <;> simp [Gamma_psi0, Gamma_psi1]

theorem span_chi_le_eigenspace_minus :
    Submodule.span ℂ (Set.range ![chi0, chi1]) ≤ Module.End.eigenspace Gamma (-1) := by
  rw [Submodule.span_le]
  rintro x ⟨i, rfl⟩
  fin_cases i <;> simp [Gamma_chi0, Gamma_chi1, neg_smul]

theorem two_le_finrank_eigenspace_plus :
    2 ≤ Module.finrank ℂ (Module.End.eigenspace Gamma 1) := by
  have h := finrank_span_eq_card linearIndependent_psi
  calc 2 = Module.finrank ℂ (Submodule.span ℂ (Set.range ![psi0, psi1])) := by
        rw [h]; simp
    _ ≤ Module.finrank ℂ (Module.End.eigenspace Gamma 1) :=
        Submodule.finrank_mono span_psi_le_eigenspace_plus

theorem two_le_finrank_eigenspace_minus :
    2 ≤ Module.finrank ℂ (Module.End.eigenspace Gamma (-1)) := by
  have h := finrank_span_eq_card linearIndependent_chi
  calc 2 = Module.finrank ℂ (Submodule.span ℂ (Set.range ![chi0, chi1])) := by
        rw [h]; simp
    _ ≤ Module.finrank ℂ (Module.End.eigenspace Gamma (-1)) :=
        Submodule.finrank_mono span_chi_le_eigenspace_minus

/-- The two chirality eigenspaces cannot exceed the ambient dimension 4 in total. -/
theorem finrank_eigenspace_sum_le :
    Module.finrank ℂ (Module.End.eigenspace Gamma 1)
      + Module.finrank ℂ (Module.End.eigenspace Gamma (-1)) ≤ 4 := by
  have hdim := Submodule.finrank_sup_add_finrank_inf_eq
    (Module.End.eigenspace Gamma 1) (Module.End.eigenspace Gamma (-1))
  have hbot : Module.End.eigenspace Gamma 1 ⊓ Module.End.eigenspace Gamma (-1) = ⊥ :=
    disjoint_iff.mp eigenspace_disjoint
  have hle : Module.finrank ℂ
      ↥(Module.End.eigenspace Gamma 1 ⊔ Module.End.eigenspace Gamma (-1)) ≤ 4 := by
    have h := Submodule.finrank_le
      (Module.End.eigenspace Gamma 1 ⊔ Module.End.eigenspace Gamma (-1))
    simpa [finrank_euclideanSpace_fin] using h
  rw [hbot] at hdim
  simp only [finrank_bot, add_zero] at hdim
  omega

/-- **Inertia, positive part: the `Γ = +1` eigenspace is exactly 2-dimensional.**
Together with `finrank_eigenspace_minus` this certifies inertia `(2,2)`, hence
Pontryagin index `κ = 2 > 0` — the non-vacuous indefinite reading of Fable call-03. -/
theorem finrank_eigenspace_plus :
    Module.finrank ℂ (Module.End.eigenspace Gamma 1) = 2 := by
  have h1 := two_le_finrank_eigenspace_plus
  have h2 := two_le_finrank_eigenspace_minus
  have h3 := finrank_eigenspace_sum_le
  omega

/-- **Inertia, negative part: the `Γ = -1` eigenspace is exactly 2-dimensional.** -/
theorem finrank_eigenspace_minus :
    Module.finrank ℂ (Module.End.eigenspace Gamma (-1)) = 2 := by
  have h1 := two_le_finrank_eigenspace_plus
  have h2 := two_le_finrank_eigenspace_minus
  have h3 := finrank_eigenspace_sum_le
  omega

/-! ## The certified positivity instantiation -/

theorem phi_comm (c : ℂ) : Gamma ∘ₗ phi c = phi c ∘ₗ Gamma := by
  rw [phi]
  ext x
  simp

/-- **Certified strict Krein positivity on the flat sector (the witness headline).**
On the explicit model — `Γ` a CERTIFIED fundamental symmetry (self-adjoint involution
of inertia `(2,2)`, `κ = 2`) — the Krein mass form of the carrier on the flat
chirality-positive state `ψ₀` equals `|c|²` and is strictly positive. This is the
instantiation of `flat_sector_positivity` + `kreinForm_hermitian` that both Codex
review-flags identified as the missing step from "conditional form identity" to
"certified Krein positivity". -/
theorem witness_mass_form_strictly_positive (c : ℂ) (hc : c ≠ 0) :
    kreinForm Gamma (carrierOp gammaE nabla Gamma (phi c) psi0)
        (carrierOp gammaE nabla Gamma (phi c) psi0) = (Complex.normSq c : ℂ)
    ∧ 0 < (kreinForm Gamma (carrierOp gammaE nabla Gamma (phi c) psi0)
        (carrierOp gammaE nabla Gamma (phi c) psi0)).re := by
  obtain ⟨hval, -⟩ :=
    flat_sector_positivity gammaE nabla Gamma (phi c) (phi_comm c) psi0 nabla_psi0 Gamma_psi0
  have hpsi : (inner ℂ psi0 psi0 : ℂ) = 1 := by
    rw [psi0]
    simp
  have hinner : (inner ℂ (phi c psi0) (phi c psi0) : ℂ) = (Complex.normSq c : ℂ) := by
    rw [phi]
    simp only [LinearMap.smul_apply, LinearMap.id_apply]
    rw [inner_smul_left, inner_smul_right, hpsi, mul_one, mul_comm, Complex.mul_conj]
  have hform : kreinForm Gamma (carrierOp gammaE nabla Gamma (phi c) psi0)
      (carrierOp gammaE nabla Gamma (phi c) psi0) = (Complex.normSq c : ℂ) := by
    rw [kreinForm, hval, hinner]
  refine ⟨hform, ?_⟩
  rw [hform]
  simpa using Complex.normSq_pos.mpr hc

/-- **The 2-dimensional certified-nonnegative mass subspace.**  On the whole flat
chirality-positive plane `span{ψ₀, ψ₁}` (dimension 2 = κ) the Krein mass form of the
carrier is nonnegative — the concrete finite realization of the
`exists_nonneg_mass_subspace` endgame item. -/
theorem witness_two_dim_nonneg_sector (c : ℂ) :
    Module.finrank ℂ (Submodule.span ℂ (Set.range ![psi0, psi1])) = 2
    ∧ ∀ ψ ∈ Submodule.span ℂ (Set.range ![psi0, psi1]),
        0 ≤ (kreinForm Gamma (carrierOp gammaE nabla Gamma (phi c) ψ)
              (carrierOp gammaE nabla Gamma (phi c) ψ)).re := by
  constructor
  · rw [finrank_span_eq_card linearIndependent_psi]; simp
  · intro ψ hψ
    have hflat : ∀ e, nabla e ψ = 0 := by
      intro e
      have hker : Submodule.span ℂ (Set.range ![psi0, psi1]) ≤ LinearMap.ker (nabla e) := by
        rw [Submodule.span_le]
        rintro x ⟨i, rfl⟩
        fin_cases i <;> simp [LinearMap.mem_ker, nabla_psi0 e, nabla_psi1 e]
      exact hker hψ
    have hchi : Gamma ψ = ψ := by
      have hmem := span_psi_le_eigenspace_plus hψ
      rw [Module.End.mem_eigenspace_iff] at hmem
      simpa using hmem
    obtain ⟨-, hre⟩ :=
      flat_sector_positivity gammaE nabla Gamma (phi c) (phi_comm c) ψ hflat hchi
    exact hre

/-- **The certificate bundle** — everything Fable call-03 required of the fundamental
symmetry, packaged: `Γ` self-adjoint, involutive, inertia `(2,2)` (so `κ = 2 > 0`), a
nonzero flat chiral-positive state, and strict positivity of the Krein mass form on it. -/
theorem certified_krein_positivity (c : ℂ) (hc : c ≠ 0) :
    LinearMap.adjoint Gamma = Gamma
    ∧ Gamma ∘ₗ Gamma = LinearMap.id
    ∧ Module.finrank ℂ (Module.End.eigenspace Gamma 1) = 2
    ∧ Module.finrank ℂ (Module.End.eigenspace Gamma (-1)) = 2
    ∧ psi0 ≠ 0
    ∧ Gamma psi0 = psi0
    ∧ (∀ e, nabla e psi0 = 0)
    ∧ 0 < (kreinForm Gamma (carrierOp gammaE nabla Gamma (phi c) psi0)
            (carrierOp gammaE nabla Gamma (phi c) psi0)).re :=
  ⟨Gamma_selfAdjoint, Gamma_involutive, finrank_eigenspace_plus, finrank_eigenspace_minus,
    psi0_ne_zero, Gamma_psi0, nabla_psi0,
    (witness_mass_form_strictly_positive c hc).2⟩

end PontryaginWitness

end PhysicsSM.Draft.NullEdge.Carrier
