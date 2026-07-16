import Mathlib

/-!
# Pi-flux 3+1 magnetic-translation cell: exact seed and spectral doubling

This standalone target carries out a finite-cell gate requested by
`NE-3PLUS1-PIFLUX-001`: an exact spectral-doubling theorem for both zero and pi
quasienergy on an explicit three-dimensional cocycle-twisted (pi-flux)
magnetic-translation cell.  It does not define an infinite lattice, Bloch
momentum, a Brillouin zone, or a Dirac tangent.

## Construction

* `Site := (ZMod 2)^3` is a small periodic cell supporting three translations
  with a nontrivial central plaquette cocycle in all three coordinate planes.
* `TxL`, `TyL`, `TzL` are the three exact magnetic translations, defined as
  `ℂ`-linear maps.  `TxL` is an ordinary shift; `TyL` carries the sign
  `(-1)^x`; `TzL` carries the sign `(-1)^{x+y}`.  Each is an involution
  (`*_inv`), hence bijective (`*_bijective`); the three *pairwise anticommute*
  (`TxTy_anti`, `TyTz_anti`, `TxTz_anti`), i.e. each plaquette carries the
  nontrivial central phase `-1` (pi flux).

* `PL := TxL ∘ TyL ∘ TzL` is a chirality-like element of the magnetic
  commutant: it commutes with all three translations (`PL_comm_*`) and squares
  to `-1` (`PL_sq`).  It is *not* a scalar (`PL_not_scalar`), so the commutant
  is strictly larger than the scalar operators.  No tensor-factor
  classification of that commutant is claimed here.

## The census (main result)

On the explicit eight-dimensional state space we prove, for **every** operator
`U` commuting with `TxL` and `TyL`:

* `magnetic_doubling` : every `U`-eigenvector `v` has a *linearly independent*
  eigen-partner `w` with the same eigenvalue.  Hence every eigenspace of `U`
  has dimension `≥ 2`.
* `zero_crossing_doubled` : any zero-quasienergy crossing (`U v = v`) is at
  least two-fold degenerate.
* `pi_crossing_doubled` : any pi-quasienergy crossing (`U v = -v`) is at least
  two-fold degenerate.

The mechanism uses only the two anticommuting in-plane translations `TxL`,
`TyL`; the third axis is not needed, so a single pi-flux plane already forces
the doubling.

## Verdict (honest construction/no-go)

This is a **scoped no-go**.  On the displayed pi-flux magnetic-translation
cell `(ZMod 2)^3`, spectral doubling of every invariant operator is
*forced* by the plane cocycle `TxL TyL = - TyL TxL`.  Consequently:

* both the zero and the pi crossing of any invariant walk are unavoidably at
  least two-fold degenerate; the partner is *enforced*, not removed;
* the finite-cell partner is enforced at the same eigenvalue, rather than
  relocated between zero and pi;
* any nonzero eigenspace of an invariant projector is subject to the same
  finite-cell doubling theorem, so such a projector cannot have a
  one-dimensional nonzero eigenspace.

**Sharpened missing hypothesis.**  Escaping this finite-cell obstruction
requires breaking at least one of the two exact magnetic-translation
commutation hypotheses, or passing to a separately defined physical quotient
with an observable algebra.  This theorem alone does not decide whether such
an escape extends to a local infinite-lattice Dirac walk.

