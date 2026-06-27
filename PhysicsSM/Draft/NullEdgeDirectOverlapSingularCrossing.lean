import Mathlib

/-!
# Draft.NullEdgeDirectOverlapSingularCrossing

Aristotle task **C102** (Wave 26): a conditional *hazard* theorem for direct,
unprojected overlap fermions built on the **full bare null-edge branch locus**.

## The hazard

The overlap sign kernel uses the shifted Wilson operator

```text
X_ρ(q) = D₊(q) + r · W(q) · I − ρ · I.
```

If an unwanted branch germ reaches the origin and its zero vector `v` crosses the
Wilson mass shell, i.e.

```text
D₊(q) v = 0      and      r · W(q) = ρ,
```

then `X_ρ(q) v = 0`, so the sign kernel is **singular** and the overlap
construction (which divides by / takes the sign of `X_ρ`) is ill-defined at that
point.

This module formalizes exactly that conditional statement at the algebraic /
predicate level.  It does **not** prove or disprove overlap fermions in general
(see *Non-goals*); it is a guardrail that says:

> Raw (unprojected) overlap on the full bare `D₊` is unsafe **unless** a
> mass-window assumption forbids `r · W(q) = ρ` along the bare branch zero
> locus.  Without such a mass-window theorem, direct overlap cannot be used as a
> C1 route, because a zero-branch crossing makes the sign kernel singular.

## API

* `shiftedKernel` / `ShiftedKernelData.X` — the shifted overlap sign operator.
* `shifted_kernel_apply_eq_zero` — the core algebraic fact (standalone form).
* `ShiftedKernelData` — packaged data `(Q, V, D, W, r, ρ, q, v)`.
* `ShiftedKernelData.IsSingular` — `∃ x ≠ 0, X x = 0`.
* `ShiftedKernelData.IsZeroBranchCrossing` — `D q v = 0 ∧ r·W q = ρ ∧ v ≠ 0`.
* `ShiftedKernelData.crossing_imp_singular` — the Gate C packaging:
  a zero-branch crossing forces the shifted kernel to be singular.
* `exists_zero_branch_crossing_imp_singular` — existence form.
* `direct_overlap_requires_mass_window` — the contrapositive guardrail:
  if the shifted kernel is everywhere nonsingular then no bare zero branch
  crosses the Wilson shell (a mass-window condition is necessary).
* `directOverlap_requires_per_symbol_mass_window` — the usable per-symbol
  version: for fixed `(D, W, r, ρ)`, the shifted kernel avoids annihilating
  nonzero bare zero modes iff the bare zero locus avoids the Wilson shell.
* `discrete_first_crossing` — a finite intermediate-value-style localization of
  the crossing along a discrete ordered list of sample Wilson values.
* `finite_attained_crossing_singular` — over a finite family of sample data, an
  attained crossing yields a genuine shifted-kernel zero.

## Non-goals

We do **not** formalize the analytic overlap/Ginsparg–Wilson construction, the
matrix sign function, or any claim about overlap fermions in general.  The point
is purely the conditional algebraic hazard.
-/

namespace PhysicsSM.Draft.NullEdgeDirectOverlapSingularCrossing

variable {Q : Type*} {V : Type*}

/-- The shifted overlap sign operator
`X_ρ(q) x = D₊(q) x + (r · W(q) − ρ) • x`, in standalone (unbundled) form. -/
def shiftedKernel [AddCommGroup V] [Module ℝ V]
    (D : Q → V → V) (W : Q → ℝ) (r rho : ℝ) (q : Q) (x : V) : V :=
  D q x + (r * W q - rho) • x

/-- **Core algebraic fact.** If `v` is a zero mode of the bare operator,
`D q v = 0`, and the Wilson value sits exactly on the mass shell,
`r · W q = ρ`, then `v` is annihilated by the shifted overlap sign kernel. -/
theorem shifted_kernel_apply_eq_zero [AddCommGroup V] [Module ℝ V]
    (D : Q → V → V) (W : Q → ℝ) (r rho : ℝ) (q : Q) (v : V)
    (hD : D q v = 0) (hW : r * W q = rho) :
    shiftedKernel D W r rho q v = 0 := by
  rw [shiftedKernel, hD, hW, zero_add, sub_self, zero_smul]

