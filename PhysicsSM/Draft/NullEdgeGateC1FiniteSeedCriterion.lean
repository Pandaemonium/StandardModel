import Mathlib

/-!
# Gate C1 finite seed criterion

This draft module records a small, reusable Lean-facing interface for the
current Gate C1 overlap strategy.

The surrounding program has shifted to a null-edge overlap/Ginsparg-Wilson
ansatz

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

where the finite algebraic release starts with a branch/flavor/qutrit seed
`W_branch`.  The key finite-origin audit, distilled from the recent Aristotle
C140/C141 work, is:

* native mode needs a nonzero, gauge-safe, `J`-odd seed;
* if the gauge-safe algebra is forced to be `J`-even, then every gauge-safe
  `J`-odd seed is zero, so the native odd-seed route is blocked.

The definitions below deliberately avoid committing to a concrete matrix model.
They only assume a rational vector space of finite operators and an abstract
`J`-conjugation map.  Later modules can instantiate `Op` with concrete finite
matrix algebras, Schur complements, or overlap sign kernels.

This is draft infrastructure: it is a finite algebraic audit interface, not a
claim that Gate C1 is physically released.  The remaining physical obligations
are the full sign-transfer theorem, a stable branch-line projector, locality or
controlled nonlocality, anomaly/index import, and a true bad-sector gap.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGateC1FiniteSeedCriterion

/-! ## Abstract finite-origin parity and gauge-safety predicates -/

/-- An abstract involution/parity operation, intended to be conjugation by the
branch-balance involution `J`. -/
abbrev JConj (Op : Type _) := Op → Op

/-- A term is `J`-even when conjugation by the branch-balance involution fixes it. -/
def BalanceEven {Op : Type _} (C : JConj Op) (W : Op) : Prop := C W = W

/-- A term is `J`-odd when conjugation by the branch-balance involution negates it. -/
def BalanceOdd {Op : Type _} [Neg Op] (C : JConj Op) (W : Op) : Prop := C W = -W

/-- `GaugeSafe W` is intentionally abstract.  In concrete matrix models it
should mean that `W` lies in the centralizer of the internal gauge action. -/
abbrev GaugeSafe (Op : Type _) := Op → Prop

/-- A finite native Gate C1 seed: gauge-safe, `J`-odd, and nonzero. -/
structure NativeOddSeed (Op : Type _) [Zero Op] [Neg Op]
    (C : JConj Op) (Safe : GaugeSafe Op) where
  W : Op
  gauge_safe : Safe W
  balance_odd : BalanceOdd C W
  nonzero : W ≠ 0

/-- The positive-regime data needed before constructing the overlap sign kernel:
there exists at least one finite native odd seed. -/
def NativeOddChannelAvailable (Op : Type _) [Zero Op] [Neg Op]
    (C : JConj Op) (Safe : GaugeSafe Op) : Prop :=
  Nonempty (NativeOddSeed Op C Safe)

/-- The no-go regime: gauge safety forces every allowed term to be `J`-even.

This abstracts the C140 negative branch: if the gauge representation contains
or gauges the branch involution `J`, then centralizing the gauge action forces
commutation with `J`, hence `J`-evenness. -/
def GaugeForcesJEven {Op : Type _} (C : JConj Op) (Safe : GaugeSafe Op) : Prop :=
  ∀ W : Op, Safe W → BalanceEven C W

/-! ## Elementary algebra: even and odd implies zero over a rational vector space -/

/-- In a rational vector space, the equation `x = -x` forces `x = 0`.

This is the only algebraic cancellation fact the abstract no-go needs. -/
theorem eq_zero_of_eq_neg {Op : Type _} [AddCommGroup Op] [Module ℚ Op]
    {x : Op} (h : x = -x) : x = 0 := by
  have htwo : (2 : ℚ) • x = 0 := by
    rw [two_smul]
    rw [h]
    simp
  exact (smul_eq_zero.mp htwo).resolve_left (by norm_num)

/-- If a term is both `J`-even and `J`-odd, then it vanishes.

This is the finite algebraic heart of the "if `J` is gauged, native odd
selection collapses" branch of the Gate C1 audit. -/
theorem eq_zero_of_balanceEven_and_balanceOdd {Op : Type _}
    [AddCommGroup Op] [Module ℚ Op] {C : JConj Op} {W : Op}
    (heven : BalanceEven C W) (hodd : BalanceOdd C W) : W = 0 := by
  exact eq_zero_of_eq_neg (heven.symm.trans hodd)

