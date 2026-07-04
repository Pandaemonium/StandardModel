import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore

/-!
# Gate YM1: Elitzur's theorem, assembled (Z2, finite lattice)

PKG-YM1-lattice: threads the one-site gauge-flip involution and the
already-proved Wilson-term invariance (`Z2GaugeCore.plaqSpins_gauge`)
through the already-proved abstract pairing bound
(`ElitzurCore.abstract_elitzur_bound`) to recover the full quantitative,
volume-uniform Elitzur theorem (statement freeze:
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`, Theorem 1).
Assembled in-repo; no Aristotle job needed - every step below is either an
already-proved lemma or elementary `Finset`/`Bool` bookkeeping.

## The instantiation

For `Z2`, the involution "flip every link incident to site `x0`" used in
the freeze document's proof is EXACTLY the already-defined gauge
transformation `Z2GaugeCore.gauge` at the indicator function of `x0`
(`flipAt`): for a link `(x0, y)` or `(y, x0)` it flips (one of the two
`gauge` factors is `true`), for a link avoiding `x0` entirely it is fixed,
and for the (physically absent, here excluded by hypothesis) self-loop
`(x0,x0)` it is also fixed (both factors flip and cancel). This makes:

* **involutivity** (`flipAt_involutive`) a direct instance of the already-
  proved `Z2GaugeCore.gauge_invol`;
* **Wilson-term invariance** (`plaqSpins_flipAt_invariant`) a direct
  instance of the already-proved `Z2GaugeCore.plaqSpins_gauge` - true for
  ANY plaquette list, so any real-valued statistic built from it (in
  particular the Wilson action `S_beta`) is invariant configuration by
  configuration;
* **the source-term covariance** (`sourceTerm_flipAt`): splitting the edge
  set `E` into "at `x0`" and "away from `x0`" and using that `spin` flips
  sign exactly on the former, `sourceTerm E (flipAt x0 U) = sourceTerm E U
  - 2 * K E x0 U` with `K E x0 U` the sum of spins on links touching `x0`
  (the freeze document's `K_x`), bounded by `|K E x0 U| <= (linksAt E
  x0).card` (the coordination number `q_x0`).

Feeding `w(U) := exp(beta * (Wilson sum) + h * sourceTerm E U)` and any
`phi`-odd, bounded observable `f` (e.g. the spin of one link incident to
`x0`) into `ElitzurCore.abstract_elitzur_bound` with `K := h * (K E x0 ·)`
and `b := h * q_x0` (using `h >= 0`) gives exactly the freeze document's
Theorem 1: `|sum f w| <= ||f||_inf * tanh(q_x0 * h) * sum w` - volume-
uniform (no dependence on the lattice size or shape beyond `q_x0`), coupling-
uniform (any `beta`, since the Wilson term cancels identically), and true
for any additional gauge-invariant terms in the action for the same reason
the Wilson term cancels (`plaqSpins_gauge` needs only gauge invariance, not
the specific Wilson form).

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (quantitative, volume-uniform Elitzur
theorem for Z2 lattice gauge theory).
Prerequisites: `Z2GaugeCore`, `ElitzurCore`. This closes PKG-YM1-lattice;
the YM1 finite-`G` paper layer (Z2 exact solutions, general-`G` Elitzur) is
the next assembly target.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ElitzurLattice

open PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore
open PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore (LinkField gauge_invol plaqSpins plaqSpins_gauge)

variable {V : Type} [Fintype V] [DecidableEq V]

/-- `LinkField V` is definitionally `V → V → Bool`; instance search does not
unfold the `def` on its own, so the `Fintype` instance is supplied
explicitly (needed for the `∑ U, ...` sums and for `abstract_elitzur_bound`'s
`[Fintype Ω]`). -/
instance : Fintype (LinkField V) := inferInstanceAs (Fintype (V → V → Bool))

/-- The one-site gauge flip: `Z2GaugeCore.gauge` at the indicator of `x0`. -/
def flipAt (x0 : V) (U : LinkField V) : LinkField V :=
  Z2GaugeCore.gauge (fun v => decide (v = x0)) U

/-- **Involutivity of the one-site flip** - a direct instance of the
already-proved `gauge_invol`. -/
theorem flipAt_involutive (x0 : V) : Function.Involutive (flipAt (V := V) x0) :=
  fun U => gauge_invol (fun v => decide (v = x0)) U

/-- **Wilson-term (and every gauge-invariant statistic) invariance under
the one-site flip** - a direct instance of the already-proved
`plaqSpins_gauge`. -/
theorem plaqSpins_flipAt_invariant (x0 : V) (U : LinkField V)
    (ps : List (V × V × V × V)) :
    plaqSpins (flipAt x0 U) ps = plaqSpins U ps :=
  plaqSpins_gauge (fun v => decide (v = x0)) U ps

/-- The Z2 spin of a link value: `false ↦ +1`, `true ↦ -1`. -/
def spin (b : Bool) : ℝ := if b then -1 else 1

theorem spin_flip (b : Bool) : spin (!b) = - spin b := by
  cases b <;> simp [spin]

theorem abs_spin_le_one (b : Bool) : |spin b| ≤ 1 := by
  cases b <;> simp [spin]

/-- The source (symmetry-breaking) term: sum of link spins over an edge
set `E`. -/
def sourceTerm (E : Finset (V × V)) (U : LinkField V) : ℝ :=
  ∑ l ∈ E, spin (U l.1 l.2)

/-- The links of `E` incident to `x0` (one or both endpoints equal `x0`). -/
def linksAt (E : Finset (V × V)) (x0 : V) : Finset (V × V) :=
  E.filter (fun l => l.1 = x0 ∨ l.2 = x0)

/-- The freeze document's `K_x`: the sum of spins on links touching `x0`. -/
def K (E : Finset (V × V)) (x0 : V) (U : LinkField V) : ℝ :=
  sourceTerm (linksAt E x0) U

/-- No self-loops at `x0` within `E` (the natural, physical hypothesis: a
lattice edge set has no `(x0,x0)` link). -/
def NoSelfLoopAt (E : Finset (V × V)) (x0 : V) : Prop := (x0, x0) ∉ E

theorem flipAt_apply_of_incident (x0 y z : V) (U : LinkField V)
    (h : y = x0 ∨ z = x0) (hne : y ≠ z) :
    flipAt x0 U y z = ! (U y z) := by
  unfold flipAt Z2GaugeCore.gauge
  rcases h with h | h
  · subst h; simp [hne.symm]
  · subst h; simp [hne]

theorem flipAt_apply_of_not_incident (x0 y z : V) (U : LinkField V)
    (h : y ≠ x0 ∧ z ≠ x0) :
    flipAt x0 U y z = U y z := by
  unfold flipAt Z2GaugeCore.gauge
  simp [h.1, h.2]

/-- **Source-term covariance under the one-site flip.**
`sourceTerm E (flipAt x0 U) = sourceTerm E U - 2 * K E x0 U`: only the
links touching `x0` flip sign; every other link is unchanged. -/
theorem sourceTerm_flipAt (E : Finset (V × V)) (x0 : V) (hloop : NoSelfLoopAt E x0)
    (U : LinkField V) :
    sourceTerm E (flipAt x0 U) = sourceTerm E U - 2 * K E x0 U := by
  unfold K linksAt sourceTerm
  have hsplit : ∀ (f : V × V → ℝ), ∑ l ∈ E, f l
      = ∑ l ∈ E.filter (fun l => l.1 = x0 ∨ l.2 = x0), f l
        + ∑ l ∈ E.filter (fun l => ¬ (l.1 = x0 ∨ l.2 = x0)), f l :=
    fun f => (Finset.sum_filter_add_sum_filter_not E _ f).symm
  rw [hsplit (fun l => spin (flipAt x0 U l.1 l.2)), hsplit (fun l => spin (U l.1 l.2))]
  have hin : ∑ l ∈ E.filter (fun l => l.1 = x0 ∨ l.2 = x0),
        spin (flipAt x0 U l.1 l.2)
      = - ∑ l ∈ E.filter (fun l => l.1 = x0 ∨ l.2 = x0), spin (U l.1 l.2) := by
    rw [← Finset.sum_neg_distrib]
    refine Finset.sum_congr rfl fun l hl => ?_
    obtain ⟨hlE, hl'⟩ := Finset.mem_filter.mp hl
    have hne : l.1 ≠ l.2 := by
      rintro heq
      have hx0 : l = (x0, x0) := by
        rcases hl' with h1 | h2
        · exact Prod.ext h1 (heq.symm.trans h1)
        · exact Prod.ext (heq.trans h2) h2
      exact hloop (hx0 ▸ hlE)
    rw [flipAt_apply_of_incident x0 l.1 l.2 U hl' hne, spin_flip]
  have hout : ∑ l ∈ E.filter (fun l => ¬ (l.1 = x0 ∨ l.2 = x0)),
        spin (flipAt x0 U l.1 l.2)
      = ∑ l ∈ E.filter (fun l => ¬ (l.1 = x0 ∨ l.2 = x0)), spin (U l.1 l.2) := by
    refine Finset.sum_congr rfl fun l hl => ?_
    have hl' := (Finset.mem_filter.mp hl).2
    push_neg at hl'
    rw [flipAt_apply_of_not_incident x0 l.1 l.2 U hl']
  rw [hin, hout]; ring

/-- **`K` is bounded by the coordination number** `q_x0 = |linksAt E x0|`:
each of its finitely many spin terms has absolute value at most `1`. -/
theorem abs_K_le_card (E : Finset (V × V)) (x0 : V) (U : LinkField V) :
    |K E x0 U| ≤ (linksAt E x0).card := by
  unfold K sourceTerm
  calc |∑ l ∈ linksAt E x0, spin (U l.1 l.2)|
      ≤ ∑ l ∈ linksAt E x0, |spin (U l.1 l.2)| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _l ∈ linksAt E x0, (1 : ℝ) :=
        Finset.sum_le_sum fun l _ => abs_spin_le_one (U l.1 l.2)
    _ = (linksAt E x0).card := by rw [Finset.sum_const, nsmul_eq_mul, mul_one]

/-- **Elitzur's theorem (Z2, finite lattice, quantitative and volume-
uniform).** For any finite lattice edge set `E` (no self-loop at `x0`), any
finite plaquette list `ps`, any `beta : ℝ`, any `h >= 0`, and any observable
`f` that is a `c`-bounded function of a single link's spin AND ODD under
the one-site flip at `x0` (e.g. `f = spin ∘ (fun U => U l.1 l.2)` for a
link `l` incident to `x0`): the source-symmetry-breaking expectation is
bounded uniformly by `c * tanh(q_x0 * h)`, where `q_x0` is the number of
`E`-links touching `x0` - independent of the lattice, of `beta`, and of any
additional gauge-invariant term added to the action. -/
theorem elitzur_bound (E : Finset (V × V)) (x0 : V) (hloop : NoSelfLoopAt E x0)
    (ps : List (V × V × V × V)) (beta h : ℝ) (hh : 0 ≤ h)
    (f : LinkField V → ℝ) (c : ℝ)
    (hodd : ∀ U, f (flipAt x0 U) = - f U)
    (hfb : ∀ U, |f U| ≤ c) :
    |∑ U, f U * Real.exp (beta * ((plaqSpins U ps).map (fun b => spin b)).sum
        + h * sourceTerm E U)|
      ≤ c * Real.tanh (h * (linksAt E x0).card)
        * ∑ U, Real.exp (beta * ((plaqSpins U ps).map (fun b => spin b)).sum
            + h * sourceTerm E U) := by
  set w : LinkField V → ℝ :=
    fun U => Real.exp (beta * ((plaqSpins U ps).map (fun b => spin b)).sum
      + h * sourceTerm E U) with hw_def
  have hw_pos : ∀ U, 0 < w U := fun U => Real.exp_pos _
  have hcov : ∀ U, w (flipAt x0 U) = w U * Real.exp (-2 * (h * K E x0 U)) := by
    intro U
    have hWilson : ((plaqSpins (flipAt x0 U) ps).map (fun b => spin b)).sum
        = ((plaqSpins U ps).map (fun b => spin b)).sum := by
      rw [plaqSpins_flipAt_invariant]
    have hSource : sourceTerm E (flipAt x0 U) = sourceTerm E U - 2 * K E x0 U :=
      sourceTerm_flipAt E x0 hloop U
    rw [hw_def]; simp only
    rw [hWilson, hSource, ← Real.exp_add]
    congr 1; ring
  have := abstract_elitzur_bound (Ω := LinkField V) (φ := flipAt x0)
    (flipAt_involutive x0) f w (fun U => h * K E x0 U) c (h * (linksAt E x0).card)
    hw_pos (by positivity)
    (fun U => by
      rw [abs_mul, abs_of_nonneg hh]
      exact mul_le_mul_of_nonneg_left (abs_K_le_card E x0 U) hh)
    hodd hcov hfb
  simpa [hw_def] using this

end ElitzurLattice
end GateYM
end NullEdge
end Draft
end PhysicsSM