/-- Packaged data for the direct-overlap shifted-kernel hazard:
the bare Dirac/Wilson operator `D`, the Wilson term `W`, the overlap parameters
`r` and `ρ`, and a distinguished branch point `q` with candidate zero vector
`v`. -/
structure ShiftedKernelData (Q : Type*) (V : Type*)
    [AddCommGroup V] [Module ℝ V] where
  /-- The bare (e.g. naive/null-edge) Dirac operator at each momentum. -/
  D : Q → V → V
  /-- The Wilson term coefficient at each momentum. -/
  W : Q → ℝ
  /-- The Wilson radius parameter. -/
  r : ℝ
  /-- The overlap mass-shell value. -/
  rho : ℝ
  /-- The distinguished branch momentum. -/
  q : Q
  /-- The candidate branch zero vector. -/
  v : V

namespace ShiftedKernelData

variable [AddCommGroup V] [Module ℝ V] (S : ShiftedKernelData Q V)

/-- The shifted overlap sign operator attached to the data. -/
def X (x : V) : V := shiftedKernel S.D S.W S.r S.rho S.q x

@[simp] theorem X_def (x : V) : S.X x = S.D S.q x + (S.r * S.W S.q - S.rho) • x :=
  rfl

/-- The shifted kernel is **singular** if it annihilates a nonzero vector. -/
def IsSingular : Prop := ∃ x : V, x ≠ 0 ∧ S.X x = 0

/-- A **zero-branch crossing**: the candidate vector is a nonzero bare zero mode
(`D q v = 0`, `v ≠ 0`) that crosses the Wilson mass shell (`r · W q = ρ`). -/
def IsZeroBranchCrossing : Prop :=
  S.D S.q S.v = 0 ∧ S.r * S.W S.q = S.rho ∧ S.v ≠ 0

/-- **Gate C packaging.** A zero-branch crossing forces the shifted overlap sign
kernel to be singular. -/
theorem crossing_imp_singular (h : S.IsZeroBranchCrossing) : S.IsSingular :=
  ⟨S.v, h.2.2, by rw [S.X_def, h.1, zero_add, h.2.1, sub_self, zero_smul]⟩

end ShiftedKernelData

/-- Existence form of the hazard: if some bare zero branch crosses the Wilson
mass shell, the shifted overlap sign kernel is singular there. -/
theorem exists_zero_branch_crossing_imp_singular
    [AddCommGroup V] [Module ℝ V]
    (h : ∃ S : ShiftedKernelData Q V, S.IsZeroBranchCrossing) :
    ∃ S : ShiftedKernelData Q V, S.IsSingular :=
  ⟨h.choose, h.choose.crossing_imp_singular h.choose_spec⟩

/-- **The mass-window guardrail (contrapositive).** If the shifted overlap sign
kernel is nonsingular for *every* configuration of the bare branch data, then no
bare zero branch can sit on the Wilson mass shell: i.e. raw direct overlap is
legal only under a mass-window assumption that excludes `r · W q = ρ` along the
bare zero locus. -/
theorem direct_overlap_requires_mass_window
    [AddCommGroup V] [Module ℝ V]
    (hsafe : ∀ S : ShiftedKernelData Q V, ¬ S.IsSingular) :
    ∀ S : ShiftedKernelData Q V, ¬ S.IsZeroBranchCrossing :=
  fun S h => hsafe S <| S.crossing_imp_singular h

/--
**Per-symbol mass-window equivalence.** Fix the bare symbol data
`(D, W, r, ρ)`. Then the shifted overlap kernel avoids annihilating any nonzero
bare zero mode if and only if the bare zero locus avoids the Wilson mass shell
`r * W q = ρ`.