Provenance: clean-room finite magnetic-translation construction, extending the
two-dimensional seed `PiFluxCocycleDecoder`.  No external code copied.  Every
theorem is kernel-checked and uses only the guarded standard footprint.  The
proof was returned by Aristotle project `cdcc00ba-0380-49ea-8a9a-7f6d8a6a349c`;
the finite-cell scope and prose were independently audited in
`AutonomousLab/reviews/CLAUDE_REVIEW_PiFlux3Plus1Census_2026-07-13.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census

/-! ## The magnetic cell and the sign cocycle -/

/-- A small periodic cell carrying a nontrivial central cocycle in all three
planes.  No minimality theorem is asserted. -/
abbrev Site := ZMod 2 × ZMod 2 × ZMod 2

/-- Complex amplitudes on the finite cell. -/
abbrev St := Site → ℂ

/-- The position-dependent sign `(-1)^x`. -/
def sgn (x : ZMod 2) : ℂ := if x = 0 then 1 else -1

/-- The sign flips under a unit shift: `(-1)^{x+1} = -(-1)^x`. -/
theorem sgn_flip (x : ZMod 2) : sgn (x + 1) = - sgn x := by
  fin_cases x <;> simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

/-- The sign squares to one. -/
theorem sgn_sq (x : ZMod 2) : sgn x * sgn x = 1 := by
  unfold sgn; split <;> norm_num

/-- The cocycle is genuinely position dependent. -/
theorem sgn_nonconstant : sgn 0 ≠ sgn 1 := by norm_num [sgn]

/-! ## The three exact magnetic translations -/

/-- Ordinary periodic translation in the `x` direction. -/
def TxL : St →ₗ[ℂ] St where
  toFun ψ := fun p => ψ (p.1 + 1, p.2.1, p.2.2)
  map_add' a b := by funext p; simp
  map_smul' c a := by funext p; simp

/-- Magnetic translation in the `y` direction, twisted by the sign `(-1)^x`. -/
def TyL : St →ₗ[ℂ] St where
  toFun ψ := fun p => sgn p.1 * ψ (p.1, p.2.1 + 1, p.2.2)
  map_add' a b := by funext p; simp; ring
  map_smul' c a := by funext p; simp; ring

/-- Magnetic translation in the `z` direction, twisted by the sign
`(-1)^{x+y}`. -/
def TzL : St →ₗ[ℂ] St where
  toFun ψ := fun p => sgn p.1 * sgn p.2.1 * ψ (p.1, p.2.1, p.2.2 + 1)
  map_add' a b := by funext p; simp; ring
  map_smul' c a := by funext p; simp; ring

/-! ### Each translation is an involution, hence bijective -/

theorem Tx_inv : TxL.comp TxL = LinearMap.id := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.id_apply, TxL, LinearMap.coe_mk, AddHom.coe_mk]
  rw [add_assoc, CharTwo.add_self_eq_zero, add_zero]

theorem Ty_inv : TyL.comp TyL = LinearMap.id := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.id_apply, TyL, LinearMap.coe_mk, AddHom.coe_mk]
  rw [add_assoc, CharTwo.add_self_eq_zero, add_zero, ← mul_assoc, sgn_sq, one_mul]

theorem Tz_inv : TzL.comp TzL = LinearMap.id := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.id_apply, TzL, LinearMap.coe_mk, AddHom.coe_mk]
  rw [add_assoc, CharTwo.add_self_eq_zero, add_zero]
  rw [show sgn p.1 * sgn p.2.1 * (sgn p.1 * sgn p.2.1 * ψ (p.1, p.2.1, p.2.2))
        = (sgn p.1 * sgn p.1) * (sgn p.2.1 * sgn p.2.1) * ψ (p.1, p.2.1, p.2.2) by ring,
      sgn_sq, sgn_sq, one_mul, one_mul]

theorem Tx_involutive : Function.Involutive TxL := fun ψ =>
  congrArg (fun f : St →ₗ[ℂ] St => f ψ) Tx_inv

theorem Ty_involutive : Function.Involutive TyL := fun ψ =>
  congrArg (fun f : St →ₗ[ℂ] St => f ψ) Ty_inv

theorem Tz_involutive : Function.Involutive TzL := fun ψ =>
  congrArg (fun f : St →ₗ[ℂ] St => f ψ) Tz_inv

theorem Tx_bijective : Function.Bijective TxL := Tx_involutive.bijective
theorem Ty_bijective : Function.Bijective TyL := Ty_involutive.bijective
theorem Tz_bijective : Function.Bijective TzL := Tz_involutive.bijective

/-! ### The three pairwise anticommutators: pi flux in every plane -/

/-- `xy`-plaquette: `TxL TyL = - TyL TxL`. -/
theorem TxTy_anti : TxL.comp TyL = - (TyL.comp TxL) := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.neg_apply, Pi.neg_apply, TxL, TyL,
    LinearMap.coe_mk, AddHom.coe_mk]
  rw [sgn_flip]; ring

/-- `yz`-plaquette: `TyL TzL = - TzL TyL`. -/
theorem TyTz_anti : TyL.comp TzL = - (TzL.comp TyL) := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.neg_apply, Pi.neg_apply, TyL, TzL,
    LinearMap.coe_mk, AddHom.coe_mk]
  rw [sgn_flip]; ring

/-- `xz`-plaquette: `TxL TzL = - TzL TxL`. -/
theorem TxTz_anti : TxL.comp TzL = - (TzL.comp TxL) := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [LinearMap.comp_apply, LinearMap.neg_apply, Pi.neg_apply, TxL, TzL,
    LinearMap.coe_mk, AddHom.coe_mk]
  rw [sgn_flip]; ring

/-! ## The chirality element of the magnetic commutant -/

/-- The product `TxL TyL TzL`, a chirality-like element of the commutant. -/
def PL : St →ₗ[ℂ] St := TxL.comp (TyL.comp TzL)

theorem PL_comm_Tx : PL.comp TxL = TxL.comp PL := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [PL, LinearMap.comp_apply, TxL, TyL, TzL, LinearMap.coe_mk, AddHom.coe_mk]
  rcases p with ⟨a, b, c⟩
  fin_cases a <;> fin_cases b <;> fin_cases c <;>
    simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

theorem PL_comm_Ty : PL.comp TyL = TyL.comp PL := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [PL, LinearMap.comp_apply, TxL, TyL, TzL, LinearMap.coe_mk, AddHom.coe_mk]
  rcases p with ⟨a, b, c⟩
  fin_cases a <;> fin_cases b <;> fin_cases c <;>
    simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

theorem PL_comm_Tz : PL.comp TzL = TzL.comp PL := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [PL, LinearMap.comp_apply, TxL, TyL, TzL, LinearMap.coe_mk, AddHom.coe_mk]
  rcases p with ⟨a, b, c⟩
  fin_cases a <;> fin_cases b <;> fin_cases c <;>
    simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

/-- The chirality element squares to `-1`: its spectrum is `±i`. -/
theorem PL_sq : PL.comp PL = - LinearMap.id := by
  apply LinearMap.ext; intro ψ; funext p
  simp only [PL, LinearMap.comp_apply, TxL, TyL, TzL, LinearMap.neg_apply, Pi.neg_apply,
    LinearMap.id_apply, LinearMap.coe_mk, AddHom.coe_mk]
  rcases p with ⟨a, b, c⟩
  fin_cases a <;> fin_cases b <;> fin_cases c <;>
    simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

/-- The chirality element is genuinely nonscalar, so the magnetic commutant is
strictly larger than the scalar operators. -/
theorem PL_not_scalar : ¬ ∃ c : ℂ, PL = c • LinearMap.id := by
  rintro ⟨c, hc⟩
  -- Test on the delta function at the origin.
  set e0 : St := fun p => if p = 0 then 1 else 0 with he0
  have h := congrArg (fun f : St →ₗ[ℂ] St => f e0 (1, 1, 1)) hc
  simp only [PL, LinearMap.comp_apply, TxL, TyL, TzL, LinearMap.smul_apply,
    LinearMap.id_apply, Pi.smul_apply, LinearMap.coe_mk, AddHom.coe_mk, he0] at h
  rw [show ((1 : ZMod 2) + 1) = 0 from by decide] at h
  simp [sgn, Prod.ext_iff] at h

/-! ## The abstract spectral-doubling mechanism -/

/-- **Magnetic doubling.**  Let `A`, `B`, `U` be linear operators over a field
of characteristic `≠ 2` with `A`, `B` anticommuting involutions that both
commute with `U`.  Then every `U`-eigenvector `v` has a *linearly independent*
eigen-partner `w` with the same eigenvalue.  Hence each `U`-eigenspace has
dimension at least two. -/
theorem magnetic_doubling
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (A B U : V →ₗ[F] V)
    (hchar : (2 : F) ≠ 0)
    (hA : A.comp A = LinearMap.id)
    (hB : B.comp B = LinearMap.id)
    (hAB : A.comp B = - (B.comp A))
    (hUA : U.comp A = A.comp U)
    (hUB : U.comp B = B.comp U)
    (lam : F) (v : V) (hv : v ≠ 0) (hUv : U v = lam • v) :
    ∃ w, U w = lam • w ∧ LinearIndependent F ![v, w] := by
  have hAinv : ∀ x, A (A x) = x := fun x => congrArg (fun f : V →ₗ[F] V => f x) hA
  have hBinv : ∀ x, B (B x) = x := fun x => congrArg (fun f : V →ₗ[F] V => f x) hB
  have hAvne : A v ≠ 0 := by
    intro h; apply hv; have := hAinv v; rw [h, map_zero] at this; exact this.symm
  have hBvne : B v ≠ 0 := by
    intro h; apply hv; have := hBinv v; rw [h, map_zero] at this; exact this.symm
  have hAv : U (A v) = lam • (A v) := by
    have := congrArg (fun f : V →ₗ[F] V => f v) hUA
    simp only [LinearMap.comp_apply] at this
    rw [this, hUv, map_smul]
  have hBv : U (B v) = lam • (B v) := by
    have := congrArg (fun f : V →ₗ[F] V => f v) hUB
    simp only [LinearMap.comp_apply] at this
    rw [this, hUv, map_smul]
  by_cases hAdep : ∀ c : F, A v ≠ c • v
  · refine ⟨A v, hAv, ?_⟩
    rw [linearIndependent_fin2]
    refine ⟨by simpa using hAvne, ?_⟩
    intro a ha
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one] at ha
    apply hAdep a
    have h := congrArg A ha
    rw [map_smul, hAinv] at h
    exact h.symm
  · push_neg at hAdep
    obtain ⟨d, hd⟩ := hAdep
    by_cases hBdep : ∀ c : F, B v ≠ c • v
    · refine ⟨B v, hBv, ?_⟩
      rw [linearIndependent_fin2]
      refine ⟨by simpa using hBvne, ?_⟩
      intro a ha
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one] at ha
      apply hBdep a
      have h := congrArg B ha
      rw [map_smul, hBinv] at h
      exact h.symm
    · exfalso
      push_neg at hBdep
      obtain ⟨e, he⟩ := hBdep
      have hkey := congrArg (fun f : V →ₗ[F] V => f v) hAB
      simp only [LinearMap.comp_apply, LinearMap.neg_apply] at hkey
      rw [he, hd, map_smul, map_smul, hd, he] at hkey
      rw [smul_smul, smul_smul] at hkey
      have hz : (e * d + d * e) • v = 0 := by
        rw [add_smul, hkey]; ring_nf; rw [neg_add_cancel]
      have h2 : (2 * (e * d)) • v = 0 := by
        rw [show 2 * (e * d) = e * d + d * e by ring]; exact hz
      rw [smul_eq_zero] at h2
      rcases h2 with h2 | h2
      · rcases mul_eq_zero.mp h2 with h2 | h2
        · exact hchar h2
        · rcases mul_eq_zero.mp h2 with h2 | h2
          · apply hBvne; rw [he, h2, zero_smul]
          · apply hAvne; rw [hd, h2, zero_smul]
      · exact hv h2

/-! ## The finite-cell zero/pi doubling theorem -/

/-- **Finite-cell doubling.**  Every operator `U` on the pi-flux cell that
commutes with `TxL` and `TyL` has each eigenvalue at least two-fold degenerate:
any nonzero eigenvector has a linearly independent partner at the same
eigenvalue. -/
theorem census_doubling
    (U : St →ₗ[ℂ] St)
    (hUx : U.comp TxL = TxL.comp U)
    (hUy : U.comp TyL = TyL.comp U)
    (lam : ℂ) (v : St) (hv : v ≠ 0) (hUv : U v = lam • v) :
    ∃ w, U w = lam • w ∧ LinearIndependent ℂ ![v, w] :=
  magnetic_doubling TxL TyL U two_ne_zero Tx_inv Ty_inv TxTy_anti hUx hUy lam v hv hUv

/-- **Zero-quasienergy crossings are doubled.**  Any zero mode (`U v = v`) of an
invariant walk has a linearly independent zero-mode partner. -/
theorem zero_crossing_doubled
    (U : St →ₗ[ℂ] St)
    (hUx : U.comp TxL = TxL.comp U)
    (hUy : U.comp TyL = TyL.comp U)
    (v : St) (hv : v ≠ 0) (hUv : U v = v) :
    ∃ w, U w = w ∧ LinearIndependent ℂ ![v, w] := by
  obtain ⟨w, hw, hind⟩ := census_doubling U hUx hUy 1 v hv (by rw [hUv, one_smul])
  exact ⟨w, by rw [hw, one_smul], hind⟩

/-- **Pi-quasienergy crossings are doubled.**  Any pi mode (`U v = -v`) of an
invariant walk has a linearly independent pi-mode partner. -/
theorem pi_crossing_doubled
    (U : St →ₗ[ℂ] St)
    (hUx : U.comp TxL = TxL.comp U)
    (hUy : U.comp TyL = TyL.comp U)
    (v : St) (hv : v ≠ 0) (hUv : U v = -v) :
    ∃ w, U w = -w ∧ LinearIndependent ℂ ![v, w] := by
  obtain ⟨w, hw, hind⟩ := census_doubling U hUx hUy (-1) v hv (by rw [hUv, neg_one_smul])
  exact ⟨w, by rw [hw, neg_one_smul], hind⟩

/-! ## Adversarial nonvacuity: the census is not vacuous

The chirality element `PL` is an explicit nonscalar operator that commutes with
`TxL` and `TyL`, so the invariant-walk hypotheses of the census are satisfiable
by a genuinely nontrivial operator (not merely the scalars).  Its spectrum is
constrained by `PL_sq`; it certifies only that the commutant is larger than the
scalars.  Projector eigenspace doubling follows from `census_doubling`, not from
nonscalarity alone. -/
theorem PL_is_invariant_nonscalar :
    PL.comp TxL = TxL.comp PL ∧ PL.comp TyL = TyL.comp PL ∧
      PL.comp PL = - LinearMap.id ∧ ¬ ∃ c : ℂ, PL = c • LinearMap.id :=
  ⟨PL_comm_Tx, PL_comm_Ty, PL_sq, PL_not_scalar⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.magnetic_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms magnetic_doubling

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.census_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms census_doubling

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.zero_crossing_doubled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_crossing_doubled

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.pi_crossing_doubled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pi_crossing_doubled

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.TxTy_anti' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TxTy_anti

/-- info: 'PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census.PL_is_invariant_nonscalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PL_is_invariant_nonscalar

end PhysicsSM.Draft.NullEdge.PiFlux3Plus1Census