/-! ## Gate C1 dichotomy interface -/

/-- If gauge safety forces `J`-evenness, then any gauge-safe `J`-odd term is
zero. -/
theorem gauge_forces_even_no_nonzero_odd {Op : Type _}
    [AddCommGroup Op] [Module ℚ Op] {C : JConj Op} {Safe : GaugeSafe Op}
    (hforces : GaugeForcesJEven C Safe) {W : Op}
    (hsafe : Safe W) (hodd : BalanceOdd C W) : W = 0 := by
  exact eq_zero_of_balanceEven_and_balanceOdd (hforces W hsafe) hodd

/-- A direct contradiction form: in the no-go regime, no nonzero gauge-safe
`J`-odd term can exist. -/
theorem no_native_odd_seed_of_gauge_forces_even {Op : Type _}
    [AddCommGroup Op] [Module ℚ Op] {C : JConj Op} {Safe : GaugeSafe Op}
    (hforces : GaugeForcesJEven C Safe) :
    ¬ NativeOddChannelAvailable Op C Safe := by
  intro hseed
  rcases hseed with ⟨seed⟩
  exact seed.nonzero (gauge_forces_even_no_nonzero_odd hforces
    seed.gauge_safe seed.balance_odd)

/-- A constructor for the positive/native regime: a concrete nonzero,
gauge-safe, `J`-odd term gives the finite seed certificate. -/
def nativeOddSeed_of {Op : Type _} [Zero Op] [Neg Op]
    {C : JConj Op} {Safe : GaugeSafe Op} (W : Op)
    (hsafe : Safe W) (hodd : BalanceOdd C W) (hnonzero : W ≠ 0) :
    NativeOddSeed Op C Safe where
  W := W
  gauge_safe := hsafe
  balance_odd := hodd
  nonzero := hnonzero

/-- The positive regime follows immediately from one certified seed. -/
theorem native_channel_available_of_seed {Op : Type _} [Zero Op] [Neg Op]
    {C : JConj Op} {Safe : GaugeSafe Op} (W : Op)
    (hsafe : Safe W) (hodd : BalanceOdd C W) (hnonzero : W ≠ 0) :
    NativeOddChannelAvailable Op C Safe :=
  ⟨nativeOddSeed_of W hsafe hodd hnonzero⟩

/-! ## Bad-sector gap interface -/

/-- Abstract finite bad-sector gap certificate.

For concrete Schur-Feshbach models, `heavyBlock` should be the bad/heavy-sector
compression.  C139 identifies the no-ghost finite audit with invertibility of
this block, rather than removal by a propagator zero. -/
structure BadSectorGapCertificate (Heavy : Type _) [Monoid Heavy] where
  heavyBlock : Heavy
  heavy_invertible : IsUnit heavyBlock

/-- A Gate C1 finite release seed package combines the odd seed with the
independent bad-sector gap audit.

This still does not assert physical release.  It only records the finite
algebraic ingredients that the current overlap program must preserve through
sign transfer, branch-line stability, locality, and anomaly/index import. -/
structure FiniteReleaseSeed (Op Heavy : Type _) [Zero Op] [Neg Op] [Monoid Heavy]
    (C : JConj Op) (Safe : GaugeSafe Op) where
  oddSeed : NativeOddSeed Op C Safe
  badSectorGap : BadSectorGapCertificate Heavy

/-- The odd-channel part of a finite release seed is available. -/
theorem native_channel_available_of_finite_release_seed
    {Op Heavy : Type _} [Zero Op] [Neg Op] [Monoid Heavy]
    {C : JConj Op} {Safe : GaugeSafe Op}
    (seed : FiniteReleaseSeed Op Heavy C Safe) :
    NativeOddChannelAvailable Op C Safe :=
  ⟨seed.oddSeed⟩

/-- If gauge safety forces `J`-evenness, then no finite release seed of this
native odd-seed form can exist. -/
theorem no_finite_release_seed_of_gauge_forces_even
    {Op Heavy : Type _} [AddCommGroup Op] [Module ℚ Op] [Monoid Heavy]
    {C : JConj Op} {Safe : GaugeSafe Op}
    (hforces : GaugeForcesJEven C Safe) :
    ¬ Nonempty (FiniteReleaseSeed Op Heavy C Safe) := by
  intro hseed
  rcases hseed with ⟨seed⟩
  exact no_native_odd_seed_of_gauge_forces_even hforces
    (native_channel_available_of_finite_release_seed seed)

end PhysicsSM.Draft.NullEdgeGateC1FiniteSeedCriterion