This is the usable Gate C guardrail: raw direct overlap on a fixed full bare
symbol requires this mass-window condition before the sign kernel can be treated
as nonsingular on bare zero modes. It remains purely algebraic and does not
assert overlap locality, chiral index, Krein positivity, ghost safety, or a C1
release.
-/
theorem directOverlap_requires_per_symbol_mass_window
    [AddCommGroup V] [Module ℝ V]
    (D : Q → V → V) (W : Q → ℝ) (r rho : ℝ) :
    (∀ q v, v ≠ 0 → D q v = 0 → shiftedKernel D W r rho q v ≠ 0) ↔
      (∀ q v, v ≠ 0 → D q v = 0 → r * W q ≠ rho) := by
  constructor
  · intro hsafe q v hv hD hW
    exact hsafe q v hv hD (shifted_kernel_apply_eq_zero D W r rho q v hD hW)
  · intro hwindow q v hv hD hshift
    rw [shiftedKernel, hD, zero_add] at hshift
    have hmass : r * W q - rho = 0 := (smul_eq_zero.mp hshift).resolve_right hv
    exact hwindow q v hv hD (sub_eq_zero.mp hmass)

/-! ## Finite intermediate-value-style localization

Along a discrete ordered list of sample momenta we record the Wilson values
`f i = r · W(qᵢ)`.  If they straddle the mass shell `ρ`, a first crossing index
exists.  This is the discrete-IVT *localization* of the hazard region.

Producing a genuine shifted-kernel zero additionally requires that the crossing
value `ρ` is actually *attained* at a sampled point (`finite_attained_crossing_singular`).
Discrete samples in general only bracket the crossing; the *bare continuous*
branch attains it.  This gap is precisely why raw overlap needs a mass-window
theorem rather than a finite sampling check. -/

/-- **Discrete intermediate-value localization.** Given sample values
`f : Fin (n+1) → ℝ` that straddle the shell `c` (`f 0 ≤ c ≤ f last`), there is a
first index `i` whose value reaches the shell (`c ≤ f i`) while every earlier
sample stays strictly below it.

The lower straddle bound `_h0 : f 0 ≤ c` is kept so the statement is an honest
"straddle" precondition (as requested); the proof only needs the upper bound
`hlast`, which makes the crossing-index set nonempty, so `_h0` is marked
intentionally unused. -/
theorem discrete_first_crossing {n : ℕ} (f : Fin (n + 1) → ℝ) (c : ℝ)
    (_h0 : f 0 ≤ c) (hlast : c ≤ f (Fin.last n)) :
    ∃ i : Fin (n + 1), c ≤ f i ∧ ∀ j : Fin (n + 1), j < i → f j < c := by
  refine ⟨Finset.min' (Finset.univ.filter fun i => c ≤ f i) ⟨Fin.last n, by aesop⟩,
    by simpa using Finset.min'_mem (Finset.univ.filter fun i => c ≤ f i) ⟨Fin.last n, by aesop⟩,
    fun j hj => lt_of_not_ge fun h => hj.not_ge <| Finset.min'_le _ _ <| by aesop⟩

/-- **Finite attained crossing ⇒ singular sample.** Given a finite family of
branch data along which every sample carries a nonzero bare zero mode
(`D qₖ vₖ = 0`, `vₖ ≠ 0`), if some sample `k` attains the Wilson mass shell
(`r · W qₖ = ρ`) then the shifted overlap sign kernel of that sample is
singular. -/
theorem finite_attained_crossing_singular
    [AddCommGroup V] [Module ℝ V] {n : ℕ}
    (S : Fin n → ShiftedKernelData Q V)
    (hbranch : ∀ k, (S k).D (S k).q (S k).v = 0 ∧ (S k).v ≠ 0)
    (k : Fin n) (hcross : (S k).r * (S k).W (S k).q = (S k).rho) :
    (S k).IsSingular :=
  (S k).crossing_imp_singular ⟨(hbranch k).1, hcross, (hbranch k).2⟩

end PhysicsSM.Draft.NullEdgeDirectOverlapSingularCrossing
