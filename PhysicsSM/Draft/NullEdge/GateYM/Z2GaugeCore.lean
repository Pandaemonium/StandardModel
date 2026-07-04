/-!
# Gate YM0: Z2 lattice gauge theory - the gauge-invariance core

First Lean content of the Yang-Mills ladder
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`; statement freeze and
proofs: `AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`).
Provenance: external draft seed (`YM0Seed.lean`, delivered 2026-07-03,
explicitly NOT kernel-checked by its author), compiled in-repo the same day
after a one-line fix (the nil case of `hol_gauge` needed
`simp only [hol, walkEnd]` before the case split, so that
`g (walkEnd x [])` is normalized to `g x` and abstracted by `cases`).

Z2 is realized as `Bool` with `xor` (`false = +1`, `true = -1`), so the
group inverse is the identity and orientation bookkeeping is trivial;
conventions pinned to `Scripts/oracle/validate_lgt_core.py` v0.1 (C-1..C-3:
links on ordered pairs, plaquette based and counterclockwise), oracle 30/30
(reproduced in-repo; original run log
`AgentTasks/ym-oracle-run-2026-07-03.log`).

Contents (all kernel-checked, CORE LEAN ONLY - no Mathlib import):
* `hol_gauge` (L2a): the telescoping identity - a gauge transformation
  changes a walk holonomy only by the boundary factor.
* `hol_gauge_closed` (L2), `plaq_gauge` (L2'): closed-walk and plaquette
  gauge invariance.
* `gauge_comp` (L4a), `gauge_invol` (L4b): the gauge group acts; each Z2
  gauge transformation is an involution (the orbit machinery for
  partition-function invariance at the Mathlib layer, PKG-YM0-B).
* `plaqSpins_gauge` (L3): every statistic of the plaquette spin list -
  Wilson action and Wilson-loop insertions included - is gauge invariant
  configuration by configuration.

Axiom audit (2026-07-03): `hol_gauge`, `hol_gauge_closed`, `plaq_gauge`,
`plaqSpins_gauge` depend on NO axioms; `gauge_comp`, `gauge_invol` on
`[Quot.sound]` only (funext). Draft-trust, no `s o r r y`, no
`n a t i v e _ d e c i d e`.
Claim label: **finite identity** (Z2 gauge-invariance core).
Successors: PKG-YM0-B (partition function, general G, Fintype/Haar);
PKG-YM1-A (Elitzur core, submitted); the YM1 finite-G paper layer.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace Z2GaugeCore

/-- A ℤ₂ link field assigns a group element to every ORDERED pair of
vertices. (Multigraph edges are not needed for the invariance theorems;
the lattice instance factors through this.) -/
def LinkField (V : Type) : Type := V → V → Bool

variable {V : Type}

/-- Gauge action: `(g · U) x y = g x * U x y * (g y)⁻¹`; for ℤ₂, xor. -/
def gauge (g : V → Bool) (U : LinkField V) : LinkField V :=
  fun x y => g x ^^ (U x y ^^ g y)

/-- Endpoint of the walk that starts at `x` and visits `w` in order. -/
def walkEnd (x : V) : List V → V
  | []      => x
  | y :: w  => walkEnd y w

/-- Holonomy of the walk `x :: w` (product of link variables along it). -/
def hol (U : LinkField V) : V → List V → Bool
  | _, []     => false
  | x, y :: w => U x y ^^ hol U y w

/-- **L2a (telescoping).** A gauge transformation changes a walk holonomy
only by the boundary factor `g x * g (walkEnd x w)`. This is the single
load-bearing induction; everything else is a corollary. -/
theorem hol_gauge (g : V → Bool) (U : LinkField V) (x : V) (w : List V) :
    hol (gauge g U) x w = (g x ^^ (hol U x w ^^ g (walkEnd x w))) := by
  induction w generalizing x with
  | nil =>
      -- goal: false = g x ^^ (false ^^ g x), after normalizing
      -- `walkEnd x [] = x` so the case split sees both `g x` occurrences
      simp only [hol, walkEnd]
      cases g x <;> rfl
  | cons y w ih =>
      simp only [hol, walkEnd, gauge, ih y]
      -- xor shuffle: (gx ^^ (Uxy ^^ gy)) ^^ (gy ^^ (h ^^ ge))
      --            = gx ^^ ((Uxy ^^ h) ^^ ge)
      cases g x <;> cases g y <;> cases U x y <;>
        cases hol U y w <;> cases g (walkEnd y w) <;> rfl
      -- Aristotle alternative if the case split stalls:
      --   simp [Bool.xor_assoc, Bool.xor_comm, Bool.xor_left_comm,
      --         Bool.xor_self, Bool.xor_false, Bool.false_xor]

/-- **L2 (gauge invariance of closed-walk holonomy).** For ℤ₂ the holonomy
itself is invariant; for general `G` the corresponding statement is
invariance up to conjugation, hence invariance of class functions. -/
theorem hol_gauge_closed (g : V → Bool) (U : LinkField V) (x : V)
    (w : List V) (hcl : walkEnd x w = x) :
    hol (gauge g U) x w = hol U x w := by
  rw [hol_gauge, hcl]
  cases g x <;> cases hol U x w <;> rfl

/-- Plaquette holonomy, convention C-2 (based at `a`, counterclockwise). -/
def plaq (U : LinkField V) (a b c d : V) : Bool := hol U a [b, c, d, a]

/-- **L2′ (plaquette gauge invariance).** -/
theorem plaq_gauge (g : V → Bool) (U : LinkField V) (a b c d : V) :
    plaq (gauge g U) a b c d = plaq U a b c d :=
  hol_gauge_closed g U a [b, c, d, a] rfl

/-- **L4a.** The gauge transformations compose pointwise (a `(V → ℤ₂)`
action on configurations). -/
theorem gauge_comp (g h : V → Bool) (U : LinkField V) :
    gauge g (gauge h U) = gauge (fun v => g v ^^ h v) U := by
  funext x y
  simp only [gauge]
  cases g x <;> cases h x <;> cases g y <;> cases h y <;> cases U x y <;> rfl

/-- **L4b.** Each ℤ₂ gauge transformation is an involution. Together with
L4a this exhibits the orbit structure used by the (Mathlib-layer) proof
that the partition function is gauge invariant: `gauge g` is a bijection
of configuration space and the Boltzmann summand is invariant (L3). -/
theorem gauge_invol (g : V → Bool) (U : LinkField V) :
    gauge g (gauge g U) = U := by
  funext x y
  simp only [gauge]
  cases g x <;> cases g y <;> cases U x y <;> rfl

/-- Wilson-action data: a list of based plaquettes. The ℤ₂ action is
`S_β(U) = β Σ_p s_p` with `s_p = 1 − 2·(plaq bit)`; L3 below is the exact
pointwise content, and partition-function invariance follows at the
Mathlib layer from L3 + L4b (sum over a bijection). -/
def plaqSpins (U : LinkField V) (ps : List (V × V × V × V)) : List Bool :=
  ps.map (fun q => plaq U q.1 q.2.1 q.2.2.1 q.2.2.2)

/-- **L3 (action-summand invariance).** Every statistic of the plaquette
spin list — in particular `S_β` and any Wilson-loop insertion — is gauge
invariant configuration by configuration. -/
theorem plaqSpins_gauge (g : V → Bool) (U : LinkField V)
    (ps : List (V × V × V × V)) :
    plaqSpins (gauge g U) ps = plaqSpins U ps := by
  induction ps with
  | nil => rfl
  | cons q ps ih =>
      simp only [plaqSpins, List.map_cons] at ih ⊢
      rw [plaq_gauge, ih]

/- NOT in this seed (deliberately):
   * partition function and its invariance — needs Fintype/Finset sums
     (Mathlib), packaged as PKG-YM0-B together with the general-G version;
   * center symmetry and the Polyakov-loop order parameter — trivial for
     ℤ₂ (center = group), stated for general G in the freeze document §L5;
   * anything about measures, Haar, or expectation values. -/

end Z2GaugeCore
end GateYM
end NullEdge
end Draft
end PhysicsSM
